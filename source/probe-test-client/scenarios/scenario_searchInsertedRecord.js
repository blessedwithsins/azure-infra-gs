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

const sampleLegalTag = require(`${__dirname}/../testData/ sample_legal_tag.json`);
const sampleSchema = require(`${__dirname}/../testData/sample_schema.json`);
const sampleRecord = require(`${__dirname}/../testData/sample_record.json`);
const sampleQuery = require(`${__dirname}/../testData/sample_query.json`);

// Test Setup
let scenario = "scenario_searchInsertedRecord";

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
let kind = `${testUtils.partition}:probetest:dummydata:0.${runId}`;
let tag = `${testUtils.partition}-probetest-tag`;
sampleLegalTag.name = tag;
sampleSchema.kind = kind;
sampleRecord[0].kind = kind;
sampleRecord[0].legal.legaltags[0] = tag;
sampleQuery.kind = kind;


// Test Scenario
describe(scenario, (done) => {
    let token;
    let recordId;

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

    describe('Scenario: When a Storage Record is created it can be found by a search query', (done) => {
        
        if (config.test_flags.scenario_searchInsertedRecord.enableScenario) {
            describe('Entitlement Check', done => {
            
                it("Groups: Get", done => {
                    test.service = testUtils.services.entitlement;
                    test.api = test.service.api.getGroups;
                    test.expectedResponse = test.api.expectedResponse;
    
                    test.service.host
                    .get(test.api.path)
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
            
            describe('Prepare Legal', done => {
                let data;
          
                it("LegalTag: Create", done => {
                    test.service = testUtils.services.legal;
                    test.api = test.service.api.createLegalTags;
                    test.expectedResponse = test.api.expectedResponse;
    
                    test.service.host
                    .post(test.api.path)
                    .set('Authorization', token)
                    .set('data-partition-id', testUtils.partition)
                    .send(sampleLegalTag)
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
          
                it('LegalTag: Get', done => {
                    test.service = testUtils.services.legal;
                    test.api = test.service.api.getLegalTag;
                    test.expectedResponse = test.api.expectedResponse;
    
                    test.service.host
                    .get(test.api.path + sampleLegalTag.name)
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
          
                it('LegalTag: Validate', () => {
                    test.service = testUtils.services.legal;
                    test.api.name = 'validate_' + test.service.api.getLegalTag.name;
                    test.expectedResponse = "Valid Match";
    
                    if (isEqual(data, sampleLegalTag)) {
                        telemetryUtils.passApiRequest(test);
                        expect(true).to.be.true;
                    } else {
                        telemetryUtils.failApiRequest(test, "Invalid");
                        console.log(`actual:${JSON.stringify(data)}`);
                        expect(false).to.be.true;
                    }
              });
            });
    
            describe('Prepare Schema', done => {
                let data;
          
                it("Schema: Create", done => {
                    test.service = testUtils.services.storage;
                    test.api = test.service.api.createSchema;
                    test.expectedResponse = test.api.expectedResponse;
    
                    test.service.host
                    .post(test.api.path)
                    .set('Authorization', token)
                    .set('data-partition-id', testUtils.partition)
                    .send(sampleSchema)
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
          
                it('Schema: Get', done => {
                    test.service = testUtils.services.storage;
                    test.api = test.service.api.getSchema;
                    test.expectedResponse = test.api.expectedResponse;
    
                    test.service.host
                    .get(test.api.path + sampleSchema.kind)
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
          
                it('Schema: Validate', () => {
                    test.service = testUtils.services.storage;
                    test.api.name = 'validate_' + test.service.api.getSchema.name;
                    test.expectedResponse = "Valid Match";
    
                    if (isEqual(data, sampleSchema)) {
                        telemetryUtils.passApiRequest(test);
                        expect(true).to.be.true;
                    } else {
                        telemetryUtils.failApiRequest(test, "Invalid");
                        console.log(`actual:${JSON.stringify(data)}`);
                        expect(false).to.be.true;
                    }
              });
            });
    
            describe('Create Record', done => {
                let data;
          
                it("Record: Create", done => {
                    test.service = testUtils.services.storage;
                    test.api = test.service.api.createRecord;
                    test.expectedResponse = test.api.expectedResponse;
    
                    test.service.host
                    .put(test.api.path)
                    .set('Authorization', token)
                    .set('data-partition-id', testUtils.partition)
                    .send(sampleRecord)
                    .then(res => {
                        test.expectedResponse.should.be.an('array').that.includes(res.statusCode);
                        res.body.should.be.an('object');
                        recordId = res.body.recordIds[0];
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
    
            describe('Search Record', done => {
                let data;
    
                before((done) => {
                    console.log("          Waiting for record to be indexed...");
                    setTimeout(done, 60000)
                });        
          
                it("Search: Find", done => {
                    test.service = testUtils.services.search;
                    test.api = test.service.api.search;
                    test.expectedResponse = test.api.expectedResponse;
    
                    test.service.host
                    .post(test.api.path)
                    .set('Authorization', token)
                    .set('data-partition-id', testUtils.partition)
                    .send(sampleQuery)
                    .then(res => {
                        test.expectedResponse.should.be.an('array').that.includes(res.statusCode);
                        res.body.should.be.an('object');
                        data = res.body.results[0].id;
                        telemetryUtils.passApiRequest(test);
                        done();
                    })
                    .catch(err => {
                        telemetryUtils.failApiRequest(test, err);
                        done(err)
                    });
                });
          
                it('Search: Validate', () => {
                    test.service = testUtils.services.search;
                    test.api.name = 'validate_' + test.service.api.search.name;
                    test.expectedResponse = "Valid Match";
    
                    if (isEqual(data, recordId)) {
                        telemetryUtils.passApiRequest(test);
                        expect(true).to.be.true;
                    } else {
                        telemetryUtils.failApiRequest(test, "Invalid");
                        console.log(`actual:${JSON.stringify(data)}`);
                        expect(false).to.be.true;
                    }
              });
            });
            
            describe('Probe Cleanup', done => {
    
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
    
                it('Schema: Delete', done => {
                    test.service = testUtils.services.storage;
                    test.api = test.service.api.deleteSchema;
                    test.expectedResponse = test.api.expectedResponse;
    
                    test.service.host
                    .delete(test.api.path + sampleSchema.kind)
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
    
                it('LegalTag: Delete', done => {
                    test.service = testUtils.services.legal;
                    test.api = test.service.api.deleteLegalTags;
                    test.expectedResponse = test.api.expectedResponse;
    
                    test.service.host
                    .delete(test.api.path + sampleLegalTag.name)
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