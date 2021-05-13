"use strict";

const request = require("supertest");
const config = require("../config");
const testUtils = require("../utils/testUtils");
let appInsights = require("applicationinsights");

// Configure AI
let version = '0.1.3';
if (process.env.VERSION !== undefined) {
  version = process.env.VERSION;
}

let probeId_majorVersion = testUtils.between(1, 100000);
let probeId_minorVersion = testUtils.between(1, 100000);
const probeId = `${probeId_majorVersion}.${probeId_minorVersion}`;

appInsights.setup(process.env.APPINSIGHTS_INSTRUMENTATIONKEY).start();
const client = appInsights.defaultClient;
appInsights.defaultClient.context.tags[
  appInsights.defaultClient.context.keys.cloudRole
] = `azure-probe-test:${version}`;
appInsights.defaultClient.context.tags[
  appInsights.defaultClient.context.keys.sessionId
] = probeId;

const results = {
  SUCCESS: 1,
  FAIL: 0,
};

const failApiRequest = (test, errorResponse) => {
  client.trackMetric({
    name: `${test.scenario}.${test.service}.${test.api}:${test.runId}:api-metric`,
    value: results.FAIL
  });
  client.trackEvent({
    name: `${test.scenario}.${test.service}.${test.api}:${test.runId}:api-event`,
    properties: {
      success: false,
      probeId: probeId,
      runId: test.runId,
      scenario: test.scenario,
      service: test.service,
      api: test.api,
      expectedResponse: test.expectedResponse,
      errorResponse: errorResponse,
    },
  });
  client.flush();

  console.log(
    `Failed API ${test.api}!, Run ID: ${test.runId}, Expected response code(s) ${test.expectedResponse}, but got error \"${errorResponse}\"`
  );
};

const passApiRequest = (test) => {
  client.trackMetric({
    name: `${test.scenario}.${test.service}.${test.api}:${test.runId}:api-metric`,
    value: results.SUCCESS
  });
  client.trackEvent({
    name: `${test.scenario}.${test.service}.${test.api}:${test.runId}:api-event`,
    properties: {
      success: true,
      probeId: probeId,
      runId: test.runId,
      scenario: test.scenario,
      service: test.service,
      api: test.api,
      expectedResponses: test.expectedResponses,
    },
  });
  client.flush();
};

const scenarioRequest = (runId, service, scenarioName, failedTests) => {
  let successStatus = failedTests == 0;
  let resultStatus = successStatus ? results.SUCCESS : results.FAIL;

  client.trackMetric({
    name: `${service}.${scenarioName}:${runId}:scenario-metric`,
    value: resultStatus
  });
  client.trackEvent({
    name: `${service}.${scenarioName}:${runId}:scenario-event`,
    properties: {
      success: successStatus,
      probeId: probeId,
      runId: runId,
      scenario: scenarioName,
      service: service,
      failedTests: failedTests,
    },
  });
  client.flush();
};

const logScenarioResults = (scenarioName, passed) => {
  const val = passed == true ? 1 : 0;
  client.trackMetric({
    name: scenarioName,
    value: val,
  });
};

module.exports = {
  probeId: probeId,
  failApiRequest: failApiRequest,
  passApiRequest: passApiRequest,
  scenarioRequest: scenarioRequest,
  logScenarioResults: logScenarioResults,
};
