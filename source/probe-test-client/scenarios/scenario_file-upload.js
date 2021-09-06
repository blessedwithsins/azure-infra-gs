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

let sampleFile = testUtils.readTextFile(`${__dirname}/../testData/sample.las`);
let sampleFileMetadata = require(`${__dirname}/../testData/sample_file_upload_file_metadata.json`);

// Test Setup
let scenario = "scenario_file-upload";

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
let kind = `${testUtils.partition}:wks:dataset--File.Generic:1.0.0`;
let tag =  `${testUtils.partition}-public-usa-check-1`;

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

let data = '';
let file_id = '';
let file_url = '';
let file_source = '';
let file_metadata_id = '';
let file_download_url = '';

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

    describe('Scenario: File Upload', (done) => {
        
        if (config.test_flags.scenario_file_upload.enableScenario) {

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

            describe('Get Schema', (done) => {
                
                it("Get Schema By ID", done => {
                    test.service = testUtils.services.schema;
                    test.api = test.service.api.getSchemaById;
                    test.expectedResponse = test.api.expectedResponse;
        
                    test.service.host
                    .get(test.api.path + kind)
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

                it("Get File List", done => {
                    test.service = testUtils.services.file;
                    test.api = test.service.api.getFilesList;
                    test.expectedResponse = test.api.expectedResponse;

                    let date = new Date();
                    let pastdate = new Date();
                    pastdate.setHours(pastdate.getHours() - 1);

                    let filePayload = {
                        "Items": 5,
                        "PageNum": 0,
                        "TimeFrom": `${pastdate.toISOString()}`,
                        "TimeTo": `${date.toISOString()}`,
                        "UserID": "osdu-user"
                    };
                    
                    test.service.host
                    .post(test.api.path)
                    .set('Authorization', token)
                    .set('Accept', 'application/json')
                    .set('Content-Type', 'application/json')
                    .set('data-partition-id', testUtils.partition)
                    .send(filePayload)
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
                    .send(sampleFile)
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
      
                    sampleFileMetadata = JSON.parse(JSON.stringify(sampleFileMetadata).replace(/##PARTITION##/g, `${testUtils.partition}`));
                    sampleFileMetadata = JSON.parse(JSON.stringify(sampleFileMetadata).replace(/##KIND##/g, `${kind}`));
                    sampleFileMetadata = JSON.parse(JSON.stringify(sampleFileMetadata).replace(/##TAG##/g, `${tag}`));
                    sampleFileMetadata = JSON.parse(JSON.stringify(sampleFileMetadata).replace(/##FILE_SOURCE##/g, `${file_source}`));
                    
                    test.service.host
                    .post(test.api.path)
                    .set('Authorization', token)
                    .set('Accept', 'application/json')
                    .set('Content-Type', 'application/json')
                    .set('data-partition-id', testUtils.partition)
                    .send(sampleFileMetadata)
                    .then(res => {
                      file_metadata_id = res.body.id;
                      test.expectedResponse.should.be.an('array').that.includes(res.statusCode);
                      should.exist(file_metadata_id);
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
                    .get(test.api.path.prefix + file_metadata_id + test.api.path.suffix)
                    .set('Authorization', token)
                    .set('Accept', 'application/json')
                    .set('Content-Type', 'application/json')
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

                it("Get Download URL", done => {
                    test.service = testUtils.services.file;
                    test.api = test.service.api.downloadURL;
                    test.expectedResponse = test.api.expectedResponse;
                    
                    test.service.host
                    .get(test.api.path.prefix + file_metadata_id + test.api.path.suffix)
                    .set('Authorization', token)
                    .set('Accept', 'application/json')
                    .set('Content-Type', 'application/json')
                    .set('data-partition-id', testUtils.partition)
                    .expect(test.expectedResponse)
                    .then(res => {
                      file_download_url = res.body.SignedUrl
                      should.exist(file_download_url)

                      telemetryUtils.passApiRequest(test); 
                      done(); 
                    })
                    .catch(err => { 
                        telemetryUtils.failApiRequest(test, err);
                        done(err); 
                    });
                });

                it("Download File", done => {
                    test.service = testUtils.services.file;
                    test.api = test.service.api.downloadFile;
                    test.expectedResponse = test.api.expectedResponse;
      
                    let downloadUrl = new URL(file_download_url);
                    let downloadUrlHost = `https://${downloadUrl.hostname}`;
                    let downloadUrlPath = file_download_url.replace(`${downloadUrlHost}`, '');

                    console.log(`Download URL: ${file_download_url}`);
                    console.log(`Download URL Host Name: ${downloadUrlHost}`);
                    console.log(`Download URL Path: ${downloadUrlPath}`);
                    
                    request(downloadUrlHost)
                    .get(downloadUrlPath)
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
            telemetryUtils.scenarioRequest(runId, testUtils.services.file, scenario, test.failedTests);
            done();
        });
    });
});