'use strict';

// Imports
const should = require('chai').Should();
const { expect } = require('chai');
const request = require("supertest");
const config = require("../config");
const testUtils = require("../utils/testUtils");
const telemetryUtils = require("../utils/telemetryUtils");
const { assert } = require('console');
var isEqual = require('lodash.isequal');

// Test Data
let scenario = "storageService_searchRecord";

const majorVersion = testUtils.between(1, 100000);
const minorVersion = testUtils.between(1, 100000);
let runId = `${majorVersion}.${minorVersion}`;
let kind = `${testUtils.partition}:probetest:dummydata:0.${runId}`;
let tag = `${testUtils.partition}-probetest-tag`;

console.log(`run ID: ${runId}`);

testUtils.test.scenario = scenario;
testUtils.test.runId = runId;
testUtils.sampleData.sampleLegalTag.name = tag;
testUtils.sampleData.sampleSchema.kind = kind;
testUtils.sampleData.sampleRecord[0].kind = kind;
testUtils.sampleData.sampleRecord[0].legal.legaltags[0] = tag;
testUtils.sampleData.sampleQuery.kind = kind;
testUtils.failedTests = 0;

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
        
        describe('Entitlement Check', done => {
            
            it("Groups: Get", done => {
                testUtils.test.service = testUtils.services.entitlement;
                testUtils.test.api = testUtils.api.entitlement.getGroups.name;
                testUtils.test.expectedResponse = testUtils.api.entitlement.getGroups.expectedResponse;

                testUtils.serviceHosts.entitlementHost
                .get('/groups/')
                .set('Authorization', token)
                .set('data-partition-id', testUtils.partition)
                .expect(testUtils.api.entitlement.getGroups.expectedResponse)
                .then(() => {
                    telemetryUtils.passApiRequest(testUtils.test); 
                    done(); 
                })
                .catch(err => { 
                    telemetryUtils.failApiRequest(testUtils.test, err);
                    done(err); 
                });
            });
        });
        
        describe('Prepare Legal', done => {
            let data;
      
            it("LegalTag: Create", done => {
                testUtils.test.service = testUtils.services.legal;
                testUtils.test.api = testUtils.api.legal.createLegalTags.name;
                testUtils.test.expectedResponse = testUtils.api.legal.createLegalTags.expectedResponse;

                testUtils.serviceHosts.legalHost
                .post(testUtils.api.legal.createLegalTags.path)
                .set('Authorization', token)
                .set('data-partition-id', testUtils.partition)
                .send(testUtils.sampleData.sampleLegalTag)
                .then(res => {
                    testUtils.api.legal.createLegalTags.expectedResponse.should.be.an('array').that.includes(res.statusCode);
                    telemetryUtils.passApiRequest(testUtils.test);
                  done();
                })
                .catch(err => {
                    telemetryUtils.failApiRequest(testUtils.test, err);
                    done(err)
                });
            });
      
            it('LegalTag: Get', done => {
                testUtils.test.service = testUtils.services.legal;
                testUtils.test.api = testUtils.api.legal.getLegalTags.name;
                testUtils.test.expectedResponse = testUtils.api.legal.getLegalTags.expectedResponse;

                testUtils.serviceHosts.legalHost
                .get(testUtils.api.legal.getLegalTags.path + testUtils.sampleData.sampleLegalTag.name)
                .set('Authorization', token)
                .set('Accept', 'application/json')
                .set('data-partition-id', testUtils.partition)
                .expect(testUtils.api.legal.getLegalTags.expectedResponse)
                .then(res => {
                    data = res.body;
                    telemetryUtils.passApiRequest(testUtils.test); 
                    done(); 
                })
                .catch(err => { 
                    telemetryUtils.failApiRequest(testUtils.test, err);
                    done(err); 
                });
            });
      
            it('LegalTag: Validate', () => {
                testUtils.test.service = testUtils.services.legal;
                testUtils.test.api = 'validate_' + testUtils.api.legal.getLegalTags.name;
                testUtils.test.expectedResponse = "Valid Match";

                if (isEqual(data, testUtils.sampleData.sampleLegalTag)) {
                    telemetryUtils.passApiRequest(testUtils.test);
                    expect(true).to.be.true;
                } else {
                    telemetryUtils.failApiRequest(testUtils.test, "Invalid");
                    expect(false).to.be.true;
                }
          });
        });

        describe('Prepare Schema', done => {
            let data;
      
            it("Schema: Create", done => {
                testUtils.test.service = testUtils.services.storage;
                testUtils.test.api = testUtils.api.storage.createSchema.name;
                testUtils.test.expectedResponse = testUtils.api.storage.createSchema.expectedResponse;

                testUtils.serviceHosts.storageHost
                .post(testUtils.api.storage.createSchema.path)
                .set('Authorization', token)
                .set('data-partition-id', testUtils.partition)
                .send(testUtils.sampleData.sampleSchema)
                .then(res => {
                    testUtils.api.storage.createSchema.expectedResponse.should.be.an('array').that.includes(res.statusCode);
                    telemetryUtils.passApiRequest(testUtils.test);
                  done();
                })
                .catch(err => {
                    telemetryUtils.failApiRequest(testUtils.test, err);
                    done(err)
                });
            });
      
            it('Schema: Get', done => {
                testUtils.test.service = testUtils.services.storage;
                testUtils.test.api = testUtils.api.storage.getSchema.name;
                testUtils.test.expectedResponse = testUtils.api.storage.getSchema.expectedResponse;

                testUtils.serviceHosts.storageHost
                .get(testUtils.api.storage.getSchema.path + testUtils.sampleData.sampleSchema.kind)
                .set('Authorization', token)
                .set('Accept', 'application/json')
                .set('data-partition-id', testUtils.partition)
                .expect(testUtils.api.storage.getSchema.expectedResponse)
                .then(res => {
                    data = res.body;
                    telemetryUtils.passApiRequest(testUtils.test); 
                    done(); 
                })
                .catch(err => { 
                    telemetryUtils.failApiRequest(testUtils.test, err);
                    done(err); 
                });
            });
      
            it('Schema: Validate', () => {
                testUtils.test.service = testUtils.services.storage;
                testUtils.test.api = 'validate_' + testUtils.api.storage.getSchema.name;
                testUtils.test.expectedResponse = "Valid Match";

                if (isEqual(data, testUtils.sampleData.sampleSchema)) {
                    telemetryUtils.passApiRequest(testUtils.test);
                    expect(true).to.be.true;
                } else {
                    telemetryUtils.failApiRequest(testUtils.test, "Invalid");
                    expect(false).to.be.true;
                }
          });
        });

        describe('Create Record', done => {
            let data;
      
            it("Record: Create", done => {
                testUtils.test.service = testUtils.services.storage;
                testUtils.test.api = testUtils.api.storage.createRecord.name;
                testUtils.test.expectedResponse = testUtils.api.storage.createRecord.expectedResponse;

                testUtils.serviceHosts.storageHost
                .put(testUtils.api.storage.createRecord.path)
                .set('Authorization', token)
                .set('data-partition-id', testUtils.partition)
                .send(testUtils.sampleData.sampleRecord)
                .then(res => {
                    testUtils.api.storage.createRecord.expectedResponse.should.be.an('array').that.includes(res.statusCode);
                    telemetryUtils.passApiRequest(testUtils.test);
                    res.body.should.be.an('object');
                    recordId = res.body.recordIds[0];
                    done();
                })
                .catch(err => {
                    telemetryUtils.failApiRequest(testUtils.test, err);
                    done(err)
                });
            });
      
            it('Record: Get', done => {
                testUtils.test.service = testUtils.services.storage;
                testUtils.test.api = testUtils.api.storage.getRecord.name;
                testUtils.test.expectedResponse = testUtils.api.storage.getRecord.expectedResponse;

                testUtils.serviceHosts.storageHost
                .get(testUtils.api.storage.getRecord.path + recordId)
                .set('Authorization', token)
                .set('data-partition-id', testUtils.partition)
                .expect(testUtils.api.storage.getRecord.expectedResponse)
                .then(() => {
                    telemetryUtils.passApiRequest(testUtils.test); 
                    done(); 
                })
                .catch(err => { 
                    telemetryUtils.failApiRequest(testUtils.test, err);
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
                testUtils.test.service = testUtils.services.search;
                testUtils.test.api = testUtils.api.search.findRecord.name;
                testUtils.test.expectedResponse = testUtils.api.search.findRecord.expectedResponse;

                testUtils.serviceHosts.searchHost
                .post(testUtils.api.search.findRecord.path)
                .set('Authorization', token)
                .set('data-partition-id', testUtils.partition)
                .send(testUtils.sampleData.sampleQuery)
                .then(res => {
                    testUtils.api.search.findRecord.expectedResponse.should.be.an('array').that.includes(res.statusCode);
                    telemetryUtils.passApiRequest(testUtils.test);
                    res.body.should.be.an('object');
                    data = res.body.results[0].id;
                    done();
                })
                .catch(err => {
                    telemetryUtils.failApiRequest(testUtils.test, err);
                    done(err)
                });
            });
      
            it('Search: Validate', () => {
                testUtils.test.service = testUtils.services.search;
                testUtils.test.api = 'validate_' + testUtils.api.search.findRecord.name;
                testUtils.test.expectedResponse = "Valid Match";

                if (isEqual(data, recordId)) {
                    telemetryUtils.passApiRequest(testUtils.test);
                    expect(true).to.be.true;
                } else {
                    telemetryUtils.failApiRequest(testUtils.test, "Invalid");
                    expect(false).to.be.true;
                }
          });
        });
        
        describe('Probe Cleanup', done => {

            it('Record: Delete', done => {
                testUtils.test.service = testUtils.services.storage;
                testUtils.test.api = testUtils.api.storage.deleteRecord.name;
                testUtils.test.expectedResponse = testUtils.api.storage.deleteRecord.expectedResponse;

                testUtils.serviceHosts.storageHost
                .delete(testUtils.api.storage.deleteRecord.path + recordId)
                .set('Authorization', token)
                .set('data-partition-id', testUtils.partition)
                .expect(testUtils.api.storage.deleteRecord.expectedResponse)
                .then(() => {
                    telemetryUtils.passApiRequest(testUtils.test); 
                    done(); 
                })
                .catch(err => { 
                    telemetryUtils.failApiRequest(testUtils.test, err);
                    done(err); 
                });
            });

            it('Schema: Delete', done => {
                testUtils.test.service = testUtils.services.storage;
                testUtils.test.api = testUtils.api.storage.deleteSchema.name;
                testUtils.test.expectedResponse = testUtils.api.storage.deleteSchema.expectedResponse;

                testUtils.serviceHosts.storageHost
                .delete(testUtils.api.storage.deleteSchema.path + testUtils.sampleData.sampleSchema.kind)
                .set('Authorization', token)
                .set('Accept', 'application/json')
                .set('data-partition-id', testUtils.partition)
                .expect(testUtils.api.storage.deleteSchema.expectedResponse)
                .then(() => {
                    telemetryUtils.passApiRequest(testUtils.test); 
                    done(); 
                })
                .catch(err => { 
                    telemetryUtils.failApiRequest(testUtils.test, err);
                    done(err); 
                });
            });

            it('LegalTag: Delete', done => {
                testUtils.test.service = testUtils.services.legal;
                testUtils.test.api = testUtils.api.legal.deleteLegalTags.name;
                testUtils.test.expectedResponse = testUtils.api.legal.deleteLegalTags.expectedResponse;

                testUtils.serviceHosts.legalHost
                .delete(testUtils.api.legal.deleteLegalTags.path + testUtils.sampleData.sampleLegalTag.name)
                .set('Authorization', token)
                .set('Accept', 'application/json')
                .set('data-partition-id', testUtils.partition)
                .expect(testUtils.api.legal.deleteLegalTags.expectedResponse)
                .then(() => {
                    telemetryUtils.passApiRequest(testUtils.test); 
                    done(); 
                })
                .catch(err => { 
                    telemetryUtils.failApiRequest(testUtils.test, err);
                    done(err); 
                });
            });
        });
            
        afterEach(function() {
            if (this.currentTest.state === 'failed') {
                testUtils.failedTests += 1;
            }
          });

        after(done => {
            telemetryUtils.scenarioRequest(runId, testUtils.services.storage, scenario, testUtils.failedTests);
            done();
        });
    });
});