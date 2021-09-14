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
let scenario = "legalservice_crudOps";

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
let tag = 'opendes-public-usa-dataset-1'
const sampleLegalTag = require(`${__dirname}/../testData/sample_legal_tag_crud.json`);
sampleLegalTag.name = tag
let data = "";

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

    describe('Scenario: Legal Service supports CRUD operations', (done) => {

        if (config.test_flags.crud_legal.getAllLegalTags) {
            it("Get All Legal Tags", done => {
                test.service = testUtils.services.legal;
                test.api = test.service.api.getAllLegalTags;
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

        if (config.test_flags.crud_legal.createLegalTag) {
            it("Create Legal Tag", done => {
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
    
            if (config.test_flags.crud_legal.getCreatedLegalTag) {
                it("Get Created Legal Tag", done => {
                    test.service = testUtils.services.legal;
                    test.api = test.service.api.getLegalTag;
                    test.expectedResponse = test.api.expectedResponse;
                    
                    test.service.host
                    .get(test.api.path + sampleLegalTag.name)
                    .set('Authorization', token)
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
        
                    if (isEqual(data, sampleLegalTag)) {
                        telemetryUtils.passApiRequest(test);
                        expect(true).to.be.true;
                    } else {
                        telemetryUtils.failApiRequest(test, "Invalid");
                            console.log(`actual:${JSON.stringify(data)}`);
                        expect(false).to.be.true;
                    }
                });
            }
    
            describe('Probe Cleanup', done => {
    
                it('Delete Created LegalTag', done => {
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
            telemetryUtils.scenarioRequest(runId, testUtils.services.legal, scenario, test.failedTests);
            done();
        });
    });
});