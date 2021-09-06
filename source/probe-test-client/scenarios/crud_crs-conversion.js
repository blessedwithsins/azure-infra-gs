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
let scenario = "crs-conversionservice_crudOps";

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
const sample_crs_basic = require(`${__dirname}/../testData/sample_crs_basic.json`);
const sample_crs_geojson = require(`${__dirname}/../testData/sample_crs_geojson.json`);
const sample_crs_point_converted = require(`${__dirname}/../testData/sample_crs_point_conversion_response.json`);
const sample_crs_trajectory_converted = require(`${__dirname}/../testData/sample_crs_trajectory_conversion_response.json`);
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

    describe('Scenario: CRS Conversion Service supports CRUD operations', (done) => {

        if (config.test_flags.crud_crs_conversion.pointConversion) {
            it("CRS Point Conversion", done => {
                test.service = testUtils.services.crs_conversion;
                test.api = test.service.api.convert;
                test.expectedResponse = test.api.expectedResponse;
                
                test.service.host
                .post(test.api.path)
                .set('Authorization', token)
                .set('data-partition-id', testUtils.partition)
                .send(sample_crs_basic)
                .then(res => {
                    test.expectedResponse.should.be.an('array').that.includes(res.statusCode);
                    data = res.body;
                    telemetryUtils.passApiRequest(test);
                    done();
                })
                .catch(err => {
                    telemetryUtils.failApiRequest(test, err);
                    done(err)
                });
            });
    
            it('Validate: CRS Point Conversion', () => {
                test.service = testUtils.services.crs_conversion;
                test.api.name = 'validate_' + test.service.api.convert.name;
                test.expectedResponse = "Valid Match";
    
                if (isEqual(data, sample_crs_point_converted)) {
                    telemetryUtils.passApiRequest(test);
                    expect(true).to.be.true;
                } else {
                    telemetryUtils.failApiRequest(test, "Invalid");
                    console.log(`actual:${JSON.stringify(data)}`);
                    expect(false).to.be.true;
                }
            });
        }

        if (config.test_flags.crud_crs_conversion.geoJsonConversion) {
            it("CRS GeoJson Conversion", done => {
                test.service = testUtils.services.crs_conversion;
                test.api = test.service.api.convertGeoJson;
                test.expectedResponse = test.api.expectedResponse;
                
                test.service.host
                .post(test.api.path)
                .set('Authorization', token)
                .set('data-partition-id', testUtils.partition)
                .send(sample_crs_geojson)
                .then(res => {
                    test.expectedResponse.should.be.an('array').that.includes(res.statusCode);
                    console.log(`CRS_geoJson:${JSON.stringify(res.body)}`); // Add response validation
                    telemetryUtils.passApiRequest(test);
                    done();
                })
                .catch(err => {
                    telemetryUtils.failApiRequest(test, err);
                    done(err)
                });
            });

            // Add Response Validation
        }

        if (config.test_flags.crud_crs_conversion.trajectoryConversion) {
            it("CRS Trajectory Conversion", done => {
                test.service = testUtils.services.crs_conversion;
                test.api = test.service.api.convertTrajectory;
                test.expectedResponse = test.api.expectedResponse;
                
                test.service.host
                .post(test.api.path)
                .set('Authorization', token)
                .set('data-partition-id', testUtils.partition)
                .send(sample_crs_geojson)
                .then(res => {
                    test.expectedResponse.should.be.an('array').that.includes(res.statusCode);
                    data = res.body;
                    telemetryUtils.passApiRequest(test);
                    done();
                })
                .catch(err => {
                    telemetryUtils.failApiRequest(test, err);
                    done(err)
                });
            });
    
            it('Validate: CRS Trajectory Conversion', () => {
                test.service = testUtils.services.crs_conversion;
                test.api.name = 'validate_' + test.service.api.convertTrajectory.name;
                test.expectedResponse = "Valid Match";
    
                if (isEqual(data, sample_crs_trajectory_converted)) {
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
            telemetryUtils.scenarioRequest(runId, testUtils.services.crs_conversion, scenario, test.failedTests);
            done();
        });
    });
});