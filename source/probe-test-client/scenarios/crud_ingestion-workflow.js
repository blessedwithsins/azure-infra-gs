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
let scenario = "ingestion-workflowservice_crudOps";

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
const sampleIngestionWorkflow = require(`${__dirname}/../testData/sample_ingestion_workflow.json`);
const sampleIngestionWorkflowResponse = require(`${__dirname}/../testData/sample_ingestion_workflow_response.json`);
let workflow_name = 'Default_ingest';
sampleIngestionWorkflow.workflowName = workflow_name;
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

    describe('Scenario: Ingestion Workflow Service supports CRUD operations', (done) => {
        
        if (config.test_flags.crud_ingestion_workflow.getAllWorkflows) {
            it("Get All Ingestion Workflows", done => {
                test.service = testUtils.services.ingestion_workflow;
                test.api = test.service.api.getAllWorkflows;
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

        if (config.test_flags.crud_ingestion_workflow.createWorkflow) {
            it("Create Ingestion Workflow", done => {
                test.service = testUtils.services.ingestion_workflow;
                test.api = test.service.api.createWorkflow;
                test.expectedResponse = test.api.expectedResponse;
                
                test.service.host
                .post(test.api.path)
                .set('Authorization', token)
                .set('data-partition-id', testUtils.partition)
                .send(sampleIngestionWorkflow)
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
    
            if (config.test_flags.crud_ingestion_workflow.getCreatedWorkflow) {
                it("Get Created Ingestion Workflow", done => {
                    test.service = testUtils.services.ingestion_workflow;
                    test.api = test.service.api.getWorkflow;
                    test.expectedResponse = test.api.expectedResponse;
                    
                    test.service.host
                    .get(test.api.path + sampleIngestionWorkflow.workflowName)
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
        
                it('Validate: Get Created Ingestion Workflow', () => {
                    test.service = testUtils.services.ingestion_workflow;
                    test.api.name = 'validate_' + test.service.api.getWorkflow.name;
                    test.expectedResponse = "Valid Match";
        
                    data.creationTimestamp = "";
                    if (isEqual(data, sampleIngestionWorkflowResponse)) {
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
    
                it('Delete Created Ingestion Workflow', done => {
                    test.service = testUtils.services.ingestion_workflow;
                    test.api = test.service.api.deleteWorkflow;
                    test.expectedResponse = test.api.expectedResponse;
    
                    test.service.host
                    .delete(test.api.path + sampleIngestionWorkflow.workflowName)
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
            telemetryUtils.scenarioRequest(runId, testUtils.services.ingestion_workflow, scenario, test.failedTests);
            done();
        });
    });
});