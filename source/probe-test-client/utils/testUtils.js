"use strict";

const request = require("supertest");
const fs = require('fs')
const config = require(`${__dirname}/../config`);

function between(min, max) {
    return Math.floor(Math.random() * (max - min + 1) + min);
};

function readTextFile(file)
{
    try {
        return fs.readFileSync(file, 'utf8');
    } catch (err) {
        console.error(`Error in read file: ${err}`);
        return null;
    }
};

// SERVICE INFO
const services = {
    entitlement: {
        name: "entitlements",
        host: request(config.api_host.entitlement),
        api: {
            initTenant: {
                name: 'initTenant',
                path: '/tenant-provisioning',
                expectedResponse: [200],
            },
            getGroups: {
                name: 'getGroups',
                path: '/groups/',
                expectedResponse: 200,
            },
            createGroup: {
                name: 'createGroup',
                path: '/groups',
                expectedResponse: [201, 409],
            },
            createUser: {
                name: 'createUser',
                path: {
                    prefix: '/groups/',
                    suffix: '/members'
                },
                expectedResponse: [200, 409],
            },
            deleteUser: {
                name: 'deleteUser',
                path: '/members/',
                expectedResponse: 204,
            },
            getUserGroups: {
                name: 'getUserGroups',
                path: {
                    prefix: '/members/',
                    suffix: '/groups?type=none'
                },
                expectedResponse: 200,
            },
            assignMemberToDataLakeGroup: {
                name: 'assignMemberToDataLakeGroup',
                path: {
                    prefix: '/groups/',
                    suffix: '/members',
                },
                expectedResponse: [200],
            },
            listMembersInDataLakeGroup: {
                name: 'assignMemberToDataLakeGroup',
                path: {
                    prefix: '/groups/',
                    suffix: '/members',
                },
                expectedResponse: 200,
            },
            removeMemberFromDataLakeGroup: {
                name: 'removeMemberFromDataLakeGroup',
                path: {
                    prefix: '/groups/',
                    suffix: '/members/',
                },
                expectedResponse: 204,
            },
            deleteUser: {
                name: 'deleteUser',
                path: '/members/',
                expectedResponse: 204,
            },
            deleteGroup: {
                name: 'deleteGroup',
                path: '/groups/',
                expectedResponse: 204,
            },
        },
    },
    legal: {
        name: "legal",
        host: request(config.api_host.legal),
        api: {
            createLegalTags: {
                name: 'createLegalTags',
                path: '/legaltags/',
                expectedResponse: [201, 409],
            },
            getAllLegalTags: {
                name: 'getAllLegalTags',
                path: '/legaltags',
                expectedResponse: 200,
            },
            getLegalTag: {
                name: 'getLegalTag',
                path: '/legaltags/',
                expectedResponse: 200,
            },
            deleteLegalTags: {
                name: 'deleteLegalTags',
                path: '/legaltags/',
                expectedResponse: 204,
            },
        },
    },
    storage: {
        name: "storage",
        host: request(config.api_host.storage),
        api: {
            createSchema: {
                name: 'createSchema',
                path: '/schemas/',
                expectedResponse: [201, 409],
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
                expectedResponse: [201, 409],
            },
            getRecord: {
                name: 'getRecord',
                path: '/records/',
                expectedResponse: 200,
            },
            getRecordByKind: {
                name: 'getRecordByKind',
                path: '/query/records?kind=',
                expectedResponse: 200,
            },
            listRecordVersions: {
                name: 'listRecordVersions',
                path: '/records/versions/',
                expectedResponse: 200,
            },
            getRecordVersion: {
                name: 'getRecordVersion',
                path: '/records/',
                expectedResponse: 200,
            },
            deleteRecord: {
                name: 'deleteRecord',
                path: '/records/',
                expectedResponse: 204,
            },
        },
    },
    notification: {
        name: "notification",
        host: request(config.api_host.notification),
        api: {
            createSubscription: {
                name: 'createSubscription',
                path: '/push-handlers/records-changed',
                expectedResponse: [200, 201]
            },
        },
    },
    partition: {
        name: "partition",
        host: request(config.api_host.partition),
        api: {
            getPartition: {
                name: 'getPartition',
                path: '/partitions/',
                expectedResponse: 200,
                expectedFailureResponse: 404,
            },
            createPartition: {
                name: 'createPartition',
                path: '/partitions/',
                expectedResponse: [200, 201],
            },
            deletePartition: {
                name: 'deletePartition',
                path: '/partitions/',
                expectedResponse: 204,
            },
        },
    },
    crs_catalog: {
        name: "crs-catalog",
        host: request(config.api_host.crs_catalog),
        api: {
            getArea: {
                name: 'getArea',
                path: '/v2/area',
                expectedResponse: 200,
            },
            getCatalog: {
                name: 'getCatalog',
                path: '/v2/catalog',
                expectedResponse: 200,
            },
            getCrs: {
                name: 'getCrs',
                path: '/v2/crs',
                expectedResponse: 200,
            },
        },
    },
    crs_conversion: {
        name: "crs-conversion",
        host: request(config.api_host.crs_conversion),
        api: {
            convert: {
                name: 'convert',
                path: '/v2/convert',
                expectedResponse: [200],
            },
            convertGeoJson: {
                name: 'convertGeoJson',
                path: '/v2/convertGeoJson',
                expectedResponse: [200],
            },
            convertTrajectory: {
                name: 'convertTrajectory',
                path: '/v2/convertTrajectory',
                expectedResponse: [200],
            },
        },
    },
    ingestion_workflow: {
        name: "ingestion-workflow",
        host: request(config.api_host.ingestion_workflow),
        api: {
            getAllWorkflows: {
                name: 'getAllWorkflows',
                path: '/workflow',
                expectedResponse: 200,
            },
            createWorkflow: {
                name: 'createWorkflow',
                path: '/workflow',
                expectedResponse: [200],
            },
            getWorkflow: {
                name: 'getWorkflow',
                path: '/workflow/',
                expectedResponse: 200,
            },
            deleteWorkflow: {
                name: 'deleteWorkflow',
                path: '/workflow/',
                expectedResponse: 204,
            },
        },
    },
    policy: {
        name: "policy",
        host: request(config.api_host.policy),
        api: {
            getAllPolicies: {
                name: 'getAllPolicies',
                path: '/policies',
                expectedResponse: 200,
            },
            getSearchPolicies: {
                name: 'getSearchPolicies',
                path: '/policies/search',
                expectedResponse: 200,
            },
            evaluatePolicy: {
                name: 'evaluatePolicy',
                path: '/evaluations/query',
                expectedResponse: [200],
            },
            createTestPolicy: {
                name: 'createTestPolicy',
                path: '/policies/test',
                expectedResponse: [200],
            },
            getTestPolicies: {
                name: 'getTestPolicies',
                path: '/policies/test',
                expectedResponse: 200,
                expectedFailureResponse: 404,
            },
            deleteTestPolicy: {
                name: 'deleteTestPolicy',
                path: '/policies/test',
                expectedResponse: 200,
            },
        },
    },
    unit: {
        name: "unit",
        host: request(config.api_host.unit),
        api: {
            getUnit: {
                name: 'getUnit',
                path: '/unit',
                expectedResponse: 200,
            },
            getCatalog: {
                name: 'getCatalog',
                path: '/catalog',
                expectedResponse: 200,
            },
            getMeasurement: {
                name: 'getMeasurement',
                path: '/measurement/list',
                expectedResponse: 200,
            },
            getUnitMaps: {
                name: 'getUnitMaps',
                path: '/unit/maps',
                expectedResponse: 200,
            },
            getUnitSystems: {
                name: 'getUnitSystems',
                path: '/unitsystem/list',
                expectedResponse: 200,
            },
        },
    },
    search: {
        name: "search",
        host: request(config.api_host.search),
        api: {
            search:{
                name: 'search',
                path: '',
                expectedResponse: [200],
            },
        },
    },
    schema: {
        name: "schema",
        host: request(config.api_host.schema),
        api: {
            getSchema:{
                name: 'getSchema',
                path: '/schema',
                expectedResponse: 200,
            },
            getSchemaById:{
                name: 'getSchemaById',
                path: '/schema/',
                expectedResponse: 200,
            },
            createSchema:{
                name: 'createSchema',
                path: '/schema',
                expectedResponse: [200, 201],
            },
            deleteSchema: {
                name: 'deleteSchema',
                path: '/schema/',
                expectedResponse: [200, 204],
            },
        },
    },
    register: {
        name: "register",
        host: request(config.api_host.register),
        api: {
            createSubscription: {
                name: 'createSubscription',
                path: '/subscription',
                expectedResponse: [200, 201, 409],
            },
            getSubscription: {
                name: 'getSubscription',
                path: '/subscription/',
                expectedResponse: 200,
            },
            deleteSubscription: {
                name: 'deleteSubscription',
                path: '/subscription/',
                expectedResponse: 204,
            },
            createDdms: {
                name: 'createDdms',
                path: '/ddms',
                expectedResponse: [200, 201, 409],
            },
            getDdms: {
                name: 'getDdms',
                path: '/ddms/',
                expectedResponse: 200,
            },
            deleteDdms: {
                name: 'deleteDdms',
                path: '/ddms/',
                expectedResponse: 204,
            },
            createAction: {
                name: 'createAction',
                path: '/action',
                expectedResponse: [200, 201, 409],
            },
            getAction: {
                name: 'getAction',
                path: '/action/',
                expectedResponse: 200,
            },
            deleteAction: {
                name: 'deleteAction',
                path: '/action/',
                expectedResponse: 204,
            },
        },
    },
    file: {
        name: "file",
        host: request(config.api_host.file),
        api: {
            getFilesList: {
                name: 'getFilesList',
                path: '/getFileList',
                expectedResponse: [200, 201],
            },
            uploadURL: {
                name: 'uploadURL',
                path: '/files/uploadURL',
                expectedResponse: 200,
            },
            uploadFile: {
                name: 'uploadFile',
                path: '',
                expectedResponse: [200, 201, 409],
            },
            downloadURL: {
                name: 'downloadURL',
                path: {
                    prefix: '/files/',
                    suffix: '/downloadURL',
                },
                expectedResponse: 200,
            },
            downloadFile: {
                name: 'downloadFile',
                path: '',
                expectedResponse: 200,
            },
            postMetadata: {
                name: 'postMetadata',
                path: '/files/metadata',
                expectedResponse: [200, 201],
            },
            getMetadata: {
                name: 'getMetadata',
                path: {
                    prefix: '/files/',
                    suffix: '/metadata',
                },
                expectedResponse: 200,
            },
        }
    },
    workflow: {
        name: "workflow",
        host: request(config.api_host.workflow),
        api: {
            createWorkflow: {
                name: 'createWorkflow',
                path: '/workflow',
                expectedResponse: [200, 409],
            },
            getWorkflowByName: {
                name: 'getWorkflowByName',
                path: '/workflow/',
                expectedResponse: 200,
            },
            runWorkflow: {
                name: 'runWorkflow',
                path: {
                    prefix: '/workflow/',
                    suffix: '/workflowRun',
                },
                expectedResponse: [200],
            },
            getWorkflowPreDefinedId: {
                name: 'getWorkflowPreDefinedId',
                path: {
                    prefix: '/workflow/',
                    suffix: '/workflowRun/',
                },
                expectedResponse: 200,
            },
        }
    },
};

// TEST DATA
let partition = 'opendes';
if (process.env.DATA_PARTITION !== undefined) {
  partition = process.env.DATA_PARTITION;
}

// OAUTH2.0
let oAuth = request(config.api_host.auth + "/oauth2");

module.exports = {
    between: between,
    readTextFile: readTextFile,
    services: services,
    partition: partition,
    oAuth: oAuth,
};  