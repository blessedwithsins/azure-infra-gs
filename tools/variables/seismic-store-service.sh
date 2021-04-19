#!/usr/bin/env bash
#
#  Purpose: Create the Developer Environment Variables.
#  Usage:
#    seismic-store-service.sh

###############################
## ARGUMENT INPUT            ##
###############################
usage() { echo "Usage: DNS_HOST=<your_host> INVALID_JWT=<your_token> crs-conversion-service.sh " 1>&2; exit 1; }

SERVICE="seismic-store-service"

if [ -z $UNIQUE ]; then
  tput setaf 1; echo 'ERROR: UNIQUE not provided' ; tput sgr0
  usage;
fi

if [ -z $DNS_HOST ]; then
  tput setaf 1; echo 'ERROR: DNS_HOST not provided' ; tput sgr0
  usage;
fi

if [ -z $ENV_NAME ]; then
  tput setaf 1; echo 'ERROR: ENV_NAME not provided' ; tput sgr0
  usage;
fi

if [ -z $PORT ]; then
  tput setaf 1; echo 'ERROR: PORT not provided' ; tput sgr0
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
CLOUDPROVIDER="azure"
DES_SERVICE_HOST="https://${DNS_HOST}/entitlements/v1"
REDIS_INSTANCE_PORT="6379"
APP_ENVIRONMENT_IDENTIFIER="${ENV_NAME}"
PORT="${PORT}"
KEYVAULT_URL=$ENV_KEYVAULT

# ------------------------------------------------------------------------------------------------------
# Integration Test Settings
# ------------------------------------------------------------------------------------------------------

# ------------------------------------------------------------------------------------------------------
# Create envrc file
# ------------------------------------------------------------------------------------------------------
cat > ${UNIQUE}/${SERVICE}.envrc <<LOCALENV
# ------------------------------------------------------------------------------------------------------
# Common Settings
# ------------------------------------------------------------------------------------------------------
export CLOUDPROVIDER=$CLOUDPROVIDER

# ------------------------------------------------------------------------------------------------------
# Environment Settings
# ------------------------------------------------------------------------------------------------------
export ENV_SUBSCRIPTION_NAME=$ENV_SUBSCRIPTION_NAME
export ENV_APP_ID=$ENV_APP_ID
export ENV_PRINCIPAL_ID=$ENV_PRINCIPAL_ID
export ENV_PRINCIPAL_SECRET=$ENV_PRINCIPAL_SECRET

export DES_SERVICE_HOST=$DES_SERVICE_HOST
export REDIS_INSTANCE_PORT=$REDIS_INSTANCE_PORT
export APP_ENVIRONMENT_IDENTIFIER=$APP_ENVIRONMENT_IDENTIFIER
expor PORT=$PORT
export KEYVAULT_URL=$KEYVAULT_URL

# ------------------------------------------------------------------------------------------------------
# LocalHost Run Settings
# ------------------------------------------------------------------------------------------------------
export AZURE_TENANT_ID="${TENANT_ID}"
export AZURE_CLIENT_ID="${ENV_PRINCIPAL_ID}"
export AZURE_CLIENT_SECRET="${ENV_PRINCIPAL_SECRET}"
export KEYVAULT_URI="${ENV_KEYVAULT}"
export aad_client_id="${ENV_APP_ID}"

# ------------------------------------------------------------------------------------------------------
# Integration Test Settings
# ------------------------------------------------------------------------------------------------------
LOCALENV

