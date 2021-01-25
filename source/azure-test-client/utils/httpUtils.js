'use strict';

const should = require('chai').Should();
const request = require("supertest");
const config = require('../config');
const appInsights = require('applicationinsights');

// Configure AI
appInsights.setup().start();
const client = appInsights.defaultClient;
appInsights.defaultClient.context.tags[appInsights.defaultClient.context.keys.cloudRole] = `smoke-test-probe`


const results = {
    SUCCESS: 1,
    FAIL: 0
};


const failRequest = (test, actualResponse) => {
    client.trackMetric({
        name: test.name, 
        value: results.FAIL
    });    
    client.trackEvent({
        name: `${test.name}-event`,
        properties: {
            success: false,
            service: test.service,
            expectedResponses: test.expectedResponses,
            actualResponse: actualResponse
        }
    });

    console.log(`Failed scenario ${test.name}! Expected response code(s) ${test.expectedResponses}, but got ${actualResponse}`)
    throw new Error(`Failed scenario ${test.name}! Expected response code(s) ${test.expectedResponses}, but got ${actualResponse}`);
}

const passRequest = (test, actualResponse) => {
    client.trackMetric({
        name: test.name, 
        value: results.SUCCESS
    });
    client.trackEvent({
        name: `${test.name}-event`,
        properties: {
            success: true,
            service: test.service,
            expectedResponses: test.expectedResponses,
            actualResponse: actualResponse
        }
    });
}


module.exports = {
    failRequest: failRequest,
    passRequest: passRequest
}