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

// Test Data Setup
const sampleUser = require(`${__dirname}/../testData/sample_user.json`);
const sampleUserResponse = require(`${__dirname}/../testData/sample_user_response.json`);
let data = "";

// Test Setup
let scenario = "entitlementsservice_crudOps";

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
let group_name = `app.trusted`
let viewers_group_type= `users.datalake.viewers`
let editors_group_type= `users.datalake.editors`
let admins_group_type= `users.datalake.admins`
let ops_group_type= `users.datalake.ops`

let domain = 'contoso.com'
let member_email = `myuser@email.com`
sampleUser.email = member_email;
let user_group = `users@${testUtils.partition}.${domain}`
let admin_group_type_email = `${group_name}@${testUtils.partition}.${domain}`
let group_type_email = `${admins_group_type}@${testUtils.partition}.${domain}`

let viewer_group = `${viewers_group_type}@${testUtils.partition}.${domain}`
let editor_group = `${editors_group_type}@${testUtils.partition}.${domain}`
let admin_group = `${admins_group_type}@${testUtils.partition}.${domain}`
let ops_group = `${ops_group_type}@${testUtils.partition}.${domain}`

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

    describe('Scenario: Entitlements V2 Service supports CRUD operations', (done) => {

        if (config.test_flags.crud_entitlements.enableScenario) {
            describe('Inititalize Users for a Partition', done => {
            
                // NOTE: This API can ONLY be called by the application service principal.
                it('Initialize Entitlements for a Partition', done => {
                    test.service = testUtils.services.entitlement;
                    test.api = test.service.api.initTenant;
                    test.expectedResponse = test.api.expectedResponse;
    
                    test.service.host
                    .post(test.api.path)
                    .set('Authorization', token)
                    .set('data-partition-id', testUtils.partition)
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
    
                // NOTE: The Owner of the partition by default is the service principal.
                it("Validate the Owner of the Partition", done => {
                    test.service = testUtils.services.entitlement;
                    test.api = test.service.api.getGroups;
                    test.expectedResponse = test.api.expectedResponse;
    
                    test.service.host
                    .get(test.api.path)
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
    
            describe('Create Group', done => {
    
                it("Create a new Group.", done => {
                    test.service = testUtils.services.entitlement;
                    test.api = test.service.api.createGroup;
                    test.expectedResponse = test.api.expectedResponse;
    
                    let payload = {
                        "name": `${group_name}`,
                        "description": "My Group"
                    };
    
                    test.service.host
                    .post(test.api.path)
                    .set('Authorization', token)
                    .set('data-partition-id', testUtils.partition)
                    .send(payload)
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
    
                // Purpose: Allow group type to access the group.
                it("Add admin user to group.", done => {
                    test.service = testUtils.services.entitlement;
                    test.api = test.service.api.createUser;
                    test.expectedResponse = test.api.expectedResponse;
    
                    let payload = {
                        "email": `${group_type_email}`,
                        "role": "MEMBER"
                    };
    
                    test.service.host
                    .post(test.api.path.prefix + admin_group_type_email + test.api.path.suffix)
                    .set('Authorization', token)
                    .set('data-partition-id', testUtils.partition)
                    .send(payload)
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
    
                it("Get All groups.", done => {
                    test.service = testUtils.services.entitlement;
                    test.api = test.service.api.getGroups;
                    test.expectedResponse = test.api.expectedResponse;
    
                    test.service.host
                    .get(test.api.path)
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
    
            describe('Create Users', done => {
    
                it("Create a new User", done => {
                    test.service = testUtils.services.entitlement;
                    test.api = test.service.api.createUser;
                    test.expectedResponse = test.api.expectedResponse;
    
                    test.service.host
                    .post(test.api.path.prefix + user_group + test.api.path.suffix)
                    .set('Authorization', token)
                    .set('data-partition-id', testUtils.partition)
                    .send(sampleUser)
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
    
            describe('Manage Roles', done => {
    
                it("Validate that the User has groups", done => {
                    test.service = testUtils.services.entitlement;
                    test.api = test.service.api.getUserGroups;
                    test.expectedResponse = test.api.expectedResponse;
    
                    test.service.host
                    .get(test.api.path.prefix + member_email + test.api.path.suffix)
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
    
                it("Assign the user to the datalake.viewers Group", done => {
                    test.service = testUtils.services.entitlement;
                    test.api = test.service.api.assignMemberToDataLakeGroup;
                    test.expectedResponse = test.api.expectedResponse;
    
                    test.service.host
                    .post(test.api.path.prefix + viewer_group + test.api.path.suffix)
                    .set('Authorization', token)
                    .set('data-partition-id', testUtils.partition)
                    .send(sampleUser)
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
    
                it("Assign the user to the datalake.editors Group", done => {
                    test.service = testUtils.services.entitlement;
                    test.api = test.service.api.assignMemberToDataLakeGroup;
                    test.expectedResponse = test.api.expectedResponse;
    
                    test.service.host
                    .post(test.api.path.prefix + editor_group + test.api.path.suffix)
                    .set('Authorization', token)
                    .set('data-partition-id', testUtils.partition)
                    .send(sampleUser)
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
    
                // NOTE: This role can not delete for Legal, Schema or Storage
                it("Assign the user to the datalake.admins Group", done => {
                    test.service = testUtils.services.entitlement;
                    test.api = test.service.api.assignMemberToDataLakeGroup;
                    test.expectedResponse = test.api.expectedResponse;
    
                    test.service.host
                    .post(test.api.path.prefix + admin_group + test.api.path.suffix)
                    .set('Authorization', token)
                    .set('data-partition-id', testUtils.partition)
                    .send(sampleUser)
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
    
                // NOTE: This role can delete data
                it("Assign the user to the datalake.ops Group", done => {
                    test.service = testUtils.services.entitlement;
                    test.api = test.service.api.assignMemberToDataLakeGroup;
                    test.expectedResponse = test.api.expectedResponse;
    
                    test.service.host
                    .post(test.api.path.prefix + ops_group + test.api.path.suffix)
                    .set('Authorization', token)
                    .set('data-partition-id', testUtils.partition)
                    .send(sampleUser)
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
    
                it("List the Users with the Role of Reader", done => {
                    test.service = testUtils.services.entitlement;
                    test.api = test.service.api.listMembersInDataLakeGroup;
                    test.expectedResponse = test.api.expectedResponse;
    
                    test.service.host
                    .get(test.api.path.prefix + viewer_group + test.api.path.suffix)
                    .set('Authorization', token)
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
    
                it('Validate: List the Users with the Role of Reader', () => {
                    test.service = testUtils.services.entitlement;
                    test.api.name = 'validate_' + test.service.api.listMembersInDataLakeGroup.name;
                    test.expectedResponse = "Valid Match";
        
                    if (JSON.stringify(data).includes(JSON.stringify(sampleUserResponse))) {
                        telemetryUtils.passApiRequest(test);
                        expect(true).to.be.true;
                    } else {
                        telemetryUtils.failApiRequest(test, "Invalid");
                        console.log(`actual:${JSON.stringify(data)}`);
                        console.log(`expected:${JSON.stringify(sampleUserResponse)}`);
                        expect(false).to.be.true;
                    }
                });
    
                it("List the Users with the Role of Contributor", done => {
                    test.service = testUtils.services.entitlement;
                    test.api = test.service.api.listMembersInDataLakeGroup;
                    test.expectedResponse = test.api.expectedResponse;
    
                    test.service.host
                    .get(test.api.path.prefix + editor_group + test.api.path.suffix)
                    .set('Authorization', token)
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
    
                it('Validate: List the Users with the Role of Contributor', () => {
                    test.service = testUtils.services.entitlement;
                    test.api.name = 'validate_' + test.service.api.listMembersInDataLakeGroup.name;
                    test.expectedResponse = "Valid Match";
        
                    if (JSON.stringify(data).includes(JSON.stringify(sampleUserResponse))) {
                        telemetryUtils.passApiRequest(test);
                        expect(true).to.be.true;
                    } else {
                        telemetryUtils.failApiRequest(test, "Invalid");
                        console.log(`actual:${JSON.stringify(data)}`);
                        console.log(`expected:${JSON.stringify(sampleUserResponse)}`);
                        expect(false).to.be.true;
                    }
                });
    
                it("List the Users with the Role of Admin", done => {
                    test.service = testUtils.services.entitlement;
                    test.api = test.service.api.listMembersInDataLakeGroup;
                    test.expectedResponse = test.api.expectedResponse;
    
                    test.service.host
                    .get(test.api.path.prefix + admin_group + test.api.path.suffix)
                    .set('Authorization', token)
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
    
                it('Validate: List the Users with the Role of Admin', () => {
                    test.service = testUtils.services.entitlement;
                    test.api.name = 'validate_' + test.service.api.listMembersInDataLakeGroup.name;
                    test.expectedResponse = "Valid Match";
        
                    if (JSON.stringify(data).includes(JSON.stringify(sampleUserResponse))) {
                        telemetryUtils.passApiRequest(test);
                        expect(true).to.be.true;
                    } else {
                        telemetryUtils.failApiRequest(test, "Invalid");
                        console.log(`actual:${JSON.stringify(data)}`);
                        console.log(`expected:${JSON.stringify(sampleUserResponse)}`);
                        expect(false).to.be.true;
                    }
                });
    
                it("List the Users with the Role of Owner", done => {
                    test.service = testUtils.services.entitlement;
                    test.api = test.service.api.listMembersInDataLakeGroup;
                    test.expectedResponse = test.api.expectedResponse;
    
                    test.service.host
                    .get(test.api.path.prefix + ops_group + test.api.path.suffix)
                    .set('Authorization', token)
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
    
                it('Validate: List the Users with the Role of Owner', () => {
                    test.service = testUtils.services.entitlement;
                    test.api.name = 'validate_' + test.service.api.listMembersInDataLakeGroup.name;
                    test.expectedResponse = "Valid Match";
        
                    if (JSON.stringify(data).includes(JSON.stringify(sampleUserResponse))) {
                        telemetryUtils.passApiRequest(test);
                        expect(true).to.be.true;
                    } else {
                        telemetryUtils.failApiRequest(test, "Invalid");
                        console.log(`actual:${JSON.stringify(data)}`);
                        console.log(`expected:${JSON.stringify(sampleUserResponse)}`);
                        expect(false).to.be.true;
                    }
                });
            });
    
            describe('Probe Cleanup', done => {
    
                it("Remove the Owner Role from a User", done => {
                    test.service = testUtils.services.entitlement;
                    test.api = test.service.api.removeMemberFromDataLakeGroup;
                    test.expectedResponse = test.api.expectedResponse;
    
                    test.service.host
                    .delete(test.api.path.prefix + ops_group + test.api.path.suffix + sampleUser.email)
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
    
                it("Remove the Admin Role from a User", done => {
                    test.service = testUtils.services.entitlement;
                    test.api = test.service.api.removeMemberFromDataLakeGroup;
                    test.expectedResponse = test.api.expectedResponse;
    
                    test.service.host
                    .delete(test.api.path.prefix + admin_group + test.api.path.suffix + sampleUser.email)
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
    
                it("Remove the Contributor Role from a User", done => {
                    test.service = testUtils.services.entitlement;
                    test.api = test.service.api.removeMemberFromDataLakeGroup;
                    test.expectedResponse = test.api.expectedResponse;
    
                    test.service.host
                    .delete(test.api.path.prefix + editor_group + test.api.path.suffix + sampleUser.email)
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
    
                it("Remove the Reader Role from a User", done => {
                    test.service = testUtils.services.entitlement;
                    test.api = test.service.api.removeMemberFromDataLakeGroup;
                    test.expectedResponse = test.api.expectedResponse;
    
                    test.service.host
                    .delete(test.api.path.prefix + viewer_group + test.api.path.suffix + sampleUser.email)
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
    
                it("Delete User", done => {
                    test.service = testUtils.services.entitlement;
                    test.api = test.service.api.deleteUser;
                    test.expectedResponse = test.api.expectedResponse;
    
                    test.service.host
                    .delete(test.api.path + sampleUser.email)
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
    
                it("Delete Groups", done => {
                    test.service = testUtils.services.entitlement;
                    test.api = test.service.api.deleteGroup;
                    test.expectedResponse = test.api.expectedResponse;
    
                    test.service.host
                    .delete(test.api.path + admin_group_type_email + `?groupEmail=${group_type_email}`)
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
    
                it("Delete Admin Groups", done => {
                    test.service = testUtils.services.entitlement;
                    test.api = test.service.api.deleteGroup;
                    test.expectedResponse = test.api.expectedResponse;
    
                    test.service.host
                    .delete(test.api.path + admin_group_type_email + `?groupEmail=${admin_group_type_email}`)
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
        }
        else
        {
            console.log("Scenario Disabled by flag");
        }

        afterEach(function() {
            if (this.currentTest.state === 'failed') {
                test.failedTests += 1;
            }
          });

        after(done => {
            telemetryUtils.scenarioRequest(runId, testUtils.services.entitlement, scenario, test.failedTests);
            done();
        });
    });
});