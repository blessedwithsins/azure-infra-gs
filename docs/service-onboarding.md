# Service Onboarding
This document outlines the process of onboarding a service with OSDU on Azure. Note that if you are a service owner who is onboarding a service, there is an issue template in this repository titled "service_onboarding_template" that we ask you use so we can track along with your process.

## Table of Contents
1. [Infrastructure and Initial Requirements](#infrastructure-and-initial-requirements)
1. [Gitlab Code and Documentation](#gitlab-code-and-documentation)
1. [Development and Demo Azure Devops Pipelines](#development-and-demo-azure-devops-pipelines)
1. [User Documentation](#user-documentation)
1. [Release](#release)


## Infrastructure and Initial Requirements
Quick links: [Terraform infra template](https://community.opengroup.org/osdu/platform/deployment-and-operations/infra-azure-provisioning/-/tree/master/infra/templates/osdu-r3-mvp), [ingress](https://community.opengroup.org/osdu/platform/deployment-and-operations/infra-azure-provisioning/-/blob/master/charts/osdu-common/templates/appgw-ingress.yaml), [test data](https://community.opengroup.org/osdu/platform/deployment-and-operations/infra-azure-provisioning/-/tree/master/tools/test_data), [integration tester](https://community.opengroup.org/osdu/platform/deployment-and-operations/infra-azure-provisioning/-/blob/master/tools/test_data/user_info_1.json), [secrets](https://community.opengroup.org/osdu/platform/deployment-and-operations/infra-azure-provisioning/-/blob/master/charts/osdu-common/templates/kv-secrets.yaml), [environment variable scripts](https://community.opengroup.org/osdu/platform/deployment-and-operations/infra-azure-provisioning/-/tree/master/tools/variables)

---

The first step to onboarding a service with OSDU on Azure is onboarding with the infrastructure. This includes the following activities:
- Add any additional Azure cloud infrastructure (Cosmos containers, Storage containers, fileshares, etc.) to the Terraform template. [Link](https://community.opengroup.org/osdu/platform/deployment-and-operations/infra-azure-provisioning/-/tree/master/infra/templates/osdu-r3-mvp). Note that if the infrastructure is a part of the data-partition template, you may need to add secrets to the keyvault that are partition specific; if doing so, update the createPartition REST request to include the keys that you have added so they are accessible in service code. [Link](https://community.opengroup.org/osdu/platform/deployment-and-operations/infra-azure-provisioning/-/blob/master/tools/rest/partition.http#L48)
- Create an ingress point for the service. [Link](https://community.opengroup.org/osdu/platform/deployment-and-operations/infra-azure-provisioning/-/blob/master/charts/osdu-common/templates/appgw-ingress.yaml)
- Add any test data that is required for the service integration tests. [Link](https://community.opengroup.org/osdu/platform/deployment-and-operations/infra-azure-provisioning/-/tree/master/tools/test_data)
- Update `upload-data.py` to upload any new test data files you created. [Link](https://community.opengroup.org/osdu/platform/deployment-and-operations/infra-azure-provisioning/-/blob/master/tools/test_data/upload-data.py).
- Update the integration tester with any entitlements required to test the service. [Link](https://community.opengroup.org/osdu/platform/deployment-and-operations/infra-azure-provisioning/-/blob/master/tools/test_data/user_info_1.json)
- Add in any new secrets that the service needs to run. [Link](https://community.opengroup.org/osdu/platform/deployment-and-operations/infra-azure-provisioning/-/blob/master/charts/osdu-common/templates/kv-secrets.yaml)
- Create environment variable script to generate .yaml files to be used with Intellij [EnvFile](https://plugins.jetbrains.com/plugin/7861-envfile) plugin and .envrc files to be used with [direnv](https://direnv.net/). [Link](https://community.opengroup.org/osdu/platform/deployment-and-operations/infra-azure-provisioning/-/tree/master/tools/variables)

## Gitlab Code and Documentation
Quick Links: [Azure Provider Implementation Guidance](./gitlab-service-guide.md), [Gitlab Azure pipeline variables](https://community.opengroup.org/osdu/platform/ci-cd-pipelines/-/blob/master/cloud-providers/azure.yml), [sample Istio auth policy](https://community.opengroup.org/osdu/platform/system/file/-/blob/master/devops/azure/chart/templates/azure-istio-auth-policy.yaml), [Gitlab provider README template](./gitlab-service-readme-template.md).

---

After onboarding with the infrastructure, the code and documentation for the service must be completed. This includes the following activities:
- Complete the service code such that it passes all integration tests locally. There is some documentation on starting off implementing an Azure provider. [Link](./gitlab-service-readme-template.md)
- Create helm charts for service. The charts for each service are located in the devops/azure directory. You can look at charts from other services as a model. The charts will be nearly identical except for the different environment variables, values, etc each service needs to run. [Link](./gitlab-service-guide.md)
- Implement Istio for the service if this has not already been done. Here is an example MR that shows what steps are required. [Link](https://community.opengroup.org/osdu/platform/system/storage/-/merge_requests/64)
- Create an Istio auth policy in the devops/azure/chart/templates directory. Here is an example of an Istio auth policy that is generic and can be used by other services. [Link](https://community.opengroup.org/osdu/platform/system/storage/-/blob/master/devops/azure/chart/templates/azure-istio-auth-policy.yaml)
- Add any variables that are required for the service integration tests to the Azure CI-CD file. [Link](https://community.opengroup.org/osdu/platform/ci-cd-pipelines/-/blob/master/cloud-providers/azure.yml)
- Verify that the README for the Azure provider correctly and clearly describes how to run and test the service. There is a README template to help. [Link](./gitlab-service-readme-template.md)
- Push any changes and verify that the Gitlab pipeline is passing in master.

## Development and Demo Azure Devops Pipelines
Quick Links: [Azure Provider Implementation Guidance](./gitlab-service-guide.md), [sample pipeline.yml](https://community.opengroup.org/osdu/platform/system/storage/-/blob/master/devops/azure/pipeline.yml), [sample development-pipeline.yml](https://community.opengroup.org/osdu/platform/system/storage/-/blob/master/devops/azure/development-pipeline.yml)

---
Once the code is passing through the pipelines in Gitlab, a pipeline needs to be established in Azure Devops (ADO). There are two nearly identical files for each service that define its ADO pipelines. These two pipelines are located at devops/azure/development-pipeline.yml and devops/azure/pipeline.yml for each service.  The development pipeline.yml file is currently a Microsoft used pipeline for Microsoft's Development efforts on OSDU.  Pipelines with the name pipeline.yml are treated as customer example pipelines for reference architecture which utilizes the environment name of `demo` in all documentation samples and pipelines.  Before proceeding, make sure that both pipelines are passing in ADO.


## User Documentation
Quick Links: [manual deployment instructions](https://community.opengroup.org/osdu/platform/deployment-and-operations/infra-azure-provisioning/-/tree/master/charts), [code mirror instructions](https://community.opengroup.org/osdu/platform/deployment-and-operations/infra-azure-provisioning/-/blob/master/docs/code-mirroring.md), [rest calls](https://community.opengroup.org/osdu/platform/deployment-and-operations/infra-azure-provisioning/-/tree/master/tools/rest), [automated deployment instructions and variable group creation](https://community.opengroup.org/osdu/platform/deployment-and-operations/infra-azure-provisioning/-/blob/master/docs/service-automation.md)

---

Once the service is passing both Gitlab and ADO pipelines, it has to be properly documented so other users can deploy and test the service. There are currently two distinct processes for deploying the services into AKS: a manual process and a pipeline controlled process. In a manual deployment, the user manually pushes the helm manifest for each service to their Flux repository which causes the service to be deployed into the AKS cluster. In a pipeline-controlled deployment, the user configures ADO pipelines to automate the deployment process. Additionally, each service is expected to have a file containing sample API calls for the service so that users can easily experiment with a service. In summary, the process of documentating a service includes the following activities:

- Add the service to the mirror pipeline instructions. [Link](https://community.opengroup.org/osdu/platform/deployment-and-operations/infra-azure-provisioning/-/blob/master/docs/code-mirroring.md)
- Add the service to the manual deployment instructions. [Link](https://community.opengroup.org/osdu/platform/deployment-and-operations/infra-azure-provisioning/-/tree/master/charts)
- Add any required variables to the already existing variable group instructions for automated deployment. You should know if any variables need to be added to existing variable groups from creating the development and demo pipelines. [Link](https://community.opengroup.org/osdu/platform/deployment-and-operations/infra-azure-provisioning/-/blob/master/docs/service-automation.md#create-osdu-service-libraries)
- Add a variable group `Azure Service Release - $SERVICE_NAME` to the documentation. You should know what values to set for this variable group from creating the development and demo pipelines. [Link](https://community.opengroup.org/osdu/platform/deployment-and-operations/infra-azure-provisioning/-/blob/master/docs/service-automation.md#create-osdu-service-libraries)
- Add a step for creating the service pipeline at the bottom of the service-automation page. [Link](https://community.opengroup.org/osdu/platform/deployment-and-operations/infra-azure-provisioning/-/blob/master/docs/service-automation.md#create-osdu-service-libraries)
- Create a rest script with sample calls to the service for users. [Link](https://community.opengroup.org/osdu/platform/deployment-and-operations/infra-azure-provisioning/-/tree/master/tools/rest)
- (Optional) Add documentation on how to deploy the service into an already existing manual deployment and pipeline-controlled deployment to the service repo.
- (Optional) Create a video walkthrough explaining the process of deploying the service.

## Release 
**Coming soon**