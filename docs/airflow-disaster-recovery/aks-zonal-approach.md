[[_TOC_]]


## Introduction
For our services available across multiple Azs, we need our Gateway and AKS cluster to be available in multiple Zones. This document drafts the different approaches that can be done for achieving it. 

### Using availability zones in nodepool (Implemented)
1.	Enable multiple zones for application gateway using zones property.
2.	Enable multiple availability zones in nodepool for AKS cluster.
3.	Setup cluster to use Redis, Postgres and Storage for Config copy in another region in case of disaster (If this can’t be done than Flows need to be explored to update these endpoints for stateful resource copies in the event of disaster). 

![image.png](docs/images/airflow-dr/aks-appgw-zonal.png)

Pros
•	High availability is maintained with single multi-zone AKS cluster and gateway.
•	No passive cluster needs to be maintained.
Cons
•	Multiple zones in a single region are supported in this. So, its not true disaster resistant.

### Using Azure Front Door/Traffic Manager
Recommended approach as per https://docs.microsoft.com/en-us/azure/aks/operator-best-practices-multi-region.
1.	Setup AFD before the gateway. As Gateway is a regional resource, we would need to create gateways in each region and have them setup as backends to AFD.
2.	Replicate service resources in the standby region.
3.	Configure Standby region to use DR copies of Redis, Storage and Postgres (Needs to be explored).
4.	In case of unavailability of Active Region, Front door will automatically re-route requests to Standby Region.

![image.png](docs/images/airflow-dr/osdu_azure_fd.jpg)
 
Pros
•	High availability maintained with no downtime.
Cons
•	Stand by cluster need to be maintained in another region.
•	Additional cost for AFD.

Flow diagram explaining choice between Traffic Manager and Azure Front Door.

![image.png](docs/images/airflow-dr/atm-vs-azure-fd.png)
 
**The subsequent approaches were explored were insufficient in solving the scenarios. (mostly because gateway is a regional resource or AGIC is part of AKS cluster)**

### Active/Passive with down time using AGIC
1.	Enable multiple zones for application gateway using zones property.
2.	In case of disaster,
a.	Bring up the cluster 

AKS cluster for Airflow:
1. Cluster1 - nodepool - namespaceA - airflow - az1
2. Cluster2 - nodepool - namespaceB - airflow - az2
3. Integration AGIC once Cluster1 is down

### AKS cluster for Airflow:
1. Cluster1 - nodepool1 - namespaceA - airflow - az1
2. Cluster1 - nodepool2 - namespaceA - airflow - az2
3. Integration AGIC once Cluster1 is down

### Replica of all stateless resources except AppGW in another zone and have down time with Active/Passive approach
1.	Enable multiple zones for application gateway using zones property.
2.	In case of disaster,
a.	Use monitoring to detect disaster.
b.	Bring up the 

### Using Istio Ingress in place of AGIC
SLB is already working on a task to remove 
Once SLB changes are done for using Istio Ingress instead of AGIC:
1. Cluster1 - nodepool - namespaceA - airflow - az1
2. Cluster2 - nodepool - namespaceB - airflow - az2
