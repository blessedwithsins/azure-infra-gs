"use strict";

const config = require("../config");
let appInsights = require("applicationinsights");

// Helper Functions
function between(min, max) {
    return Math.floor(Math.random() * (max - min + 1) + min);
};

// Configure AI
let version = '0.9.0';
if (process.env.VERSION !== undefined) {
  version = process.env.VERSION;
}

let runid_majorVersion = between(1, 100000);
let runid_minorVersion = between(1, 100000);
const runId = `${runid_majorVersion}.${runid_minorVersion}`;

appInsights.setup(process.env.APPINSIGHTS_INSTRUMENTATIONKEY.trim()).start();
const client = appInsights.defaultClient;
appInsights.defaultClient.context.tags[
  appInsights.defaultClient.context.keys.cloudRole
] = `legaltags-sync:${version}`;
appInsights.defaultClient.context.tags[
  appInsights.defaultClient.context.keys.sessionId
] = runId;

const results = {
  SUCCESS: 1,
  FAIL: 0,
};

const failApiRequest = (uri, errorResponse, data) => {
  client.trackEvent({
    name: `${uri}:api-event`,
    properties: {
      success: false,
      runId: runId,
      errorResponse: errorResponse,
      data: data,
    },
  });
  client.flush();

  console.log(
    `Failed API ${uri}!, Run ID: ${runId}, got error \"${errorResponse}\" with Data: ${data}`
  );
};

const passApiRequest = (uri, data) => {
  client.trackEvent({
    name: `${uri}:api-event`,
    properties: {
      success: true,
      runId: runId,
      data: data,
    },
  });
  client.flush();

  console.log(
      `Success API ${uri}!, Run ID: ${runId}, Data: ${data}`
    );
};

module.exports = {
  runId: runId,
  failApiRequest: failApiRequest,
  passApiRequest: passApiRequest,
};