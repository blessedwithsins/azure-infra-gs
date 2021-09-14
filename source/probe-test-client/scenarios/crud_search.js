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

// Test Setup
let scenario = "searchservice_crudOps";

const majorVersion = testUtils.between(1, 100000);
const minorVersion = testUtils.between(1, 100000);
let runId = `${majorVersion}.${minorVersion}`;

// Test Data Setup
const standardSearchQuery = require(`${__dirname}/../testData/sample_search_standardQuery.json`);
const enrichedSearchQuery = require(`${__dirname}/../testData/sample_search_enrichedQuery.json`);
let searchQuery = "";
let testApiName = testUtils.services.search.api.search.name;

console.log(`run ID: ${runId}`);

let test = {
  runId: runId,
  scenario: scenario,
  service: "service",
  api: "api",
  expectedResponse: -1,
  failedTests: 0,
};

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

    describe('Scenario: Search Service supports CRUD operations', (done) => {

        if (config.test_flags.crud_search.standardQueries) {
            describe('Standard 0.2.0 Queries', (done) => {

                it("Search: Full Text Search", done => {
                    test.service = testUtils.services.search;
                    test.api = test.service.api.search;
                    test.api.name = `${testApiName}_standardQuery_fullTextSearch`;
                    test.expectedResponse = test.api.expectedResponse;
                    searchQuery = standardSearchQuery;
                    searchQuery.query = "BIR*";
        
                    test.service.host
                    .post(test.api.path)
                    .set('Authorization', token)
                    .set('data-partition-id', testUtils.partition)
                    .send(searchQuery)
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
    
                it("Search: Full Text Search With Wildcard", done => {
                    test.service = testUtils.services.search;
                    test.api = test.service.api.search;
                    test.api.name = `${testApiName}_standardQuery_fullTextSearchWildcard`;
                    test.expectedResponse = test.api.expectedResponse;
                    searchQuery = standardSearchQuery;
                    searchQuery.query = "(BIR AND 0?)";
        
                    test.service.host
                    .post(test.api.path)
                    .set('Authorization', token)
                    .set('data-partition-id', testUtils.partition)
                    .send(searchQuery)
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
    
                it("Search: Full Text Search Fuzzy", done => {
                    test.service = testUtils.services.search;
                    test.api = test.service.api.search;
                    test.api.name = `${testApiName}_standardQuery_fullTextSearchFuzzy`;
                    test.expectedResponse = test.api.expectedResponse;
                    searchQuery = standardSearchQuery;
                    searchQuery.query = "data.Data.IndividualTypeProperties.FacilityName:EMM~";
        
                    test.service.host
                    .post(test.api.path)
                    .set('Authorization', token)
                    .set('data-partition-id', testUtils.partition)
                    .send(searchQuery)
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
    
                it("Search: All Resources By Well ID", done => {
                    test.service = testUtils.services.search;
                    test.api = test.service.api.search;
                    test.api.name = `${testApiName}_standardQuery_allResByWellId`;
                    test.expectedResponse = test.api.expectedResponse;
                    searchQuery = standardSearchQuery;
                    searchQuery.query = "data.Data.IndividualTypeProperties.WellID:\"srn:master-data/Well:8690:\"";
        
                    test.service.host
                    .post(test.api.path)
                    .set('Authorization', token)
                    .set('data-partition-id', testUtils.partition)
                    .send(searchQuery)
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
    
                it("Search: All Resources By Well ID & Wildcard", done => {
                    test.service = testUtils.services.search;
                    test.api = test.service.api.search;
                    test.api.name = `${testApiName}_standardQuery_allResByWellId&Wilcard`;
                    test.expectedResponse = test.api.expectedResponse;
                    searchQuery = standardSearchQuery;
                    searchQuery.query = "data.Data.IndividualTypeProperties.WellID:(\"srn:master-data/Well:\" AND 101?)";
        
                    test.service.host
                    .post(test.api.path)
                    .set('Authorization', token)
                    .set('data-partition-id', testUtils.partition)
                    .send(searchQuery)
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
    
                it("Search: Wells By Resource ID With OR", done => {
                    test.service = testUtils.services.search;
                    test.api = test.service.api.search;
                    test.api.name = `${testApiName}_standardQuery_wellsByResIdWithOR`;
                    test.expectedResponse = test.api.expectedResponse;
                    searchQuery = standardSearchQuery;
                    searchQuery.query = "data.ResourceID:(\"srn:master-data/Well:8690:\" OR \"srn:master-data/Well:1000:\")";
        
                    test.service.host
                    .post(test.api.path)
                    .set('Authorization', token)
                    .set('data-partition-id', testUtils.partition)
                    .send(searchQuery)
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
    
                it("Search: Wells By Resource ID & Country ID", done => {
                    test.service = testUtils.services.search;
                    test.api = test.service.api.search;
                    test.api.name = `${testApiName}_standardQuery_wellsByResId&CountryId`;
                    test.expectedResponse = test.api.expectedResponse;
                    searchQuery = standardSearchQuery;
                    searchQuery.query = "(data.ResourceID:(\"srn:master-data/Well:8690:\" OR \"srn:master-data/Well:1000:\")) AND (data.Data.IndividualTypeProperties.CountryID: \"srn:master-data/GeopoliticalEntity:Netherlands:\")";
        
                    test.service.host
                    .post(test.api.path)
                    .set('Authorization', token)
                    .set('data-partition-id', testUtils.partition)
                    .send(searchQuery)
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
    
                it("Search: Well Log with GRCurve", done => {
                    test.service = testUtils.services.search;
                    test.api = test.service.api.search;
                    test.api.name = `${testApiName}_standardQuery_wellLogWithGrcurve`;
                    test.expectedResponse = test.api.expectedResponse;
                    searchQuery = standardSearchQuery;
                    searchQuery.query = "(data.ResourceTypeID: \"srn:type:work-product-component/WellLog:\") AND (data.Data.IndividualTypeProperties.Curves.Mnemonic: GR)";
        
                    test.service.host
                    .post(test.api.path)
                    .set('Authorization', token)
                    .set('data-partition-id', testUtils.partition)
                    .send(searchQuery)
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
    
                it("Search: Markers & Trajectories For Wellbore", done => {
                    test.service = testUtils.services.search;
                    test.api = test.service.api.search;
                    test.api.name = `${testApiName}_standardQuery_markers_and_trajectories_for_wellbore`;
                    test.expectedResponse = test.api.expectedResponse;
                    searchQuery = standardSearchQuery;
                    searchQuery.query = "(data.Data.IndividualTypeProperties.WellboreID: \"srn:master-data/Wellbore:3687:\") AND (data.ResourceTypeID: (\"srn:type:work-product-component/WellboreTrajectory:\" OR \"srn:type:work-product-component/WellboreMarker:\"))";
        
                    test.service.host
                    .post(test.api.path)
                    .set('Authorization', token)
                    .set('data-partition-id', testUtils.partition)
                    .send(searchQuery)
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
    
                it("Search: First Wellbore Page", done => {
                    test.service = testUtils.services.search;
                    test.api = test.service.api.search;
                    test.api.name = `${testApiName}_standardQuery_firstWellborePage`;
                    test.expectedResponse = test.api.expectedResponse;
                    searchQuery = standardSearchQuery;
                    searchQuery.query = "data.Data.IndividualTypeProperties.WellID:\"srn:master-data/Well:3687:\"";
                    searchQuery.offset = 0;
                    searchQuery.limit = 1;
                    searchQuery.sort = {};
                    searchQuery.sort.field = ["data.Data.IndividualTypeProperties.SequenceNumber"];
                    searchQuery.sort.order = ["ASC"];
        
                    test.service.host
                    .post(test.api.path)
                    .set('Authorization', token)
                    .set('data-partition-id', testUtils.partition)
                    .send(searchQuery)
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
    
                it("Search: Next Wellbore Page", done => {
                    test.service = testUtils.services.search;
                    test.api = test.service.api.search;
                    test.api.name = `${testApiName}_standardQuery_nextWellborePage`;
                    test.expectedResponse = test.api.expectedResponse;
                    searchQuery = standardSearchQuery;
                    searchQuery.query = "data.Data.IndividualTypeProperties.WellID:\"srn:master-data/Well:3687:\"";
                    searchQuery.offset = 1;
                    searchQuery.limit = 10;
                    searchQuery.sort = {};
                    searchQuery.sort.field = ["data.Data.IndividualTypeProperties.SequenceNumber"];
                    searchQuery.sort.order = ["ASC"];
        
                    test.service.host
                    .post(test.api.path)
                    .set('Authorization', token)
                    .set('data-partition-id', testUtils.partition)
                    .send(searchQuery)
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
    
                it("Search: Limit Returned Fields", done => {
                    test.service = testUtils.services.search;
                    test.api = test.service.api.search;
                    test.api.name = `${testApiName}_standardQuery_limitReturnedFields`;
                    test.expectedResponse = test.api.expectedResponse;
                    searchQuery = standardSearchQuery;
                    searchQuery.query = "data.ResourceTypeID: \"srn:type:work-product-component/WellLog:\"";
                    searchQuery.returnedFields = ["data.ResourceID", "data.Data.IndividualTypeProperties.Name"];
        
                    test.service.host
                    .post(test.api.path)
                    .set('Authorization', token)
                    .set('data-partition-id', testUtils.partition)
                    .send(searchQuery)
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
    
                it("Search: Count Wellbore For Well ID", done => {
                    test.service = testUtils.services.search;
                    test.api = test.service.api.search;
                    test.api.name = `${testApiName}_standardQuery_count_wellbore_for_wellID`;
                    test.expectedResponse = test.api.expectedResponse;
                    searchQuery = standardSearchQuery;
                    searchQuery.query = "data.Data.IndividualTypeProperties.WellID:\"srn:master-data/Well:3687:\"";
                    searchQuery.returnedFields = [""];
                    searchQuery.limit = 1;
        
                    test.service.host
                    .post(test.api.path)
                    .set('Authorization', token)
                    .set('data-partition-id', testUtils.partition)
                    .send(searchQuery)
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
    
                it("Search: Group By Kind", done => {
                    test.service = testUtils.services.search;
                    test.api = test.service.api.search;
                    test.api.name = `${testApiName}_standardQuery_group_by_kind`;
                    test.expectedResponse = test.api.expectedResponse;
                    searchQuery = standardSearchQuery;
                    searchQuery.limit = 1;
                    searchQuery.aggregateBy = "kind";
        
                    test.service.host
                    .post(test.api.path)
                    .set('Authorization', token)
                    .set('data-partition-id', testUtils.partition)
                    .send(searchQuery)
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
    
                it("Search: Well Logs with Depth > x", done => {
                    test.service = testUtils.services.search;
                    test.api = test.service.api.search;
                    test.api.name = `${testApiName}_standardQuery_welllogs_with_depth_larger_then_x`;
                    test.expectedResponse = test.api.expectedResponse;
                    searchQuery = standardSearchQuery;
                    searchQuery.query = "data.Data.IndividualTypeProperties.TopMeasuredDepth.Depth: >2200";
        
                    test.service.host
                    .post(test.api.path)
                    .set('Authorization', token)
                    .set('data-partition-id', testUtils.partition)
                    .send(searchQuery)
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
    
                it("Search: Well Logs with x < Depth < y", done => {
                    test.service = testUtils.services.search;
                    test.api = test.service.api.search;
                    test.api.name = `${testApiName}_standardQuery_welllogs_with_depth_between_x_and_y`;
                    test.expectedResponse = test.api.expectedResponse;
                    searchQuery = standardSearchQuery;
                    searchQuery.query = "data.Data.IndividualTypeProperties.TopMeasuredDepth.Depth:[2000 TO 3000]";
        
                    test.service.host
                    .post(test.api.path)
                    .set('Authorization', token)
                    .set('data-partition-id', testUtils.partition)
                    .send(searchQuery)
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
            });
        }

        if (config.test_flags.crud_search.enrichedQueries) {
            describe('Enriched 0.2.1 Queries', (done) => {

                it("Search: Full Text Search", done => {
                    test.service = testUtils.services.search;
                    test.api = test.service.api.search;
                    test.api.name = `${testApiName}_enrichedQuery_fullTextSearch`;
                    test.expectedResponse = test.api.expectedResponse;
                    searchQuery = enrichedSearchQuery;
                    searchQuery.query = "BIR*";
        
                    test.service.host
                    .post(test.api.path)
                    .set('Authorization', token)
                    .set('data-partition-id', testUtils.partition)
                    .send(searchQuery)
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
    
                it("Search: Full Text Search With Wildcard", done => {
                    test.service = testUtils.services.search;
                    test.api = test.service.api.search;
                    test.api.name = `${testApiName}_enrichedQuery_fullTextSearchWildcard`;
                    test.expectedResponse = test.api.expectedResponse;
                    searchQuery = enrichedSearchQuery;
                    searchQuery.query = "BIR 0?";
        
                    test.service.host
                    .post(test.api.path)
                    .set('Authorization', token)
                    .set('data-partition-id', testUtils.partition)
                    .send(searchQuery)
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
    
                it("Search: Full Text Search Fuzzy", done => {
                    test.service = testUtils.services.search;
                    test.api = test.service.api.search;
                    test.api.name = `${testApiName}_enrichedQuery_fullTextSearchFuzzy`;
                    test.expectedResponse = test.api.expectedResponse;
                    searchQuery = enrichedSearchQuery;
                    searchQuery.query = "data.WellName:EMM~";
        
                    test.service.host
                    .post(test.api.path)
                    .set('Authorization', token)
                    .set('data-partition-id', testUtils.partition)
                    .send(searchQuery)
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
    
                it("Search: Resources By UWI", done => {
                    test.service = testUtils.services.search;
                    test.api = test.service.api.search;
                    test.api.name = `${testApiName}_enrichedQuery_resources_by_uwi`;
                    test.expectedResponse = test.api.expectedResponse;
                    searchQuery = enrichedSearchQuery;
                    searchQuery.query = "data.UWI:8690";
        
                    test.service.host
                    .post(test.api.path)
                    .set('Authorization', token)
                    .set('data-partition-id', testUtils.partition)
                    .send(searchQuery)
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
    
                it("Search: Resources By UWI Wildcard", done => {
                    test.service = testUtils.services.search;
                    test.api = test.service.api.search;
                    test.api.name = `${testApiName}_enrichedQuery_resources_by_uwi_wildcard`;
                    test.expectedResponse = test.api.expectedResponse;
                    searchQuery = enrichedSearchQuery;
                    searchQuery.query = "data.UWI:101*";
        
                    test.service.host
                    .post(test.api.path)
                    .set('Authorization', token)
                    .set('data-partition-id', testUtils.partition)
                    .send(searchQuery)
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
    
                it("Search: Resources By UWI OR", done => {
                    test.service = testUtils.services.search;
                    test.api = test.service.api.search;
                    test.api.name = `${testApiName}_enrichedQuery_resources_by_uwi_OR`;
                    test.expectedResponse = test.api.expectedResponse;
                    searchQuery = enrichedSearchQuery;
                    searchQuery.query = "data.UWI:(8690 OR 8438)";
        
                    test.service.host
                    .post(test.api.path)
                    .set('Authorization', token)
                    .set('data-partition-id', testUtils.partition)
                    .send(searchQuery)
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
    
                it("Search: Resources By UWI AND", done => {
                    test.service = testUtils.services.search;
                    test.api = test.service.api.search;
                    test.api.name = `${testApiName}_enrichedQuery_resources_by_uwi_AND`;
                    test.expectedResponse = test.api.expectedResponse;
                    searchQuery = enrichedSearchQuery;
                    searchQuery.query = "(data.UWI:(8690 OR 8438)) AND (data.Data.IndividualTypeProperties.CountryID: \"srn:master-data/GeopoliticalEntity:Netherlands:\")";
        
                    test.service.host
                    .post(test.api.path)
                    .set('Authorization', token)
                    .set('data-partition-id', testUtils.partition)
                    .send(searchQuery)
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
    
                it("Search: Well Logs with GR & DT curves", done => {
                    test.service = testUtils.services.search;
                    test.api = test.service.api.search;
                    test.api.name = `${testApiName}_enrichedQuery_welllogs_with_gr_and_dt_curves`;
                    test.expectedResponse = test.api.expectedResponse;
                    searchQuery = enrichedSearchQuery;
                    searchQuery.query = "data.Curves.Mnemonic: GR AND DT";
        
                    test.service.host
                    .post(test.api.path)
                    .set('Authorization', token)
                    .set('data-partition-id', testUtils.partition)
                    .send(searchQuery)
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
    
                it("Search: Markers & Trajectories By UWBI", done => {
                    test.service = testUtils.services.search;
                    test.api = test.service.api.search;
                    test.api.name = `${testApiName}_enrichedQuery_markers_and_trajectories_by_UWBI`;
                    test.expectedResponse = test.api.expectedResponse;
                    searchQuery = enrichedSearchQuery;
                    searchQuery.query = "(data.UWBI: 3687) AND (kind: \"opendes:osdu:wellboremarker-wpc:0.2.1\" \"opendes:osdu:wellboretrajectory-wpc:0.2.1\")";
        
                    test.service.host
                    .post(test.api.path)
                    .set('Authorization', token)
                    .set('data-partition-id', testUtils.partition)
                    .send(searchQuery)
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
    
                it("Search: First Wellbore Page", done => {
                    test.service = testUtils.services.search;
                    test.api = test.service.api.search;
                    test.api.name = `${testApiName}_enrichedQuery_first_wellbore_page`;
                    test.expectedResponse = test.api.expectedResponse;
                    searchQuery = enrichedSearchQuery;
                    searchQuery.query = "data.UWI:3687";
                    searchQuery.offset = 0;
                    searchQuery.limit = 1;
                    searchQuery.sort = {};
                    searchQuery.sort.field = ["data.Data.IndividualTypeProperties.SequenceNumber"];
                    searchQuery.sort.order = ["ASC"];
        
                    test.service.host
                    .post(test.api.path)
                    .set('Authorization', token)
                    .set('data-partition-id', testUtils.partition)
                    .send(searchQuery)
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
    
                it("Search: Next Wellbore Page", done => {
                    test.service = testUtils.services.search;
                    test.api = test.service.api.search;
                    test.api.name = `${testApiName}_enrichedQuery_next_wellbore_page`;
                    test.expectedResponse = test.api.expectedResponse;
                    searchQuery = enrichedSearchQuery;
                    searchQuery.query = "data.UWI:3687";
                    searchQuery.offset = 1;
                    searchQuery.limit = 10;
                    searchQuery.sort = {};
                    searchQuery.sort.field = ["data.Data.IndividualTypeProperties.SequenceNumber"];
                    searchQuery.sort.order = ["ASC"];
        
                    test.service.host
                    .post(test.api.path)
                    .set('Authorization', token)
                    .set('data-partition-id', testUtils.partition)
                    .send(searchQuery)
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
    
                it("Search: Limit Returned Fields", done => {
                    test.service = testUtils.services.search;
                    test.api = test.service.api.search;
                    test.api.name = `${testApiName}_enrichedQuery_limit_returned_fields`;
                    test.expectedResponse = test.api.expectedResponse;
                    searchQuery = enrichedSearchQuery;
                    searchQuery.query = "data.UWI:3687";
        
                    test.service.host
                    .post(test.api.path)
                    .set('Authorization', token)
                    .set('data-partition-id', testUtils.partition)
                    .send(searchQuery)
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
    
                it("Search: Count Wellbores for UWI", done => {
                    test.service = testUtils.services.search;
                    test.api = test.service.api.search;
                    test.api.name = `${testApiName}_enrichedQuery_count_wellbores_for_UWI`;
                    test.expectedResponse = test.api.expectedResponse;
                    searchQuery = enrichedSearchQuery;
                    searchQuery.query = "data.UWI:3687";
                    searchQuery.returnedFields = [""];
                    searchQuery.limit = 1;
        
                    test.service.host
                    .post(test.api.path)
                    .set('Authorization', token)
                    .set('data-partition-id', testUtils.partition)
                    .send(searchQuery)
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
    
                it("Search: Group Wells By Spud Date", done => {
                    test.service = testUtils.services.search;
                    test.api = test.service.api.search;
                    test.api.name = `${testApiName}_enrichedQuery_group_wells_by_Spud_date`;
                    test.expectedResponse = test.api.expectedResponse;
                    searchQuery = enrichedSearchQuery;
                    searchQuery.returnedFields = [""];
                    searchQuery.limit = 1;
                    searchQuery.aggregateBy = "data.SpudDate";
        
                    test.service.host
                    .post(test.api.path)
                    .set('Authorization', token)
                    .set('data-partition-id', testUtils.partition)
                    .send(searchQuery)
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
    
                it("Search: Wells in Bounding Box", done => {
                    test.service = testUtils.services.search;
                    test.api = test.service.api.search;
                    test.api.name = `${testApiName}_enrichedQuery_wells_in_bounding_box`;
                    test.expectedResponse = test.api.expectedResponse;
                    searchQuery = enrichedSearchQuery;
                    searchQuery.spatialFilter = {
                        "field": "data.GeoLocation",
                        "byBoundingBox": {
                            "topLeft": {
                                "longitude": 4.9493408203125,
                                "latitude": 52.859180945520826
                            },
                            "bottomRight": {
                                "longitude": 5.1580810546875,
                                "latitude": 52.75956761546834
                            }
                        }
                    };
        
                    test.service.host
                    .post(test.api.path)
                    .set('Authorization', token)
                    .set('data-partition-id', testUtils.partition)
                    .send(searchQuery)
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
    
                it("Search: Wells within Distance", done => {
                    test.service = testUtils.services.search;
                    test.api = test.service.api.search;
                    test.api.name = `${testApiName}_enrichedQuery_wells_within_distance`;
                    test.expectedResponse = test.api.expectedResponse;
                    searchQuery = enrichedSearchQuery;
                    searchQuery.spatialFilter = {
                        "field": "data.GeoLocation",
                        "byDistance": {
                            "point": {
                                    "longitude": 5.1580810546875,
                                    "latitude": 52.859180945520826
                                },
                            "distance": 10000
                        }
                    };
        
                    test.service.host
                    .post(test.api.path)
                    .set('Authorization', token)
                    .set('data-partition-id', testUtils.partition)
                    .send(searchQuery)
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
    
                it("Search: Wells In Polygon", done => {
                    test.service = testUtils.services.search;
                    test.api = test.service.api.search;
                    test.api.name = `${testApiName}_enrichedQuery_wells_in_polygon`;
                    test.expectedResponse = test.api.expectedResponse;
                    searchQuery = enrichedSearchQuery;
                    searchQuery.spatialFilter = {
                        "field": "data.GeoLocation",
                        "byGeoPolygon": {
                            "points": [
                                {
                                    "longitude": 5.1580810546875,
                                    "latitude": 52.859180945520826
                                },
                                {
                                    "longitude": 4.9493408203125,
                                    "latitude": 52.75956761546834
                                },
                                {
                                    "longitude": 5.064697265625,
                                    "latitude": 52.579688026538726
                                },
                                {
                                    "longitude": 5.372314453125,
                                    "latitude": 52.68970242806752
                                },
                                {
                                    "longitude": 5.1580810546875,
                                    "latitude": 52.859180945520826
                                }
                            ]
                        }
                    };
                    searchQuery.offset = 0;
                    searchQuery.limit = 30;
        
                    test.service.host
                    .post(test.api.path)
                    .set('Authorization', token)
                    .set('data-partition-id', testUtils.partition)
                    .send(searchQuery)
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
    
                it("Search: Wells With x < Spud Date < y", done => {
                    test.service = testUtils.services.search;
                    test.api = test.service.api.search;
                    test.api.name = `${testApiName}_enrichedQuery_wells_with_Spud_date_between_x_and_y`;
                    test.expectedResponse = test.api.expectedResponse;
                    searchQuery = enrichedSearchQuery;
                    searchQuery.query = "data.SpudDate:[1999-01-01 TO 1999-02-27}";
                    searchQuery.sort = {
                        "field": ["data.SpudDate"],
                        "order": ["DESC"]
                    };
                    searchQuery.limit = 30;
    
                    test.service.host
                    .post(test.api.path)
                    .set('Authorization', token)
                    .set('data-partition-id', testUtils.partition)
                    .send(searchQuery)
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
    
                it("Search: Wells With Depth > x", done => {
                    test.service = testUtils.services.search;
                    test.api = test.service.api.search;
                    test.api.name = `${testApiName}_enrichedQuery_wells_with_depth_greater_then_x`;
                    test.expectedResponse = test.api.expectedResponse;
                    searchQuery = enrichedSearchQuery;
                    searchQuery.query = "data.Data.IndividualTypeProperties.TopMeasuredDepth.Depth: >2000";
                    searchQuery.returnedFields = ["data.Data.IndividualTypeProperties.TopMeasuredDepth.Depth", "data.Data.IndividualTypeProperties.TopMeasuredDepth.UnitOfMeasure"];
                    searchQuery.sort = {
                        "field": ["data.Data.IndividualTypeProperties.TopMeasuredDepth.Depth"],
                        "order": ["ASC"]
                    };
                    searchQuery.limit = 99; 
    
                    test.service.host
                    .post(test.api.path)
                    .set('Authorization', token)
                    .set('data-partition-id', testUtils.partition)
                    .send(searchQuery)
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
    
                it("Search: Wells With Depth In Range", done => {
                    test.service = testUtils.services.search;
                    test.api = test.service.api.search;
                    test.api.name = `${testApiName}_enrichedQuery_wells_with_depth_in_range`;
                    test.expectedResponse = test.api.expectedResponse;
                    searchQuery = enrichedSearchQuery;
                    searchQuery.query = "data.Data.IndividualTypeProperties.TopMeasuredDepth.Depth: {0 TO 2000]";
                    searchQuery.returnedFields = ["data.Data.IndividualTypeProperties.TopMeasuredDepth.Depth", "data.Data.IndividualTypeProperties.TopMeasuredDepth.UnitOfMeasure"];
                    searchQuery.sort = {
                        "field": ["data.Data.IndividualTypeProperties.TopMeasuredDepth.Depth"],
                        "order": ["ASC"]
                    };
                    searchQuery.limit = 99; 
    
                    test.service.host
                    .post(test.api.path)
                    .set('Authorization', token)
                    .set('data-partition-id', testUtils.partition)
                    .send(searchQuery)
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
            });
        }

        if (config.test_flags.crud_search.seismicQueries) {
            describe('Seismic Queries', (done) => {

                it("Search: Acquisition Project By Name", done => {
                    test.service = testUtils.services.search;
                    test.api = test.service.api.search;
                    test.api.name = `${testApiName}_seismicQuery_acquisition_project_by_name`;
                    test.expectedResponse = test.api.expectedResponse;
                    searchQuery = standardSearchQuery;
                    searchQuery.query = "data.Data.IndividualTypeProperties.ProjectID: ST0202R08";
        
                    test.service.host
                    .post(test.api.path)
                    .set('Authorization', token)
                    .set('data-partition-id', testUtils.partition)
                    .send(searchQuery)
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
    
                it("Search: Processing Projects for Acquisition", done => {
                    test.service = testUtils.services.search;
                    test.api = test.service.api.search;
                    test.api.name = `${testApiName}_seismicQuery_processing_projects_for_aquisition`;
                    test.expectedResponse = test.api.expectedResponse;
                    searchQuery = standardSearchQuery;
                    searchQuery.query = "data.Data.IndividualTypeProperties.SeismicAcquisitionProjects: \"srn:master-data/SeismicAcquisitionProject:ST2020R08:\"";
        
                    test.service.host
                    .post(test.api.path)
                    .set('Authorization', token)
                    .set('data-partition-id', testUtils.partition)
                    .send(searchQuery)
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
    
                it("Search: Acquisitions By Operator", done => {
                    test.service = testUtils.services.search;
                    test.api = test.service.api.search;
                    test.api.name = `${testApiName}_seismicQuery_aquisitions_by_operator`;
                    test.expectedResponse = test.api.expectedResponse;
                    searchQuery = standardSearchQuery;
                    searchQuery.query = "(data.Data.IndividualTypeProperties.Operator: \"srn:master-data/Organisation:Statoil:\") AND (data.Data.IndividualTypeProperties.ProjectTypeID: \"srn:reference-data/ProjectType:Acquisition:\")";
        
                    test.service.host
                    .post(test.api.path)
                    .set('Authorization', token)
                    .set('data-partition-id', testUtils.partition)
                    .send(searchQuery)
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
    
                it("Search: Acquisitions within Dates", done => {
                    test.service = testUtils.services.search;
                    test.api = test.service.api.search;
                    test.api.name = `${testApiName}_seismicQuery_aquisitions_within_dates`;
                    test.expectedResponse = test.api.expectedResponse;
                    searchQuery = standardSearchQuery;
                    searchQuery.query = "data.Data.IndividualTypeProperties.ProjectEndDate:[2000-01-01 TO 2008-02-01]";
        
                    test.service.host
                    .post(test.api.path)
                    .set('Authorization', token)
                    .set('data-partition-id', testUtils.partition)
                    .send(searchQuery)
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
    
                it("Search: Acquisitions with Cable Length > x", done => {
                    test.service = testUtils.services.search;
                    test.api = test.service.api.search;
                    test.api.name = `${testApiName}_seismicQuery_acquisitions_with_cable_length_greater_then_x`;
                    test.expectedResponse = test.api.expectedResponse;
                    searchQuery = standardSearchQuery;
                    searchQuery.query = "data.Data.IndividualTypeProperties.CableLength: >5000";
        
                    test.service.host
                    .post(test.api.path)
                    .set('Authorization', token)
                    .set('data-partition-id', testUtils.partition)
                    .send(searchQuery)
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
    
                it("Search: Trace By Geographic Region", done => {
                    test.service = testUtils.services.search;
                    test.api = test.service.api.search;
                    test.api.name = `${testApiName}_seismicQuery_trace_by_geographic_region`;
                    test.expectedResponse = test.api.expectedResponse;
                    searchQuery = standardSearchQuery;
                    searchQuery.spatialFilter = {
                        "field": "data.Data.ExtensionProperties.locationWGS84",
                        "byGeoPolygon": {
                            "points": [
                                {
                                    "longitude": 1.813767236,
                                    "latitude": 58.42946998
                                },
                                {
                                    "longitude": 1.949673713,
                                    "latitude": 58.4041567
                                },
                                {
                                    "longitude": 1.978324105,
                                    "latitude": 58.45614207
                                },
                                {
                                    "longitude": 1.84227351,
                                    "latitude": 58.48147214
                                },
                                {
                                    "longitude": 1.813767236,
                                    "latitude": 58.42946998
                                }
                            ]
                        }
                    };
                    searchQuery.offset = 0;
                    searchQuery.limit = 30;
        
                    test.service.host
                    .post(test.api.path)
                    .set('Authorization', token)
                    .set('data-partition-id', testUtils.partition)
                    .send(searchQuery)
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
    
                it("Search: Trace By Domain Type", done => {
                    test.service = testUtils.services.search;
                    test.api = test.service.api.search;
                    test.api.name = `${testApiName}_seismicQuery_trace_by_domain_type`;
                    test.expectedResponse = test.api.expectedResponse;
                    searchQuery = standardSearchQuery;
                    searchQuery.query = "data.Data.IndividualTypeProperties.SeismicDomainTypeID:\"srn:reference-data/SeismicDomainType:Depth:\"";
        
                    test.service.host
                    .post(test.api.path)
                    .set('Authorization', token)
                    .set('data-partition-id', testUtils.partition)
                    .send(searchQuery)
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
    
                it("Search: Horizons By Geographic Region", done => {
                    test.service = testUtils.services.search;
                    test.api = test.service.api.search;
                    test.api.name = `${testApiName}_seismicQuery_horizons_by_geo_region`;
                    test.expectedResponse = test.api.expectedResponse;
                    searchQuery = standardSearchQuery;
                    searchQuery.spatialFilter = {
                        "field": "data.Data.ExtensionProperties.locationWGS84",
                        "byGeoPolygon": {
                            "points": [
                                {
                                    "longitude": 1.813767236,
                                    "latitude": 58.42946998
                                },
                                {
                                    "longitude": 1.949673713,
                                    "latitude": 58.4041567
                                },
                                {
                                    "longitude": 1.978324105,
                                    "latitude": 58.45614207
                                },
                                {
                                    "longitude": 1.84227351,
                                    "latitude": 58.48147214
                                },
                                {
                                    "longitude": 1.813767236,
                                    "latitude": 58.42946998
                                }
                            ]
                        }
                    };
                    searchQuery.offset = 0;
                    searchQuery.limit = 30;
        
                    test.service.host
                    .post(test.api.path)
                    .set('Authorization', token)
                    .set('data-partition-id', testUtils.partition)
                    .send(searchQuery)
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
    
                it("Search: Horizons By Name", done => {
                    test.service = testUtils.services.search;
                    test.api = test.service.api.search;
                    test.api.name = `${testApiName}_seismicQuery_horizon_by_name`;
                    test.expectedResponse = test.api.expectedResponse;
                    searchQuery = standardSearchQuery;
                    searchQuery.query = "data.Data.IndividualTypeProperties.Name: SHETLAND_GP";
        
                    test.service.host
                    .post(test.api.path)
                    .set('Authorization', token)
                    .set('data-partition-id', testUtils.partition)
                    .send(searchQuery)
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
    
                it("Search: Horizons By Age & Unit Name", done => {
                    test.service = testUtils.services.search;
                    test.api = test.service.api.search;
                    test.api.name = `${testApiName}_seismicQuery_horizon_by_age_and_unitname`;
                    test.expectedResponse = test.api.expectedResponse;
                    searchQuery = standardSearchQuery;
                    searchQuery.query = "(data.Data.IndividualTypeProperties.GeologicalUnitAgePeriod: Turonian) AND (data.Data.IndividualTypeProperties.GeologicalUnitName: Shetland*)";
    
                    test.service.host
                    .post(test.api.path)
                    .set('Authorization', token)
                    .set('data-partition-id', testUtils.partition)
                    .send(searchQuery)
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
            });
        }
        
        afterEach(function() {
            if (this.currentTest.state === 'failed') {
                test.failedTests += 1;
            }
        });
        
        after(done => {
            telemetryUtils.scenarioRequest(runId, testUtils.services.search, scenario, test.failedTests);
            done();
        });
    });
});