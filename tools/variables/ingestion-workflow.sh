#!/usr/bin/env bash
#
#  Purpose: Create the Developer Environment Variables.
#  Usage:
#    ingestion-workflow.sh

###############################
## ARGUMENT INPUT            ##
###############################
usage() { echo "Usage: DNS_HOST=<your_host> INVALID_JWT=<your_token> ingestion-workflow.sh " 1>&2; exit 1; }

SERVICE="ingestion-workflow"

if [ -z $UNIQUE ]; then
  tput setaf 1; echo 'ERROR: UNIQUE not provided' ; tput sgr0
  usage;
fi

if [ -z $DNS_HOST ]; then
  tput setaf 1; echo 'ERROR: DNS_HOST not provided' ; tput sgr0
  usage;
fi

if [ -z $COMMON_VAULT ]; then
  tput setaf 1; echo 'ERROR: COMMON_VAULT not provided' ; tput sgr0
  usage;
fi

if [ -z $INVALID_JWT ]; then
  tput setaf 1; echo 'ERROR: INVALID_JWT not provided' ; tput sgr0
  usage;
fi

if [ -f ./settings_common.env ]; then
  source ./settings_common.env;
else
  tput setaf 1; echo 'ERROR: common.env not found' ; tput sgr0
fi

if [ -f ./settings_environment.env ]; then
  source ./settings_environment.env;
else
  tput setaf 1; echo 'ERROR: environment.env not found' ; tput sgr0
fi

if [ ! -d $UNIQUE ]; then mkdir $UNIQUE; fi


# ------------------------------------------------------------------------------------------------------
# LocalHost Run Settings
# ------------------------------------------------------------------------------------------------------
AZURE_TENANT_ID="${TENANT_ID}"
AZURE_CLIENT_ID="${ENV_PRINCIPAL_ID}"
AZURE_CLIENT_SECRET="${ENV_PRINCIPAL_SECRET}"
KEYVAULT_URI="${ENV_KEYVAULT}"
aad_client_id="${ENV_APP_ID}"
appinsights_key="${ENV_APPINSIGHTS_KEY}"
cosmosdb_database="${COSMOS_DB_NAME}"
entitlements_service_api_key="${API_KEY}"
entitlements_service_endpoint="https://${ENV_HOST}/entitlements/v1"
airflow_url="https://${ENV_HOST}/airflow"
airflow_username="admin"
airflow_password="${ENV_AIRFLOW_PASSWORD}"
AIRFLOW_STORAGE_ACCOUNT_NAME=${ENV_FILESHARE_STORAGE}
AIRFLOW_STORAGE_ACCOUNT_KEY=${ENV_FILESHARE_STORAGE_KEY}
LOG_PREFIX="workflow"
server_port="8085"
azure_istioauth_enabled="true"
partition_service_endpoint="https://${ENV_HOST}/api/partition/v1"

# ------------------------------------------------------------------------------------------------------
# Integration Test Settings
# ------------------------------------------------------------------------------------------------------
AZURE_AD_TENANT_ID="${TENANT_ID}"
INTEGRATION_TESTER="${ENV_PRINCIPAL_ID}"
AZURE_TESTER_SERVICEPRINCIPAL_SECRET="${ENV_PRINCIPAL_SECRET}"
AZURE_AD_APP_RESOURCE_ID="${ENV_APP_ID}"
NO_DATA_ACCESS_TESTER="${NO_ACCESS_ID}"
NO_DATA_ACCESS_TESTER_SERVICEPRINCIPAL_SECRET="${NO_ACCESS_SECRET}"
WORKFLOW_HOST="https://${ENV_HOST}/api/workflow/v1"
DEFAULT_DATA_PARTITION_ID_TENANT1="${OSDU_TENANT}"
DOMAIN="${COMPANY_DOMAIN}"
FINISHED_WORKFLOW_ID="c80a2419-8527-4804-b96a-6b6444f0d361"

cat > ${UNIQUE}/${SERVICE}.envrc <<LOCALENV
# ------------------------------------------------------------------------------------------------------
# Common Settings
# ------------------------------------------------------------------------------------------------------
export OSDU_TENANT=$OSDU_TENANT
export OSDU_TENANT2=$OSDU_TENANT2
export OSDU_TENANT3=$OSDU_TENANT3
export COMPANY_DOMAIN=$COMPANY_DOMAIN
export COSMOS_DB_NAME=$COSMOS_DB_NAME
export LEGAL_SERVICE_BUS_TOPIC=$LEGAL_SERVICE_BUS_TOPIC
export RECORD_SERVICE_BUS_TOPIC=$RECORD_SERVICE_BUS_TOPIC
export LEGAL_STORAGE_CONTAINER=$LEGAL_STORAGE_CONTAINER
export TENANT_ID=$TENANT_ID
export INVALID_JWT=$INVALID_JWT

export NO_ACCESS_ID=$NO_ACCESS_ID
export NO_ACCESS_SECRET=$NO_ACCESS_SECRET
export OTHER_APP_ID=$OTHER_APP_ID
export OTHER_APP_OID=$OTHER_APP_OID

export AD_USER_EMAIL=$AD_USER_EMAIL
export AD_USER_OID=$AD_USER_OID
export AD_GUEST_EMAIL=$AD_GUEST_EMAIL
export AD_GUEST_OID=$AD_GUEST_OID

# ------------------------------------------------------------------------------------------------------
# Environment Settings
# ------------------------------------------------------------------------------------------------------
export ENV_SUBSCRIPTION_NAME=$ENV_SUBSCRIPTION_NAME
export ENV_APP_ID=$ENV_APP_ID
export ENV_PRINCIPAL_ID=$ENV_PRINCIPAL_ID
export ENV_PRINCIPAL_SECRET=$ENV_PRINCIPAL_SECRET
export ENV_APPINSIGHTS_KEY=$ENV_APPINSIGHTS_KEY
export ENV_REGISTRY=$ENV_REGISTRY
export ENV_STORAGE=$ENV_STORAGE
export ENV_STORAGE_KEY=$ENV_STORAGE_KEY
export ENV_STORAGE_CONNECTION=$ENV_STORAGE_CONNECTION
export ENV_COSMOSDB_HOST=$ENV_COSMOSDB_HOST
export ENV_COSMOSDB_KEY=$ENV_COSMOSDB_KEY
export ENV_SERVICEBUS_NAMESPACE=$ENV_SERVICEBUS_NAMESPACE
export ENV_SERVICEBUS_CONNECTION=$ENV_SERVICEBUS_CONNECTION
export ENV_KEYVAULT=$ENV_KEYVAULT
export ENV_HOST=$ENV_HOST
export ENV_REGION=$ENV_REGION
export ENV_ELASTIC_HOST=$ENV_ELASTIC_HOST
export ENV_ELASTIC_PORT=$ENV_ELASTIC_PORT
export ENV_ELASTIC_USERNAME=$ENV_ELASTIC_USERNAME
export ENV_ELASTIC_PASSWORD=$ENV_ELASTIC_PASSWORD
export ENV_AIRFLOW_PASSWORD=$ENV_AIRFLOW_PASSWORD
export ENV_FILESHARE_STORAGE=$ENV_FILESHARE_STORAGE
export ENV_FILESHARE_STORAGE_KEY=$ENV_FILESHARE_STORAGE_KEY

# ------------------------------------------------------------------------------------------------------
# LocalHost Run Settings
# ------------------------------------------------------------------------------------------------------
export AZURE_TENANT_ID="${TENANT_ID}"
export AZURE_CLIENT_ID="${ENV_PRINCIPAL_ID}"
export AZURE_CLIENT_SECRET="${ENV_PRINCIPAL_SECRET}"
export KEYVAULT_URI="${ENV_KEYVAULT}"
export aad_client_id="${ENV_APP_ID}"
export appinsights_key="${ENV_APPINSIGHTS_KEY}"
export cosmosdb_database="${COSMOS_DB_NAME}"
export entitlements_service_api_key="${API_KEY}"
export entitlements_service_endpoint="https://${ENV_HOST}/entitlements/v1"
export airflow_url="https://${ENV_HOST}/airflow"
export airflow_username="admin"
export airflow_password="${ENV_AIRFLOW_PASSWORD}"
export AIRFLOW_STORAGE_ACCOUNT_NAME=${ENV_FILESHARE_STORAGE}
export AIRFLOW_STORAGE_ACCOUNT_KEY=${ENV_FILESHARE_STORAGE_KEY}
export LOG_PREFIX="workflow"
export server_port="8085"
export azure_istioauth_enabled="true"
export partition_service_endpoint="https://${ENV_HOST}/api/partition/v1"

# ------------------------------------------------------------------------------------------------------
# Integration Test Settings
# ------------------------------------------------------------------------------------------------------
export AZURE_AD_TENANT_ID="${TENANT_ID}"
export INTEGRATION_TESTER="${ENV_PRINCIPAL_ID}"
export AZURE_TESTER_SERVICEPRINCIPAL_SECRET="${ENV_PRINCIPAL_SECRET}"
export AZURE_AD_APP_RESOURCE_ID="${ENV_APP_ID}"
export NO_DATA_ACCESS_TESTER="${NO_ACCESS_ID}"
export NO_DATA_ACCESS_TESTER_SERVICEPRINCIPAL_SECRET="${NO_ACCESS_SECRET}"
export WORKFLOW_HOST="https://${ENV_HOST}/api/workflow/v1"
export DEFAULT_DATA_PARTITION_ID_TENANT1="${OSDU_TENANT}"
export DOMAIN="${COMPANY_DOMAIN}"
export FINISHED_WORKFLOW_ID="c80a2419-8527-4804-b96a-6b6444f0d361"
LOCALENV

cat > ${UNIQUE}/${SERVICE}_local.yaml <<LOCALRUN
AZURE_TENANT_ID: "${TENANT_ID}"
AZURE_CLIENT_ID: "${ENV_PRINCIPAL_ID}"
AZURE_CLIENT_SECRET: "${ENV_PRINCIPAL_SECRET}"
KEYVAULT_URI: "${ENV_KEYVAULT}"
aad_client_id: "${ENV_APP_ID}"
appinsights_key: "${ENV_APPINSIGHTS_KEY}"
cosmosdb_database: "${COSMOS_DB_NAME}"
entitlements_service_api_key: "${API_KEY}"
entitlements_service_endpoint: "https://${ENV_HOST}/entitlements/v1"
airflow_url: "https://${ENV_HOST}/airflow"
airflow_username: "admin"
airflow_password: "${ENV_AIRFLOW_PASSWORD}"
AIRFLOW_STORAGE_ACCOUNT_NAME: "${ENV_FILESHARE_STORAGE}"
AIRFLOW_STORAGE_ACCOUNT_KEY: "${ENV_FILESHARE_STORAGE_KEY}"
LOG_PREFIX: "workflow"
server_port: "8085"
azure_istioauth_enabled: "true"
partition_service_endpoint: "https://${ENV_HOST}/api/partition/v1"
LOCALRUN

cat > ${UNIQUE}/${SERVICE}_local_test.yaml <<LOCALTEST
AZURE_AD_TENANT_ID: "${TENANT_ID}"
INTEGRATION_TESTER: "${ENV_PRINCIPAL_ID}"
AZURE_TESTER_SERVICEPRINCIPAL_SECRET: "${ENV_PRINCIPAL_SECRET}"
AZURE_AD_APP_RESOURCE_ID: "${ENV_APP_ID}"
NO_DATA_ACCESS_TESTER: "${NO_ACCESS_ID}"
NO_DATA_ACCESS_TESTER_SERVICEPRINCIPAL_SECRET: "${NO_ACCESS_SECRET}"
WORKFLOW_HOST: "https://${ENV_HOST}/api/workflow/v1"
DEFAULT_DATA_PARTITION_ID_TENANT1: "${OSDU_TENANT}"
DOMAIN: "${COMPANY_DOMAIN}"
FINISHED_WORKFLOW_ID: "c80a2419-8527-4804-b96a-6b6444f0d361"
LOCALTEST

cat > ${UNIQUE}/${SERVICE}_test.yaml <<DEVTEST
AZURE_AD_TENANT_ID: "${TENANT_ID}"
INTEGRATION_TESTER: "${ENV_PRINCIPAL_ID}"
AZURE_TESTER_SERVICEPRINCIPAL_SECRET: "${ENV_PRINCIPAL_SECRET}"
AZURE_AD_APP_RESOURCE_ID: "${ENV_APP_ID}"
NO_DATA_ACCESS_TESTER: "${NO_ACCESS_ID}"
NO_DATA_ACCESS_TESTER_SERVICEPRINCIPAL_SECRET: "${NO_ACCESS_SECRET}"
WORKFLOW_HOST: "https://${ENV_HOST}/api/workflow/v1"
DEFAULT_DATA_PARTITION_ID_TENANT1: "${OSDU_TENANT}"
DOMAIN: "${COMPANY_DOMAIN}"
FINISHED_WORKFLOW_ID: "c80a2419-8527-4804-b96a-6b6444f0d361"
DEVTEST
