"use strict";

const httpUtils = require("../utils/httpUtils");
const config = require("../config");
const testUtils = require("../utils/testUtils");
const { passScenario } = require("../utils/httpUtils");

const partition = "opendes";

let test;
let token;
let record;

const tests = testUtils.tests;

describe(testUtils.scenarios.coreServices, () => {
  var allPassed = true;
  afterEach(function () {
    allPassed = allPassed && this.currentTest.state === "passed";
  });

  after(function () {
    httpUtils.logScenarioResults(testUtils.scenarios.coreServices, allPassed);
  });

  describe("Write record sceario (entitlements, storage, partition, legal)", () => {
    before((done) => {
      // Get a new OAuth Token
      testUtils.oauth
        .post("/token")
        .set("Content-Type", "application/x-www-form-urlencoded")
        .send(config.auth_params)
        .then((res) => {
          token = "Bearer " + res.body.access_token;
          done();
        });
    });

    it(tests.createLegalTag.name, (done) => {
      test = tests.createLegalTag;
      test.serviceBaseUrl
        .post(test.endpoint)
        .set("Authorization", token)
        .set("data-partition-id", partition)
        .send(test.parameters)
        .then((res) => {
          if (!test.expectedResponses.includes(res.status)) {
            httpUtils.failRequest(test, res.status);
          }
          httpUtils.passRequest(test, res.status);
          done();
        })
        .catch((err) => done(err));
    });

    it(tests.createSchema.name, (done) => {
      test = tests.createSchema;
      test.serviceBaseUrl
        .post(test.endpoint)
        .set("Authorization", token)
        .set("data-partition-id", partition)
        .send(test.parameters)
        .then((res) => {
          if (!test.expectedResponses.includes(res.status)) {
            httpUtils.failRequest(test, res.status);
          }
          httpUtils.passRequest(test, res.status);
          done();
        })
        .catch((err) => done(err));
    });

    it(tests.createStorageRecord.name, (done) => {
      test = tests.createStorageRecord;
      test.serviceBaseUrl
        .put(test.endpoint)
        .set("Authorization", token)
        .set("data-partition-id", partition)
        .send(test.parameters)
        .then((res) => {
          if (!test.expectedResponses.includes(res.status)) {
            httpUtils.failRequest(test, res.status);
          }
          record = res.body;
          httpUtils.passRequest(test, res.status);
          done();
        })
        .catch((err) => done(err));
    });

    it(tests.getStorageRecord.name, (done) => {
      test = tests.getStorageRecord;
      test.serviceBaseUrl
        .get(test.endpoint(record))
        .set("Authorization", token)
        .set("data-partition-id", partition)
        .then((res) => {
          if (!test.expectedResponses.includes(res.status)) {
            httpUtils.failRequest(test, res.status);
          }
          httpUtils.passRequest(test, res.status);
          done();
        })
        .catch((err) => done(err));
    });

    it(tests.deleteLegalTag.name, (done) => {
      test = tests.deleteLegalTag;
      test.serviceBaseUrl
        .delete(test.endpoint)
        .set("Authorization", token)
        .set("data-partition-id", partition)
        .then((res) => {
          if (!test.expectedResponses.includes(res.status)) {
            httpUtils.failRequest(test, res.status);
          }
          httpUtils.passRequest(test, res.status);
          done();
        })
        .catch((err) => done(err));
    });
  });

  describe("Searching for indexed record (partition, entitlements, search, indexer-service, indexer-queue)", () => {
    before((done) => {
      console.log(
        "      Sleeping for 30 seconds to wait for record to be indexed..."
      );
      setTimeout(done, 30000);
    });

    it(tests.searchStorageRecord.name, (done) => {
      test = tests.searchStorageRecord;
      test.serviceBaseUrl
        .post(test.endpoint)
        .set("Authorization", token)
        .set("data-partition-id", partition)
        .send(test.parameters)
        .then((res) => {
          if (
            !test.expectedResponses.includes(res.status) ||
            res.body.totalCount < 1
          ) {
            httpUtils.failRequest(test, res.status);
          }
          httpUtils.passRequest(test, res.status);
          done();
        })
        .catch((err) => done(err));
    });

    it(tests.deleteStorageRecord.name, (done) => {
      test = tests.deleteStorageRecord;
      test.serviceBaseUrl
        .delete(test.endpoint(record))
        .set("Authorization", token)
        .set("data-partition-id", partition)
        .then((res) => {
          if (!test.expectedResponses.includes(res.status)) {
            httpUtils.failRequest(test, res.status);
          }
          httpUtils.passRequest(test, res.status);
          done();
        })
        .catch((err) => done(err));
    });
  });
});
