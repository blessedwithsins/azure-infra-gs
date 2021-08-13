#!/usr/bin/env bash

read -p "ARM_TENANT_ID: " tenantId
read -p "ARM_CLIENT_SECRET: " servicePrincipalKey
read -p "ARM_CLIENT_ID: " servicePrincipalId
read -p "ARM_SUBSCRIPTION_ID: " ARM_SUBSCRIPTION_ID
read -p "Remote State Account(Service Resource): " TF_VAR_remote_state_account
read -p "Remote State Container(Service Resource): " TF_VAR_remote_state_container
read -p "Azure Resource Group with AKS Cluster(Service Resource): " myResourceGroup
read -p "AKS Cluster(Service Resource): " myAKSCluster
read -p "ARM Access Key: " storageAccountArmAccessKey
read -p "Terraform workspace for central resources: " centralResourceTerraformWorkspace
read -p "Gitops Branch: " gitopsBranch
read -p "Gitops ssh url: " gitopsSshUrl
read -p "Gitops path: " gitopsPath
read -p "Gitops ssh public key file: " sshPublicKeyFile
read -p "Gitops ssh key file: " gitopsSshKeyFile
read -p "Terraform workspace name: " tfWorkspaceName
read -p "Resource Group Location: " resourceGroupLocation
read -p "Git Repo link with feature flag for keda v2 present.(Script assumes that repo name is infra-azure-provisioning. You can edit it if its something else): " gitRepo
read -p "Repo branch name with feature flag for keda v2 present. This branch should be in sync with your current infra setup: " repoBranch

read -p "Automated Pipeline deployment (only yes is accepted as true. Any other input will be treated as manual deployment): " automatedDeployment

read -p "Application namespace (Leave empty for default value - osdu. You'll need to edit this script if applications are running in different namespaces): " namespace

export TF_VERSION="0.14.4"
export TF_VAR_gitops_ssh_url="$gitopsSshUrl"
export TF_VAR_gitops_path="$gitopsPath"
export TF_VAR_gitops_branch="$gitopsBranch"
export TF_VAR_ssh_public_key_file="$sshPublicKeyFile"
export TF_VAR_gitops_ssh_key_file="$gitopsSshKeyFile"
export TF_WORKSPACE="$tfWorkspaceName"
export TF_VAR_remote_state_account="$TF_VAR_remote_state_account"
export TF_VAR_remote_state_container="$TF_VAR_remote_state_container"
export TF_VAR_resource_group_location="$resourceGroupLocation"

function enableFlux {
  echo "Enabling flux"
  kubectl patch deployment flux -p '{"spec":{"replicas": 1}}' -n flux
}

function disableFlux {
  echo "Disabling flux"
  kubectl patch deployment flux -p '{"spec":{"replicas": 0}}' -n flux
}

trap enableFlux EXIT

echo "Script Started"
if [ ! "$namespace" ]; then
  echo "Assigning default namespace: osdu"
  namespace=osdu
fi

echo "Namespace: $namespace"

function terraformVersionCheck() {
  if [[ $(which terraform) && $(terraform --version | head -n1 | cut -d" " -f2 | cut -c 2\-) == $TF_VERSION ]]; then
    echo "Terraform version check completed"
  else
    TF_ZIP_TARGET="https://releases.hashicorp.com/terraform/$TF_VERSION/terraform_${TF_VERSION}_linux_amd64.zip"
    echo "Info: installing $TF_VERSION, target: $TF_ZIP_TARGET"

    wget $TF_ZIP_TARGET -q
    unzip -q "terraform_${TF_VERSION}_linux_amd64.zip"
    sudo mv terraform /usr/local/bin
    rm *.zip
  fi

  terraform -version
  # Assert that jq is available, and install if it's not
  command -v jq >/dev/null 2>&1 || {
    echo >&2 "Installing jq"
    sudo apt install -y jq
  }
}
#terraformVersionCheck

#echo "Terraform verion check complete"

echo "Logging in to az cli"
az login --service-principal -u "$servicePrincipalId" --password="$servicePrincipalKey" --tenant "$tenantId"

echo "Login successful"

az aks get-credentials --resource-group="$myResourceGroup" --name="$myAKSCluster"

#echo "Credential fetch successful"

az account set --subscription "$ARM_SUBSCRIPTION_ID"

echo "Subscription set to $ARM_SUBSCRIPTION_ID"

export ARM_TENANT_ID=$tenantId
export ARM_CLIENT_SECRET=$servicePrincipalKey
export ARM_CLIENT_ID=$servicePrincipalId
export ARM_SUBSCRIPTION_ID="$ARM_SUBSCRIPTION_ID"
export TF_VAR_central_resources_workspace_name="$centralResourceTerraformWorkspace"

export ARM_ACCESS_KEY="$storageAccountArmAccessKey"

disableFlux

echo "Deleting existing scaled objects"
NEXT_WAIT_TIME=0
until [ $NEXT_WAIT_TIME -eq 5 ] || timeout 3 kubectl delete scaledobjects.keda.k8s.io --all; do
    sleep $(( NEXT_WAIT_TIME++ ))
done
[ "$NEXT_WAIT_TIME" -lt 5 ]


echo "Deleting existing trigger authentications"
NEXT_WAIT_TIME=0
until [ $NEXT_WAIT_TIME -eq 5 ] || timeout 3 kubectl delete triggerauthentications.keda.k8s.io --all; do
    sleep $(( NEXT_WAIT_TIME++ ))
done
[ "$NEXT_WAIT_TIME" -lt 5 ]

#set -euo pipefail

echo "Uninstalling Keda v1"
helm uninstall -n keda keda

echo "Deleting Keda v1 CRDs"

NEXT_WAIT_TIME=0
until [ $NEXT_WAIT_TIME -eq 5 ] || timeout 3 kubectl delete crd scaledobjects.keda.k8s.io --ignore-not-found=true; do
    kubectl patch crd/scaledobjects.keda.k8s.io -p '{"metadata":{"finalizers":[]}}' --type=merge
    sleep $(( NEXT_WAIT_TIME++ ))
done
[ "$NEXT_WAIT_TIME" -lt 5 ]

NEXT_WAIT_TIME=0
until [ $NEXT_WAIT_TIME -eq 5 ] || timeout 3 kubectl delete crd triggerauthentications.keda.k8s.io --ignore-not-found=true; do
    kubectl patch crd/triggerauthentications.keda.k8s.io -p '{"metadata":{"finalizers":[]}}' --type=merge
    sleep $(( NEXT_WAIT_TIME++ ))
done
[ "$NEXT_WAIT_TIME" -lt 5 ]

set -euo pipefail

echo "terraform applying with keda version updated to 2.2.0"

git clone --branch $repoBranch $gitRepo

# Assuming repo name is infra-azure-provisioning. If its not, edit the repo name in below command and cd into service_resources.
cd infra-azure-provisioning/infra/templates/osdu-r3-mvp/service_resources
echo "keda_v2_enabled = true" >> override.tfvars
terraform init -upgrade -backend-config "storage_account_name=$TF_VAR_remote_state_account" -backend-config "container_name=$TF_VAR_remote_state_container"

terraform state rm helm_release.keda

echo "Terraform applying"
terraform apply -var-file override.tfvars