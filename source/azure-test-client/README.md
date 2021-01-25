# Azure Test Client
This repository defines a tool that can be used to validate a deployment of OSDU on Azure. It is designed to support two use cases:
1. Manual usage to perform a smoke test on an Azure environment.
1. Automated usage via a scheduled job in the AKS cluster that the services are running in. There are several metrics emitted to Application Insights that can be used to track availability at a platform or service level.

## Required Environment Variables

The following environment variables are required and can be defined in an env file such as: `[environment-name].env`. Ex: `demo.env` or if using docker then in a .envrc file

```bash
# Azure Test Client Configuration
TENANT_ID=""
PRINCIPAL_ID=""
PRINCIPAL_SECRET=""
CLIENT_ID=""
OSDU_HOST=""
APPINSIGHTS_INSTRUMENTATIONKEY=""
```

## Execute Using Docker
Ensure environment variables are configured _(.envrc)_ and execute `docker-compose up`


## Execute using Node
Ensure environment variables are configured _(demo.env)_

```bash
# Install Node Dependencies
npm install

# Execute Test Run
ENVIRONMENT=demo npm run test
```

## Setting Up Automated Runs
Coming soon
