[[_TOC_]]


## Introduction 
This is a guide documents recovery from Zonal failures. 

## Zonal Resiliency Recovery (Airflow Engine) 

### AKS, AppGateway

For AKS and App Gateway, once Zone Redundancy is enabled, the failover is Automatic in case of a Zonal Failure.

### Redis

For Redis, once Zone Redundancy is enabled, zone-redundant cache runs on VMs spread across multiple Availability Zones. It provides higher resilience and availability and automatically switches zones(failover) in case of a Zonal Failure.

### Storage (FileShare)

With ZRS enabled for Storage accounts, your data is still accessible for both read and write operations even if a zone becomes unavailable. If a zone becomes unavailable, Azure undertakes networking updates, such as DNS re-pointing. These updates may affect your application if you access data before the updates have completed. Once these updates are completed, operations resume as normal."

### PostGres

Zone redundant configuration for PostGres enables automatic failover capability with zero data loss during planned events such as user-initiated scale compute operation, and also during unplanned events such as underlying hardware and software faults, network failures, and availability zone failures.

