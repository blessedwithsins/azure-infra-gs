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
let scenario = "unitsservice_crudOps";

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
const sample_getAll_response = require(`${__dirname}/../testData/sample_unit_getAll_response.json`);
const sample_getCatalog_response = require(`${__dirname}/../testData/sample_unit_getCatalog_response.json`);
const sample_getMeasurement_response = require(`${__dirname}/../testData/sample_unit_getMeasurement_response.json`);
const sample_getUnitMap_response = require(`${__dirname}/../testData/sample_unit_getUnitMap_response.json`);
const sample_getUnitSystem_response = require(`${__dirname}/../testData/sample_unit_getUnitSystem_response.json`);
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

    describe('Scenario: Units Service supports CRUD operations', (done) => {

        if (config.test_flags.crud_unit.getUnits) {
            it("Get All Units", done => {
                test.service = testUtils.services.unit;
                test.api = test.service.api.getUnit;
                test.expectedResponse = test.api.expectedResponse;
                
                test.service.host
                .get(test.api.path)
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
    
            it('Validate: Get All Units', () => {
                test.service = testUtils.services.unit;
                test.api.name = 'validate_' + test.service.api.getUnit.name;
                test.expectedResponse = "Valid Match";
    
                if (isEqual(data, sample_getAll_response)) {
                    telemetryUtils.passApiRequest(test);
                    expect(true).to.be.true;
                } else {
                    telemetryUtils.failApiRequest(test, "Invalid");
                        console.log(`actual:${JSON.stringify(data)}`);
                    expect(false).to.be.true;
                }
            });
        }

        if (config.test_flags.crud_unit.getCatalog) {
            it("Get Catalog", done => {
                test.service = testUtils.services.unit;
                test.api = test.service.api.getCatalog;
                test.expectedResponse = test.api.expectedResponse;
                
                test.service.host
                .get(test.api.path)
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
    
            it('Validate: Get Catalog', () => {
                test.service = testUtils.services.unit;
                test.api.name = 'validate_' + test.service.api.getCatalog.name;
                test.expectedResponse = "Valid Match";
    
                if (isEqual(data, sample_getCatalog_response)) {
                    telemetryUtils.passApiRequest(test);
                    expect(true).to.be.true;
                } else {
                    telemetryUtils.failApiRequest(test, "Invalid");
                        console.log(`actual:${JSON.stringify(data)}`);
                    expect(false).to.be.true;
                }
            });
        }

        if (config.test_flags.crud_unit.getMeasurements) {
            it("Get Measurements", done => {
                test.service = testUtils.services.unit;
                test.api = test.service.api.getMeasurement;
                test.expectedResponse = test.api.expectedResponse;
                
                test.service.host
                .get(test.api.path)
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
    
            it('Validate: Get Measurements', () => {
                test.service = testUtils.services.unit;
                test.api.name = 'validate_' + test.service.api.getMeasurement.name;
                test.expectedResponse = "Valid Match";
    
                if (isEqual(data, sample_getMeasurement_response)) {
                    telemetryUtils.passApiRequest(test);
                    expect(true).to.be.true;
                } else {
                    telemetryUtils.failApiRequest(test, "Invalid");
                        console.log(`actual:${JSON.stringify(data)}`);
                    expect(false).to.be.true;
                }
            });
        }

        if (config.test_flags.crud_unit.getUnitMaps) {
            it("Get Unit Maps", done => {
                test.service = testUtils.services.unit;
                test.api = test.service.api.getUnitMaps;
                test.expectedResponse = test.api.expectedResponse;
                
                test.service.host
                .get(test.api.path)
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
    
            it('Validate: Get Unit Maps', () => {
                test.service = testUtils.services.unit;
                test.api.name = 'validate_' + test.service.api.getUnitMaps.name;
                test.expectedResponse = "Valid Match";
    
                if (isEqual(data, sample_getUnitMap_response)) {
                    telemetryUtils.passApiRequest(test);
                    expect(true).to.be.true;
                } else {
                    telemetryUtils.failApiRequest(test, "Invalid");
                        console.log(`actual:${JSON.stringify(data)}`);
                    expect(false).to.be.true;
                }
            });
        }

        if (config.test_flags.crud_unit.getUnitSystems) {
            it("Get Unit Systems", done => {
                test.service = testUtils.services.unit;
                test.api = test.service.api.getUnitSystems;
                test.expectedResponse = test.api.expectedResponse;
                
                test.service.host
                .get(test.api.path)
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
    
            it('Validate: Get Unit Systems', () => {
                test.service = testUtils.services.unit;
                test.api.name = 'validate_' + test.service.api.getUnitSystems.name;
                test.expectedResponse = "Valid Match";
    
                if (isEqual(data, sample_getUnitSystem_response)) {
                    telemetryUtils.passApiRequest(test);
                    expect(true).to.be.true;
                } else {
                    telemetryUtils.failApiRequest(test, "Invalid");
                        console.log(`actual:${JSON.stringify(data)}`);
                    expect(false).to.be.true;
                }
            });
        }
        
        afterEach(function() {
            if (this.currentTest.state === 'failed') {
                test.failedTests += 1;
            }
          });

        after(done => {
            telemetryUtils.scenarioRequest(runId, testUtils.services.unit, scenario, test.failedTests);
            done();
        });
    });
});