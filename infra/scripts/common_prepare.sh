#!/usr/bin/env bash
#
#  Purpose: Initialize the common resources necessary for building infrastructure.
#  Usage:
#    common_prepare.sh

###############################
## ARGUMENT INPUT            ##
###############################
usage() { echo "Usage: common_prepare.sh <subscription_id> <unique>" 1>&2; exit 1; }

if [ -z $GIT_REPO ]; then
  tput setaf 1; echo 'ERROR: GIT_REPO not provided' ; tput sgr0
  usage;
fi

if [ ! -z $1 ]; then ARM_SUBSCRIPTION_ID=$1; fi
if [ -z $ARM_SUBSCRIPTION_ID ]; then
  tput setaf 1; echo 'ERROR: ARM_SUBSCRIPTION_ID not provided' ; tput sgr0
  usage;
fi

if [ ! -z $2 ]; then UNIQUE=$2; fi
if [ -z $UNIQUE ]; then
  tput setaf 1; echo 'ERROR: UNIQUE not provided' ; tput sgr0
  usage;
fi

if [ -z $RANDOM_NUMBER ]; then
  RANDOM_NUMBER=$(echo $((RANDOM%9999+100)))
  echo "export RANDOM_NUMBER=${RANDOM_NUMBER}" > .envrc
fi

if [ -z $AZURE_LOCATION ]; then
  AZURE_LOCATION="centralus"
fi

if [ -z $AZURE_PAIR_LOCATION ]; then
  AZURE_PAIR_LOCATION="eastus"
fi

if [ -z $AZURE_GROUP ]; then
  AZURE_GROUP="osdu-common-${UNIQUE}"
fi

if [ -z $AZURE_STORAGE ]; then
  AZURE_STORAGE="osducommon${RANDOM_NUMBER}"
fi

if [ -z $AZURE_VAULT ]; then
  AZURE_VAULT="osducommon${RANDOM_NUMBER}"
fi

if [ -z $REMOTE_STATE_CONTAINER ]; then
  REMOTE_STATE_CONTAINER="remote-state-container"
fi

if [ -z $AZURE_AKS_USER ]; then
  AZURE_AKS_USER="osdu.${UNIQUE}"
fi




###############################
## FUNCTIONS                 ##
###############################
function CreateResourceGroup() {
  # Required Argument $1 = RESOURCE_GROUP
  # Required Argument $2 = LOCATION

  if [ -z $1 ]; then
    tput setaf 1; echo 'ERROR: Argument $1 (RESOURCE_GROUP) not received'; tput sgr0
    exit 1;
  fi
  if [ -z $2 ]; then
    tput setaf 1; echo 'ERROR: Argument $2 (LOCATION) not received'; tput sgr0
    exit 1;
  fi

  local _result=$(az group show --name $1 2>/dev/null)
  if [ "$_result"  == "" ]
    then
      OUTPUT=$(az group create --name $1 \
        --location $2 \
        -ojsonc)
      LOCK=$(az group lock create --name "OSDU-PROTECTED" \
        --resource-group $1 \
        --lock-type CanNotDelete \
        -ojsonc)
    else
      tput setaf 3;  echo "Resource Group $1 already exists."; tput sgr0
    fi
}
function CreateTfPrincipal() {
    # Required Argument $1 = PRINCIPAL_NAME
    # Required Argument $2 = VAULT_NAME
    # Required Argument $3 = true/false (Add Scope)

    if [ -z $1 ]; then
        tput setaf 1; echo 'ERROR: Argument $1 (PRINCIPAL_NAME) not received'; tput sgr0
        exit 1;
    fi

    local _result=$(az ad sp list --display-name $1 --query [].appId -otsv)
    if [ "$_result"  == "" ]
    then

      PRINCIPAL_SECRET=$(az ad sp create-for-rbac \
        --name $1 \
        --role owner \
        --scopes /subscriptions/${ARM_SUBSCRIPTION_ID} \
        --query password -otsv)

      PRINCIPAL_ID=$(az ad sp list \
        --display-name $1 \
        --query [].appId -otsv)

      PRINCIPAL_OID=$(az ad app list \
        --display-name $1 \
        --query [].objectId -otsv)

      AD_GRAPH_API_GUID="00000002-0000-0000-c000-000000000000"

      # Azure AD Graph API Access Application.ReadWrite.OwnedBy
      AD_GRAPH_API=$(az ad app permission add \
        --id $PRINCIPAL_ID \
        --api $AD_GRAPH_API_GUID \
        --api-permissions 824c81eb-e3f8-4ee6-8f6d-de7f50d565b7=Role \
        -ojsonc)

      tput setaf 2; echo "Adding Information to Vault..." ; tput sgr0
      AddKeyToVault $2 "${1}-id" $PRINCIPAL_ID
      AddKeyToVault $2 "${1}-key" $PRINCIPAL_SECRET

      tput setaf 2; echo "Adding Access Policy..." ; tput sgr0
      ACCESS_POLICY=$(az keyvault set-policy --name $AZURE_VAULT \
        --object-id $(az ad sp list --display-name $1 --query [].objectId -otsv) \
        --secret-permissions list get \
        -ojson 2>/dev/null)

    else
        tput setaf 3;  echo "Service Principal $1 already exists."; tput sgr0
    fi
}
function CreatePrincipal() {
    # Required Argument $1 = PRINCIPAL_NAME
    # Required Argument $2 = VAULT_NAME
    # Required Argument $3 = true/false (Add Scope)

    if [ -z $1 ]; then
        tput setaf 1; echo 'ERROR: Argument $1 (PRINCIPAL_NAME) not received'; tput sgr0
        exit 1;
    fi

    local _result=$(az ad sp list --display-name $1 --query [].appId -otsv)
    if [ "$_result"  == "" ]
    then

      PRINCIPAL_SECRET=$(az ad sp create-for-rbac \
        --name $1 \
        --skip-assignment \
        --role owner \
        --scopes subscription/${ARM_SUBSCRIPTION_ID} \
        --query password -otsv)

      PRINCIPAL_ID=$(az ad sp list \
        --display-name $1 \
        --query [].appId -otsv)

      PRINCIPAL_OID=$(az ad sp list \
        --display-name $1 \
        --query [].objectId -otsv)

      MS_GRAPH_API_GUID="00000003-0000-0000-c000-000000000000"

      # MS Graph API Directory.Read.All
      PERMISSION_1=$(az ad app permission add \
        --id $PRINCIPAL_ID \
        --api $MS_GRAPH_API_GUID \
        --api-permissions 7ab1d382-f21e-4acd-a863-ba3e13f7da61=Role \
        -ojsonc)

      tput setaf 2; echo "Adding Information to Vault..." ; tput sgr0
      AddKeyToVault $2 "${1}-id" $PRINCIPAL_ID
      AddKeyToVault $2 "${1}-key" $PRINCIPAL_SECRET
      AddKeyToVault $2 "${1}-oid" $PRINCIPAL_OID

    else
        tput setaf 3;  echo "Service Principal $1 already exists."; tput sgr0
    fi
}
function CreateADApplication() {
    # Required Argument $1 = APPLICATION_NAME
    # Required Argument $2 = VAULT_NAME

    if [ -z $1 ]; then
        tput setaf 1; echo 'ERROR: Argument $1 (APPLICATION_NAME) not received'; tput sgr0
        exit 1;
    fi

    local _result=$(az ad sp list --display-name $1 --query [].appId -otsv)
    if [ "$_result"  == "" ]
    then

      APP_SECRET=$(az ad sp create-for-rbac \
        --name $1 \
        --skip-assignment \
        --query password -otsv)

      APP_ID=$(az ad sp list \
        --display-name $1 \
        --query [].appId -otsv)

      APP_OID=$(az ad sp list \
        --display-name $1 \
        --query [].objectId -otsv)

      tput setaf 2; echo "Adding AD Application to Vault..." ; tput sgr0
      AddKeyToVault $2 "${1}-clientid" $APP_ID
      AddKeyToVault $2 "${1}-secret" $APP_SECRET
      AddKeyToVault $2 "${1}-oid" $APP_OID

    else
        tput setaf 3;  echo "AD Application $1 already exists."; tput sgr0
    fi
}
function CreateSSHKeysPassphrase() {
  # Required Argument $1 = SSH_USER
  # Required Argument $2 = KEY_NAME

  if [ -z $1 ]; then
    tput setaf 1; echo 'ERROR: Argument $1 (SSH_USER) not received'; tput sgr0
    exit 1;
  fi

  if [ -z $2 ]; then
    tput setaf 1; echo 'ERROR: Argument $2 (KEY_NAME) not received'; tput sgr0
    exit 1;
  fi

  if [ ! -d ~/.ssh ]
  then
    mkdir ~/.ssh
  fi

  if [ ! -d ~/.ssh/osdu_${UNIQUE} ]
  then
    mkdir  ~/.ssh/osdu_${UNIQUE}
  fi

  if [ -f ~/.ssh/osdu_${UNIQUE}/$2.passphrase ]; then
    tput setaf 3;  echo "SSH Keys already exist."; tput sgr0
    PASSPHRASE=`cat ~/.ssh/osdu_${UNIQUE}/${2}.passphrase`
  else
    BASE_DIR=$(pwd)
    cd ~/.ssh/osdu_${UNIQUE}

    PASSPHRASE=$(echo $((RANDOM%20000000000000000000+100000000000000000000)))
    echo "$PASSPHRASE" >> "$2.passphrase"
    ssh-keygen -t rsa -b 2048 -C $1 -f $2 -N $PASSPHRASE
    cd $BASE_DIR
  fi

  AddKeyToVault $AZURE_VAULT "${2}" "~/.ssh/osdu_${UNIQUE}/${2}" "file"
  AddKeyToVault $AZURE_VAULT "${2}-pub" "~/.ssh/osdu_${UNIQUE}/${2}.pub" "file"
  AddKeyToVault $AZURE_VAULT "${2}-passphrase" $PASSPHRASE
}
function CreateSSHKeys() {
  # Required Argument $1 = SSH_USER
  # Required Argument $2 = KEY_NAME

  if [ -z $1 ]; then
    tput setaf 1; echo 'ERROR: Argument $1 (SSH_USER) not received'; tput sgr0
    exit 1;
  fi

  if [ -z $2 ]; then
    tput setaf 1; echo 'ERROR: Argument $2 (KEY_NAME) not received'; tput sgr0
    exit 1;
  fi

  if [ ! -d ~/.ssh ]
  then
    mkdir ~/.ssh
  fi

  if [ ! -d ~/.ssh/osdu_${UNIQUE} ]
  then
    mkdir  ~/.ssh/osdu_${UNIQUE}
  fi

  if [ -f ~/.ssh/osdu_${UNIQUE}/$2.pub ]; then
    tput setaf 3;  echo "SSH Keys already exist."; tput sgr0
  else
    BASE_DIR=$(pwd)
    cd ~/.ssh/osdu_${UNIQUE}

    ssh-keygen -t rsa -b 2048 -C $1 -f $2 -N ""
    cd $BASE_DIR
  fi

  AddKeyToVault $AZURE_VAULT "${2}" "~/.ssh/osdu_${UNIQUE}/${2}" "file"
  AddKeyToVault $AZURE_VAULT "${2}-pub" "~/.ssh/osdu_${UNIQUE}/${2}.pub" "file"
}

function CreateKeyVault() {
  # Required Argument $1 = KV_NAME
  # Required Argument $2 = RESOURCE_GROUP
  # Required Argument $3 = LOCATION

  if [ -z $1 ]; then
    tput setaf 1; echo 'ERROR: Argument $1 (KV_NAME) not received' ; tput sgr0
    exit 1;
  fi
  if [ -z $2 ]; then
    tput setaf 1; echo 'ERROR: Argument $2 (RESOURCE_GROUP) not received' ; tput sgr0
    exit 1;
  fi
  if [ -z $3 ]; then
    tput setaf 1; echo 'ERROR: Argument $3 (LOCATION) not received' ; tput sgr0
    exit 1;
  fi

  local _vault=$(az keyvault list --resource-group $2 --query [].name -otsv 2>/dev/null)
  if [ "$_vault"  == "" ]
    then
      OUTPUT=$(az keyvault create --name $1 --resource-group $2 --location $3 --query [].name -otsv)
    else
      tput setaf 3;  echo "Key Vault $1 already exists."; tput sgr0
    fi
}
function CreateStorageAccount() {
  # Required Argument $1 = STORAGE_ACCOUNT
  # Required Argument $2 = RESOURCE_GROUP
  # Required Argument $3 = LOCATION

  if [ -z $1 ]; then
    tput setaf 1; echo 'ERROR: Argument $1 (STORAGE_ACCOUNT) not received' ; tput sgr0
    exit 1;
  fi
  if [ -z $2 ]; then
    tput setaf 1; echo 'ERROR: Argument $2 (RESOURCE_GROUP) not received' ; tput sgr0
    exit 1;
  fi
  if [ -z $3 ]; then
    tput setaf 1; echo 'ERROR: Argument $3 (LOCATION) not received' ; tput sgr0
    exit 1;
  fi

  local _storage=$(az storage account show --name $1 --resource-group $2 --query name -otsv 2>/dev/null)
  if [ "$_storage"  == "" ]
      then
      OUTPUT=$(az storage account create \
        --name $1 \
        --resource-group $2 \
        --location $3 \
        --sku Standard_LRS \
        --kind StorageV2 \
        --encryption-services blob \
        --query name -otsv)
      else
        tput setaf 3;  echo "Storage Account $1 already exists."; tput sgr0
      fi
}
function GetStorageAccountKey() {
  # Required Argument $1 = STORAGE_ACCOUNT
  # Required Argument $2 = RESOURCE_GROUP

  if [ -z $1 ]; then
    tput setaf 1; echo 'ERROR: Argument $1 (STORAGE_ACCOUNT) not received'; tput sgr0
    exit 1;
  fi
  if [ -z $2 ]; then
    tput setaf 1; echo 'ERROR: Argument $2 (RESOURCE_GROUP) not received'; tput sgr0
    exit 1;
  fi

  local _result=$(az storage account keys list \
    --account-name $1 \
    --resource-group $2 \
    --query '[0].value' \
    --output tsv)
  echo ${_result}
}
function CreateBlobContainer() {
  # Required Argument $1 = CONTAINER_NAME
  # Required Argument $2 = STORAGE_ACCOUNT
  # Required Argument $3 = STORAGE_KEY

  if [ -z $1 ]; then
    tput setaf 1; echo 'ERROR: Argument $1 (CONTAINER_NAME) not received' ; tput sgr0
    exit 1;
  fi

  if [ -z $2 ]; then
    tput setaf 1; echo 'ERROR: Argument $2 (STORAGE_ACCOUNT) not received' ; tput sgr0
    exit 1;
  fi

  if [ -z $3 ]; then
    tput setaf 1; echo 'ERROR: Argument $3 (STORAGE_KEY) not received' ; tput sgr0
    exit 1;
  fi

  local _container=$(az storage container show --name $1 --account-name $2 --account-key $3 --query name -otsv 2>/dev/null)
  if [ "$_container"  == "" ]
      then
        OUTPUT=$(az storage container create \
              --name $1 \
              --account-name $2 \
              --account-key $3 -otsv)
        if [ $OUTPUT == True ]; then
          tput setaf 3;  echo "Storage Container $1 created."; tput sgr0
        else
          tput setaf 1;  echo "Storage Container $1 not created."; tput sgr0
        fi
      else
        tput setaf 3;  echo "Storage Container $1 already exists."; tput sgr0
      fi
}
function AddKeyToVault() {
  # Required Argument $1 = KEY_VAULT
  # Required Argument $2 = SECRET_NAME
  # Required Argument $3 = SECRET_VALUE
  # Optional Argument $4 = isFile (bool)

  if [ -z $1 ]; then
    tput setaf 1; echo 'ERROR: Argument $1 (KEY_VAULT) not received' ; tput sgr0
    exit 1;
  fi

  if [ -z $2 ]; then
    tput setaf 1; echo 'ERROR: Argument $2 (SECRET_NAME) not received' ; tput sgr0
    exit 1;
  fi

  if [ -z $3 ]; then
    tput setaf 1; echo 'ERROR: Argument $3 (SECRET_VALUE) not received' ; tput sgr0
    exit 1;
  fi

  if [ "$4" == "file" ]; then
    local _secret=$(az keyvault secret set --vault-name $1 --name $2 --file $3)
  else
    local _secret=$(az keyvault secret set --vault-name $1 --name $2 --value $3)
  fi
}

function CreateADUser() {
  # Required Argument $1 = FIRST_NAME
  # Required Argument $2 = LAST_NAME


  if [ -z $1 ]; then
    tput setaf 1; echo 'ERROR: Argument $1 (FIRST_NAME) not received' ; tput sgr0
    exit 1;
  fi

  if [ -z $2 ]; then
    tput setaf 1; echo 'ERROR: Argument $2 (LAST_NAME) not received' ; tput sgr0
    exit 1;
  fi

  local _result=$(az ad user list --display-name $1 --query [].objectId -otsv)
    if [ "$_result"  == "" ]
    then
      USER_PASSWORD=$(echo $((RANDOM%200000000000000+1000000000000000))TESTER\!)
      TENANT_NAME=$(az ad signed-in-user show -otsv --query 'userPrincipalName' | cut -d '@' -f 2 | sed 's/\"//')
      EMAIL="${1}.${2}@${TENANT_NAME}"

      OBJECT_ID=$(az ad user create \
        --display-name "${1} ${2}" \
        --password $USER_PASSWORD \
        --user-principal-name $EMAIL \
        --query objectId
      )

      AddKeyToVault $AZURE_VAULT "ad-user-email" $EMAIL
      AddKeyToVault $AZURE_VAULT "ad-user-oid" $OBJECT_ID
    else
        tput setaf 3;  echo "User $1 already exists."; tput sgr0
    fi
}


###############################
## EXECUTION                 ##
###############################
printf "\n"
tput setaf 2; echo "Creating OSDU Common Resources" ; tput sgr0
tput setaf 3; echo "------------------------------------" ; tput sgr0

tput setaf 2; echo 'Logging in and setting subscription...' ; tput sgr0
az account set --subscription ${ARM_SUBSCRIPTION_ID}

tput setaf 2; echo 'Creating the Common Resource Group...' ; tput sgr0
CreateResourceGroup $AZURE_GROUP $AZURE_LOCATION

tput setaf 2; echo "Creating a Common Key Vault..." ; tput sgr0
CreateKeyVault $AZURE_VAULT $AZURE_GROUP $AZURE_LOCATION

tput setaf 2; echo "Creating a Common Storage Account..." ; tput sgr0
CreateStorageAccount $AZURE_STORAGE $AZURE_GROUP $AZURE_LOCATION

tput setaf 2; echo "Retrieving the Storage Account Key..." ; tput sgr0
STORAGE_KEY=$(GetStorageAccountKey $AZURE_STORAGE $AZURE_GROUP)

tput setaf 2; echo "Creating a Storage Account Container..." ; tput sgr0
CreateBlobContainer $REMOTE_STATE_CONTAINER $AZURE_STORAGE $STORAGE_KEY

tput setaf 2; echo "Adding Storage Account Secrets to Vault..." ; tput sgr0
AddKeyToVault $AZURE_VAULT "${AZURE_STORAGE}-storage" $AZURE_STORAGE
AddKeyToVault $AZURE_VAULT "${AZURE_STORAGE}-storage-key" $STORAGE_KEY

tput setaf 2; echo 'Creating required Service Principals...' ; tput sgr0
CreateTfPrincipal "${ADO_PROJECT}-${UNIQUE}-terraform" $AZURE_VAULT
CreatePrincipal "${ADO_PROJECT}-${UNIQUE}-principal" $AZURE_VAULT

tput setaf 2; echo 'Creating required AD Application...' ; tput sgr0
CreateADApplication "${ADO_PROJECT}-${UNIQUE}-application" $AZURE_VAULT
CreateADApplication "${ADO_PROJECT}-${UNIQUE}-noaccess" $AZURE_VAULT

tput setaf 2; echo 'Creating SSH Keys...' ; tput sgr0
CreateSSHKeys $AZURE_AKS_USER "azure-aks-gitops-ssh-key"
CreateSSHKeysPassphrase $AZURE_AKS_USER "azure-aks-node-ssh-key"

tput setaf 2; echo "# OSDU ENVIRONMENT ${UNIQUE}" ; tput sgr0
tput setaf 3; echo "------------------------------------" ; tput sgr0

cat > .envrc << EOF

# OSDU ENVIRONMENT ${UNIQUE}
# ------------------------------------------------------------------------------------------------------
export RANDOM_NUMBER=${RANDOM_NUMBER}
export UNIQUE=${UNIQUE}
export COMMON_VAULT="${AZURE_VAULT}"
export ARM_TENANT_ID="$(az account show -ojson --query tenantId -otsv)"
export ARM_SUBSCRIPTION_ID="${ARM_SUBSCRIPTION_ID}"
export ARM_CLIENT_ID="$(az keyvault secret show --id https://$AZURE_VAULT.vault.azure.net/secrets/${ADO_PROJECT}-${UNIQUE}-terraform-id --query value -otsv)"
export ARM_CLIENT_SECRET="$(az keyvault secret show --id https://$AZURE_VAULT.vault.azure.net/secrets/${ADO_PROJECT}-${UNIQUE}-terraform-key --query value -otsv)"
export ARM_ACCESS_KEY="$(az keyvault secret show --id https://$AZURE_VAULT.vault.azure.net/secrets/osducommon${RANDOM_NUMBER}-storage-key --query value -otsv)"

export TF_VAR_remote_state_account="$(az keyvault secret show --id https://$AZURE_VAULT.vault.azure.net/secrets/osducommon${RANDOM_NUMBER}-storage --query value -otsv)"
export TF_VAR_remote_state_container="remote-state-container"

export TF_VAR_resource_group_location="${AZURE_LOCATION}"
export TF_VAR_cosmosdb_replica_location="${AZURE_PAIR_LOCATION}"

export TF_VAR_central_resources_workspace_name="cr-${UNIQUE}"
export TF_VAR_service_resources_workspace_name="sr-${UNIQUE}"
export TF_VAR_data_partition_resources_workspace_name="dp1-${UNIQUE}"

export TF_VAR_principal_appId="$(az keyvault secret show --id https://$AZURE_VAULT.vault.azure.net/secrets/${ADO_PROJECT}-${UNIQUE}-principal-id --query value -otsv)"
export TF_VAR_principal_name="${ADO_PROJECT}-${UNIQUE}-principal"
export TF_VAR_principal_password="$(az keyvault secret show --id https://$AZURE_VAULT.vault.azure.net/secrets/${ADO_PROJECT}-${UNIQUE}-principal-key --query value -otsv)"
export TF_VAR_principal_objectId="$(az keyvault secret show --id https://$AZURE_VAULT.vault.azure.net/secrets/${ADO_PROJECT}-${UNIQUE}-principal-oid --query value -otsv)"

export TF_VAR_application_clientid="$(az keyvault secret show --id https://$AZURE_VAULT.vault.azure.net/secrets/${ADO_PROJECT}-${UNIQUE}-application-clientid --query value -otsv)"
export TF_VAR_application_secret="$(az keyvault secret show --id https://$AZURE_VAULT.vault.azure.net/secrets/${ADO_PROJECT}-${UNIQUE}-application-secret --query value -otsv)"

export TF_VAR_ssh_public_key_file=~/.ssh/osdu_${UNIQUE}/azure-aks-node-ssh-key.pub
export TF_VAR_gitops_ssh_key_file=~/.ssh/osdu_${UNIQUE}/azure-aks-gitops-ssh-key
export TF_VAR_gitops_ssh_url="${GIT_REPO}"
export TF_VAR_gitops_branch="${UNIQUE}"

EOF

cp .envrc .envrc_${UNIQUE}
