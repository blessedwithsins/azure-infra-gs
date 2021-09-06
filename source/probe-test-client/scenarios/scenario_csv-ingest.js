'use strict';

// Imports
const should = require('chai').Should();
const { expect } = require('chai');
const request = require("supertest");
const config = require(`${__dirname}/../config`);
const testUtils = require(`${__dirname}/../utils/testUtils`);
const telemetryUtils = require(`${__dirname}/../utils/telemetryUtils`);
const { assert } = require('console');
var isEqual = require('lodash.isequal');

let sampleCsvIngestSchema = require(`${__dirname}/../testData/sample_csv_ingest_schema.json`);
let sampleCsvIngestCsv = testUtils.readTextFile(`${__dirname}/../testData/sample.csv`);
let sampleCsvIngestMetadata = require(`${__dirname}/../testData/sample_csv_ingest_file_metadata.json`);

// Test Setup
let scenario = "scenario_csv-ingest";

const majorVersion = testUtils.between(1, 100000);
const minorVersion = testUtils.between(1, 100000);
let runId = `${majorVersion}.${minorVersion}`;
console.log(`run ID: ${runId}`);

let test = {
    runId: runId,
    scenario: scenario,
    service: "service",
    api: "api",
    expectedResponse: -1,
    failedTests: 0,
};

// Test Data Setup
let testApiName = testUtils.services.search.api.search.name;
let tag =  `${testUtils.partition}-public-usa-check-1`
let kind = `${testUtils.partition}:qatest:wellbore:0.0.1`
let workflow_name = `csv-parser-0.7.0`

let legalTag = {
  "name": `${tag}`,
  "description": "This tag is used by Data Upload Scripts",
  "properties": {
    "countryOfOrigin": [
      "US"
    ],
    "contractId": "A1234",
    "expirationDate": "2021-12-31",
    "originator": "MyCompany",
    "dataType": "Transferred Data",
    "securityClassification": "Public",
    "personalData": "No Personal Data",
    "exportClassification": "EAR99"
  }
};

let data = ''
let file_id = ''
let file_url = ''
let file_source = ''
let metadata_id = ''
let workflowRunId = ''
let recordId1 = ''
let recordId2 = ''

sampleCsvIngestSchema = JSON.parse(JSON.stringify(sampleCsvIngestSchema).replace(/##PARTITION##/g, `${testUtils.partition}`));
sampleCsvIngestSchema = JSON.parse(JSON.stringify(sampleCsvIngestSchema).replace(/##KIND##/g, `${kind}`));

// Test Scenario
describe(scenario, (done) => {
    let token;

    before(done => {
        // Get a new OAuth Token
        testUtils.oAuth.post('/token')
          .set('Content-Type', 'application/x-www-form-urlencoded')
          .send(config.auth_params)
          .then(res => {
            token = 'Bearer ' + res.body.access_token;
            done();
          })
          .catch(err => {
            done(err)
          });
    });

    describe('Scenario: CSV Ingest', (done) => {
        
        if (config.test_flags.scenario_csv_ingest.enableScenario) {
          describe('Get Entitlements', (done) => {
            
            it("Get All groups.", done => {
              test.service = testUtils.services.entitlement;
              test.api = test.service.api.getGroups;
              test.expectedResponse = test.api.expectedResponse;

              test.service.host
              .get(test.api.path)
              .set('Authorization', token)
              .set('Accept', 'application/json')
              .set('data-partition-id', testUtils.partition)
              .expect(test.expectedResponse)
              .then(() => {
                  telemetryUtils.passApiRequest(test);
                  done(); 
              })
              .catch(err => { 
                  telemetryUtils.failApiRequest(test, err);
                  done(err); 
              });
            });
          });

          describe('Create Necessary Legal Tag', (done) => {
            
            it("Create Legal Tag", done => {
              test.service = testUtils.services.legal;
              test.api = test.service.api.createLegalTags;
              test.expectedResponse = test.api.expectedResponse;
              
              test.service.host
              .post(test.api.path)
              .set('Authorization', token)
              .set('Content-Type', 'application/json')
              .set('data-partition-id', testUtils.partition)
              .send(legalTag)
              .then(res => {
                  test.expectedResponse.should.be.an('array').that.includes(res.statusCode);
                  telemetryUtils.passApiRequest(test);
                  done();
              })
              .catch(err => {
                  telemetryUtils.failApiRequest(test, err);
                  done(err)
              });
            });

            it("Get Created Legal Tag", done => {
              test.service = testUtils.services.legal;
              test.api = test.service.api.getLegalTag;
              test.expectedResponse = test.api.expectedResponse;
              
              test.service.host
              .get(test.api.path + legalTag.name)
              .set('Authorization', token)
              .set('Accept', 'application/json')
              .set('data-partition-id', testUtils.partition)
              .expect(test.expectedResponse)
              .then(res => {
                  data = res.body;
                  telemetryUtils.passApiRequest(test); 
                  done(); 
              })
              .catch(err => { 
                  telemetryUtils.failApiRequest(test, err);
                  done(err); 
              });
            });
  
            it('Validate: Get Created Legal Tag', () => {
              test.service = testUtils.services.legal;
              test.api.name = 'validate_' + test.service.api.getLegalTag.name;
              test.expectedResponse = "Valid Match";
  
              if (isEqual(data, legalTag)) {
                  telemetryUtils.passApiRequest(test);
                  expect(true).to.be.true;
              } else {
                  telemetryUtils.failApiRequest(test, "Invalid");
                  console.log(`actual:${JSON.stringify(data)}`);
                  expect(false).to.be.true;
              }
            });
          });

          describe('Check And Create Necessary Schema', (done) => {
            it("Get AbstractSpatialLocation Schema By ID", done => {
              test.service = testUtils.services.schema;
              test.api = test.service.api.getSchemaById;
              test.expectedResponse = test.api.expectedResponse;
              
              test.service.host
              .get(test.api.path + `${testUtils.partition}:wks:AbstractSpatialLocation:1.0.0`)
              .set('Authorization', token)
              .set('Accept', 'application/json')
              .set('data-partition-id', testUtils.partition)
              .expect(test.expectedResponse)
              .then(() => {
                  telemetryUtils.passApiRequest(test); 
                  done(); 
              })
              .catch(err => { 
                  telemetryUtils.failApiRequest(test, err);
                  done(err); 
              });
            });

            it("Get DatasetFileGeneric Schema By ID", done => {
              test.service = testUtils.services.schema;
              test.api = test.service.api.getSchemaById;
              test.expectedResponse = test.api.expectedResponse;
            
              test.service.host
              .get(test.api.path + `${testUtils.partition}:wks:dataset--File.Generic:1.0.0`)
              .set('Authorization', token)
              .set('Accept', 'application/json')
              .set('data-partition-id', testUtils.partition)
              .expect(test.expectedResponse)
              .then(() => {
                telemetryUtils.passApiRequest(test); 
                done(); 
              })
              .catch(err => { 
                telemetryUtils.failApiRequest(test, err);
                done(err); 
              });
            });

            it("Create Schema", done => {
              test.service = testUtils.services.schema;
              test.api = test.service.api.createSchema;
              test.expectedResponse = test.api.expectedResponse;
              
              test.service.host
              .post(test.api.path)
              .set('Authorization', token)
              .set('Content-Type', 'application/json')
              .set('data-partition-id', testUtils.partition)
              .send(sampleCsvIngestSchema)
              .then(res => {
                  test.expectedResponse.should.be.an('array').that.includes(res.statusCode);
                  telemetryUtils.passApiRequest(test);
                  done();
              })
              .catch(err => {
                  telemetryUtils.failApiRequest(test, err);
                  done(err)
              });
            });

            it("Get Newly Created Schema By ID", done => {
              test.service = testUtils.services.schema;
              test.api = test.service.api.getSchemaById;
              test.expectedResponse = test.api.expectedResponse;

              let schemaId = `${sampleCsvIngestSchema.schemaInfo.schemaIdentity.entityType}:${sampleCsvIngestSchema.schemaInfo.schemaIdentity.schemaVersionMajor}:${sampleCsvIngestSchema.schemaInfo.schemaIdentity.schemaVersionMinor}:${sampleCsvIngestSchema.schemaInfo.schemaIdentity.schemaVersionPatch}`
  
              test.service.host
              .get(test.api.path + schemaId)
              .set('Authorization', token)
              .set('Accept', 'application/json')
              .set('data-partition-id', testUtils.partition)
              .expect(test.expectedResponse)
              .then(() => {
                  telemetryUtils.passApiRequest(test); 
                  done(); 
              })
              .catch(err => { 
                  telemetryUtils.failApiRequest(test, err);
                  done(err); 
              });
            });
          });

          describe('Upload File', (done) => {
            it("Get File Upload Url", done => {
              test.service = testUtils.services.file;
              test.api = test.service.api.uploadURL;
              test.expectedResponse = test.api.expectedResponse;
              
              test.service.host
              .get(test.api.path)
              .set('Authorization', token)
              .set('Accept', 'application/json')
              .set('Content-Type', 'application/json')
              .set('data-partition-id', testUtils.partition)
              .expect(test.expectedResponse)
              .then(res => {
                file_id = res.body.FileID
                file_url = res.body.Location.SignedURL
                file_source = res.body.Location.FileSource

                should.exist(file_id)
                should.exist(file_url)
                should.exist(file_source)

                telemetryUtils.passApiRequest(test); 
                done(); 
              })
              .catch(err => { 
                  telemetryUtils.failApiRequest(test, err);
                  done(err); 
              });
            });

            it("Upload File", done => {
              test.service = testUtils.services.file;
              test.api = test.service.api.uploadFile;
              test.expectedResponse = test.api.expectedResponse;

              let uploadUrl = new URL(file_url);
              let uploadUrlHost = `https://${uploadUrl.hostname}`;
              let uploadUrlPath = file_url.replace(`${uploadUrlHost}`, '');

              console.log(`Upload URL: ${file_url}`);
              console.log(`Upload URL Host Name: ${uploadUrlHost}`);
              console.log(`Upload URL Path: ${uploadUrlPath}`);
                    
              request(uploadUrlHost)
              .put(uploadUrlPath)
              .set('x-ms-blob-type', 'BlockBlob')
              .send(sampleCsvIngestCsv)
              .then(res => {
                test.expectedResponse.should.be.an('array').that.includes(res.statusCode);
                telemetryUtils.passApiRequest(test);
                done(); 
              })
              .catch(err => { 
                  telemetryUtils.failApiRequest(test, err);
                  done(err); 
              });
            });

            it("Upload File Metadata", done => {
              test.service = testUtils.services.file;
              test.api = test.service.api.postMetadata;
              test.expectedResponse = test.api.expectedResponse;

              sampleCsvIngestMetadata = JSON.parse(JSON.stringify(sampleCsvIngestMetadata).replace(/##PARTITION##/g, `${testUtils.partition}`));
              sampleCsvIngestMetadata = JSON.parse(JSON.stringify(sampleCsvIngestMetadata).replace(/##KIND##/g, `${kind}`));
              sampleCsvIngestMetadata = JSON.parse(JSON.stringify(sampleCsvIngestMetadata).replace(/##TAG##/g, `${tag}`));
              sampleCsvIngestMetadata = JSON.parse(JSON.stringify(sampleCsvIngestMetadata).replace(/##FILE_SOURCE##/g, `${file_source}`));
              
              test.service.host
              .post(test.api.path)
              .set('Authorization', token)
              .set('Accept', 'application/json')
              .set('Content-Type', 'application/json')
              .set('data-partition-id', testUtils.partition)
              .send(sampleCsvIngestMetadata)
              .then(res => {
                metadata_id = res.body.id;
                test.expectedResponse.should.be.an('array').that.includes(res.statusCode);
                should.exist(metadata_id);
                telemetryUtils.passApiRequest(test);
                done(); 
              })
              .catch(err => { 
                  telemetryUtils.failApiRequest(test, err);
                  done(err); 
              });
            });

            it("Get File Metadata", done => {
              test.service = testUtils.services.file;
              test.api = test.service.api.getMetadata;
              test.expectedResponse = test.api.expectedResponse;
              
              test.service.host
              .get(test.api.path.prefix + metadata_id + test.api.path.suffix)
              .set('Authorization', token)
              .set('Accept', 'application/json')
              .set('Content-Type', 'application/json')
              .set('data-partition-id', testUtils.partition)
              .expect(test.expectedResponse)
              .then(res => {
                telemetryUtils.passApiRequest(test); 
                done(); 
              })
              .catch(err => { 
                  telemetryUtils.failApiRequest(test, err);
                  done(err); 
              });
            });
          });

          describe('Workflow Runs', (done) => {
              
            it("Trigger Workflow Run", done => {
              test.service = testUtils.services.workflow;
              test.api = test.service.api.runWorkflow;
              test.expectedResponse = test.api.expectedResponse;

              let workflowPayload = {
                "executionContext": {
                  "dataPartitionId": `${testUtils.partition}`,
                  "id": `${metadata_id}`
                }
              };

              test.service.host
              .post(test.api.path.prefix + workflow_name + test.api.path.suffix)
              .set('Authorization', token)
              .set('Content-Type', 'application/json')
              .set('data-partition-id', testUtils.partition)
              .send(workflowPayload)
              .then(res => {
                workflowRunId = res.body.runId;
                test.expectedResponse.should.be.an('array').that.includes(res.statusCode);
                should.exist(workflowRunId);
                telemetryUtils.passApiRequest(test);
                done(); 
              })
              .catch(err => { 
                  telemetryUtils.failApiRequest(test, err);
                  done(err); 
              });
            });

            it("Get Workflow PreDefined Id", done => {
              test.service = testUtils.services.workflow;
              test.api = test.service.api.getWorkflowPreDefinedId;
              test.expectedResponse = test.api.expectedResponse;
              
              test.service.host
              .get(test.api.path.prefix + workflow_name + test.api.path.suffix + workflowRunId)
              .set('Authorization', token)
              .set('Content-Type', 'application/json')
              .set('data-partition-id', testUtils.partition)
              .expect(test.expectedResponse)
              .then(res => {
                telemetryUtils.passApiRequest(test); 
                done(); 
              })
              .catch(err => { 
                  telemetryUtils.failApiRequest(test, err);
                  done(err); 
              });
            });
          });

          describe('Search Records', (done) => { 

            it("Search: Record 1", done => {
              test.service = testUtils.services.search;
              test.api = test.service.api.search;
              test.api.name = `${testApiName}_csvIngest_record1`;
              test.expectedResponse = test.api.expectedResponse;
              searchQuery = {
                "kind": `${kind}`,
                "query": "data.UWI:\"MS1010\"",
                "offset": 0,
                "limit": 10
              }
  
              test.service.host
              .post(test.api.path)
              .set('Authorization', token)
              .set('Content-Type', 'application/json')
              .set('data-partition-id', testUtils.partition)
              .send(searchQuery)
              .then(res => {
                  test.expectedResponse.should.be.an('array').that.includes(res.statusCode);
                  console.log(`Total Record Count: ${res.body.totalCount}`)
                  recordId1 = res.body.results[0].id
                  telemetryUtils.passApiRequest(test);
                  done();
              })
              .catch(err => {
                  telemetryUtils.failApiRequest(test, err);
                  done(err)
              });
            });

            it('Validate: Record 1', done => {
              test.service = testUtils.services.storage;
              test.api = test.service.api.getRecord;
              test.expectedResponse = test.api.expectedResponse;

              test.service.host
              .get(test.api.path + recordId1)
              .set('Authorization', token)
              .set('Accept', 'application/json')
              .set('data-partition-id', testUtils.partition)
              .expect(test.expectedResponse)
              .then(() => {
                  telemetryUtils.passApiRequest(test); 
                  done(); 
              })
              .catch(err => { 
                  telemetryUtils.failApiRequest(test, err);
                  done(err); 
              });
            });

            it("Search: Record 2", done => {
              test.service = testUtils.services.search;
              test.api = test.service.api.search;
              test.api.name = `${testApiName}_csvIngest_record2`;
              test.expectedResponse = test.api.expectedResponse;
              searchQuery = {
                "kind": `${kind}`,
                "query": "data.UWI:\"MS1011\"",
                "offset": 0,
                "limit": 10
              }
  
              test.service.host
              .post(test.api.path)
              .set('Authorization', token)
              .set('Content-Type', 'application/json')
              .set('data-partition-id', testUtils.partition)
              .send(searchQuery)
              .then(res => {
                  test.expectedResponse.should.be.an('array').that.includes(res.statusCode);
                  console.log(`Total Record Count: ${res.body.totalCount}`)
                  recordId2 = res.body.results[0].id
                  telemetryUtils.passApiRequest(test);
                  done();
              })
              .catch(err => {
                  telemetryUtils.failApiRequest(test, err);
                  done(err)
              });
            });

            it('Validate: Record 2', done => {
              test.service = testUtils.services.storage;
              test.api = test.service.api.getRecord;
              test.expectedResponse = test.api.expectedResponse;

              test.service.host
              .get(test.api.path + recordId2)
              .set('Authorization', token)
              .set('Accept', 'application/json')
              .set('data-partition-id', testUtils.partition)
              .expect(test.expectedResponse)
              .then(() => {
                  telemetryUtils.passApiRequest(test); 
                  done(); 
              })
              .catch(err => { 
                  telemetryUtils.failApiRequest(test, err);
                  done(err); 
              });
            });
          });

          describe('Probe Cleanup', (done) => {
            it('Record 1: Delete', done => {
              test.service = testUtils.services.storage;
              test.api = test.service.api.deleteRecord;
              test.expectedResponse = test.api.expectedResponse;

              test.service.host
              .delete(test.api.path + recordId1)
              .set('Authorization', token)
              .set('data-partition-id', testUtils.partition)
              .expect(test.expectedResponse)
              .then(() => {
                  telemetryUtils.passApiRequest(test); 
                  done(); 
              })
              .catch(err => { 
                  telemetryUtils.failApiRequest(test, err);
                  done(err); 
              });
            });

            it('Record 2: Delete', done => {
              test.service = testUtils.services.storage;
              test.api = test.service.api.deleteRecord;
              test.expectedResponse = test.api.expectedResponse;

              test.service.host
              .delete(test.api.path + recordId2)
              .set('Authorization', token)
              .set('data-partition-id', testUtils.partition)
              .expect(test.expectedResponse)
              .then(() => {
                  telemetryUtils.passApiRequest(test); 
                  done(); 
              })
              .catch(err => { 
                  telemetryUtils.failApiRequest(test, err);
                  done(err); 
              });
            });

            it('Schema: Delete', done => {
              test.service = testUtils.services.storage;
              test.api = test.service.api.deleteSchema;
              test.expectedResponse = test.api.expectedResponse;

              test.service.host
              .delete(test.api.path + kind)
              .set('Authorization', token)
              .set('Accept', 'application/json')
              .set('data-partition-id', testUtils.partition)
              .expect(test.expectedResponse)
              .then(() => {
                  telemetryUtils.passApiRequest(test); 
                  done(); 
              })
              .catch(err => { 
                  telemetryUtils.failApiRequest(test, err);
                  done(err); 
              });
            });

            it('LegalTag: Delete', done => {
              test.service = testUtils.services.legal;
              test.api = test.service.api.deleteLegalTags;
              test.expectedResponse = test.api.expectedResponse;

              test.service.host
              .delete(test.api.path + legalTag.name)
              .set('Authorization', token)
              .set('Accept', 'application/json')
              .set('data-partition-id', testUtils.partition)
              .expect(test.expectedResponse)
              .then(() => {
                  telemetryUtils.passApiRequest(test); 
                  done(); 
              })
              .catch(err => { 
                  telemetryUtils.failApiRequest(test, err);
                  done(err); 
              });
            });
          });
        }
            
        afterEach(function() {
            if (this.currentTest.state === 'failed') {
                test.failedTests += 1;
            }
          });

        after(done => {
            telemetryUtils.scenarioRequest(runId, testUtils.services.workflow, scenario, test.failedTests);
            done();
        });
    });
});