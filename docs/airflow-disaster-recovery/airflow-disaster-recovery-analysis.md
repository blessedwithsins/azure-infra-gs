[[_TOC_]]


## Introduction 
This is a guide on how to make our current Airflow resources resilient to disaster scenarios. 

## Disaster Management and Recovery (Airflow Engine) 
 
### Requirements 

1. 	Airflow is deployed on K8S, hence in case of zonal failures, K8S should support zonal recovery.  
  - Worker node, Web server, scheduler should be recoverable to support business continuity.  
2. 	Airflow storage requirements to be recoverable from Zonal failures
  - RDBMS (PostGres) for metadata:
    State of airflow workflows is maintained in Postgres. So, we need to setup a data sync for Postgres to a Postgres in another region.
  - Queues (Azure Redis) for task submission:
    Workflow run tasks are queued for Airflow scheduler to pick.
  - DAGs (Storage File Share) for storing DAGs:
    DAGs submitted to airflow and other configs are maintained in storage account.


| Component | Deployed | Failover Support |
| ------ | ------ | ------ |
| K8s | Central US | NO |
| Worker Node | Central US | Local, Will come with K8s Zonal support |
| Web Server | Central US | Local, Will come with K8s Zonal support |
| Scheduler | Central US | Local, Will come with K8s Zonal support |
| PostGres | Central US | GeoRestore Enabled |
| AzureRedis | Central US | Local Replica |
| Storage | Central US | LRS |


### Infra Code for provisioning

#### AKS
As ACR, KV, Pipelines are in Central Resources and hence DR for them is not assumed. Failure of central resources is agreed upon as failure of the system. 
For AKS, a manual deployment will be required for DR purposes for now.
Manual Deployment:
Set variable `AZURE_LOCATION` = “EastUS2” then call ‘./common_prepare.sh’
Pipeline:
Update environment variable ‘TF_VAR_resource_group_location’ to “EastUS2”.

#### POSTGRES
Already Geo Redundant.

#### REDIS
Change sku_name to “Premium” instead on “Standard” in tfvars file.
variable "sku_name" {
  description = "The Azure Cache for Redis pricing tier. Possible values are Basic, Standard and Premium. Azure currently charges by the minute for all pricing tiers."
  type        = string
  default     = "Standard"
}

#### STORAGE
/infra-azure-provisioning?path=%2Finfra%2Ftemplates%2Fosdu-r3-mvp%2Fservice_resources%2Fvariables.tf
Provision Infra using ‘RAGRS’ for Geo-Replication
variable "replication_type" {
  description = "Defines the type of replication to use for this storage account. Valid options are LRS*, GRS, RAGRS and ZRS."
  type        = string
  default     = "LRS"
}
 
## AKS GEO-REPLICATION 
 
Unlike other Azure services such as CosmosDB, Azure Kubernetes Service (AKS) clusters cannot span multiple regions. Instead, web traffic must be routed to the applications in these clusters using global services like Azure Front Door or Traffic Manager 
This makes it very challenging to design secure, scalable, and well-governed AKS clusters on these Azure Landing Zones. It takes time, buy-in, and planning to design clusters at this scale. There can also be a significant lead time for application teams to leverage these AKS clusters. 
In many cases, application teams across the enterprise will end up deploying their own AKS clusters for their application instead of waiting for a well-designed solution. This is called physical isolation, and it is not recommended. In addition to increasing attack surface and the complexity of managing many different AKS clusters within an organization, it also limits one of the main benefits of Kubernetes - automated bin packing. 
AKS AT THE ENTERPRISE 

![image.png](docs/images/airflow-dr/aks-enterprise-grade.png)

In non-trivial scenarios, it is likely that an enterprise-grade, multi-regional AKS design will require: 	
- Strong Azure foundations including proper Azure subscription design, deployment automation, and centralized identity, permissions, policies, and other governance aspects 	
- Integration with third-party firewall appliances from vendors such as Palo Alto Networks or Barracuda Networks. 
- Sufficient planning to enable several teams across multiple business units to use the same AKS clusters and leverage logical isolation. 
- GitOps deployment methodologies to synchronize configuration between regional clusters. 
- Additional planning to enable teams to use the same Azure Container Registry that is geo-replicated to several Azure regions closest to the AKS clusters. 
- Well-designed hub/spoke architecture to enable Central IT teams to centrally monitor, govern, and secure workloads across various business units and teams. 
 
## POSTGRESQL GEO REPLICATION 
 
Azure Database for PostgreSQL provides business continuity features that include geo-redundant backups with the ability to initiate geo-restore, and deploying read replicas in a different region. Each has different characteristics for the recovery time and the potential data loss. With Geo-restore feature, a new server is created using the backup data that is replicated from another region. The overall time it takes to restore and recover depends on the size of the database and the amount of logs to recover. The overall time to establish the server varies from few minutes to few hours. With read replicas, transaction logs from the primary are asynchronously streamed to the replica. In the event of a primary database outage due to a zone-level or a region-level fault, failing over to the replica provides a shorter RTO and reduced data loss. 

### GEO-RESTORE 
The geo-restore feature restores the server using geo-redundant backups. The backups are hosted in your server's paired region. You can restore from these backups to any other region. The geo-restore creates a new server with the data from the backups. Learn more about geo-restore from the backup and restore concepts article. 

### CROSS-REGION READ REPLICAS 
You can use cross region read replicas to enhance your business continuity and disaster recovery planning. Read replicas are updated asynchronously using PostgreSQL's physical replication technology and may lag the primary. Learn more about read replicas, available regions, and how to fail over from the read replicas concepts article. 

    https://docs.microsoft.com/en-us/azure/postgresql/concepts-business-continuity 
    https://docs.microsoft.com/en-us/azure/postgresql/concepts-read-replicas 
    https://docs.microsoft.com/en-us/azure/postgresql/concepts-backup 
    https://docs.microsoft.com/en-us/azure/postgresql/howto-restore-server-portal 
 
## REDIS GEO REPLICATION 
 
Geo-replication links together two Premium Azure Cache for Redis instances and creates a data replication relationship. These cache instances are usually located in different Azure regions, though they aren't required to. One instance acts as the primary, and the other as the secondary. The primary handles read and write requests and propagates changes to the secondary. This process continues until the link between the two instances is removed. 

 Note 
Geo-replication is designed as a disaster-recovery solution. 

### GEO-REPLICATION PREREQUISITES 

To configure geo-replication between two caches, the following prerequisites must be met: 
- Both caches are Premium tier caches. 
- Both caches are in the same Azure subscription. 
- The secondary linked cache is either the same cache size or a larger cache size than the primary linked cache. 
- Both caches are created and in a running state. 

Some features aren't supported with geo-replication: 
- Persistence isn't supported with geo-replication. 
- Clustering is supported if both caches have clustering enabled and have the same number of shards. 
- Caches in the same VNET are supported. 
- Caches
 in different VNETs are supported with caveats. See Can I use geo-replication with my caches in a VNET? for more information.

After geo-replication is configured, the following restrictions apply to your linked cache pair: 	
- The secondary linked cache is read-only; you can read from it, but you can't write any data to it. 
- Any data that was in the secondary linked cache before the link was added is removed. If the geo-replication is later removed
however, the replicated data remains in the secondary linked cache. 
- You can't scale either cache while the caches are linked. 
- You can't change the number of shards if the cache has clustering enabled. 
- You can't enable persistence on either cache. 
- You can Export from either cache. 
- You can't Import into the secondary linked cache. 
- You can't delete either linked cache, or the resource group that contains them, until you unlink the caches. For more information, see Why did the operation fail when I tried to delete my linked cache? 
- If the caches are in different regions, network egress costs apply to the data moved across regions. For more information, see How much does it cost to replicate my data across Azure regions? 
- Automatic failover doesn't occur between the primary and secondary linked cache. For more information and information on how to failover a client application, see How does failing over to the secondary linked cache work? 
    a.	No downtime while linking 
    b.	Both caches must be in the same Azure subscription. 
    c.	Replication is continuous and asynchronous and doesn't happen on a specific schedule. All the writes done to the primary are instantaneously and asynchronously replicated on the secondary. 
    d.	Pricing across region data transfer: https://azure.microsoft.com/en-us/pricing/details/bandwidth/ 
 
HOW DOES FAILING OVER TO THE SECONDARY LINKED CACHE WORK? 

Automatic failover across Azure regions isn't supported for geo-replicated caches. In a disaster-recovery scenario, customers should bring up the entire application stack in a coordinated manner in their backup region. Letting individual application components decide when to switch to their backups on their own can negatively impact performance. One of the key benefits of Redis is that it's a very low-latency store. If the customer's main application is in a different region than its cache, the added round-trip time would have a noticeable impact on performance. For this reason, we avoid failing over automatically because of transient availability issues. 
To start a customer-initiated failover, first unlink the caches. Then, change your Redis client to use the connection endpoint of the (formerly linked) secondary cache. When the two caches are unlinked, the secondary cache becomes a regular read-write cache again and accepts requests directly from Redis clients. 
    
    Pricing:
    https://azure.microsoft.com/en-us/pricing/details/bandwidth/
    
    https://docs.microsoft.com/en-us/azure/azure-cache-for-redis/cache-how-to-geo-replication#how-much-does-it-cost-to-replicate-my-data-across-azure-regions 
    https://docs.microsoft.com/en-us/azure/azure-cache-for-redis/cache-overview 

 
## STORAGE GEO REPLICATION 
 
Azure Storage maintains multiple copies of your storage account to ensure durability and high availability. Which redundancy option you choose for your account depends on the degree of resiliency you need. For protection against regional outages, configure your account for geo-redundant storage, with or without the option of read access from the secondary region: 
Geo-redundant storage (GRS) or geo-zone-redundant storage (GZRS) copies your data asynchronously in two geographic regions that are at least hundreds of miles apart. If the primary region suffers an outage, then the secondary region serves as a redundant source for your data. You can initiate a failover to transform the secondary endpoint into the primary endpoint. 
Read-access geo-redundant storage (RA-GRS) or read-access geo-zone-redundant storage (RA-GZRS) provides geo-redundant storage with the additional benefit of read access to the secondary endpoint. If an outage occurs in the primary endpoint, applications configured for read access to the secondary and designed for high availability can continue to read from the secondary endpoint. Microsoft recommends RA-GZRS for maximum availability and durability for your applications. 
 
### UNDERSTAND THE ACCOUNT FAILOVER PROCESS 

Customer-managed account failover enables you to fail your entire storage account over to the secondary region if the primary becomes unavailable for any reason. When you force a failover to the secondary region, clients can begin writing data to the secondary endpoint after the failover is complete. The failover typically takes about an hour. 
 
    https://docs.microsoft.com/en-us/azure/storage/common/redundancy-migration?tabs=portal 
    https://docs.microsoft.com/en-us/azure/storage/common/storage-redundancy 
 
 


