'use strict';

// Imports
const should = require('chai').Should();
const { expect } = require('chai');
const request = require("supertest");
const config = require(`${__dirname}/../config`);
const testUtils = require(`${__dirname}/../utils/testUtils`);
const telemetryUtils = require(`${__dirname}/../utils/telemetryUtils`);
const { assert } = require('console');
var isEqual = require('lodash.isequal');

// Test Setup
let scenario = "scenario_recordSchema";

const majorVersion = testUtils.between(1, 100000);
const minorVersion = testUtils.between(1, 100000);
let runId = `${majorVersion}.${minorVersion}`;
console.log(`run ID: ${runId}`);

let test = {
    runId: runId,
    scenario: scenario,
    service: "service",
    api: "api",
    expectedResponse: -1,
    failedTests: 0,
};

// Test Data Setup
let testApiName = testUtils.services.search.api.search.name;
let kind = `${testUtils.partition}:wks:reference-data--ProcessingParameterType:1.0.0`;
let tag =  `${testUtils.partition}-public-usa-check-1`;

let legalTag = {
    "name": `${tag}`,
    "description": "This tag is used by Data Upload Scripts",
    "properties": {
      "countryOfOrigin": [
        "US"
      ],
      "contractId": "A1234",
      "expirationDate": "2021-12-31",
      "originator": "MyCompany",
      "dataType": "Transferred Data",
      "securityClassification": "Public",
      "personalData": "No Personal Data",
      "exportClassification": "EAR99"
    }
};

let data = '';
let recordId = '';
let recordVersion = '';

// Test Scenario
describe(scenario, (done) => {
    let token;

    before(done => {
        // Get a new OAuth Token
        testUtils.oAuth.post('/token')
          .set('Content-Type', 'application/x-www-form-urlencoded')
          .send(config.auth_params)
          .then(res => {
            token = 'Bearer ' + res.body.access_token;
            done();
          })
          .catch(err => {
            done(err)
          });
    });

    describe('Scenario: Check Record Schema', (done) => {
        
        if (config.test_flags.scenario_recordSchema.enableScenario) {

            describe('Get Entitlements', (done) => {
            
                it("Get All groups.", done => {
                  test.service = testUtils.services.entitlement;
                  test.api = test.service.api.getGroups;
                  test.expectedResponse = test.api.expectedResponse;
    
                  test.service.host
                  .get(test.api.path)
                  .set('Authorization', token)
                  .set('Accept', 'application/json')
                  .set('data-partition-id', testUtils.partition)
                  .expect(test.expectedResponse)
                  .then(() => {
                      telemetryUtils.passApiRequest(test);
                      done(); 
                  })
                  .catch(err => { 
                      telemetryUtils.failApiRequest(test, err);
                      done(err); 
                  });
                });
              });
    
              describe('Create Necessary Legal Tag', (done) => {
                
                it("Create Legal Tag", done => {
                  test.service = testUtils.services.legal;
                  test.api = test.service.api.createLegalTags;
                  test.expectedResponse = test.api.expectedResponse;
                  
                  test.service.host
                  .post(test.api.path)
                  .set('Authorization', token)
                  .set('Content-Type', 'application/json')
                  .set('data-partition-id', testUtils.partition)
                  .send(legalTag)
                  .then(res => {
                      test.expectedResponse.should.be.an('array').that.includes(res.statusCode);
                      telemetryUtils.passApiRequest(test);
                      done();
                  })
                  .catch(err => {
                      telemetryUtils.failApiRequest(test, err);
                      done(err)
                  });
                });
    
                it("Get Created Legal Tag", done => {
                  test.service = testUtils.services.legal;
                  test.api = test.service.api.getLegalTag;
                  test.expectedResponse = test.api.expectedResponse;
                  
                  test.service.host
                  .get(test.api.path + legalTag.name)
                  .set('Authorization', token)
                  .set('Accept', 'application/json')
                  .set('data-partition-id', testUtils.partition)
                  .expect(test.expectedResponse)
                  .then(res => {
                      data = res.body;
                      telemetryUtils.passApiRequest(test); 
                      done(); 
                  })
                  .catch(err => { 
                      telemetryUtils.failApiRequest(test, err);
                      done(err); 
                  });
                });
      
                it('Validate: Get Created Legal Tag', () => {
                  test.service = testUtils.services.legal;
                  test.api.name = 'validate_' + test.service.api.getLegalTag.name;
                  test.expectedResponse = "Valid Match";
      
                  if (isEqual(data, legalTag)) {
                      telemetryUtils.passApiRequest(test);
                      expect(true).to.be.true;
                  } else {
                      telemetryUtils.failApiRequest(test, "Invalid");
                      console.log(`actual:${JSON.stringify(data)}`);
                      expect(false).to.be.true;
                  }
                });
            });

            describe('Get Schema', (done) => {
                
                it("Get Schema By ID", done => {
                    test.service = testUtils.services.schema;
                    test.api = test.service.api.getSchemaById;
                    test.expectedResponse = test.api.expectedResponse;
        
                    test.service.host
                    .get(test.api.path + kind)
                    .set('Authorization', token)
                    .set('data-partition-id', testUtils.partition)
                    .expect(test.expectedResponse)
                    .then(() => {
                        telemetryUtils.passApiRequest(test); 
                        done(); 
                    })
                    .catch(err => { 
                        telemetryUtils.failApiRequest(test, err);
                        done(err); 
                    });
                });
            });

            describe('Create & Validate Storage Record', (done) => {
                
                it("Record: Create", done => {
                    test.service = testUtils.services.storage;
                    test.api = test.service.api.createRecord;
                    test.expectedResponse = test.api.expectedResponse;

                    let sampleRecord = [
                        {
                          "kind": `${kind}`,
                          "acl": {
                            "viewers": [
                              `data.default.viewers@${testUtils.partition}.contoso.com`
                            ],
                            "owners": [
                              `data.default.owners@${testUtils.partition}.contoso.com`
                            ]
                          },
                          "legal": {
                            "legaltags": [
                              `${tag}`
                            ],
                            "otherRelevantDataCountries": [
                              "US"
                            ],
                            "status": "compliant"
                          },
                          "data": {
                            "Name": "QA Test Case",
                            "ID": "qatest",
                            "Code": "QA Test Case",
                            "Source": "osdu-tno-load-js"
                          }
                        }
                    ];
    
                    test.service.host
                    .put(test.api.path)
                    .set('Authorization', token)
                    .set('data-partition-id', testUtils.partition)
                    .send(sampleRecord)
                    .then(res => {
                        test.expectedResponse.should.be.an('array').that.includes(res.statusCode);
                        res.body.should.be.an('object');

                        recordId = res.body.recordIds[0];
                        recordVersion = res.body.recordIdVersions[0];
                        console.log(`Record ID: ${recordId}`);
                        console.log(`Record Version: ${recordVersion}`);

                        telemetryUtils.passApiRequest(test);
                        done();
                    })
                    .catch(err => {
                        telemetryUtils.failApiRequest(test, err);
                        done(err)
                    });
                });

                it('Record: Get', done => {
                    test.service = testUtils.services.storage;
                    test.api = test.service.api.getRecord;
                    test.expectedResponse = test.api.expectedResponse;
    
                    test.service.host
                    .get(test.api.path + recordId)
                    .set('Authorization', token)
                    .set('data-partition-id', testUtils.partition)
                    .expect(test.expectedResponse)
                    .then((res) => {
                        telemetryUtils.passApiRequest(test); 
                        res.body.should.be.an('object');
                        done(); 
                    })
                    .catch(err => { 
                        telemetryUtils.failApiRequest(test, err);
                        done(err); 
                    });
                });

                it('Record: Get By Kind', done => {
                    test.service = testUtils.services.storage;
                    test.api = test.service.api.getRecordByKind;
                    test.expectedResponse = test.api.expectedResponse;
    
                    test.service.host
                    .get(test.api.path + kind)
                    .set('Authorization', token)
                    .set('data-partition-id', testUtils.partition)
                    .expect(test.expectedResponse)
                    .then((res) => {
                        telemetryUtils.passApiRequest(test); 
                        res.body.should.be.an('object');
                        done(); 
                    })
                    .catch(err => { 
                        telemetryUtils.failApiRequest(test, err);
                        done(err); 
                    });
                });

                it('Record: List Record Versions', done => {
                    test.service = testUtils.services.storage;
                    test.api = test.service.api.listRecordVersions;
                    test.expectedResponse = test.api.expectedResponse;
    
                    test.service.host
                    .get(test.api.path + recordId)
                    .set('Authorization', token)
                    .set('data-partition-id', testUtils.partition)
                    .expect(test.expectedResponse)
                    .then((res) => {
                        telemetryUtils.passApiRequest(test);
                        res.body.should.be.an('object');
                        should.exist(res.body.versions[0]);
                        recordVersion = res.body.versions[0];
                        done(); 
                    })
                    .catch(err => { 
                        telemetryUtils.failApiRequest(test, err);
                        done(err); 
                    });
                });

                it('Record: Get Record Version', done => {
                    test.service = testUtils.services.storage;
                    test.api = test.service.api.getRecordVersion;
                    test.expectedResponse = test.api.expectedResponse;
    
                    test.service.host
                    .get(test.api.path + `${recordId}/${recordVersion}`)
                    .set('Authorization', token)
                    .set('data-partition-id', testUtils.partition)
                    .expect(test.expectedResponse)
                    .then((res) => {
                        telemetryUtils.passApiRequest(test);
                        res.body.should.be.an('object');
                        done(); 
                    })
                    .catch(err => { 
                        telemetryUtils.failApiRequest(test, err);
                        done(err); 
                    });
                });
            });

            describe('Search Record', (done) => {
                
                it("Search: Record", done => {
                    test.service = testUtils.services.search;
                    test.api = test.service.api.search;
                    test.api.name = `${testApiName}_recordSchemaSearch`;
                    test.expectedResponse = test.api.expectedResponse;
                    let searchQuery = {
                        "kind": `${kind}`,
                        "offset": 0,
                        "limit": 1
                      };
        
                    test.service.host
                    .post(test.api.path)
                    .set('Authorization', token)
                    .set('Content-Type', 'application/json')
                    .set('data-partition-id', testUtils.partition)
                    .send(searchQuery)
                    .then(res => {
                        test.expectedResponse.should.be.an('array').that.includes(res.statusCode);
                        let record_Id = res.body.results[0].id
                        should.exist(record_Id);
                        console.log(`Total Record Count: ${res.body.totalCount}`);
                        telemetryUtils.passApiRequest(test);
                        done();
                    })
                    .catch(err => {
                        telemetryUtils.failApiRequest(test, err);
                        done(err)
                    });
                });
            });

            describe('Probe Cleanup', (done) => {
            
                it('Record: Delete', done => {
                  test.service = testUtils.services.storage;
                  test.api = test.service.api.deleteRecord;
                  test.expectedResponse = test.api.expectedResponse;
    
                  test.service.host
                  .delete(test.api.path + recordId)
                  .set('Authorization', token)
                  .set('data-partition-id', testUtils.partition)
                  .expect(test.expectedResponse)
                  .then(() => {
                      telemetryUtils.passApiRequest(test); 
                      done(); 
                  })
                  .catch(err => { 
                      telemetryUtils.failApiRequest(test, err);
                      done(err); 
                  });
                });
    
                it('LegalTag: Delete', done => {
                  test.service = testUtils.services.legal;
                  test.api = test.service.api.deleteLegalTags;
                  test.expectedResponse = test.api.expectedResponse;
    
                  test.service.host
                  .delete(test.api.path + legalTag.name)
                  .set('Authorization', token)
                  .set('Accept', 'application/json')
                  .set('data-partition-id', testUtils.partition)
                  .expect(test.expectedResponse)
                  .then(() => {
                      telemetryUtils.passApiRequest(test); 
                      done(); 
                  })
                  .catch(err => { 
                      telemetryUtils.failApiRequest(test, err);
                      done(err); 
                  });
                });
            });
        }
            
        afterEach(function() {
            if (this.currentTest.state === 'failed') {
                test.failedTests += 1;
            }
          });

        after(done => {
            telemetryUtils.scenarioRequest(runId, testUtils.services.storage, scenario, test.failedTests);
            done();
        });
    });
});