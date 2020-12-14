**Service name**: `INSERT SERVICE NAME HERE`

The following steps must be completed for a service to onboard with OSDU on Azure. Additionally, please add the `Service Onboarding` tag to this issue when it is created.

For more information, visit our service onboarding documentation [here](https://community.opengroup.org/osdu/platform/deployment-and-operations/infra-azure-provisioning/-/blob/master/docs/service-onboarding.md).

## Steps:

**Infrastructure and Initial Requirements**

- [ ] Add any additional Azure cloud infrastructure (Cosmos containers, Storage containers, fileshares, etc.) to the Terraform template. [Link](https://community.opengroup.org/osdu/platform/deployment-and-operations/infra-azure-provisioning/-/tree/master/infra/templates/osdu-r3-mvp). Note that if the infrastructure is a part of the data-partition template, you may need to add secrets to the keyvault that are partition specific; if doing so, update the createPartition REST request to include the keys that you have added so they are accessible in service code. [Link](https://community.opengroup.org/osdu/platform/deployment-and-operations/infra-azure-provisioning/-/blob/master/tools/rest/partition.http#L48)
- [ ] Create an ingress point for the service. [Link](https://community.opengroup.org/osdu/platform/deployment-and-operations/infra-azure-provisioning/-/blob/master/charts/osdu-common/templates/appgw-ingress.yaml)
- [ ] Add any test data that is required for the service integration tests. [Link](https://community.opengroup.org/osdu/platform/deployment-and-operations/infra-azure-provisioning/-/tree/master/tools/test_data)
- [ ] Update `upload-data.py` to upload any new test data files you created. [Link](https://community.opengroup.org/osdu/platform/deployment-and-operations/infra-azure-provisioning/-/blob/master/tools/test_data/upload-data.py).
- [ ] Update the integration tester with any entitlements required to test the service. [Link](https://community.opengroup.org/osdu/platform/deployment-and-operations/infra-azure-provisioning/-/blob/master/tools/test_data/user_info_1.json)
- [ ] Add in any new secrets that the service needs to run. [Link](https://community.opengroup.org/osdu/platform/deployment-and-operations/infra-azure-provisioning/-/blob/master/charts/osdu-common/templates/kv-secrets.yaml)
- [ ] Create environment variable script to generate .yaml files to be used with Intellij [EnvFile](https://plugins.jetbrains.com/plugin/7861-envfile) plugin and .envrc files to be used with [direnv](https://direnv.net/). [Link](https://community.opengroup.org/osdu/platform/deployment-and-operations/infra-azure-provisioning/-/tree/master/tools/variables)

**Gitlab Code and Documentation**

- [ ] Complete the service code such that it passes all integration tests locally. There is some documentation on starting off implementing an Azure provider. [Link](./gitlab-service-readme-template.md)
- [ ] Create helm charts for service. The charts for each service are located in the `devops/azure` directory. You can look at charts from other services as a model. The charts will be nearly identical except for the different environment variables, values, etc each service needs to run. [Link](./gitlab-service-guide.md)
- [ ] Implement Istio for the service if this has not already been done. Here is an example MR that shows what steps are required. [Link](https://community.opengroup.org/osdu/platform/system/storage/-/merge_requests/64)
- [ ] Create an Istio auth policy in the `devops/azure/chart/templates` directory. Here is an example of an Istio auth policy that is generic and can be used by other services. [Link](https://community.opengroup.org/osdu/platform/system/storage/-/blob/master/devops/azure/chart/templates/azure-istio-auth-policy.yaml)
- [ ] Add any variables that are required for the service integration tests to the Azure CI-CD file. [Link](https://community.opengroup.org/osdu/platform/ci-cd-pipelines/-/blob/master/cloud-providers/azure.yml)
- [ ] Verify that the README for the Azure provider correctly and clearly describes how to run and test the service. There is a README template to help. [Link](./gitlab-service-readme-template.md)
- [ ] Push any changes and verify that the Gitlab pipeline is passing in master.

**Development and Demo Azure Devops Pipelines**

- [ ] Create development ADO pipeline at `devops/azure/development-pipeline.yml` in the service repo.
- [ ] Verify development pipeline passes in ADO.
- [ ] Create Demo ADO pipeline at `devops/azure/pipeline.yml` in the service repo.
- [ ] Verify demo pipeline is passing in ADO.

**User Documentation**

- [ ] Add the service to the mirror pipeline instructions. [Link](https://community.opengroup.org/osdu/platform/deployment-and-operations/infra-azure-provisioning/-/blob/master/docs/code-mirroring.md)
- [ ] Add the service to the manual deployment instructions. [Link](https://community.opengroup.org/osdu/platform/deployment-and-operations/infra-azure-provisioning/-/tree/master/charts)
- [ ] Add any required variables to the already existing variable group instructions for automated deployment. You should know if any variables need to be added to existing variable groups from creating the development and demo pipelines. [Link](https://community.opengroup.org/osdu/platform/deployment-and-operations/infra-azure-provisioning/-/blob/master/docs/service-automation.md#create-osdu-service-libraries)
- [ ] Add a variable group `Azure Service Release - $SERVICE_NAME` to the documentation. You should know what values to set for this variable group from creating the development and demo pipelines. [Link](https://community.opengroup.org/osdu/platform/deployment-and-operations/infra-azure-provisioning/-/blob/master/docs/service-automation.md#create-osdu-service-libraries)
- [ ] Add a step for creating the service pipeline at the bottom of the service-automation page. [Link](https://community.opengroup.org/osdu/platform/deployment-and-operations/infra-azure-provisioning/-/blob/master/docs/service-automation.md#create-osdu-service-libraries)
- [ ] Create a rest script with sample calls to the service for users. [Link](https://community.opengroup.org/osdu/platform/deployment-and-operations/infra-azure-provisioning/-/tree/master/tools/rest)
