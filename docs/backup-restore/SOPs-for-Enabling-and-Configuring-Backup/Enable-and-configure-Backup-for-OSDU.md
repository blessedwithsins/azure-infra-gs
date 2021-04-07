[[_TOC_]]

## Introduction
This wiki talks about how to onboard your OSDU partition to back up and restore. Please note that you must set the configuration per partition per deployment.

## Enabling Back-Up for Storage Accounts.

####Scope 
1. Delete Locks are applied on the Storage Accounts. 
2. PITR  is to be enabled on every Storage Account with a retention period of 28 days for Blob Storage.

#### How to configure backup policy with the help of CLI?
The Back up is enabled out of the box with the default configuration. The backup policy configuration is to be set up with the help of [this](https://community.opengroup.org/osdu/platform/deployment-and-operations/infra-azure-provisioning/-/tree/master/tools/backup) script. [This readme](https://community.opengroup.org/osdu/platform/deployment-and-operations/infra-azure-provisioning/-/tree/master#configure-back-up) explains the usage. **DO NOT CHANGE THIS CONFIGURATION. If the configuration is changed accidentally, the [recovery SLA](docs/backup-restore.md) can't be met.**


## Enabling Back-Up for CosmosDB Account
The backup applies to SQL API, Cassandra API, Gremlin API, Table API and Azure Cosmos DB API for MongoDB. For updates, please follow the [official documentation](https://docs.microsoft.com/en-us/azure/cosmos-db/online-backup-and-restore). 
####Scope
1. Delete locks are applied on the CosmosDB Accounts.
2. Periodic backups every 8 hours with a retention period of 28 days is to be set up.

#### How to configure backup policy with the help of CLI?
The Back up is enabled out of the box with the default configuration. Here is how the configuration has to be set, for each CosmosDB Accounts across partitions. [This](https://community.opengroup.org/osdu/platform/deployment-and-operations/infra-azure-provisioning/-/tree/master/tools/backup) script automates the same. [This readme](https://community.opengroup.org/osdu/platform/deployment-and-operations/infra-azure-provisioning/-/tree/master#configure-back-up) **DO NOT CHANGE THIS CONFIGURATION. If the configuration is changed accidentally, the [recovery SLA](docs/backup-restore.md) can't be met.**



## References
1. [Scope](docs/backup-restore.md) for Storage Accounts and CosmosDB Accounts. 


