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
    file: `https://${process.env.OSDU_HOST}/api/file/v2`,
    workflow: `https://${process.env.OSDU_HOST}/api/workflow/v1`,
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
  test_flags: {
    crud_crs_catalog:{
      getArea: true,
      getCatalog: true,
      getCRS: true,
    },
    crud_crs_conversion: {
      pointConversion: true,
      geoJsonConversion: false, //400 error
      trajectoryConversion: true,
    },
    crud_entitlements: {
      enableScenario: true,
    },
    crud_ingestion_workflow: {
      getAllWorkflows: true,
      createWorkflow: true,
      getCreatedWorkflow: true,
    },
    crud_legal: {
      getAllLegalTags: true,
      createLegalTag: true,
      getCreatedLegalTag: true,
    },
    crud_notification: {
      createSubscription: false, // 404 error
    },
    crud_partition: {
      preCreateGetPartition: true,
      createPartition: true,
      getCreatedPartition: true,
    },
    crud_policy: {
      getAllPolicies: true,
      evaluatePolicy: false, // {"code":"resource_not_found","message":"storage_not_found_error: policy id \"test\""}
      createTestPolicy: false, // {"code":"resource_not_found","message":"storage_not_found_error: policy id \"test\""}
      getTestPolicy: true,
    },
    crud_register: {
      subscriptionScenario: false, // Add hard coded secret in testData/sample_register_subscription_create.json
      ddmsScenario: true,
      actionScenario: true,
    },
    crud_schema: {
      getSchemaById: true,
      getAllSchemas: false, // 500 error
      createSchema: false, // 400 error
      getCreatedSchemaById: true,
      deleteSchema: true,
    },
    crud_search: {
      standardQueries: true,
      enrichedQueries: true,
      seismicQueries: true,
    },
    crud_unit: {
      getUnits: true,
      getCatalog: true,
      getMeasurements: true,
      getUnitMaps: true,
      getUnitSystems: true,
    },
    scenario_searchInsertedRecord: {
      enableScenario: true,
    },
    scenario_csv_ingest: {
      enableScenario: false,
    },
    scenario_manifest_ingest: {
      enableScenario: true,
    },
    scenario_recordSchema: {
      enableScenario: true,
    },
    scenario_file_upload: {
      enableScenario: true,
    },
  },
};
