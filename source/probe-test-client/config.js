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
    notification: `https://${process.env.OSDU_HOST}/api/notification/v1`,
    partition: `https://${process.env.OSDU_HOST}/api/partition/v1`,
    crs_catalog: `https://${process.env.OSDU_HOST}/api/crs/catalog`,
    crs_conversion: `https://${process.env.OSDU_HOST}/api/crs/converter`,
    ingestion_workflow: `https://${process.env.OSDU_HOST}/api/workflow/v1`,
    policy: `https://${process.env.OSDU_HOST}/api/policy/v1`,
    unit: `https://${process.env.OSDU_HOST}/api/unit/v3`,
    search: `https://${process.env.OSDU_HOST}/api/search/v2/query`,
    schema: `https://${process.env.OSDU_HOST}/api/schema-service/v1`,
    register: `https://${process.env.OSDU_HOST}/api/register/v1`,
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
  },
  subscription_id: process.env.SUBSCRIPTION_ID,
};
