# Setup Mirroring for Gitlab Repositories

__Create Empty Repositories__

Empty repositories need to be created that will be used by a pipeline to mirror gitlab repositories into.

| Repository Name           | Gitlab Location
|---------------------------|---------------------------|
| infra-azure-provisioning  | https://community.opengroup.org/osdu/platform/deployment-and-operations/infra-azure-provisioning.git |
| partition                 | https://community.opengroup.org/osdu/platform/system/partition.git |
| entitlements-azure        | https://community.opengroup.org/osdu/platform/security-and-compliance/entitlements-azure.git |
| legal                     | https://community.opengroup.org/osdu/platform/security-and-compliance/legal.git |
| indexer-queue             | https://community.opengroup.org/osdu/platform/system/indexer-queue.git |
| storage                   | https://community.opengroup.org/osdu/platform/system/storage.git |
| indexer-service           | https://community.opengroup.org/osdu/platform/system/indexer-service.git |
| search-service            | https://community.opengroup.org/osdu/platform/system/search-service.git |
| delivery                  | https://community.opengroup.org/osdu/platform/system/delivery.git       |
| file                      | https://community.opengroup.org/osdu/platform/system/file.git      |
| unit-service              | https://community.opengroup.org/osdu/platform/system/reference/unit-service.git |
| crs-catalog-service       | https://community.opengroup.org/osdu/platform/system/reference/crs-catalog-service.git |
| crs-conversion-service    | https://community.opengroup.org/osdu/platform/system/reference/crs-conversion-service.git |
| wks                       | https://community.opengroup.org/osdu/platform/data-flow/enrichment/wks.git |
| register                  | https://community.opengroup.org/osdu/platform/system/register.git |
| notification              | https://community.opengroup.org/osdu/platform/system/notification.git|
| schema-service            | https://community.opengroup.org/osdu/platform/system/schema-service.git|
| ingestion-workflow        | https://community.opengroup.org/osdu/platform/data-flow/ingestion/ingestion-workflow.git |

```bash
export ADO_ORGANIZATION=<organization_name>
export ADO_PROJECT=osdu-mvp

az devops configure --defaults organization=https://dev.azure.com/$ADO_ORGANIZATION project=$ADO_PROJECT

# Create required ADO Repositories
SERVICE_LIST="infra-azure-provisioning \
              partition \
              entitlements-azure \
              legal \
              storage \
              indexer-queue \
              indexer-service \
              search-service \
              delivery \
              file \
              unit-service \
              crs-catalog-service \
              crs-conversion-service \
              wks \
              register \
              notification \
              schema-service \
              ingestion-workflow"

for SERVICE in $SERVICE_LIST;
do
  az repos create --name $SERVICE --organization https://dev.azure.com/${ADO_ORGANIZATION} --project $ADO_PROJECT -ojson
done
```


__Create Variable Group__

This variable group will be used to hold the values of the GitLab Location to be mirrored.  Additionally a Personal Access Token is necessary to allow for git checkin.

Variable Group Name:  `Mirror Variables`

| Variable | Value |
|----------|-------|
| OSDU_INFRASTRUCTURE | https://dev.azure.com/osdu-demo/osdu/_git/osdu-infrastructure |
| INFRA_PROVISIONING_REPO | https://dev.azure.com/osdu-demo/osdu/_git/infra-azure-provisioning |
| PARTITION_REPO | https://dev.azure.com/osdu-demo/osdu/_git/partition |
| ENTITLEMENTS_REPO | https://dev.azure.com/osdu-demo/osdu/_git/entitlements-azure |
| LEGAL_REPO | https://dev.azure.com/osdu-demo/osdu/_git/legal |
| STORAGE_REPO | https://dev.azure.com/osdu-demo/osdu/_git/storage |
| INDEXER_QUEUE_REPO | https://dev.azure.com/osdu-demo/osdu/_git/indexer-queue |
| INDEXER_REPO | https://dev.azure.com/osdu-demo/osdu/_git/indexer-service |
| SEARCH_REPO | https://dev.azure.com/osdu-demo/osdu/_git/search-service |
| DELIVERY_REPO | https://dev.azure.com/osdu-demo/osdu/_git/delivery |
| FILE_REPO | https://dev.azure.com/osdu-demo/osdu/_git/file |
| UNIT_REPO | https://dev.azure.com/osdu-demo/osdu/_git/unit-service |
| CRS_CATALOG_REPO | https://dev.azure.com/osdu-demo/osdu/_git/crs-catalog-service |
| CRS_CONVERSION_REPO | https://dev.azure.com/osdu-demo/osdu/_git/crs-conversion-service |
| WKS_REPO | https://dev.azure.com/osdu-demo/osdu/_git/wks |
| REGISTER_REPO | https://dev.azure.com/osdu-demo/osdu/_git/register |
| NOTIFICATION_REPO | https://dev.azure.com/osdu-demo/osdu/_git/notification |
| SCHEMA_REPO | https://dev.azure.com/osdu-demo/osdu/_git/schema-service |
| INGESTION_WORKFLOW_REPO | https://dev.azure.com/osdu-demo/osdu/_git/ingestion-workflow |
| ACCESS_TOKEN | <your_personal_access_token> |


Manually create a Personal Access Token following the [documentation](https://docs.microsoft.com/en-us/azure/devops/organizations/accounts/use-personal-access-tokens-to-authenticate?view=azure-devops&tabs=preview-page) and add a Variable called `ACCESS_TOKEN` with the value being the PAT created.


```bash
ACCESS_TOKEN=<your_access_token>

az pipelines variable-group create \
  --name "Mirror Variables" \
  --authorize true \
  --variables \
  INFRA_PROVISIONING_REPO=https://dev.azure.com/${ADO_ORGANIZATION}/$ADO_PROJECT/_git/infra-azure-provisioning \
  PARTITION_REPO=https://dev.azure.com/${ADO_ORGANIZATION}/$ADO_PROJECT/_git/partition \
  ENTITLEMENTS_REPO=https://dev.azure.com/${ADO_ORGANIZATION}/$ADO_PROJECT/_git/entitlements-azure \
  LEGAL_REPO=https://dev.azure.com/${ADO_ORGANIZATION}/$ADO_PROJECT/_git/legal \
  STORAGE_REPO=https://dev.azure.com/${ADO_ORGANIZATION}/$ADO_PROJECT/_git/storage \
  INDEXER_QUEUE_REPO=https://dev.azure.com/${ADO_ORGANIZATION}/$ADO_PROJECT/_git/indexer-queue \
  INDEXER_REPO=https://dev.azure.com/${ADO_ORGANIZATION}/$ADO_PROJECT/_git/indexer-service \
  SEARCH_REPO=https://dev.azure.com/${ADO_ORGANIZATION}/$ADO_PROJECT/_git/search-service \
  DELIVERY_REPO=https://dev.azure.com/${ADO_ORGANIZATION}/$ADO_PROJECT/_git/delivery \
  FILE_REPO=https://dev.azure.com/${ADO_ORGANIZATION}/$ADO_PROJECT/_git/file \
  UNIT_REPO=https://dev.azure.com/${ADO_ORGANIZATION}/$ADO_PROJECT/_git/unit-service \
  CRS_CATALOG_REPO=https://dev.azure.com/osdu-demo/osdu/_git/unit-service \
  CRS_CONVERSION_REPO=https://dev.azure.com/${ADO_ORGANIZATION}/$ADO_PROJECT/_git/crs-conversion-service \
  WKS_REPO=https://dev.azure.com/${ADO_ORGANIZATION}/$ADO_PROJECT/_git/wks \
  REGISTER_REPO=https://dev.azure.com/${ADO_ORGANIZATION}/$ADO_PROJECT/_git/register \
  NOTIFICATION_REPO=https://dev.azure.com/${ADO_ORGANIZATION}/$ADO_PROJECT/_git/notification \
  SCHEMA_REPO=https://dev.azure.com/${ADO_ORGANIZATION}/$ADO_PROJECT/_git/schema-service \
  INGESTION_WORKFLOW_REPO=https://dev.azure.com/${ADO_ORGANIZATION}/$ADO_PROJECT/_git/ingestion-workflow \ 
  ACCESS_TOKEN=$ACCESS_TOKEN \
  -ojson
```


__Create Mirror Pipeline__

Clone the Project Repository `osdu-mvp`, and add the pipeline.


```bash
GIT_SSH_COMMAND="ssh -i ${TF_VAR_gitops_ssh_key_file}"  \
  git clone git@ssh.dev.azure.com:v3/${ADO_ORGANIZATION}/${ADO_PROJECT}/${ADO_PROJECT}

cat > ${ADO_PROJECT}/pipeline.yml << 'EOF'
#  Copyright © Microsoft Corporation
#
#  Licensed under the Apache License, Version 2.0 (the "License");
#  you may not use this file except in compliance with the License.
#  You may obtain a copy of the License at
#
#       http://www.apache.org/licenses/LICENSE-2.0
#
#  Unless required by applicable law or agreed to in writing, software
#  distributed under the License is distributed on an "AS IS" BASIS,
#  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
#  See the License for the specific language governing permissions and
#  limitations under the License.


### UNCOMMENT IF YOU WANT A SCHEDULED PULL ####

# schedules:
#   - cron: "*/10 * * * *"
#     displayName: Hourly Pull Schedule
#     branches:
#       include:
#       - master
#     always: true

variables:
  - group: 'Mirror Variables'

jobs:
  - job: mirror_sync
    displayName: 'Pull Repositories'
    steps:

    - task: swellaby.mirror-git-repository.mirror-git-repository-vsts-task.mirror-git-repository-vsts-task@1
      displayName: 'infra-azure-provisioning'
      inputs:
        sourceGitRepositoryUri: 'https://community.opengroup.org/osdu/platform/deployment-and-operations/infra-azure-provisioning.git'
        destinationGitRepositoryUri: '$(INFRA_PROVISIONING_REPO)'
        destinationGitRepositoryPersonalAccessToken: $(ACCESS_TOKEN)

    - task: swellaby.mirror-git-repository.mirror-git-repository-vsts-task.mirror-git-repository-vsts-task@1
      displayName: 'partition'
      inputs:
        sourceGitRepositoryUri: 'https://community.opengroup.org/osdu/platform/system/partition.git'
        destinationGitRepositoryUri: '$(PARTITION_REPO)'
        destinationGitRepositoryPersonalAccessToken: $(ACCESS_TOKEN)

    - task: swellaby.mirror-git-repository.mirror-git-repository-vsts-task.mirror-git-repository-vsts-task@1
      displayName: 'entitlements-azure'
      inputs:
        sourceGitRepositoryUri: 'https://community.opengroup.org/osdu/platform/security-and-compliance/entitlements-azure.git'
        destinationGitRepositoryUri: '$(ENTITLEMENTS_REPO)'
        destinationGitRepositoryPersonalAccessToken: $(ACCESS_TOKEN)

    - task: swellaby.mirror-git-repository.mirror-git-repository-vsts-task.mirror-git-repository-vsts-task@1
      displayName: 'legal'
      inputs:
        sourceGitRepositoryUri: 'https://community.opengroup.org/osdu/platform/security-and-compliance/legal.git'
        destinationGitRepositoryUri: '$(LEGAL_REPO)'
        destinationGitRepositoryPersonalAccessToken: $(ACCESS_TOKEN)

    - task: swellaby.mirror-git-repository.mirror-git-repository-vsts-task.mirror-git-repository-vsts-task@1
      displayName: 'indexer-queue'
      inputs:
        sourceGitRepositoryUri: 'https://community.opengroup.org/osdu/platform/system/indexer-queue.git'
        destinationGitRepositoryUri: '$(INDEXER_QUEUE_REPO)'
        destinationGitRepositoryPersonalAccessToken: $(ACCESS_TOKEN)

    - task: swellaby.mirror-git-repository.mirror-git-repository-vsts-task.mirror-git-repository-vsts-task@1
      displayName: 'storage'
      inputs:
        sourceGitRepositoryUri: 'https://community.opengroup.org/osdu/platform/system/storage.git'
        destinationGitRepositoryUri: '$(STORAGE_REPO)'
        destinationGitRepositoryPersonalAccessToken: $(ACCESS_TOKEN)

    - task: swellaby.mirror-git-repository.mirror-git-repository-vsts-task.mirror-git-repository-vsts-task@1
      displayName: 'indexer-service'
      inputs:
        sourceGitRepositoryUri: 'https://community.opengroup.org/osdu/platform/system/indexer-service.git'
        destinationGitRepositoryUri: '$(INDEXER_REPO)'
        destinationGitRepositoryPersonalAccessToken: $(ACCESS_TOKEN)

    - task: swellaby.mirror-git-repository.mirror-git-repository-vsts-task.mirror-git-repository-vsts-task@1
      displayName: 'search-service'
      inputs:
        sourceGitRepositoryUri: 'https://community.opengroup.org/osdu/platform/system/search-service.git'
        destinationGitRepositoryUri: '$(SEARCH_REPO)'
        destinationGitRepositoryPersonalAccessToken: $(ACCESS_TOKEN)

    - task: swellaby.mirror-git-repository.mirror-git-repository-vsts-task.mirror-git-repository-vsts-task@1
      displayName: 'delivery'
      inputs:
        sourceGitRepositoryUri: 'https://community.opengroup.org/osdu/platform/system/delivery.git'
        destinationGitRepositoryUri: '$(DELIVERY_REPO)'
        destinationGitRepositoryPersonalAccessToken: $(ACCESS_TOKEN)

    - task: swellaby.mirror-git-repository.mirror-git-repository-vsts-task.mirror-git-repository-vsts-task@1
      displayName: 'file'
      inputs:
        sourceGitRepositoryUri: 'https://community.opengroup.org/osdu/platform/system/file.git'
        destinationGitRepositoryUri: '$(FILE_REPO)'
        destinationGitRepositoryPersonalAccessToken: $(ACCESS_TOKEN)

    - task: swellaby.mirror-git-repository.mirror-git-repository-vsts-task.mirror-git-repository-vsts-task@1
      displayName: 'unit-service'
      inputs:
        sourceGitRepositoryUri: 'https://community.opengroup.org/osdu/platform/system/reference/unit-service.git'
        destinationGitRepositoryUri: '$(UNIT_REPO)'
        destinationGitRepositoryPersonalAccessToken: $(ACCESS_TOKEN)
    
    - task: swellaby.mirror-git-repository.mirror-git-repository-vsts-task.mirror-git-repository-vsts-task@1
      displayName: 'crs-catalog-service'
      inputs:
        sourceGitRepositoryUri: 'https://community.opengroup.org/osdu/platform/system/reference/crs-catalog-service.git'
        destinationGitRepositoryUri: '$(CRS_CATALOG_REPO)'
        destinationGitRepositoryPersonalAccessToken: $(ACCESS_TOKEN)

    - task: swellaby.mirror-git-repository.mirror-git-repository-vsts-task.mirror-git-repository-vsts-task@1
      displayName: 'crs-conversion-service'
      inputs:
        sourceGitRepositoryUri: 'https://community.opengroup.org/osdu/platform/system/reference/crs-conversion-service.git'
        destinationGitRepositoryUri: '$(CRS_CONVERSION_REPO)'
        destinationGitRepositoryPersonalAccessToken: $(ACCESS_TOKEN)

    - task: swellaby.mirror-git-repository.mirror-git-repository-vsts-task.mirror-git-repository-vsts-task@1
      displayName: 'wks'
      inputs:
        sourceGitRepositoryUri: 'https://community.opengroup.org/osdu/platform/data-flow/enrichment/wks.git'
        destinationGitRepositoryUri: '$(WKS_REPO)'
        destinationGitRepositoryPersonalAccessToken: $(ACCESS_TOKEN)

    - task: swellaby.mirror-git-repository.mirror-git-repository-vsts-task.mirror-git-repository-vsts-task@1
      displayName: 'register'
      inputs:
        sourceGitRepositoryUri: 'https://community.opengroup.org/osdu/platform/system/register.git'
        destinationGitRepositoryUri: '$(REGISTER_REPO)'
        destinationGitRepositoryPersonalAccessToken: $(ACCESS_TOKEN)

    - task: swellaby.mirror-git-repository.mirror-git-repository-vsts-task.mirror-git-repository-vsts-task@1
          displayName: 'notification'
          inputs:
            sourceGitRepositoryUri: 'https://community.opengroup.org/osdu/platform/system/notification.git'
            destinationGitRepositoryUri: '$(NOTIFICATION_REPO)'
            destinationGitRepositoryPersonalAccessToken: $(ACCESS_TOKEN)

    - task: swellaby.mirror-git-repository.mirror-git-repository-vsts-task.mirror-git-repository-vsts-task@1
          displayName: 'schema-service'
          inputs:
            sourceGitRepositoryUri: 'https://community.opengroup.org/osdu/platform/system/schema-service.git'
            destinationGitRepositoryUri: '$(SCHEMA_REPO)'
            destinationGitRepositoryPersonalAccessToken: $(ACCESS_TOKEN)
    - task: swellaby.mirror-git-repository.mirror-git-repository-vsts-task.mirror-git-repository-vsts-task@1
      displayName: 'ingestion-workflow'
      inputs:
        sourceGitRepositoryUri: 'https://community.opengroup.org/osdu/platform/data-flow/ingestion/ingestion-workflow.git'
        destinationGitRepositoryUri: '$(INGESTION_WORKFLOW_REPO)'
        destinationGitRepositoryPersonalAccessToken: $(ACCESS_TOKEN)

EOF

(cd ${ADO_PROJECT}  && git add -A && git commit -m "pipeline" && git push)
rm -rf ${ADO_PROJECT}

# Create and Execute the Pipeline
az pipelines create \
  --name 'gitlab-sync'  \
  --repository $ADO_PROJECT  \
  --branch master  \
  --repository-type tfsgit  \
  --yaml-path /pipeline.yml  \
  -ojson
```


