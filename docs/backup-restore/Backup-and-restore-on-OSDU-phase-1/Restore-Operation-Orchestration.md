[[_TOC_]]


## Introduction 
This is a guide on how to make the drill safe and effective. It is highly recommended to follow the steps below even during the mock restore drills. 

## When a restore is needed.
Once an incident is reported, perform the following steps. 

### Build a team for recovery. 
A single click restore is the north star, but we are a work in progress. As of today, a restore operation is a complicated task. Hence, it is advisable to have a team to perform it. You might want to put together a team for the following reasons.
-  To make sure a single person doesn't get fatigued from performing multi-step recovery in a high-stress situation. Fatigue will not only impact performance but will also increase the probability of human error. This will also decrease the context switch a person has to make, in order to parallelize the operation.
- There is a certain degree of parallel progress you can make for the restore, which will cut down your ETA. For each stream, you can deploy an engineer who has relevant expertise. 

You can use the table below to set up a team of recovery engineers.

|Stream|Expertise |Depends on|Resouces|Engineers Identified |
|--|--|--|--|--|
|Orchestration|Can function as the PoC. Has RBAC to all. Can approve, validate and coordinate the steps performed by all the restore engineers. In case of mock drills, induce data corruption. |None|[SOP-restore-an-OSDU-partition](docs/backup-restore/SOPs-for-restoring-partitions/Restore-an-OSDU-partition.md),  [Back up and restore drill](docs/backup-restore/Backup-and-restore-on-OSDU-phase-1/Backup-and-restore-drill.md)|
|AKS|Basics of AKS, az CLI, Azure KV|None|[SOP-restore-an-OSDU-partition](docs/backup-restore/SOPs-for-restoring-partitions/Restore-an-OSDU-partition.md)|
|CosmosDB restore |SQL, Azure KV, Basics of CosmosDB |AKS | [SOP-restore-an-OSDU-partition](docs/backup-restore/SOPs-for-restoring-partitions/Restore-an-OSDU-partition.md)|
|Storage Account restore | Azure KV, Basic understanding of Storage Account |AKS| [SOP-restore-an-OSDU-partition](docs/backup-restore/SOPs-for-restoring-partitions/Restore-an-OSDU-partition.md)|
|Elastic restore|Basics of ES, Indexer Service,  Search service. |All of the above| [SOP-restore-an-OSDU-partition](docs/backup-restore/SOPs-for-restoring-partitions/Restore-an-OSDU-partition.md)|



### Seal all other partitions. 
Use RBAC to make sure all the engineers on the panel have RBAC to just the partition impacted. [Here](https://docs.microsoft.com/en-us/azure/role-based-access-control/role-assignments-portal) is the documentation that guides you through the process. This will safeguard all the other partitions. Make sure you do this step before you bring in restore engineers. 

### Make a communication channel
Make sure there is a communication channel established for the engineers across the streams to collaborate and share progress. This could be a slack channel, a Teams channel, or an email stream. 

### Set up a documentation guide for the team
The idea of documentation is to capture the series of steps taken. This information can come in handy when you want to perform a postmortem. Feel free to utilize the ICM system, Teams' document share etc.



## After the restore. 
It is time for you to collect the documentation and refine the process. After the drill is complete, set up some time with the restore crew to analyze the process. List down your learnings and share them with the community. 

