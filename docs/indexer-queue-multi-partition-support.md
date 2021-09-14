# Indexer Queue Multi Partition Support

Indexer Queue in Azure CSP was implemented as Azure Function earlier. Azure Function listens to service bus of only one partition. To enable Indexer Queue to listen to multiple partitions, it has been implemented as a spring boot service which uses the [Azure Service bus Java SDK to create subscription clients](https://docs.microsoft.com/en-us/java/api/com.microsoft.azure.servicebus.subscriptionclient?view=azure-java-stable) for each partition's service bus. The partition information is fetched from Partition Service at the time of service start up.

## Gitlab Code and Documentation
(Currently these are MR links. Once merged this doc will be updated accordingly.)
* [Gitlab Code Link](https://community.opengroup.org/osdu/platform/system/indexer-queue/-/merge_requests/71)
* [README.md](https://community.opengroup.org/osdu/platform/system/indexer-queue/-/merge_requests/91/diffs): Instructions to run the service and integration tests locally.

## Azure Devops Pipeline Changes

The following change is needed to successfully run the ADO pipeline for indexer queue service.

### Create Variable Group

Create variable group `Azure Service Release - indexer-queue`. Instructions on how to create a new variable group in ADO can be found [here](https://community.opengroup.org/osdu/platform/deployment-and-operations/infra-azure-provisioning/-/blob/master/docs/service-automation.md#create-osdu-service-libraries). 
This variable group contains the service specific variables necessary for testing and deploying the service.

| Variable | Value |
|----------|-------|
| MAVEN_DEPLOY_POM_FILE_PATH     | `drop/indexer-queue-azure-enqueue` |
| MAVEN_INTEGRATION_TEST_OPTIONS | `-DAZURE_AD_TENANT_ID=$(AZURE_TENANT_ID) -DINTEGRATION_TESTER=$(INTEGRATION_TESTER) -DAZURE_TESTER_SERVICEPRINCIPAL_SECRET=$(AZURE_TESTER_SERVICEPRINCIPAL_SECRET) -DAZURE_AD_APP_RESOURCE_ID=$(AZURE_AD_APP_RESOURCE_ID) -Daad_client_id=$(AZURE_AD_APP_RESOURCE_ID) -DSTORAGE_HOST=$(STORAGE_URL) -DELASTIC_HOST=$(ELASTIC_HOST) -DELASTIC_PORT=$(ELASTIC_PORT) -DELASTIC_USER_NAME=$(ELASTIC_USERNAME) -DELASTIC_PASSWORD=$(ELASTIC_PASSWORD) -DDEFAULT_DATA_PARTITION_ID_TENANT1=$(MY_TENANT) -DDEFAULT_DATA_PARTITION_ID_TENANT2=othertenant2 -DENTITLEMENTS_DOMAIN=contoso.com -DENVIRONMENT=CLOUD -DLEGAL_TAG=opendes-public-usa-dataset-7643990 -DOTHER_RELEVANT_DATA_COUNTRIES=US -DELASTIC_SSL_ENABLED=false` |
| MAVEN_INTEGRATION_TEST_POM_FILE_PATH | `drop/deploy/indexer-queue-azure-enqueue/pom.xml` |
| SERVICE_RESOURCE_NAME | `$(AZURE_INDEXER_QUEUE_NAME)` |

## Dependencies

Currently, it is mandatory to have the partition service up and running with all the partition information loaded before starting the indexer queue service.

## Limitations
* Autoscaling component has not been added in indexer queue yet. 
* Dynamic data partition support is not yet added.