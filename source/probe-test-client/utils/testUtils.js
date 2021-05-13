"use strict";

const request = require("supertest");
const config = require("../config");

function between(min, max) {
    return Math.floor(Math.random() * (max - min + 1) + min);
};

// SERVICE INFO
const services = {
    entitlement: "entitlements",
    legal: "legal",
    storage: "storage",
    search: "search",
};

const serviceHosts = {
    entitlementHost: request(config.api_host.entitlement),
    legalHost: request(config.api_host.legal),
    storageHost: request(config.api_host.storage),
    searchHost: request(config.api_host.search),
};

const api = {
    entitlement: {
        getGroups: {
            name: 'getGroups',
            path: '/groups/',
            expectedResponse: 200,
        },
    },
    legal: {
        createLegalTags: {
            name: 'createLegalTags',
            path: '/legaltags/',
            expectedResponse: [201, 409]
        },
        getLegalTags: {
            name: 'getLegalTags',
            path: '/legaltags/',
            expectedResponse: 200,
        },
        deleteLegalTags: {
            name: 'deleteLegalTags',
            path: '/legaltags/',
            expectedResponse: 204,
        },
    },
    storage: {
        createSchema: {
            name: 'createSchema',
            path: '/schemas/',
            expectedResponse: [201, 409]
        },
        getSchema: {
            name: 'getSchema',
            path: '/schemas/',
            expectedResponse: 200,
        },
        deleteSchema: {
            name: 'deleteSchema',
            path: '/schemas/',
            expectedResponse: 204,
        },
        createRecord: {
            name: 'createRecord',
            path: '/records/',
            expectedResponse: [201],
        },
        getRecord: {
            name: 'getRecord',
            path: '/records/',
            expectedResponse: 200,
        },
        deleteRecord: {
            name: 'deleteRecord',
            path: '/records/',
            expectedResponse: 204,
        },
    },
    search: {
        findRecord: {
            name: 'findRecord',
            path: '/query/',
            expectedResponse: [200],
        },
    },
};

// TEST DATA
let partition = 'opendes';
if (process.env.DATA_PARTITION !== undefined) {
  partition = process.env.DATA_PARTITION;
}

const sampleLegalTag = require(`../testData/ sample_legal_tag.json`);
const sampleSchema = require("../testData/sample_schema.json");
const sampleRecord = require("../testData/sample_record.json");
const sampleQuery = require("../testData/sample_query.json");


const sampleData = {
    sampleLegalTag: sampleLegalTag,
    sampleSchema: sampleSchema,
    sampleRecord: sampleRecord,
    sampleQuery: sampleQuery,
};

// OAUTH2.0
let oAuth = request(config.api_host.auth + "/oauth2");

let test = {
    runId: "runId",
    scenario: "scenario",
    service: "service",
    api: "api",
    expectedResponse: -1,
    failedTests: 0,
};

module.exports = {
    between: between,
    services: services,
    serviceHosts: serviceHosts,
    api: api,
    partition: partition,
    sampleData: sampleData,
    oAuth: oAuth,
    test: test,
};  