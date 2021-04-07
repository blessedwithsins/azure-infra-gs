[[_TOC_]]
## Introduction
This wiki talks about how to migrate data from one cosmos db to another cosmos db. The migration happens at db level and one can choose what all containers from which you want to migrate data.

## Identify Source database
The source data base account would be the one created after restore. The name of database would be `<Azure_Cosmos_account_original_name>-restored1`, unless you have specified differently. The last digit is incremented when multiple restores are attempted. Pick the databases in this account one by one and repeat the process for all the dbs.

## Identify destination database
The destination database account would be the original cosmos db account on which you ran the restore operation. Pick the database same as one you picked in the previous step.

## Clean up destination database
Since we are migrating data from recovered database, most of the data in original database would be same as that in recovered one. The copy activity in Azure Data Factory does not support data overwrite and hence you need to clean up the destination database before starting the migration.

This [stackoverflow thread](https://stackoverflow.com/questions/45869002/delete-all-multiple-documents-from-azure-cosmos-db-through-the-portal) talks about how you can achieve the data cleanup. As mentioned in the link, you can either set the `Time to live` to `1 seconds` temporarily by following [these](https://docs.microsoft.com/en-us/azure/cosmos-db/how-to-time-to-live?tabs=dotnetv2%2Cjavav4) steps, ensure that all the data is gone from cosmos container and disable the time to live again. Note that **disabling it back is important**, otherwise any data that you write to the concerned cosmos container would be wiped away automatically. Once you disable it back, cross check that all the records are indeed deleted.

**NOTE**- Time taken for document deletion to complete depends on number of documents you have in the cosmos collection. If the number of documents is more than 1M, then expect it to take 30+ minutes.

 Alternatively you can write a [stored procedure](https://github.com/Azure/azure-cosmosdb-js-server/blob/master/samples/stored-procedures/bulkDelete.js) to cleanup data and use that.


## Prepare for migration
We'll migrate data from new cosmos db to the older db using Azure Data Factory (aka ADF). ADF offers support for both CLI and from azure portal. For this exercise, we'll use azure portal however equivalent CLI commands are also available.

## Start data migration using ADF

Read the overview of ADF [here](https://docs.microsoft.com/en-us/azure/data-factory/introduction#:~:text=Azure%20Data%20Factory%20is%20the,and%20transforming%20data%20at%20scale.).
### Create a data factory Instance
Create the ADF instance by following instructions [here](https://docs.microsoft.com/en-us/azure/data-factory/quickstart-create-data-factory-portal#create-a-data-factory)

### Create a copy activity
Go to the `Author & Monitor` section from your data factory instance.

![image.png](docs/images/backup-restore/monitor-selection.png)

Select the `Copy Data` option.

![image.png](docs/images/backup-restore/copy-data.png)

Provide name and description for your task. Click `Next`

![image.png](docs/images/backup-restore/pipeline-details.png)

### Create a linked service for source

Select the `+ Create New Connection` to create new connection service.

![image.png](docs/images/backup-restore/create-new-connection.png)

Choose Azure Cosmos DB as source activity.

**NOTE**- please choose MongoDB API or SQL API as required. 

![image.png](docs/images/backup-restore/select-source.png)

Fill out required details. Connection settings of the cosmos databases would be picked up automatically.

![image.png](docs/images/backup-restore/select-source-db.png)

Select the containers you want to migrate data from. For your case you want to select all the containers.

![image.png](docs/images/backup-restore/select-containers.png)

### Create a linked service for sink

**NOTE**- please choose MongoDB API or SQL API as required. 

Choose Azure Cosmos DB  as sink activity. Fill out the necessary details. Click `Create` and then click `Next`

![image.png](docs/images/backup-restore/sink-connection.png)

Validate the table mapping. The destination table name would be populated automatically. You can pick the appropriate container from the dropdown if it doesn't populate on it's own.

![image.png](docs/images/backup-restore/table-mapping.png)

Configure logging properties. You can optionally create a linked logging service to persist logs in blobs.

![image.png](docs/images/backup-restore/configurelogging.png)

Review and run.

![image.png](docs/images/backup-restore/review-and-run.png)

You can monitor the pipelines by going to the monitor pivot.

![image.png](docs/images/backup-restore/monitor-pipeline.png)

## Validate the migrated data
Compare the data in target containers with source containers manually to see if the migrated data is what you expect it to be.


## Cleanup the provisioned resources.

Delete the azure data factory that you created in this step to avoid extra cost.
![image.png](docs/images/backup-restore/delete-ADF.png)
