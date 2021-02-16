#!/usr/bin/env bash
#
#  Purpose: Create the Developer Environment Variables.
#  Usage:
#    os-wellbore-ddms.sh

###############################
## ARGUMENT INPUT            ##
###############################
usage() { echo "Usage: DNS_HOST=<your_host> INVALID_JWT=<your_token> os-wellbore-ddms.sh " 1>&2; exit 1; }

SERVICE="os-wellbore-ddms"

if [ -z $UNIQUE ]; then
  tput setaf 1; echo 'ERROR: UNIQUE not provided' ; tput sgr0
  usage;
fi

if [ -z $DNS_HOST ]; then
  tput setaf 1; echo 'ERROR: DNS_HOST not provided' ; tput sgr0
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
CLOUDPROVIDER="local"
STORAGE_SERVICE_PATH="tmpstorage"
BLOB_STORAGE_PATH="tmpblob"
SERVICE_HOST="127.0.0.1"
SERVICE_PORT="8080"

# ------------------------------------------------------------------------------------------------------
# Integration Test Settings
# ------------------------------------------------------------------------------------------------------
FILTER_TAG="basic"
cat > ${UNIQUE}/${SERVICE}.envrc <<LOCALENV


# ------------------------------------------------------------------------------------------------------
# Common Settings
# ------------------------------------------------------------------------------------------------------
export OSDU_TENANT=$OSDU_TENANT
export INVALID_JWT=$INVALID_JWT


# ------------------------------------------------------------------------------------------------------
# Environment Settings
# ------------------------------------------------------------------------------------------------------
export SERVICE_HOST_ENTITLEMENTS="https://${ENV_HOST}/entitlements/v1"
export SERVICE_HOST_SEARCH="https://${ENV_HOST}/api/search/v2"
export SERVICE_HOST_STORAGE="https://${ENV_HOST}/api/storage/v2"

# ------------------------------------------------------------------------------------------------------
# LocalHost Run Settings
# ------------------------------------------------------------------------------------------------------
export CLOUDPROVIDER=${CLOUDPROVIDER}
export STORAGE_SERVICE_PATH=${STORAGE_SERVICE_PATH}
export BLOB_STORAGE_PATH=${BLOB_STORAGE_PATH}
export SERVICE_HOST=${SERVICE_HOST}
export SERVICE_PORT=${SERVICE_PORT}

# ------------------------------------------------------------------------------------------------------
# Integration Test Settings
# ------------------------------------------------------------------------------------------------------
LOCALENV
