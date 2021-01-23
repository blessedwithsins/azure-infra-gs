## Status
- [X] Proposed
- [X] Under review
- [ ] Approved
- [ ] Retired

## Context & Scope 

Backup and recovery is a very large topic. For the scope of the phase 1 we want to concentrate on the scenarios of

- Mass data corruption from an application error e.g. deleting all records in the system
- Mass data corruption from an operator error e.g. dropping a database 

In these scenarios we want to be able to

- Restore the customer data of an entire OSDU partition to a point in time 

A single OSDU deployment can have many partitions. Each partition should be treated independently in terms of backup and restore i.e. I should be able to restore each partition independently. However all the data inside a partition needs to be aligned to the same point in time when restored.

Therefore we can state this requirement as I can restore the state of all services for a given partition to a previous point in time with the following 

- RPO: 12 hours
- RTO: 1 day
- Retention period: 28 days


Within a partition we need to be able to restore the Storage Blobs and Cosmos collections to the same point in time.

The data in Elastic is reconcilable from the data from Storage. We have some options here 
 
- Create snapshots of elastic that align with Cosmos Backups. This would be hard to keep aligned with Cosmos backups in a consistent way.
- Recreate the index by having an API in elastic that recreates the index based on the Storage service. This is a coupled implementation that only recreates indexer but there may be other services in the future that may want to recreate the same way.
-  Have an ability to replay the messages from Service Bus (either have Storage service resend the messages or have the messages stored and replayed directly from Service Bus). Indexer is not the only consumer of these messages so in this pattern the message may have to be changed slightly to indicate it is a replay in case some services want to ignore it e.g. if they were already restored directly from Cosmos backups.

A customer may decide to deploy additional data components into a partition and these will need to align to the OSDU backup/restore approach. Concretely, this means we will have more Storage Accounts and CosmosDB accounts within a partition than is currently depicted  in the OSDU architecture. 

A customer will  need to be able to apply the strategies, policies and implementations equally to these resources as well as to resources coming directly out of OSDU. Therefore, a backup/restore approach for OSDU must be considered a "reference implementation" that is extensible for their own needs. 

For OSDU R3, we will only look at backup and restore in the context of data stored in Storage Accounts and CosmosDB as well as how to restore data into Elastic.

## Overview of Azure Capability Available For Backup and Restore

### Backup Of Storage Accounts


Storage Accounts support [point in time recovery](https://docs.microsoft.com/en-us/azure/storage/blobs/point-in-time-restore-overview) (PITR) on block blobs. For OSDU this is the only type of blob we currently use and so this suits our needs.

If we couple this with placing [locks](https://docs.microsoft.com/en-us/azure/azure-resource-manager/management/lock-resources) on the provisioned accounts and containers so that they cannot be deleted we have a solution for backup and recovery using in built features of Azure and so reducing the cost of maintenance.

### Restore of Storage Accounts

The restore operation can be done on the [time range, container and account of your choosing](https://docs.microsoft.com/en-us/rest/api/storagerp/storageaccounts/restoreblobranges), meaning this can be used to support more fine grained restores in the future e.g. per service.

_At the time of writing, it is unclear how well this feature is supported for configuration in a Terraform deployment. More work will need to be done to see if this can be done natively in Terraform or if we need to apply the configuration as a post deploy script._

### Backup of Cosmos DB

For CosmosDB we have 2 options, periodic backup and continuous backup: 

* Periodic backup is run on a selected interval e.g. every 4 hours. You can keep the backup for up to 30 days to restore from and is supported by [Terraform](https://github.com/terraform-providers/terraform-provider-azurerm/issues/8507).

* The continuous backup can allow the restore to any point in time during the retention period after it was turned on. This would reduce the RPO we could offer. 

### Restore of Cosmos DB

For the restoration of the database, both solutions can be at the container level or database level. They also only restore to [a new Cosmos DB account](https://docs.microsoft.com/en-us/azure/cosmos-db/online-backup-and-restore#considerations-for-restoring-the-data-from-a-backup). This means that during restore you either have to switch your applications to point to a new database or migrate the data back into the existing database.

Our deployment model is sensitive to the names of the Cosmos accounts chosen meaning switching the services to point to a new database is not trivial undertaking. Therefore it is likely we will need to use data migration from the restored account into the existing Cosmos account to restore the data.

### Restore of Elastic Search 
* For elastic search restore we  rely on the existing Elastic snapshots that are being taken to restore and avoid reingesting, or reindexing all data. We would need to align the snapshots recovery with the Cosmos recovery which may be hard as even if they have a scheduled they are independent systems that are eventually consistent. They could easily be off in their state with one another when the snapshot occurs meaning the system is restored with dangling records.

* The other option to restore elastic is the re-ingest by kind API in Indexer Service. This requires a new API that needs to be implemented. This API will pull all Records for a given kind and re-index them. 

We can then have a new API that restores all kinds that can be run during a restore operation.

### Exceptions, Constraints
There is one service that does not conform to these standards. Partition service stores values in Table Store. As PITR is only enabled on Blob store today we should migrate to using CosmosDB (the suggested alternative to Table Store by Azure) as this can then use the same backup/restore policy.

## Decision and Supporting Backlog
1. For Storage Accounts we will use the following Azure policies
    - Delete Locks to be applied on Storage Accounts
    - PITR to be enabled on every [Storage Account](https://docs.microsoft.com/en-us/azure/storage/blobs/point-in-time-restore-overview) with retention period of 28 days
    - We need to migrate Partition service to use CosmosDB.

2. For CosmosDB we will use the periodic backup with the following policies
    - Delete locks to be applied on the CosmosDB
    - Periodic backups every 8 hours with the retention period of 28 days

3. For Elastic we will use the restore by kinds API and have an operation that can restore all kinds. 
4. RPO/RTO
    - The RPO will be defined by the Cosmos restore point (up to 8 hours) which the storage account restoration point will need to be aligned to when restoring.

5. Orchestration
    - We will create an overarching playbook on the steps to run a restore of the entire system to the same point in time. This should be for each partition individually.

### Achieved RPO/RTO
- RPO: 8 hours
- RTO: 1 day (this will need to be validated against dry runs as it is sensitive to the performance of the re-index which we are currently unsure of and Azure support restoring Cosmos)
- Retention period: 28 days

### Risks 
* A drawback of this solution is the lack of transactional consistency. This was raised as condition of the system and will need to be addressed post-R3 at at system-wide level. Since this procedure will only be applied in a major catastrophic data loss situation, we think this is an acceptable risk.  This means the vast majority of data will be restored and correctly aligned allowing for business continuity which is the main focus here. 