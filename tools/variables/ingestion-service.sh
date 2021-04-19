#!/usr/bin/env bash
#
#  Purpose: Create the Developer Environment Variables.
#  Usage:
#    ingestion-service.sh

###############################
## ARGUMENT INPUT            ##
###############################
usage() { echo "Usage: DNS_HOST=<your_host> INVALID_JWT=<your_token> ingestion-service.sh " 1>&2; exit 1; }

SERVICE="ingestion-service"

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
ENTITLEMENTS_URL="https://${ENV_HOST}/entitlements/v1"
azure_istioauth_enabled="true"

# ------------------------------------------------------------------------------------------------------
# Integration Test Settings
# ------------------------------------------------------------------------------------------------------
INTEGRATION_TESTER="${ENV_PRINCIPAL_ID}"
TESTER_SERVICEPRINCIPAL_SECRET="${ENV_PRINCIPAL_SECRET}"
AZURE_TENANT_ID="${TENANT_ID}"
AZURE_AD_APP_RESOURCE_ID="${ENV_APP_ID}"
BASE_URL=/api/crs/converter/v2
VIRTUAL_SERVICE_HOST_NAME="localhost:8080"
client_id="${ENV_PRINCIPAL_ID}"
MY_TENANT="${OSDU_TENANT}"
TIME_ZONE="UTC+0"

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


# ------------------------------------------------------------------------------------------------------
# LocalHost Run Settings
# ------------------------------------------------------------------------------------------------------
export ENTITLEMENTS_URL="https://${ENV_HOST}/entitlements/v1"
export azure_istioauth_enabled="true"

# ------------------------------------------------------------------------------------------------------
# Integration Test Settings
# ------------------------------------------------------------------------------------------------------
export INTEGRATION_TESTER="${INTEGRATION_TESTER}"
export TESTER_SERVICEPRINCIPAL_SECRET="${TESTER_SERVICEPRINCIPAL_SECRET}"
export AZURE_TENANT_ID="${AZURE_TENANT_ID}"
export AZURE_AD_APP_RESOURCE_ID="${AZURE_AD_APP_RESOURCE_ID}"
export BASE_URL=/api/crs/converter/v2
export VIRTUAL_SERVICE_HOST_NAME="localhost:8080"
export client_id="${ENV_PRINCIPAL_ID}"
export MY_TENANT="${OSDU_TENANT}"
export TIME_ZONE="${TIME_ZONE}"
LOCALENV


cat > ${UNIQUE}/${SERVICE}_local.yaml <<LOCALRUN
ENTITLEMENTS_URL: "${ENTITLEMENTS_URL}
azure_istioauth_enabled: "${azure_istioauth_enabled}"
LOCALRUN


cat > ${UNIQUE}/${SERVICE}_local_test.yaml <<LOCALTEST
INTEGRATION_TESTER: "${INTEGRATION_TESTER}"
TESTER_SERVICEPRINCIPAL_SECRET: "${TESTER_SERVICEPRINCIPAL_SECRET}"
AZURE_TENANT_ID: "${AZURE_TENANT_ID}"
AZURE_AD_APP_RESOURCE_ID: "${AZURE_AD_APP_RESOURCE_ID}"
BASE_URL: "${BASE_URL}"
VIRTUAL_SERVICE_HOST_NAME: "${VIRTUAL_SERVICE_HOST_NAME}"
client_id: "${client_id}"
MY_TENANT: "${MY_TENANT}"
TIME_ZONE: "${TIME_ZONE}"
LOCALTEST


cat > ${UNIQUE}/${SERVICE}_test.yaml <<DEVTEST
INTEGRATION_TESTER: "${INTEGRATION_TESTER}"
TESTER_SERVICEPRINCIPAL_SECRET: "${TESTER_SERVICEPRINCIPAL_SECRET}"
AZURE_TENANT_ID: "${AZURE_TENANT_ID}"
AZURE_AD_APP_RESOURCE_ID: "${AZURE_AD_APP_RESOURCE_ID}"
BASE_URL: "${BASE_URL}"
VIRTUAL_SERVICE_HOST_NAME: "${ENV_HOST}"
client_id: "${client_id}"
MY_TENANT: "${MY_TENANT}"
TIME_ZONE: "${TIME_ZONE}"
DEVTEST
