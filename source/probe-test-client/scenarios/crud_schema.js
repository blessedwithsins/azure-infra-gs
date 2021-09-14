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
let scenario = "schemaservice_crudOps";

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
const sampleSchemaToCreate = require(`${__dirname}/../testData/sample_schemaToCreate.json`);
let sampleSchemaId = `${testUtils.partition}:wks:dataset--File.Generic:1.0.0`

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

    describe('Scenario: Schema Service supports CRUD operations', (done) => {
        
        if (config.test_flags.crud_schema.getSchemaById) {
            it("Get Schema By ID", done => {
                test.service = testUtils.services.schema;
                test.api = test.service.api.getSchemaById;
                test.expectedResponse = test.api.expectedResponse;
                
                test.service.host
                .get(test.api.path + sampleSchemaId)
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
        }

        if (config.test_flags.crud_schema.getAllSchemas) {
            it("Get All Schemas", done => {
                test.service = testUtils.services.schema;
                test.api = test.service.api.getSchema;
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
        }

        if (config.test_flags.crud_schema.createSchema) {
            it("Create Schema", done => {
                test.service = testUtils.services.schema;
                test.api = test.service.api.createSchema;
                test.expectedResponse = test.api.expectedResponse;
                
                test.service.host
                .post(test.api.path)
                .set('Authorization', token)
                .set('data-partition-id', testUtils.partition)
                .send(sampleSchemaToCreate)
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

        if (config.test_flags.crud_schema.getCreatedSchemaById) {
            it("Get Newly Created Schema By ID", done => {
                test.service = testUtils.services.schema;
                test.api = test.service.api.getSchemaById;
                test.expectedResponse = test.api.expectedResponse;
    
                test.service.host
                .get(test.api.path + `${sampleSchemaToCreate.schemaInfo.schemaIdentity.id}`)
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
        }

        if (config.test_flags.crud_schema.deleteSchema) {
            it("Delete Schema By ID", done => {
                test.service = testUtils.services.schema;
                test.api = test.service.api.deleteSchema;
                test.expectedResponse = test.api.expectedResponse;
    
                test.service.host
                .get(test.api.path + `${sampleSchemaToCreate.schemaInfo.schemaIdentity.id}`)
                .set('Authorization', token)
                .set('data-partition-id', testUtils.partition)
                .then(res => {
                    test.expectedResponse.should.be.an('array').that.includes(res.statusCode);
                    telemetryUtils.passApiRequest(test); 
                    done(); 
                })
                .catch(err => { 
                    telemetryUtils.failApiRequest(test, err);
                    done(err); 
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