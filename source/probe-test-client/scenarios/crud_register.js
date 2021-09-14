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

// Test Setup
let scenario = "registerservice_crudOps";

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
let sampleCreateSubscription = require(`${__dirname}/../testData/sample_register_subscription_create.json`);
sampleCreateSubscription.pushEndpoint = `https://${process.env.OSDU_HOST}/api/register/v1/test/challenge/1`;
let subscriptionId = config.subscription_id;
let sampleCreateDdms = require(`${__dirname}/../testData/sample_register_ddms_create.json`);
let sampleCreateAction = require(`${__dirname}/../testData/sample_register_action_create.json`);

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

    describe('Scenario: Register Service supports CRUD operations', (done) => {

        if (config.test_flags.crud_register.subscriptionScenario) {
            describe('Scenario: Subscription CRUD operations', (done) => {

                it("Create Subscription", done => {
                    test.service = testUtils.services.register;
                    test.api = test.service.api.createSubscription;
                    test.expectedResponse = test.api.expectedResponse;
                    
                    test.service.host
                    .post(test.api.path)
                    .set('Authorization', token)
                    .set('data-partition-id', testUtils.partition)
                    .send(sampleCreateSubscription)
                    .then(res => {
                        let id = JSON.stringify(JSON.parse(res.text).id);
                        if (typeof id !== 'undefined' && id)
                        {
                            subscriptionId = id;
                        }
                        else
                        {
                            console.log("Subscription ID not found in \'CreateSubscription\' API.")
                            console.log("Defaulting to Env var SUBSCRIPTION_ID.")
                        }
    
                        test.expectedResponse.should.be.an('array').that.includes(res.statusCode);
                        telemetryUtils.passApiRequest(test);
                        done();
                    })
                    .catch(err => {
                        telemetryUtils.failApiRequest(test, err);
                        done(err)
                    });
                });
    
                it("Get Created Subscription", done => {
                    test.service = testUtils.services.register;
                    test.api = test.service.api.getSubscription;
                    test.expectedResponse = test.api.expectedResponse;
                    
                    test.service.host
                    .get(`${test.api.path}${subscriptionId}`.replace(/"/g, ``))
                    .set('Authorization', token)
                    .set('data-partition-id', testUtils.partition)
                    .expect(test.expectedResponse)
                    .then(res => {
                        telemetryUtils.passApiRequest(test); 
                        done(); 
                    })
                    .catch(err => { 
                        console.log(`API Path: ${test.api.path + subscriptionId}`)
                        telemetryUtils.failApiRequest(test, err);
                        done(err); 
                    });
                });
                
                it('Delete Created Subscription', done => {
                    test.service = testUtils.services.register;
                    test.api = test.service.api.deleteSubscription;
                    test.expectedResponse = test.api.expectedResponse;
    
                    test.service.host
                    .delete(`${test.api.path}${subscriptionId}`.replace(/"/g, ``))
                    .set('Authorization', token)
                    .set('Accept', 'application/json')
                    .set('data-partition-id', testUtils.partition)
                    .expect(test.expectedResponse)
                    .then(() => {
                        telemetryUtils.passApiRequest(test); 
                        done(); 
                    })
                    .catch(err => { 
                        console.log(`API Path: ${test.api.path + subscriptionId}`)
                        telemetryUtils.failApiRequest(test, err);
                        done(err); 
                    });
                });
            });
        }

        if (config.test_flags.crud_register.ddmsScenario) {
            describe('Scenario: DDMS CRUD operations', (done) => {

                it("Create DDMS", done => {
                    test.service = testUtils.services.register;
                    test.api = test.service.api.createDdms;
                    test.expectedResponse = test.api.expectedResponse;
                    
                    test.service.host
                    .post(test.api.path)
                    .set('Authorization', token)
                    .set('data-partition-id', testUtils.partition)
                    .send(sampleCreateDdms)
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
    
                it("Get Created DDMS", done => {
                    test.service = testUtils.services.register;
                    test.api = test.service.api.getDdms;
                    test.expectedResponse = test.api.expectedResponse;
                    
                    test.service.host
                    .get(test.api.path + sampleCreateDdms.id)
                    .set('Authorization', token)
                    .set('data-partition-id', testUtils.partition)
                    .expect(test.expectedResponse)
                    .then(res => {
                        telemetryUtils.passApiRequest(test); 
                        done(); 
                    })
                    .catch(err => { 
                        console.log(`API Path: ${test.api.path + subscriptionId}`)
                        telemetryUtils.failApiRequest(test, err);
                        done(err); 
                    });
                });
                
                it('Delete Created DDMS', done => {
                    test.service = testUtils.services.register;
                    test.api = test.service.api.deleteDdms;
                    test.expectedResponse = test.api.expectedResponse;
    
                    test.service.host
                    .delete(test.api.path + sampleCreateDdms.id)
                    .set('Authorization', token)
                    .set('Accept', 'application/json')
                    .set('data-partition-id', testUtils.partition)
                    .expect(test.expectedResponse)
                    .then(() => {
                        telemetryUtils.passApiRequest(test); 
                        done(); 
                    })
                    .catch(err => { 
                        console.log(`API Path: ${test.api.path + subscriptionId}`)
                        telemetryUtils.failApiRequest(test, err);
                        done(err); 
                    });
                });
            });
        }

        if (config.test_flags.crud_register.actionScenario) {
            describe('Scenario: Action CRUD operations', (done) => {

                it("Create Action", done => {
                    test.service = testUtils.services.register;
                    test.api = test.service.api.createAction;
                    test.expectedResponse = test.api.expectedResponse;
                    
                    test.service.host
                    .post(test.api.path)
                    .set('Authorization', token)
                    .set('data-partition-id', testUtils.partition)
                    .send(sampleCreateAction)
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
    
                it("Get Created Action", done => {
                    test.service = testUtils.services.register;
                    test.api = test.service.api.getAction;
                    test.expectedResponse = test.api.expectedResponse;
                    
                    test.service.host
                    .get(test.api.path + sampleCreateAction.id)
                    .set('Authorization', token)
                    .set('data-partition-id', testUtils.partition)
                    .expect(test.expectedResponse)
                    .then(res => {
                        telemetryUtils.passApiRequest(test); 
                        done(); 
                    })
                    .catch(err => { 
                        console.log(`API Path: ${test.api.path + subscriptionId}`)
                        telemetryUtils.failApiRequest(test, err);
                        done(err); 
                    });
                });
                
                it('Delete Created Action', done => {
                    test.service = testUtils.services.register;
                    test.api = test.service.api.deleteAction;
                    test.expectedResponse = test.api.expectedResponse;
    
                    test.service.host
                    .delete(test.api.path + sampleCreateAction.id)
                    .set('Authorization', token)
                    .set('Accept', 'application/json')
                    .set('data-partition-id', testUtils.partition)
                    .expect(test.expectedResponse)
                    .then(() => {
                        telemetryUtils.passApiRequest(test); 
                        done(); 
                    })
                    .catch(err => { 
                        console.log(`API Path: ${test.api.path + subscriptionId}`)
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
            telemetryUtils.scenarioRequest(runId, testUtils.services.register, scenario, test.failedTests);
            done();
        });
    });
});