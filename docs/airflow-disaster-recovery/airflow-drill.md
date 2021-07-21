## Zonal Resiliency Drill

### AKS
1.	Deletion of default nodepool along with removal of default nodepool’s zone from the internal nodepool. Using this type of testing distorts the terraform state and may cause the user to recreate entire service resource again. 
Following steps can be taken:
    - 	Change the availability zones in internal nodepool such that availability zones aren’t intersecting between internal and default nodepool.
    - Verify that pods in workload section of AKS on azure portal are spread across both nodepools.
    - Delete the one of the nodepool.
    - Post deletion successful, verify that pods get rescheduled to the nodepool in another zone.

2.	Migrate pods from multiple zones to one:
    - Make sure that internal nodepool and default nodepool are configured for more than 1 availability zone.
    - Verify that pods in workload section of AKS on azure portal are spread across nodepool.
    - Change the internal nodepool’s availability zone and make its value equal to the availability zone in default nodepool.
    - Verify that pods are migrated to the common availability zone.

Azure manages zonal resiliency for AKS/Storage Account/PostGres/Redis

## Back up drill

### Storage Account
 
https://community.opengroup.org/osdu/platform/deployment-and-operations/infra-azure-provisioning/-/blob/master/docs/backup-restore/SOPs-for-Enabling-and-Configuring-Backup/Enable-and-configure-Backup-for-OSDU.md#introduction

### PostGres

https://docs.microsoft.com/en-us/azure/postgresql/howto-restore-server-portal

### Redis

https://docs.microsoft.com/en-us/azure/azure-cache-for-redis/cache-how-to-premium-persistence
