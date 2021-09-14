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
let scenario = "partitionservice_crudOps";

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
let partition = `probetest-${testUtils.between(1, 100000)}`;
const samplePartition = require(`${__dirname}/../testData/sample_partition.json`);
const samplePartitionResponse = require(`${__dirname}/../testData/sample_partition_response.json`);
const samplePartitionResponseParsed = JSON.parse(JSON.stringify(samplePartitionResponse).replace(/##partition##/g, `${partition}`));
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

    describe('Scenario: Partition Service supports CRUD operations', (done) => {

        if (config.test_flags.crud_partition.preCreateGetPartition) {
            it("Get Partition", done => {
                test.service = testUtils.services.partition;
                test.api = test.service.api.getPartition;
                test.expectedResponse = test.api.expectedFailureResponse;
                
                test.service.host
                .get(test.api.path + partition)
                .set('Authorization', token)
                .set('data-partition-id', partition)
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

        if (config.test_flags.crud_partition.createPartition) {
            it("Create Partition", done => {
                test.service = testUtils.services.partition;
                test.api = test.service.api.createPartition;
                test.expectedResponse = test.api.expectedResponse;
                
                test.service.host
                .post(test.api.path + partition)
                .set('Authorization', token)
                .set('data-partition-id', partition)
                .send(samplePartition)
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
    
            if (config.test_flags.crud_partition.getCreatedPartition) {
                it("Get Created Partition", done => {
                    test.service = testUtils.services.partition;
                    test.api = test.service.api.getPartition;
                    test.expectedResponse = test.api.expectedResponse;
                    
                    test.service.host
                    .get(test.api.path + partition)
                    .set('Authorization', token)
                    .set('data-partition-id', partition)
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
        
                it('Validate: Get Created Partition', () => {
                    test.service = testUtils.services.partition;
                    test.api.name = 'validate_' + test.service.api.getPartition.name;
                    test.expectedResponse = "Valid Match";
        
                    if (isEqual(data, samplePartitionResponseParsed)) {
                        telemetryUtils.passApiRequest(test);
                        expect(true).to.be.true;
                    } else {
                        telemetryUtils.failApiRequest(test, "Invalid");
                        console.log(`actual:${JSON.stringify(data)}`);
                        console.log(`expected:${JSON.stringify(samplePartitionResponseParsed)}`);
                        expect(false).to.be.true;
                    }
                });
            }
    
            describe('Probe Cleanup', done => {
    
                it('Delete Created Partition', done => {
                    test.service = testUtils.services.partition;
                    test.api = test.service.api.deletePartition;
                    test.expectedResponse = test.api.expectedResponse;
    
                    test.service.host
                    .delete(test.api.path + partition)
                    .set('Authorization', token)
                    .set('Accept', 'application/json')
                    .set('data-partition-id', partition)
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
            telemetryUtils.scenarioRequest(runId, testUtils.services.partition, scenario, test.failedTests);
            done();
        });
    });
});