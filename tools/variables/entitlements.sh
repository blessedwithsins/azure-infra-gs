#!/usr/bin/env bash
#
#  Purpose: Create the Developer Environment Variables.
#  Usage:
#    entitlements.sh

###############################
## ARGUMENT INPUT            ##
###############################
usage() { echo "Usage: DNS_HOST=<your_host> INVALID_JWT=<your_token> entitlements.sh " 1>&2; exit 1; }

SERVICE="entitlements-v2"

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
aad_client_id="${ENV_APP_ID}"
appinsights_key="${ENV_APPINSIGHTS_KEY}"
KEYVAULT_URI="${ENV_KEYVAULT}"
service_domain_name="${COMPANY_DOMAIN}"
root_data_group_quota="${ROOT_DATA_GROUP_QUOTA}"
redis_ttl_seconds="${ENTV2_REDIS_TTL_SECONDS}"
partition_service_endpoint="https://${ENV_HOST}/api/partition/v1/"
azure_istioauth_enabled="true"
server_port="8080"
LOGGING_LEVEL=INFO


# ------------------------------------------------------------------------------------------------------
# Integration Test Settings
# ------------------------------------------------------------------------------------------------------
ENTITLEMENT_V2_URL="https://${ENV_HOST}/api/entitlements/v2/"
INTEGRATION_TESTER="${ENV_PRINCIPAL_ID}"
AZURE_TESTER_SERVICEPRINCIPAL_SECRET="${ENV_PRINCIPAL_SECRET}"
AZURE_AD_TENANT_ID="${TENANT_ID}"
AZURE_AD_APP_RESOURCE_ID="${ENV_APP_ID}"
DOMAIN="${COMPANY_DOMAIN}"

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
export AZURE_TENANT_ID="${TENANT_ID}"
export AZURE_CLIENT_ID="${ENV_PRINCIPAL_ID}"
export AZURE_CLIENT_SECRET="${ENV_PRINCIPAL_SECRET}"
export aad_client_id="${ENV_APP_ID}"
export appinsights_key="${ENV_APPINSIGHTS_KEY}"
export KEYVAULT_URI="${ENV_KEYVAULT}"
export service_domain_name="${COMPANY_DOMAIN}"
export root_data_group_quota="${ROOT_DATA_GROUP_QUOTA}"
export redis_ttl_seconds="${ENTV2_REDIS_TTL_SECONDS}"
export partition_service_endpoint="https://${ENV_HOST}/api/partition/v1/"
export azure_istioauth_enabled="true"
export server_port="8080"
export LOGGING_LEVEL="INFO"


# ------------------------------------------------------------------------------------------------------
# Integration Test Settings
# ------------------------------------------------------------------------------------------------------
export ENTITLEMENT_V2_URL="https://${ENV_HOST}/api/entitlements/v2/"
export INTEGRATION_TESTER="${ENV_PRINCIPAL_ID}"
export AZURE_TESTER_SERVICEPRINCIPAL_SECRET="${ENV_PRINCIPAL_SECRET}"
export AZURE_AD_TENANT_ID="${TENANT_ID}"
export AZURE_AD_APP_RESOURCE_ID="${ENV_APP_ID}"
export DOMAIN="${COMPANY_DOMAIN}"
LOCALENV


cat > ${UNIQUE}/${SERVICE}_local.yaml <<LOCALRUN
AZURE_TENANT_ID: "${TENANT_ID}"
AZURE_CLIENT_ID: "${ENV_PRINCIPAL_ID}"
AZURE_CLIENT_SECRET: "${ENV_PRINCIPAL_SECRET}"
aad_client_id: "${ENV_APP_ID}"
appinsights_key: "${ENV_APPINSIGHTS_KEY}"
KEYVAULT_URI: "${ENV_KEYVAULT}"
service_domain_name: "${COMPANY_DOMAIN}"
root_data_group_quota: "${ROOT_DATA_GROUP_QUOTA}"
redis_ttl_seconds: "${ENTV2_REDIS_TTL_SECONDS}"
partition_service_endpoint: "https://${ENV_HOST}/api/partition/v1/"
azure_istioauth_enabled: "true"
server_port: "8080"
LOGGING_LEVEL: "INFO"
LOCALRUN


cat > ${UNIQUE}/${SERVICE}_local_test.yaml <<LOCALTEST
ENTITLEMENT_V2_URL: "http://localhost:${server_port}/api/entitlements/v2/"
INTEGRATION_TESTER: "${ENV_PRINCIPAL_ID}"
AZURE_TESTER_SERVICEPRINCIPAL_SECRET: "${ENV_PRINCIPAL_SECRET}"
AZURE_AD_TENANT_ID: "${TENANT_ID}"
AZURE_AD_APP_RESOURCE_ID: "${ENV_APP_ID}"
DOMAIN: "${COMPANY_DOMAIN}"
LOCALTEST


cat > ${UNIQUE}/${SERVICE}_test.yaml <<DEVTEST
ENTITLEMENT_URL: "https://${ENV_HOST}/api/entitlements/v2/"
INTEGRATION_TESTER: "${ENV_PRINCIPAL_ID}"
AZURE_TESTER_SERVICEPRINCIPAL_SECRET: "${ENV_PRINCIPAL_SECRET}"
AZURE_AD_TENANT_ID: "${TENANT_ID}"
AZURE_AD_APP_RESOURCE_ID: "${ENV_APP_ID}"
DOMAIN="${COMPANY_DOMAIN}"
DEVTEST
