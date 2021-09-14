# Pipelines for OSDU Dags

This document aims to highlight a well defined procedure for contributing CI/CD pipelines for Dags in both
Gitlab and Azure. 

# Setting up ADO pipelines for OSDU Dags
In order to add ADO pipelines for DAGs reusable pipeline stages can be leveraged located at [**infra-azure-provisioning**](https://community.opengroup.org/osdu/platform/deployment-and-operations/infra-azure-provisioning/-/tree/master/devops/dag-pipeline-stages)
repository

For constructing an ADO pipeline features like triggers, resources and variable groups should be specified before including the templates for DAG stages,
below is an example for reference

````

trigger:
  batch: true
  branches:
    include:
      - master
  paths:
    exclude:
      - /**/*.md
      - .gitignore
      - /provider/csv-parser-aws
      - /provider/csv-parser-gcp
      - /provider/csv-parser-ibm

resources:
  repositories:
    - repository: FluxRepo
      type: git
      name: k8-gitops-manifests
    - repository: TemplateRepo
      type: git
      name: infra-azure-provisioning

variables:
  - group: 'Azure - OSDU'
  - group: 'Azure - Common'
  - group: 'Azure - OSDU Secrets'
  - group: 'Azure Target Env - dev'
  - group: 'Azure Target Env Secrets - dev'
  - name: serviceName
    value: "csv-parser"
  - name: 'MANIFEST_REPO'
    value: $[ resources.repositories['FluxRepo'].name ]
  - name: 'MAVEN_CACHE_FOLDER'
    value: $(Pipeline.Workspace)/.m2/repository
  - name: SKIP_TESTS
    value: 'false'

````

The [**ADO pipeline for CSV parser**](https://community.opengroup.org/osdu/platform/data-flow/ingestion/csv-parser/csv-parser/-/blob/master/devops/azure/dev-pipeline.yml) can be taken as a reference

Stages which can be included in the pipeline

### Stage 1 - Execute Standalone Tests

Please refer to [**link**](#execute-standalone-tests-stage) to get an overview of this [**Stage**](../devops/dag-pipeline-stages/execute-standalone-tests.yml)

The below code snippet can be added in the pipeline yml to include this stage
````
stages:
- template: /devops/dag-pipeline-stages/execute-standalone-tests.yml@TemplateRepo
  parameters:
  dockerfilePath: 'deployments/scripts/azure/dockerFolder/run_standalone_tests_dockerfile'
  buildArgs: '--build-arg AZURE_TENANT_ID=$AZURE_TENANT_ID --build-arg AZURE_AD_APP_RESOURCE_ID=$AZURE_AD_APP_RESOURCE_ID --build-arg AZURE_CLIENT_ID=$AZURE_CLIENT_ID --build-arg AZURE_CLIENT_SECRET=$AZURE_CLIENT_SECRET --build-arg aad_client_id=$AZURE_AD_APP_RESOURCE_ID --build-arg KEYVAULT_URI=$AZURE_KEYVAULT_URI --build-arg AZURE_DNS_NAME=$AZURE_DNS_NAME --build-arg DMS_KIND=$DMS_KIND --build-arg DMS_ACL=$DMS_ACL --build-arg DMS_LEGAL_TAG=$LEGAL_TAG --build-arg DATA_PARTITION_ID=$OSDU_TENANT --build-arg partition_service_endpoint=https://$AZURE_DNS_NAME/api/partition/v1 --build-arg storage_service_endpoint=https://$AZURE_DNS_NAME/api/storage/v2 --build-arg schema_service_endpoint=https://$AZURE_DNS_NAME/api/schema-service/v1 --build-arg search_service_endpoint=https://$AZURE_DNS_NAME/api/search/v2 --build-arg unit_service_endpoint=https://$AZURE_DNS_NAME/api/unit/v2/unit/symbol --build-arg legal_service_endpoint=https://$AZURE_DNS_NAME/api/legal/v1 --build-arg file_service_endpoint=https://$AZURE_DNS_NAME/api/file/v2'
  skipFailure: true
````

- The template can be imported for reuse by specifying the path in Infra repository
- ``dockerfilePath`` parameter will take the path of the dockerfile present in DAG repo, the dockerfile used here is common for both ADO and Gitlab pipelines, 
refer this [**section**](#execute-standalone-tests-stage-dockerfile) to know how to prepare this dockerfile
- `buildArgs` parameter to pass the build arguments for docker image
- `skipFailure` parameter to continue execution in case of failures

**Environment Variables required for this Stage**
- SERVICE_CONNECTION_NAME - [Azure Subscription manager subscription required by Azure CLI task](https://docs.microsoft.com/en-us/azure/devops/pipelines/tasks/deploy/azure-cli?view=azure-devops#task-inputs)

### Stage 2 - Build Dag

Please refer to [**link**](#build-dag-stage) to get an overview of this [**Stage**](../devops/dag-pipeline-stages/build-dag.yml)

The below code snippet can be added in the pipeline yml to include this stage

````
stages:
  - template: /devops/dag-pipeline-stages/build-dag.yml@TemplateRepo
    parameters:
      dockerfilePath: 'deployments/scripts/azure/dockerFolder/output_dags_dockerfile'
      outputDagFolder: '/home/output_dags'
      environmentVars: 'AZURE_REGISTRY=$(CONTAINER_REGISTRY_NAME)${NEWLINE}AZURE_PRINCIPAL_ID=$(AZURE_DEPLOY_CLIENT_ID)${NEWLINE}AZURE_PRINCIPAL_SECRET=$(AZURE_DEPLOY_CLIENT_SECRET)${NEWLINE}AZURE_TENANT_ID=$(AZURE_DEPLOY_TENANT)${NEWLINE}PARSER_IMAGE=$(CONTAINER_REGISTRY_NAME).azurecr.io/csv-parser-dev:$(Build.SourceVersion)${NEWLINE}DAG_IMAGE=$(CONTAINER_REGISTRY_NAME).azurecr.io/csv-parser-dag-dev:$(Build.SourceVersion)${NEWLINE}SHARED_TENANT=$(OSDU_TENANT)${NEWLINE}AZURE_DNS_NAME=$(AZURE_DNS_NAME)${NEWLINE}AZURE_GITLAB_PIPELINE_RUN=false'
````

- ``dockerfilePath`` parameter will take the path of the dockerfile present in DAG repo, the dockerfile and scripts used here is common for both ADO and Gitlab pipelines,
  refer this [**section**](#build-dag-stage-dockerfile) to know how to prepare this dockerfile and [**section**](#build-dag-stage-scripts) to refer to the 
- scripts which will execute as part of docker container


- `outputDagFolder` parameter defines the path of the output_dags folder which will be generated by the docker container as part of this stage,
   the stage will use this path to copy the folder from inside the docker container to the pipeline job Agent VM, refer to [**section**](#note-on-output-folder-structure)
   to understand the folder structure which this stage should generate so as to be consumed by next stages


- `environmentVars` parameter to pass the environment variables required by the docker container to execute

**Environment Variables required for this Stage**
- SERVICE_CONNECTION_NAME - [Azure Subscription manager subscription required by Azure CLI task](https://docs.microsoft.com/en-us/azure/devops/pipelines/tasks/deploy/azure-cli?view=azure-devops#task-inputs)


### Stage 3 - Copy Dag

Please refer to [**link**](#copy-dag-stage) to get an overview of this [**Stage**](../devops/dag-pipeline-stages/copy-dag.yml)

The below code snippet can be added in the pipeline yml to include this stage

````
stages:
- template: /devops/dag-pipeline-stages/copy-dag.yml@TemplateRepo
  parameters:
   deployPackagedDag: 'true'
````

- `deployPackagedDag` parameter to true/false depending on whether packaged dags are supported or not

**Environment Variables required for this Stage**
- SERVICE_CONNECTION_NAME - [Azure Subscription manager subscription required by Azure CLI task](https://docs.microsoft.com/en-us/azure/devops/pipelines/tasks/deploy/azure-cli?view=azure-devops#task-inputs)
- airflow-storage-key - Airflow Storage Account key
- airflow-storage - Airflow Storage Account Name

### Stage 4 - Register Dag

Please refer to [**link**](#register-dag-stage) to get an overview of this [**Stage**](../devops/dag-pipeline-stages/register-dag.yml)

The below code snippet can be added in the pipeline yml to include this stage

````
stages:
- template: /devops/dag-pipeline-stages/register-dag.yml@TemplateRepo
````

- No parameters required as such, refer to environment variable which should be part of Azure Library

**Environment Variables required for this Stage**
- SERVICE_CONNECTION_NAME - [Azure Subscription manager subscription required by Azure CLI task](https://docs.microsoft.com/en-us/azure/devops/pipelines/tasks/deploy/azure-cli?view=azure-devops#task-inputs)
- AZURE_TENANT_ID - Azure Tenant Id
- AZURE_AD_APP_RESOURCE_ID - Azure AAD application id
- AZURE_CLIENT_ID - Azure Principal Id
- AZURE_CLIENT_SECRET - Azure Principal Secret
- OSDU_TENANT - Data Partition id
- AZURE_DNS_NAME - DNS Host


### Stage 5 - Execute End to End Tests

Please refer to [**link**](#end-to-end-test-dag-stage) to get an overview of this [**Stage**](../devops/dag-pipeline-stages/execute-end-to-end-tests.yml)

The below code snippet can be added in the pipeline yml to include this stage

````
stages:
  - template: /devops/dag-pipeline-stages/execute-end-to-end-tests.yml@TemplateRepo
    parameters:
      dockerfilePath: 'deployments/scripts/azure/dockerFolder/end_to_end_tests_dockerfile'
      environmentVars: 'AZURE_TEST_CSV_FILE_PATH=$(AZURE_TEST_CSV_FILE_PATH)${NEWLINE}AZURE_POSTMAN_ENVIRONMENT_FILE_URL=$(AZURE_POSTMAN_ENVIRONMENT_FILE_URL)${NEWLINE}CLIENT_ID=$(CLIENT_ID)${NEWLINE}AZURE_TENANT_ID=$(AZURE_DEPLOY_TENANT)${NEWLINE}CLIENT_SECRET=$(CLIENT_SECRET)${NEWLINE}AZURE_REFRESH_TOKEN=$(AZURE_REFRESH_TOKEN)${NEWLINE}AZURE_POSTMAN_COLLECTION_FILE_URL=$(AZURE_POSTMAN_COLLECTION_FILE_URL)${NEWLINE}AZURE_DNS_NAME=$(AZURE_DNS_NAME)${NEWLINE}AZURE_TEST_SCHEMA_FILE_PATH=$(AZURE_TEST_SCHEMA_FILE_PATH)'
````

- The template can be imported for reuse by specifying the path in Infra repository
- ``dockerfilePath`` parameter will take the path of the dockerfile present in DAG repo,the dockerfile and scripts used here are common for both ADO and Gitlab pipelines,
  refer this [**section**](#end-to-end-test-dag-stage-dockerfile) to know how to prepare this dockerfile and [**section**](#end-to-end-test-dag-stage-scripts) to refer to the
- scripts which will execute as part of docker container
-  `environmentVars` parameter to pass the environment variables required by the docker container to execute


**Environment Variables required for this Stage**
- SERVICE_CONNECTION_NAME - [Azure Subscription manager subscription required by Azure CLI task](https://docs.microsoft.com/en-us/azure/devops/pipelines/tasks/deploy/azure-cli?view=azure-devops#task-inputs)




---------------------------------------------------------------------------------------------------------------------------------------------------------


# Setting up Gitlab pipelines for OSDU Dags

In order to add Gitlab pipelines for DAGs, some reusable pipeline stages can be leveraged which are located at [**azure_dag.yml**](https://community.opengroup.org/osdu/platform/ci-cd-pipelines/-/blob/master/cloud-providers/azure_dag.yml)
repository

To import this yaml add below code snippet in .gitlab-ci.yml of the DAG repository

```
include:
  - project: "osdu/platform/ci-cd-pipelines"
    ref: 'master'
    file: "cloud-providers/azure_dag.yml"
```

Some common Environment Variables required for the DAG pipeline
- AZURE - the Gitlab pipeline stages are only triggered when this variable is set to `true`
- AZURE_TENANT_ID - Azure tenant id
- AZURE_PRINCIPAL_SECRET - Azure service principal secret
- AZURE_PRINCIPAL_ID - Azure service principal id
- AZURE_UNIQUE - Service Resource group prefix (for eg. osdu-mvp-srdemo-ovyx-rg here $AZURE_UNIQUE=osdu-mvp-srdemo-ovyx)

### Stage 1 - Execute Standalone Tests (azure_test_stage)

This [**stage**](https://community.opengroup.org/osdu/platform/ci-cd-pipelines/-/blob/master/cloud-providers/azure_dag.yml#L42)
will be inherited after the yml import from the project ``osdu/platform/ci-cd-pipelines/cloud-providers/azure_dag.yml``


Please refer to [**link**](#execute-standalone-tests-stage) to get an overview of this stage

The dockerfile to be used in this stage can be referred from this [**section**](#execute-standalone-tests-stage-dockerfile)

The stage contains a `before_script` section which can be overridden in the DAG repository's gitlab-ci.yml file to set DAG specific
build arguments or environment variables required to execute the docker container, an
[**example**](https://community.opengroup.org/osdu/platform/data-flow/enrichment/wks/-/blob/master/devops/azure/bootstrap.yml#L23) on how to override a stage in Gitlab pipelines.

```
azure_standalone_tests:
  before_script:
    - <any custom script can be executed>
```

**Note:**
- If any Dag repository doesn't contain any tests, the stage can be skipped by setting ``AZURE_SKIP_TEST`` variables as `true`
- ``AZURE_DEPLOYMENTS_SCRIPTS_SUBDIR`` must be set to azure scripts folder containing all the dockerfile, bash/python scripts


### Stage 2 - Build Dag

This [**stage**](https://community.opengroup.org/osdu/platform/ci-cd-pipelines/-/blob/master/cloud-providers/azure_dag.yml#L86)
will be inherited after the yml import from the project ``osdu/platform/ci-cd-pipelines/cloud-providers/azure_dag.yml``

Please refer to [**link**](#build-dag-stage) to get an overview of this stage

The dockerfile to be used in this stage can be referred from this [**section**](#build-dag-stage-dockerfile)

The scripts to be used in this stage can be referred from this [**section**](#build-dag-stage-scripts)


**Note:**
- The path for dockerfiles and scripts can be set using `AZURE_DEPLOYMENTS_SCRIPTS_SUBDIR` variable
- The output dag folder is copied from the docker container to the pipeline job agent VM, hence this variable `AZURE_OUTPUT_DAG_FOLDER`
should be set with the output_dag folder path as value
- In case any new environment variables are required for the DAG the ``before_script`` section of the pipeline can be overridden to
  add new additional environment variables, the environment variables are set by creating an .env file

```
azure_build_dag:
  before_script:
    - <any custom script can be executed>
```

### Stage 3 - Copy Dag

This [**stage**](https://community.opengroup.org/osdu/platform/ci-cd-pipelines/-/blob/master/cloud-providers/azure_dag.yml#L145)
will be inherited after the yml import from the project ``osdu/platform/ci-cd-pipelines/cloud-providers/azure_dag.yml``

Please refer to [**link**](#copy-dag-stage) to get an overview of this stage

**Environment Variables required for this Stage**
- AZURE_DEPLOY_PACKAGED_DAG - Enabling/disabling of packaged dags


### Stage 4 - Register Dag

This [**stage**](https://community.opengroup.org/osdu/platform/ci-cd-pipelines/-/blob/master/cloud-providers/azure_dag.yml#L236)
will be inherited after the yml import from the project ``osdu/platform/ci-cd-pipelines/cloud-providers/azure_dag.yml``

Please refer to [**link**](#register-dag-stage) to get an overview of this stage

**Environment Variables required for this Stage**
- AZURE_TENANT_ID - Azure Tenant Id
- AZURE_AD_APP_RESOURCE_ID - Azure AAD application id
- AZURE_CLIENT_ID - Azure Principal Id
- AZURE_CLIENT_SECRET - Azure Principal Secret
- OSDU_TENANT - Data Partition id
- AZURE_DNS_NAME - DNS Host

### Stage 5 - Execute End to End Tests

This [**stage**](https://community.opengroup.org/osdu/platform/ci-cd-pipelines/-/blob/master/cloud-providers/azure_dag.yml#340)
will be inherited after the yml import from the project ``osdu/platform/ci-cd-pipelines/cloud-providers/azure_dag.yml``

Please refer to [**link**](#end-to-end-test-dag-stage) to get an overview of this stage

The dockerfile to be used in this stage can be referred from this [**section**](#end-to-end-test-dag-stage-dockerfile)

The scripts to be used in this stage can be referred from this [**section**](#end-to-end-test-dag-stage-scripts)


**Note:**
- The path for dockerfiles and scripts can be set using `AZURE_DEPLOYMENTS_SCRIPTS_SUBDIR` variable
- In case any new environment variables are required for the DAG the ``before_script`` section of the pipeline can be overridden to
  add new additional environment variables, the environment variables are set by creating an .env file
- This stage can be skipped by setting ``AZURE_SKIP_POSTMAN_TESTS`` variables as `true`**

```
azure_dag_end_to_end_test:
  before_script:
    - <any custom script can be executed>
```





-------------------------------------------------------------------------------------------------------------------------------------------

# Overview of DAG Pipeline stages

### Execute Standalone Tests Stage
This stage will be used to execute any standalone tests which are part of the DAG repository and could include any Unit/Functional tests.
This stage will execute any tests in a docker container to prevent any tight coupling with any one framework.

**Example of CSV Parser Repo**
##### Execute Standalone Tests Stage Dockerfile
CSV Parser Repo can be taken as a reference on how to prepare [**Dockerfile**](https://community.opengroup.org/osdu/platform/data-flow/ingestion/csv-parser/csv-parser/-/blob/master/deployments/scripts/azure/dockerFolder/run_standalone_tests_dockerfile) for running maven tests.
It will be good to organize all the dockerfile for the pipelines under a well known folder like [**deployments/scripts/azure/dockerFolder**](https://community.opengroup.org/osdu/platform/data-flow/ingestion/csv-parser/csv-parser/-/tree/master/deployments/scripts/azure/dockerFolder)

Once the DAG functionality is tested we can proceed with building and deployment of actual DAG files


### Build Dag Stage
This stage generates an output dag folder containing all the DAG related files/folders which needs to be uploaded to airflow. This
stage will execute a docker container to abstract out any DAG specific logic. For example in case of Dags using k8s operator like Csv Parser a docker image
of the parser is required as part of DAG file, hence the container used should take care of preparing any such
relevant artifacts

The output for this stage will be passed on to **Copy Dag** stage where the files can simply be copied to Airflow file share

**Example of CSV Parser Repo**

##### Build Dag Stage Dockerfile
Inside a well known folder structure [**deployments/scripts/azure/dockerFolder**](https://community.opengroup.org/osdu/platform/data-flow/ingestion/csv-parser/csv-parser/-/tree/master/deployments/scripts/azure/dockerFolder) ``output_dags_dockerfile``
defines the logic to generate and output dag artifacts. For a high level summary this dockerfile executes
a [**bash script**](https://community.opengroup.org/osdu/platform/data-flow/ingestion/csv-parser/csv-parser/-/blob/master/deployments/scripts/azure/prepare_dags.sh) to prepare the required docker images and then generates the python file for the DAG by setting
up appropriate variables and placeholder values.

##### Build Dag Stage Scripts
All the scripts are located at [**deployments/scripts/azure**](https://community.opengroup.org/osdu/platform/data-flow/ingestion/csv-parser/csv-parser/-/tree/master/deployments/scripts/azure)

##### Note on output folder structure

- The stage expects the output folder generated by the docker container to be named as **"output_dags"**

The above folder will also contain the zipped folder containing DAG files if [**packaging of DAGs**](https://community.opengroup.org/osdu/platform/data-flow/home/-/issues/47) is supported

**Structure of output_dag folder (Un-packaged Dags)**

```
output_dags
    --> dags
          --> dag.py
          --> foo.py
          --> abc
    --> plugins
          --> bar.py    
    --> workflow_request_body.json
    
```

**In the above structure**
- `output_dags` folder will contain a `dags` folder comprising of
  the DAG file, dependent python files and other folders


- `output_dags` folder can also contain some additional folders like `plugins` folder depending on the DAG


- `workflow_request_body.json` file contains a json array where an array element represents the body required for
  registering a DAG with workflow service. The basic idea behind generating this file is that we can then
  easily register all the dags which were copied in the previous stage (if are there are more than one)

This [**Python Script**](https://community.opengroup.org/osdu/platform/data-flow/ingestion/csv-parser/csv-parser/-/blob/master/deployments/scripts/azure/create_dag.py#L69) in CSV Parser
can be used as a reference. This json file will be used by **bootstrap** (azure_register_dag) to register the DAGs with workflow service.

Here is a sample json file

````
[
	{
		"workflowName": "DAG_NAME_PLACEHOLDER",
		"description": "CSVParser",
		"registrationInstructions": {
			"dagName": "DAG_NAME_PLACEHOLDER"
		}
	}
]
````

**Structure of this output dag folder (Packaged Dags)**

```
output_dags
    --> dags    
           --> zipped_dag.zip
    --> workflow_request_body.json
```

If packaging is enabled the zipped folder will contain the dependent files, the structure to be followed can be referred from this [**ADR**](https://community.opengroup.org/osdu/platform/data-flow/home/-/issues/47),
the json file will remain same for both the scenarios


- For dags like **Manifest Ingestion** where no docker images are required, the docker container
  logic can be modified appropriately to skip those steps

### Copy Dag Stage

This stage takes care of copying the dag files generated in the previous stage, [**az-copy**](https://docs.microsoft.com/en-us/azure/storage/common/storage-use-azcopy-v10) utility is used for this use case

**There are two scenarios for this stage**

- **Packaging is enabled:** This one is simple and the zipped folder inside `output_dags/dags` folder will simply be copied to Airflow file share


- **Packaging is not enabled:** For this scenario below steps are performed in order

  - Copy all the contents (if present) from `output_dags/dags` folder to `airflowdags/dags` folder in file share (Copying operation overwrites the existing files with same name but doesn't delete the other files which are not being copied)
  - Sync all the folders inside the `airflowdags/dags` folder (Syncing will delete files which are not there in the source folder)
  - Copy all the contents (if present) from `output_dags/plugins` folder to `airflowdags/plugins` folder in file share
  - Sync all the folders inside the `airflowdags/plugins/operators` folder (if present)
  - Sync all the folders inside the `airflowdags/plugins/hooks` folder (if present)

### Register Dag Stage
This stage registers the Dag with workflow service using the payload passed from the previous stage (`workflow_request_body.json`)

The stage generates the Bearer Token for Authentication and extracts the request body from the `workflow_request_body.json` file to register
the workflow with desired dag information (dag name, registration instructions etc.)


### End to End Test Dag Stage

This stage is used for running an end to end test scenario by triggering the registered dag in Airflow, we are running postman collections which
are part of [**Platform Validation project**](https://community.opengroup.org/osdu/platform/testing/-/tree/master/Postman%20Collection) using newman utility.

This stage might not be relevant if dedicated end to end tests are contributed as part of newly onboarded Dags.

This stage is also abstracted and uses a docker container to to run the postman tests

**Example of CSV Parser Repo**

##### End to End Test Dag Stage Dockerfile
CSV Parser DAG can be taken as a reference on what needs to done to enable these end to end tests

Inside a well known folder structure containing [**deployments/scripts/azure/dockerFolder**](https://community.opengroup.org/osdu/platform/data-flow/ingestion/csv-parser/csv-parser/-/tree/master/deployments/scripts/azure) ``end_to_end_dags_dockerfile``
defines the logic to execute the postman collection tests using newman utility

##### End to End Test Dag Stage Scripts
The folder [**deployments/scripts/azure/end_to_end_tests**](https://community.opengroup.org/osdu/platform/data-flow/ingestion/csv-parser/csv-parser/-/tree/master/deployments/scripts/azure/end_to_end_tests) contains all the helper scripts
and can be customized as per each DAGs requirements

This python [**script**](https://community.opengroup.org/osdu/platform/data-flow/ingestion/csv-parser/csv-parser/-/blob/master/deployments/scripts/azure/end_to_end_tests/bootstrap.py) does all the pre-requisite
tasks, for instance
- Downloading Postman collection json file from Platform Validation Project
- Downloading Environment json file for Postman
- Performing any bootstrapping/preloading tasks

The bash [**script**](https://community.opengroup.org/osdu/platform/data-flow/ingestion/csv-parser/csv-parser/-/blob/master/deployments/scripts/azure/end_to_end_tests/run_tests.sh)
will then run the postman tests using [**Newman utility**](https://learning.postman.com/docs/running-collections/using-newman-cli/command-line-integration-with-newman/)
