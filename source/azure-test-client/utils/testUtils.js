"use strict";

const config = require("../config");
const request = require("supertest");

function between(min, max) {
  return Math.floor(Math.random() * (max - min + 1) + min);
}

const services = {
  storage: "storage",
  legal: "legal",
  search: "search",
};

const storageHost = request(config.api_host.storage);
const legalHost = request(config.api_host.legal);
const searchHost = request(config.api_host.search);

const sampleRecord = require("../test_data/sample_record.json");
const sampleSchema = require("../test_data/sample_schema.json");
const sampleLegalTag = require("../test_data/sample_legal_tag.json");
const sampleQuery = require("../test_data/sample_query.json");

// Generate random run ID
const runId = between(1, 100000);
const kind = `opendes:smoketest:dummydata:0.0.${runId}`;

sampleSchema.kind = kind;
sampleRecord[0].kind = kind;
sampleQuery.kind = kind;

const scenarios = {
  coreServices: "All core services available",
};

const tests = {
  createLegalTag: {
    name: "Creating legal tag gets 201 or 409 response",
    service: services.legal,
    serviceBaseUrl: legalHost,
    endpoint: "/legaltags",
    parameters: sampleLegalTag,
    expectedResponses: [201, 409],
  },
  createSchema: {
    name: "Creating schema with storage service gets 201 or 409 response",
    service: services.storage,
    serviceBaseUrl: storageHost,
    endpoint: "/schemas",
    parameters: sampleSchema,
    expectedResponses: [201, 409],
  },
  createStorageRecord: {
    name: "Creating storage record gets 201 response",
    service: services.storage,
    serviceBaseUrl: storageHost,
    endpoint: "/records",
    parameters: sampleRecord,
    expectedResponses: [201],
  },
  getStorageRecord: {
    name: "Getting storage record gets 201 response",
    service: services.storage,
    serviceBaseUrl: storageHost,
    endpoint: (record) => `/records/${record.recordIds[0]}`,
    expectedResponses: [200],
  },
  searchStorageRecord: {
    name: "Searching for storge record gets a 200 response",
    service: services.search,
    serviceBaseUrl: searchHost,
    endpoint: "/query",
    parameters: sampleQuery,
    expectedResponses: [200],
  },
  deleteStorageRecord: {
    name: "Deleting storage record gets 200 response",
    service: services.storage,
    serviceBaseUrl: storageHost,
    endpoint: (record) => `/records/${record.recordIds[0]}`,
    expectedResponses: [204],
  },
  deleteLegalTag: {
    name: "Deleting legal tag gets 204 response",
    service: services.legal,
    serviceBaseUrl: legalHost,
    endpoint: `/legaltags/${sampleLegalTag.name}`,
    expectedResponses: [204],
  },
};

let oauth = request(config.api_host.auth + "/oauth2");

module.exports = {
  between: between,
  tests: tests,
  oauth: oauth,
  scenarios: scenarios,
};
