"use strict";
require("dotenv").config({
  path: __dirname + "/" + process.env.ENVIRONMENT + ".env",
});

module.exports = {
  api_host: {
    auth: `https://login.microsoftonline.com/${process.env.TENANT_ID.trim()}/oauth2/token`,
    legal: `https://${process.env.OSDU_HOST.trim()}/api/legal/v1`,
    partition: `https://${process.env.OSDU_HOST.trim()}/api/partition/v1`,
  },
  auth_params: {
    grant_type: "client_credentials",
    client_id: process.env.PRINCIPAL_ID.trim(),
    client_secret: process.env.PRINCIPAL_SECRET.trim(),
    resource: process.env.CLIENT_ID.trim(),
  },
};
