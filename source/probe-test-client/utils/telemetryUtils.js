"use strict";

const request = require("supertest");
const config = require(`${__dirname}/../config`);
const testUtils = require(`${__dirname}/../utils/testUtils`);
let appInsights = require("applicationinsights");

// Configure AI
let version = '0.9.0';
if (process.env.VERSION !== undefined) {
  version = process.env.VERSION;
}

let probeRunId_majorVersion = testUtils.between(1, 100000);
let probeRunId_minorVersion = testUtils.between(1, 100000);
const probeRunId = `${probeRunId_majorVersion}.${probeRunId_minorVersion}`;

appInsights.setup(process.env.APPINSIGHTS_INSTRUMENTATIONKEY).start();
const client = appInsights.defaultClient;
appInsights.defaultClient.context.tags[
  appInsights.defaultClient.context.keys.cloudRole
] = `osdu-probe:${version}`;
appInsights.defaultClient.context.tags[
  appInsights.defaultClient.context.keys.sessionId
] = probeRunId;

const results = {
  SUCCESS: 1,
  FAIL: 0,
};

const failApiRequest = (test, errorResponse) => {
  client.trackMetric({
    name: `${test.scenario}.${test.service.name}.${test.api.name}:${test.runId}:api-metric`,
    value: results.FAIL
  });
  client.trackEvent({
    name: `${test.scenario}.${test.service.name}.${test.api.name}:${test.runId}:api-event`,
    properties: {
      success: false,
      probeRunId: probeRunId,
      runId: test.runId,
      scenario: test.scenario.name,
      service: test.service,
      api: test.api.name,
      expectedResponse: test.expectedResponse,
      errorResponse: errorResponse,
    },
  });
  client.flush();

  console.log(`Failed API ${JSON.stringify(test.api)}!, Run ID: ${test.runId}, Expected response code(s) ${test.expectedResponse}, but got error \"${errorResponse}\"`
  );
};

const passApiRequest = (test) => {
  client.trackMetric({
    name: `${test.scenario}.${test.service.name}.${test.api.name}:${test.runId}:api-metric`,
    value: results.SUCCESS
  });
  client.trackEvent({
    name: `${test.scenario}.${test.service.name}.${test.api.name}:${test.runId}:api-event`,
    properties: {
      success: true,
      probeRunId: probeRunId,
      runId: test.runId,
      scenario: test.scenario,
      service: test.service.name,
      api: test.api.name,
      expectedResponses: test.expectedResponses,
    },
  });
  client.flush();
};

const scenarioRequest = (runId, service, scenarioName, failedTests) => {
  let successStatus = failedTests == 0;
  let resultStatus = successStatus ? results.SUCCESS : results.FAIL;

  client.trackMetric({
    name: `${service.name}.${scenarioName}:${runId}:scenario-metric`,
    value: resultStatus
  });
  client.trackEvent({
    name: `${service.name}.${scenarioName}:${runId}:scenario-event`,
    properties: {
      success: successStatus,
      probeRunId: probeRunId,
      runId: runId,
      scenario: scenarioName,
      service: service.name,
      serviceHost: service.host,
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
  probeRunId: probeRunId,
  failApiRequest: failApiRequest,
  passApiRequest: passApiRequest,
  scenarioRequest: scenarioRequest,
  logScenarioResults: logScenarioResults,
};
