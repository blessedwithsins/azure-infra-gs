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

const sampleEvaluatePolicy = require(`${__dirname}/../testData/sample_policy_evaluate.json`);
const samplePolicy = testUtils.readTextFile(`${__dirname}/../testData/sample_policy_crud.txt`);

// Test Setup
let scenario = "policyservice_crudOps";

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

    describe('Scenario: Policy Service supports CRUD operations', (done) => {
        
        if (config.test_flags.crud_policy.getAllPolicies) {
            it("Get All Policies", done => {
                test.service = testUtils.services.policy;
                test.api = test.service.api.getAllPolicies;
                test.expectedResponse = test.api.expectedResponse;
                
                test.service.host
                .get(test.api.path)
                .set('Authorization', token)
                .set('data-partition-id', testUtils.partition)
                .expect(test.expectedResponse)
                .then(res => {
                    telemetryUtils.passApiRequest(test); 
                    done(); 
                })
                .catch(err => { 
                    telemetryUtils.failApiRequest(test, err);
                    done(err); 
                });
            });
    
            it("Get All Search Policies", done => {
                test.service = testUtils.services.policy;
                test.api = test.service.api.getSearchPolicies;
                test.expectedResponse = test.api.expectedResponse;
                
                test.service.host
                .get(test.api.path)
                .set('Authorization', token)
                .set('data-partition-id', testUtils.partition)
                .expect(test.expectedResponse)
                .then(res => {
                    telemetryUtils.passApiRequest(test); 
                    done(); 
                })
                .catch(err => { 
                    telemetryUtils.failApiRequest(test, err);
                    done(err); 
                });
            });
        }

        if (config.test_flags.crud_policy.evaluatePolicy) {
            it("Evaluate Policy", done => {
                test.service = testUtils.services.legal;
                test.api = test.service.api.evaluatePolicy;
                test.expectedResponse = test.api.expectedResponse;
                
                test.service.host
                .post(test.api.path)
                .set('Authorization', token)
                .set('Data-Partition-Id', testUtils.partition)
                .send(sampleEvaluatePolicy)
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
        }

        if (config.test_flags.crud_policy.createTestPolicy) {
            it("Create Test Policy", done => {
                test.service = testUtils.services.legal;
                test.api = test.service.api.createTestPolicy;
                test.expectedResponse = test.api.expectedResponse;
                
                test.service.host
                .put(test.api.path)
                .set('Authorization', token)
                .set('Data-Partition-Id', testUtils.partition)
                .send(samplePolicy)
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
    
            if (config.test_flags.crud_policy.getTestPolicy) {
                it("Get All Test Policies", done => {
                    test.service = testUtils.services.policy;
                    test.api = test.service.api.getTestPolicies;
                    test.expectedResponse = test.api.expectedResponse;
                    
                    test.service.host
                    .get(test.api.path)
                    .set('Authorization', token)
                    .set('data-partition-id', testUtils.partition)
                    .expect(test.expectedResponse)
                    .then(res => {
                        console.log(JSON.stringify(res.body));
                        isEqual(res.body, res.body); // TO DO: add
                        telemetryUtils.passApiRequest(test); 
                        done(); 
                    })
                    .catch(err => { 
                        telemetryUtils.failApiRequest(test, err);
                        done(err); 
                    });
                });
            }
    
            it("Delete Test Policies", done => {
                test.service = testUtils.services.policy;
                test.api = test.service.api.deleteTestPolicy;
                test.expectedResponse = test.api.expectedResponse;
                
                test.service.host
                .delete(test.api.path)
                .set('Authorization', token)
                .set('data-partition-id', testUtils.partition)
                .expect(test.expectedResponse)
                .then(res => {
                    telemetryUtils.passApiRequest(test); 
                    done(); 
                })
                .catch(err => { 
                    telemetryUtils.failApiRequest(test, err);
                    done(err); 
                });
            });
    
            if (config.test_flags.crud_policy.getTestPolicy) {
                it("Get Deleted Test Policies", done => {
                    test.service = testUtils.services.policy;
                    test.api = test.service.api.getTestPolicies;
                    test.expectedResponse = test.api.expectedResponse;
                    
                    test.service.host
                    .get(test.api.path)
                    .set('Authorization', token)
                    .set('data-partition-id', testUtils.partition)
                    .expect(test.expectedResponse)
                    .then(res => {
                        console.log(JSON.stringify(res.body));
                        isEqual(res.body, res.body); // TO DO: add
                        telemetryUtils.passApiRequest(test); 
                        done(); 
                    })
                    .catch(err => { 
                        telemetryUtils.failApiRequest(test, err);
                        done(err); 
                    });
                });
            }
        }

        afterEach(function() {
            if (this.currentTest.state === 'failed') {
                test.failedTests += 1;
            }
          });

        after(done => {
            telemetryUtils.scenarioRequest(runId, testUtils.services.policy, scenario, test.failedTests);
            done();
        });
    });
});