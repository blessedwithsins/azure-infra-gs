[[_TOC_]]

## Introduction

This wiki contains the steps to restore an OSDU partition to a point of time in event of:
- Mass data corruption from an application error e.g. deleting all records in the system
- Mass data corruption from an operator error e.g. dropping a database 

## SLAs
- RPO: 12 hours
- RTO: 1 day
- Retention period: 28 days

## Steps to restore a partition
1. Follow [these](#Before-restoring-a-partition) to prepare the deployment for restore
2. Restore the cosmos DB by following [these](#Restoring-Cosmos-DB) instructions.
3. Restore the blob store by following [these](#Restoring-Blob-store) instructions.
4. After above two are complete, restore the Elasticsearch by following [these](#Restoring-Elasticsearch) instructions.
5. Execute the post restoration cleanup by following [these](#Post-restoration-cleanup) instructions.


## Before restoring a partition

### Prerequisite
- Azure CLI: installation instructions [here](https://docs.microsoft.com/en-us/cli/azure/install-azure-cli)
- Git bash with bash version >=4.4.23
- Check whether your partition info is up to date by following steps [here](#Check-the-partition-service-state)
### Get these details handy
- Service principal id and password
- AKS cluster name
- Cosmos DB account name(s)
- Storage account name(s)
- Indexer service URL

###Disable API access
To disable API access during restore activity, we'll bring down the AKS cluster which hosts pods running OSDU services. Follow [these](#Stop-AKS-Cluster) instructions to stop the AKS cluster.

## Restoring Cosmos DB

### Validation Steps. 
1. When you raise the ticket, please make sure you copy the database name, not type it. 
2. Mention the time in UTC. 
3. Validate the snapshot provided by Azure support, check time, version, and name. 

To restore the data in cosmos DB, follow steps described in the official [Microsoft documentation](https://docs.microsoft.com/en-us/azure/cosmos-db/configure-periodic-backup-restore#request-restore). You would be required to raise a support ticket in Azure for restoring your data.

## Restoring Blob store
Following official [Microsoft document](https://docs.microsoft.com/en-us/azure/storage/blobs/point-in-time-restore-manage?tabs=azure-cli) describes how to restore a blob storage account to a given time range. To summarize commands here
```
az storage blob restore --account-name
                        --time-to-restore
                        [--blob-range]
                        [--no-wait]
                        [--resource-group]
                        [--subscription]
```
Example:
```
# restoring to the snapshot taken 8 hours ago
time=`date -d '8 hour ago' "+%Y-%m-%dT%H:%MZ"`
az storage blob restore --account-name <storage_account_name> -g <resurce_group_name> -t $time
```
 
## Restoring Elasticsearch
Once the blob store and cosmos db have been recovered fully, restart the AKS cluster by following [these](#Start-AKS-Cluster) steps.
To fully restore the Elasticsearch data, we'll perform a full re-indexing of all the storage records. For this we'll use the `fullReindex` api of indexer-service.
###Sample request:
```
curl -X PATCH --header 'Content-Type: application/json' --header 'Accept: application/json' --header 'data-partition-id: opendes' --header  'https://<your_host>/api/indexer/v2/reindex?force_clean=false'
```

## Stop AKS Cluster
[The official Microsoft documentation](https://docs.microsoft.com/en-us/azure/aks/start-stop-cluster#:~:text=You%20can%20use%20the%20az%20aks%20start%20command%20to%20start%2cand%20number%20of%20agent%20nodes.) would be primary source of instruction for this purpose. Summarizing the steps here. Please consult the official document in case you are unable to run these steps.


```
# login using the privileged service principal
az login --service-principal -u "<sp_id>" -p "<password>" --tenant "<tenant_id>"

# optional setup
az account set -s <Azure_subscription_name_or_id>
az configure --defaults group=<resource_group_name>

# Install the aks-preview extension
az extension add --name aks-preview

# Update the extension to make sure you have the latest version installed
az extension update --name aks-preview

# set up for using aks extension
az feature register --namespace "Microsoft.ContainerService" --name "StartStopPreview"
az feature list -o table --query "[?contains(name, 'Microsoft.ContainerService/StartStopPreview')].{Name:name,State:properties.state}"
az provider register --namespace Microsoft.ContainerService

# Stop the AKS Cluster
az aks stop --name <AKS_cluster_name> --resource-group <resource_group_name>

# Monitor the status of Cluster
az aks show --name <AKS_cluster_name> --resource-group <resource_group_name>
```
Let the command finish. You can optionally validate from azure portal that all the deployments inside this cluster are stopped.


## Start AKS Cluster

```
# Start the AKS Cluster
az aks start --name <AKS_cluster_name> --resource-group <resource_group_name>

# Monitor the status of Cluster
az aks show --name <AKS_cluster_name> --resource-group <resource_group_name>
```

## Check the partition service state
Partition service related data is stored in Storage table in central resources. You can validate the partition service related data by making [REST call to partition service](#How-to-call-partition-service).
If you feel that data in partition service is not in good shape and needs to be restored, follow these steps.

### Restore partition service related data
To restore data in partition service, call the POST API of partition service with relevant details. You can use [this http tool](https://community.opengroup.org/osdu/platform/deployment-and-operations/infra-azure-provisioning/-/blob/master/tools/rest/partition.http) to restore data. This [README](https://community.opengroup.org/osdu/platform/deployment-and-operations/infra-azure-provisioning/-/blob/master/tools/rest/README.md) contains the instructions around how to use the tool. You can optionally call the POST API from a tool like postman. Use [the same payload](https://community.opengroup.org/osdu/platform/deployment-and-operations/infra-azure-provisioning/-/blob/master/tools/rest/partition.http#L54) as mentioned in the wiki. 

## Post restoration cleanup

### Migrate data back to the old cosmos account
Migrate data back to original cosmos db account by following these [instructions](docs/backup-restore/SOPs-for-restoring-partitions/Migrate-data-from-one-cosmos-db-to-another.md).

### Delete the newly created cosmos db account

The restore activity in cosmos would create a new cosmos db account. After migrating data to the old one, you need to delete the new cosmos db to save extra cost.

## Best practices 
- Keep the Bash window open during the entire activity to avoid repeated logins
## FAQs

## Appendix
### How to get cosmos db account name(s)
[Call partition service](#How-to-call-partition-service) and look for key `cosmos-endpoint` in output. This should give you the name of Key in Key Vault. Navigate to the KV in central resources and look for the secret named obtained in previous step.

### How to get storage account name(s)
[Call partition service](#How-to-call-partition-service) and look for key `storage-account-name` in output. This should give you the name of Key in Key Vault. Navigate to the KV in central resources and look for the secret named obtained in previous step.


### How to get service principal details
Contact the admin.

### How to call Partition service
```
curl -X GET --header 'Accept: text/plain' 'https://<Your_host>/api/partition/v1/partitions/<Your-partition-id>'

```

## Glossary 
AKS: Azure Kubernetes Services 
OSDU: Open Subsurface Data Universe
KV: Key Vault
