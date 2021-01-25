'use strict';

const request = require("supertest");
const httpUtils = require('../utils/httpUtils');
const config = require('../config');



let oAuth = request(config.api_host.auth + '/oauth2');
const storageHost = request(config.api_host.storage);
const legalHost = request(config.api_host.legal);
const searchHost = request(config.api_host.search);
const partition = 'opendes';

const sampleRecord = require('../test_data/sample_record.json');
const sampleSchema = require('../test_data/sample_schema.json');
const sampleLegalTag = require('../test_data/sample_legal_tag.json')
const sampleQuery = require('../test_data/sample_query.json');


// TODO: Generate runid logic
const runId = 7;
const kind = `opendes:smoketest:dummydata:0.0.${runId}`

let test;
let token;
let record;


sampleSchema.kind = kind;
sampleRecord[0].kind = kind;
sampleQuery.kind = kind;



const services = {
    storage: "storage",
    legal: "legal",
    search: "search"
}


const tests = {
    createLegalTag: {
        name: "Creating legal tag gets 201 or 409 response",
        service: services.legal,
        serviceBaseUrl: legalHost,
        endpoint: "/legaltags",
        parameters: sampleLegalTag,
        expectedResponses: [201, 409]
    },
    createSchema: {
        name: "Creating schema with storage service gets 201 or 409 response",
        service: services.storage,
        serviceBaseUrl: storageHost,
        endpoint: "/schemas",
        parameters: sampleSchema,
        expectedResponses: [201, 409]
    },
    createStorageRecord: {
        name: "Creating storage record gets 201 response",
        service: services.storage,
        serviceBaseUrl: storageHost,
        endpoint: "/records",
        parameters: sampleRecord,
        expectedResponses: [201]
    },
    getStorageRecord: {
        name: "Getting storage record gets 201 response",
        service: services.storage,
        serviceBaseUrl: storageHost,
        endpoint: (record) => `/records/${record.recordIds[0]}`,
        expectedResponses: [200]
    },
    searchStorageRecord: {
        name: "Searching for storge record gets a 200 response",
        service: services.search,
        serviceBaseUrl: searchHost,
        endpoint: "/query",
        parameters: sampleQuery,
        expectedResponses: [200]
    },
    deleteStorageRecord: {
        name: "Deleting storage record gets 200 response",
        service: services.storage,
        serviceBaseUrl: storageHost,
        endpoint: (record) => `/records/${record.recordIds[0]}`,
        expectedResponses: [204]
    },
    deleteLegalTag: {
        name: "Deleting legal tag gets 204 response",
        service: services.legal,
        serviceBaseUrl: legalHost,
        endpoint: (legalTag) => `/legaltags/${legalTag.name}`,
        expectedResponses: [204]
    }
}


describe("Testing all core services", () => {
    describe("Write record sceario (entitlements, storage, partition, legal)", () => {


        before((done) => {
            // Get a new OAuth Token
            oAuth.post('/token')
              .set('Content-Type', 'application/x-www-form-urlencoded')
              .send(config.auth_params)
              .then((res) => {
                token = 'Bearer ' + res.body.access_token;
                done();
              });
          });
    
    
        it(tests.createLegalTag.name, (done) => {
            test = tests.createLegalTag;
            test.serviceBaseUrl.post(test.endpoint)
                .set('Authorization', token)
                .set('data-partition-id', partition)
                .send(test.parameters)
                .then((res) => {
                    if(!test.expectedResponses.includes(res.status)){
                        httpUtils.failRequest(test, res.status);
                    }
                    httpUtils.passRequest(test, res.status);
                    done();
                })
                .catch(err => done(err));
        });
    
        it(tests.createSchema.name, (done) => {
            test = tests.createSchema;
            test.serviceBaseUrl.post(test.endpoint)
                .set('Authorization', token)
                .set('data-partition-id', partition)
                .send(test.parameters)
                .then((res) => {
                    if(!test.expectedResponses.includes(res.status)){
                        httpUtils.failRequest(test, res.status);
                    }
                    httpUtils.passRequest(test, res.status);
                    done();
                })
                .catch(err => done(err));
        });
    
    
        it(tests.createStorageRecord.name, (done) => {
            test = tests.createStorageRecord;
            test.serviceBaseUrl.put(test.endpoint)
            .set('Authorization', token)
            .set('data-partition-id', partition)
            .send(test.parameters)    
            .then((res) => {
                if(!test.expectedResponses.includes(res.status)){
                    httpUtils.failRequest(test, res.status);
                }
                record = res.body;
                httpUtils.passRequest(test, res.status);
                done();
            })
            .catch(err => done(err));
        });
    
        it(tests.getStorageRecord.name, (done) => {
            test = tests.getStorageRecord;
            test.serviceBaseUrl.get(test.endpoint(record))
                .set('Authorization', token)
                .set('data-partition-id', partition)
                .then((res) => {
                    if(!test.expectedResponses.includes(res.status)){
                        httpUtils.failRequest(test, res.status);
                    }
                    httpUtils.passRequest(test, res.status)
                    done();
                })
                .catch(err => done(err));
        });
    
    
        it(tests.deleteLegalTag.name, (done) => {
            test = tests.deleteLegalTag;
            test.serviceBaseUrl.delete(test.endpoint(sampleLegalTag.name))
            .set('Authorization', token)
            .set('data-partition-id', partition)
            .then((res) => {
                if(!test.expectedResponses.includes(res.status)){
                    httpUtils.failRequest(test, res.status);
                }
                httpUtils.passRequest(test, res.status);
                done();
            })
            .catch(err => done(err));
        });
    
    
    });
    
    
    describe("Searching for indexed record (partition, entitlements, search, indexer-service, indexer-queue)", () => {
        before((done) => {
            console.log("Sleeping for 30 seconds to wait for record to be indexed...");
            setTimeout(done, 30000)
        })
    
        it(tests.searchStorageRecord.name, (done) => {
            test = tests.searchStorageRecord;
            test.serviceBaseUrl.post(test.endpoint)
            .set('Authorization', token)
            .set('data-partition-id', partition)
            .send(test.parameters)    
            .then((res) => {
                if(!test.expectedResponses.includes(res.status) || res.body.totalCount < 1){
                    httpUtils.failRequest(test, res.status);
                }
                httpUtils.passRequest(test, res.status);
                done();
            })
            .catch(err => done(err));
        });
    
        it(tests.deleteStorageRecord.name, (done) => {
            test = tests.deleteStorageRecord;
            test.serviceBaseUrl.delete(test.endpoint(record))
                .set('Authorization', token)
                .set('data-partition-id', partition)
                .then((res) => {
                    if(!test.expectedResponses.includes(res.status)){
                        httpUtils.failRequest(test, res.status);
                    }
                    httpUtils.passRequest(test, res.status)
                    done();
                })
                .catch(err => done(err));
        });
    });
})
