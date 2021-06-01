"use strict";
require("dotenv").config({
  path: __dirname + "/" + process.env.ENVIRONMENT + ".env",
});

module.exports = {
  api_host: {
    auth: `https://login.microsoftonline.com/${process.env.TENANT_ID}`,
    entitlement: `https://${process.env.OSDU_HOST}/api/entitlements/v2`,
    legal: `https://${process.env.OSDU_HOST}/api/legal/v1`,
    storage: `https://${process.env.OSDU_HOST}/api/storage/v2`,
    search: `https://${process.env.OSDU_HOST}/api/search/v2`,
  },
  auth_params: {
    grant_type: "client_credentials",
    client_id: process.env.PRINCIPAL_ID,
    client_secret: process.env.PRINCIPAL_SECRET,
    resource: process.env.CLIENT_ID,
  },
  telemetry_settings: {
    metrics: process.env.TRACK_METRICS,
    events: process.env.TRACK_EVENTS,
  }
};
