'use strict';

// Imports
const should = require('chai').Should();
const request = require("supertest");
const appInsights = require('applicationinsights');

// Hosts
const config = require('../config');
const entitlementHost = request(config.api_host.entitlement);
const legalHost = request(config.api_host.legal);
const storageHost = request(config.api_host.storage);
const searchHost = request(config.api_host.search);

// Test Data
const kind = "opendes:smoketest:dummydata:0.0.1"
const tag = "opendes-smoketest-tag"

// Setup App Insights
let insights = false;
let telemetryClient = null;
if (process.env.APPINSIGHTS_INSTRUMENTATIONKEY !== undefined) {
  appInsights.setup().start();
  telemetryClient = appInsights.defaultClient;
  insights = true;
}

//////////////////////////////////////////////////////
// Execute Test Scenario
//////////////////////////////////////////////////////

describe('Probe Core Services', (done) => {
  let succcess = true;
  let partition = 'opendes';
  let oAuth = request(config.api_host.auth + '/oauth2');
  let token = null;
  let recordId = null;

  let sampleLegalTag = {
    "name": tag,
    "description": "This tag is used by Data Upload Scripts",
    "properties": {
      "countryOfOrigin": [
        "US"
      ],
      "contractId": "A1234",
      "expirationDate": "2031-12-31",
      "originator": "MyCompany",
      "dataType": "Transferred Data",
      "securityClassification": "Public",
      "personalData": "No Personal Data",
      "exportClassification": "EAR99"
    }
  }

  let sampleSchema = {
    "kind": kind,
    "schema": [
      {
        "path": "Field",
        "kind": "string"
      },
      {
        "path": "Location",
        "kind": "core:dl:geopoint:1.0.0"
      },
      {
        "path": "Basin",
        "kind": "string"
      },
      {
        "path": "County",
        "kind": "string"
      },
      {
        "path": "State",
        "kind": "string"
      },
      {
        "path": "Country",
        "kind": "string"
      },
      {
        "path": "WellStatus",
        "kind": "string"
      },
      {
        "path": "OriginalOperator",
        "kind": "string"
      },
      {
        "path": "WellName",
        "kind": "string"
      },
      {
        "path": "WellType",
        "kind": "string"
      },
      {
        "path": "EmptyAttribute",
        "kind": "string"
      },
      {
        "path": "Rank",
        "kind": "int"
      },
      {
        "path": "Score",
        "kind": "int"
      },
      {
        "path": "Established",
        "kind": "datetime"
      },
      {
        "path": "InvalidInteger",
        "kind": "int"
      }
    ]
  }

  before(done => {
    // Get a new OAuth Token
    oAuth.post('/token')
      .set('Content-Type', 'application/x-www-form-urlencoded')
      .send(config.auth_params)
      .then(res => {
        token = 'Bearer ' + res.body.access_token;
        done();
      })
      .catch(err => {
        succcess = false;
        done(err)
      });
  });

  describe('Scenario: When a Storage Record is created it can be found by a search query', (done) => {

    describe('Entitlement Check', done => {
      it("Groups: Get", done => {
        entitlementHost.get('/groups/')
          .set('Authorization', token)
          .set('data-partition-id', partition)
          .expect(200)
          .then(() => {
            done();
          })
          .catch(err => {
            succcess = false;
            done(err)
          });
      });
    });

    describe('Prepare Legal', done => {
      let data = null;

      it("LegalTag: Create", done => {
        legalHost.post('/legaltags/')
          .set('Authorization', token)
          .set('data-partition-id', partition)
          .send(sampleLegalTag)
          .then(res => {
            [201, 409].should.be.an('array').that.includes(res.statusCode);
            done();
          })
          .catch(err => {
            succcess = false;
            done(err)
          });
      });

      it('LegalTag: Get', done => {
        legalHost.get('/legaltags/' + sampleLegalTag.name)
          .set('Authorization', token)
          .set('Accept', 'application/json')
          .set('data-partition-id', partition)
          .expect(200)
          .then(res => {
            res.body.should.be.an('object');
            data = res.body;
            done();
          })
          .catch(err => {
            succcess = false;
            done(err)
          });
      });

      it('LegalTag: Validate', () => data.should.be.deep.equal(sampleLegalTag));
    });

    describe('Prepare Schema', done => {
      let data = null;

      it("Schema: Create", done => {
        storageHost.post('/schemas/')
          .set('Authorization', token)
          .set('data-partition-id', partition)
          .send(sampleSchema)
          .then(res => {
            [201, 409].should.be.an('array').that.includes(res.statusCode);
            done();
          })
          .catch(err => {
            succcess = false;
            done(err)
          });
      });

      it('Schema: Get', done => {
        storageHost.get('/schemas/' + sampleSchema.kind)
          .set('Authorization', token)
          .set('Accept', 'application/json')
          .set('data-partition-id', partition)
          .expect(200)
          .then(res => {
            res.body.should.be.an('object');
            data = res.body;
            done();
          })
          .catch(err => {
            succcess = false;
            done(err)
          });
      });

      it('Schema: Validate', () => data.should.be.deep.equal(sampleSchema));
    });

    describe('Create Record', done => {
      let sampleRecord = [
        {
          "kind": kind,
          "acl": {
            "viewers": [
              "data.default.viewer@opendes.contoso.com"
            ],
            "owners": [
              "data.default.owner@opendes.contoso.com"
            ]
          },
          "legal": {
            "legaltags": [
              tag
            ],
            "otherRelevantDataCountries": [
              "US"
            ],
            "status": "compliant"
          },
          "data": {
            "Field": "MyField",
            "Basin": "MyBasin",
            "Country": "MyCountry"
          }
        }
      ]

      it('Record: Create', done => {
        storageHost.put('/records/')
          .set('Authorization', token)
          .set('data-partition-id', partition)
          .send(sampleRecord)
          .expect(201)
          .then(res => {
            res.body.should.be.an('object');
            recordId = res.body.recordIds[0];
            done();
          })
          .catch(err => {
            succcess = false;
            done(err)
          });
      });

      it('Record: Get', done => {
        storageHost.get('/records/' + recordId)
          .set('Authorization', token)
          .set('data-partition-id', partition)
          .expect(200)
          .then(() => {
            done();
          })
          .catch(err => {
            succcess = false;
            done(err)
          });
      });

    });

    describe('Search Record', done => {
      let data = null;

      let sampleQuery = {
        "kind": kind,
        "offset": 0,
        "limit": 1
      }

      before((done) => {
        console.log("          Waiting for record to be indexed...");
        setTimeout(done, 60000)
      });

      it('Search: Find', done => {
        searchHost.post('/query')
          .set('Authorization', token)
          .set('data-partition-id', partition)
          .send(sampleQuery)
          .expect(200)
          .then((res) => {
            data = res.body.results[0].id;
            done();
          })
          .catch(err => {
            succcess = false;
            done(err)
          });
      });

      it('Search: Validate', () => data.should.be.equal(recordId));
    });

    describe('Probe Cleanup', done => {

      it('Record: Delete', done => {
        storageHost.delete('/records/' + recordId)
          .set('Authorization', token)
          .set('data-partition-id', partition)
          .expect(204)
          .then(() => {
            done();
          })
          .catch(err => {
            succcess = false;
            done(err)
          });
      });

      it('Schema: Delete', done => {
        storageHost.delete('/schemas/' + sampleSchema.kind)
          .set('Authorization', token)
          .set('Accept', 'application/json')
          .set('data-partition-id', partition)
          .expect(204)
          .then(() => {
            done();
          })
          .catch(err => {
            succcess = false;
            done(err)
          });
      });

      it('LegalTag: Delete', done => {
        legalHost.delete('/legaltags/' + sampleLegalTag.name)
          .set('Authorization', token)
          .set('Accept', 'application/json')
          .set('data-partition-id', partition)
          .expect(204)
          .then(() => {
            done();
          })
          .catch(err => {
            succcess = false;
            done(err)
          });
      });
    });
  });

  after(done => {
    if (insights && succcess) telemetryClient.trackMetric({ name: "Probe: Core", value: 1 });
    if (insights && !succcess) telemetryClient.trackMetric({ name: "Probe: Core", value: 0 });
    done();
  });
});
