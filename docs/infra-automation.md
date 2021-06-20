# Deploy Infrastructure

__Configure Azure DevOps Service Connection__

- Configure an [ARM Resources Service Connection](https://docs.microsoft.com/en-us/azure/devops/pipelines/library/connect-to-azure?view=azure-devops) for the desired subscription.
  - Scope should be to the desired Subscription but do not apply scope to a Resource Group

```bash
SERVICE_CONNECTION_NAME=osdu-mvp-$UNIQUE
export AZURE_DEVOPS_EXT_AZURE_RM_SERVICE_PRINCIPAL_KEY=$ARM_CLIENT_SECRET

az devops service-endpoint azurerm create \
  --name $SERVICE_CONNECTION_NAME \
  --azure-rm-tenant-id $ARM_TENANT_ID \
  --azure-rm-subscription-id $ARM_SUBSCRIPTION_ID \
  --azure-rm-subscription-name $(az account show --subscription $ARM_SUBSCRIPTION_ID --query name -otsv) \
  --azure-rm-service-principal-id $ARM_CLIENT_ID \
  -ojsonc
```


__Setup and Configure the ADO Library `Infrastructure Pipeline Variables`__

This variable group will be used to hold the common values for infrastructure to be built regardless of a specified environment.

  | Variable | Value |
  |----------|-------|
  | AGENT_POOL | Hosted Ubuntu 1604 |
  | BUILD_ARTIFACT_NAME | infra-templates |
  | SERVICE_CONNECTION_NAME | <your_service_connection_name> |
  | TF_VAR_elasticsearch_secrets_keyvault_name | osducommon<your_unique>-kv |
  | TF_VAR_elasticsearch_secrets_keyvault_resource_group | osdu-common-<your_unique> |
  | TF_VAR_remote_state_account | osducommon<your_unique> |
  | TF_VAR_remote_state_container | remote-state-container |

```bash
az pipelines variable-group create \
  --name "Infrastructure Pipeline Variables" \
  --authorize true \
  --variables \
  AGENT_POOL="Hosted Ubuntu 1604" \
  BUILD_ARTIFACT_NAME="infra-templates" \
  TF_VAR_elasticsearch_secrets_keyvault_name=$COMMON_VAULT  \
  TF_VAR_elasticsearch_secrets_keyvault_resource_group=osdu-common-${UNIQUE} \
  TF_VAR_remote_state_account=$TF_VAR_remote_state_account \
  TF_VAR_remote_state_container="remote-state-container" \
  SERVICE_CONNECTION_NAME=$SERVICE_CONNECTION_NAME \
  -ojson
```


__Setup and Configure the ADO Library `Infrastructure Pipeline Variables - demo`__

This variable group will be used to hold the common values for a specific infrastructure environment to be built. There is an implied naming convention to this Variable group `demo` relates to the environment name.  Additionally you can specify and override the region locations here.


  | Variable | Value |
  |----------|-------|
  | ARM_SUBSCRIPTION_ID | <your_subscription_id> |
  | TF_VAR_aks_agent_vm_count | 3 |
  | TF_VAR_central_resources_workspace_name | cr-demo |
  | TF_VAR_service_resources_workspace_name | sr-demo |
  | TF_VAR_data_partition_resources_workspace_name | dp1-demo |
  | TF_VAR_cosmosdb_replica_location | eastus2 |
  | TF_VAR_data_partition_name | opendes |
  | TF_VAR_data_resources_workspace_name | dr-demo |
  | TF_VAR_elasticsearch_version | <your_elastic_version> |
  | TF_VAR_gitops_branch | <desired_branch> |
  | TF_VAR_gitops_path | providers/azure/hld-registry |
  | TF_VAR_gitops_ssh_url | git@<your_flux_repo> |
  | TF_VAR_principal_appId | <your_principal_appId> |
  | TF_VAR_principal_name | <your_principal_name> |
  | TF_VAR_principal_objectId | <your_principal_objectId> |
  | TF_VAR_principal_password | <your_principal_password> |
  | TF_VAR_resource_group_location | centralus |

```bash
ENVIRONMENT="demo"
REGION="centralus"
REGION_PAIR="eastus2"
PARTITION_NAME="opendes"
ELASTIC_VERSION="7.11.1"
GIT_REPO=git@ssh.dev.azure.com:v3/${ADO_ORGANIZATION}/${ADO_PROJECT}/k8-gitops-manifests

az pipelines variable-group create \
  --name "Infrastructure Pipeline Variables - ${ENVIRONMENT}" \
  --authorize true \
  --variables \
  ARM_SUBSCRIPTION_ID="${ARM_SUBSCRIPTION_ID}" \
  TF_VAR_aks_agent_vm_count=3 \
  TF_VAR_central_resources_workspace_name="cr-${ENVIRONMENT}" \
  TF_VAR_service_resources_workspace_name="sr-${ENVIRONMENT}" \
  TF_VAR_data_partition_resources_workspace_name="dp1-${ENVIRONMENT}" \
  TF_VAR_cosmosdb_replica_location="${REGION_PAIR}" \
  TF_VAR_data_partition_name="${PARTITION_NAME}" \
  TF_VAR_data_resources_workspace_name="dr-${ENVIRONMENT}" \
  TF_VAR_elasticsearch_version="${ELASTIC_VERSION}" \
  TF_VAR_gitops_branch="${UNIQUE}" \
  TF_VAR_gitops_path="providers/azure/hld-registry" \
  TF_VAR_gitops_ssh_url="${GIT_REPO}" \
  TF_VAR_principal_appId="${TF_VAR_principal_appId}" \
  TF_VAR_principal_name="${TF_VAR_principal_name}" \
  TF_VAR_principal_objectId="${TF_VAR_principal_objectId}" \
  TF_VAR_principal_password="${TF_VAR_principal_password}" \
  TF_VAR_resource_group_location="${REGION}" \
  -ojson
```

__Setup and Configure the ADO Library `Infrastructure Pipeline Secrets - demo`__
> This should be linked Secrets from Azure Key Vault `osducommon<random>`

  | Variable | Value |
  |----------|-------|
  | elastic-endpoint-dp1-demo | `*********` |
  | elastic-username-dp1-demo | `*********` |
  | elastic-password-dp1-demo | `*********` |


__Setup 2 Secure Files__

[Upload the 2 Secure files](https://docs.microsoft.com/en-us/azure/devops/pipelines/library/secure-files?view=azure-devops).


  - ~/.ssh/osdu_$UNIQUE/azure-aks-gitops-ssh-key
  - ~/.ssh/osdu_$UNIQUE/azure-aks-node-ssh-key.pub



__Execute the pipelines in `osdu-infrastructure`__

> These pipelines need to be executed to completion in the specific order.

1. `infrastructure-central-resources`

  > For the first run of the pipeline approvals will need to be made for the 2 secure files and the Service Connection.

```bash
# Create and Deploy the Pipeline
az pipelines create \
  --name 'infrastructure-central-resources'  \
  --repository infra-azure-provisioning  \
  --branch master  \
  --repository-type tfsgit  \
  --yaml-path /devops/pipelines/infrastructure-central-resources.yml  \
  -ojson
```


2. `infrastructure-data-partition`

  > For the first run of the pipeline approvals will need to be made for the 2 secure files and the Service Connection.

```bash
# Create and Deploy the Pipeline
az pipelines create \
  --name 'infrastructure-data-partition'  \
  --repository infra-azure-provisioning  \
  --branch master  \
  --repository-type tfsgit  \
  --yaml-path /devops/pipelines/infrastructure-data-partition.yml  \
  -ojson
```


3. `azure-pipeline-service.yml`

  > For the first run of the pipeline approvals will need to be made for the 2 secure files and the Service Connection.

```bash
# Create and Deploy the Pipeline
az pipelines create \
  --name 'infrastructure-service-resources'  \
  --repository infra-azure-provisioning  \
  --branch master  \
  --repository-type tfsgit  \
  --yaml-path /devops/pipelines/infrastructure-service-resources.yml  \
  -ojson
```
