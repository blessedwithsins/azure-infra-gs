[[_TOC_]]

## Introduction
This document will walk you through the process of enabling the backup and restore policies in an OSDU deployment as well as the actual restore in case of a disaster.

For existing/ new OSDU deployment, the process is two-fold:
- Configure the appropriate back up policies on your deployment
- Restore data in case of a disaster

## Before starting the dill

### Prerequisites
- Make sure you have an OSDU deployment handy
- The deployment is at least 12 hours old
- Make sure that either you are an admin on the azure subscription or you have a Service Principal with admin access
- You have data handy to validate that the restore is complete successfully. This data could be:
     1. Level 1- Number of records in Cosmos db/ Storage account/ Elasticsearch at point T
     2. Level 2- List of all the document IDs present in the system
     3. Level 3- MD5 hash of records to ensure that data is also the same.

Let's define what certain things mean for our drill-
### Definition of disaster
For current drill, we won't simulate a real world disaster. We'll assume that any data that got ingested in the system after a time `T` is corrupted, hence needs to be restored to a previous point in time. 
**For this drill, we'll use RPO as 12 hours** to keep ourselves in sync with SLAs. Hence before starting the drill, make sure that your deployment is at least 12 hours old and has incoming data. 
### Success criterion
The drill will be called successful if all the documents in storage account, cosmos db and Elasticsearch have been restored successfully and OSDU services are able to consume this data. This is subject to data validation.

In general data validation is manual task and the metrices vary depending upon the degree of sophistication you need. Count of documents coupled with manual inspection of content of sample documents serves well in most of the cases. **For this drill, we'll use document count as a metric to validate the correctness of restore operation.** 

## Configuring Backup/ restore policies

[This wiki](docs/backup-restore/SOPs-for-Enabling-and-Configuring-Backup/Enable-and-configure-Backup-for-OSDU.md) talks about how to enable back up and restore policies. For this drill, we'll enable backup policies on [Cosmos db account](docs/backup-restore/SOPs-for-Enabling-and-Configuring-Backup/Enable-and-configure-Backup-for-OSDU.md#enabling-back-up-for-cosmosdb-account) and [Storage account](docs/backup-restore/SOPs-for-Enabling-and-Configuring-Backup/Enable-and-configure-Backup-for-OSDU.md#enabling-back-up-for-storage-accounts)

## Restoring data
[This wiki](docs/backup-restore/SOPs-for-restoring-partitions/Restore-an-OSDU-partition.md) talks about how you can store the data in an OSDU partition. 

Note that you can restore the data only after back up policies are configured and one round of data back up has been done. If you are using the standard scripts to enable backup policies, you can start with data restore after 12 hours of configuring policies.

## Data validation
Validate the data manually based on the criterion defined previously.

## After the drill
Document the findings from this drill here.
### Identified gaps in documentation
### Identified gaps in process
### Identified bugs

## FAQs

## Appendix
[Spec](/Backup-and-restore-on-OSDU-phase-1)




