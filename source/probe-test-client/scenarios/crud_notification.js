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
let scenario = "notificationservice_crudOps";

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
const sampleSubscription = require(`${__dirname}/../testData/sample_notification_subscription.json`);

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

    describe('Scenario: Notification Service supports CRUD operations', (done) => {

        if (config.test_flags.crud_notification.createSubscription) {
          it("Create a Subscription", done => {
            test.service = testUtils.services.notification;
            test.api = test.service.api.createSubscription;
            test.expectedResponse = test.api.expectedResponse;
            
            test.service.host
            .post(test.api.path)
            .set('Authorization', token)
            .set('Data-Partition-Id', testUtils.partition)
            .set('Aeg-Subscription-Name', config.subscription_id)
            .send(sampleSubscription)
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
        
        afterEach(function() {
            if (this.currentTest.state === 'failed') {
                test.failedTests += 1;
            }
          });

        after(done => {
            telemetryUtils.scenarioRequest(runId, testUtils.services.notification, scenario, test.failedTests);
            done();
        });
    });
});