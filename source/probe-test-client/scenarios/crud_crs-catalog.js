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
let scenario = "crs-catalogservice_crudOps";

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
const getAreaResponse = require(`${__dirname}/../testData/sample_crs_catalog_area_response.json`);
const getCatalogResponse = require(`${__dirname}/../testData/sample_crs_catalog_catalog_response.json`);
const getCrsResponse = require(`${__dirname}/../testData/sample_crs_catalog_crs_response.json`);
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

    describe('Scenario: CRS Catalog Service supports CRUD operations', (done) => {

        if (config.test_flags.crud_crs_catalog.getArea) {
            it("Get All Area", done => {
                test.service = testUtils.services.crs_catalog;
                test.api = test.service.api.getArea;
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
    
            it('Validate: Get All Area', () => {
                test.service = testUtils.services.crs_catalog;
                test.api.name = 'validate_' + test.service.api.getArea.name;
                test.expectedResponse = "Valid Match";
    
                if (isEqual(data, getAreaResponse)) {
                    telemetryUtils.passApiRequest(test);
                    expect(true).to.be.true;
                } else {
                    telemetryUtils.failApiRequest(test, "Invalid");
                    console.log(`actual:${JSON.stringify(data)}`);
                    expect(false).to.be.true;
                }
            });
        }

        if (config.test_flags.crud_crs_catalog.getCatalog) {
            it("Get All Catalog", done => {
                test.service = testUtils.services.crs_catalog;
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
    
            it('Validate: Get All Catalog', () => {
                test.service = testUtils.services.crs_catalog;
                test.api.name = 'validate_' + test.service.api.getCatalog.name;
                test.expectedResponse = "Valid Match";
    
                if (isEqual(data, getCatalogResponse)) {
                    telemetryUtils.passApiRequest(test);
                    expect(true).to.be.true;
                } else {
                    telemetryUtils.failApiRequest(test, "Invalid");
                        console.log(`actual:${JSON.stringify(data)}`);
                    expect(false).to.be.true;
                }
            });
        }

        if (config.test_flags.crud_crs_catalog.getCRS) {
            it("Get All CRS", done => {
                test.service = testUtils.services.crs_catalog;
                test.api = test.service.api.getCrs;
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
    
            it('Validate: Get All CRS', () => {
                test.service = testUtils.services.crs_catalog;
                test.api.name = 'validate_' + test.service.api.getCrs.name;
                test.expectedResponse = "Valid Match";
    
                if (isEqual(data, getCrsResponse)) {
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
            telemetryUtils.scenarioRequest(runId, testUtils.services.crs_catalog, scenario, test.failedTests);
            done();
        });
    });
});