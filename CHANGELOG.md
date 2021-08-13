**Note:** This file is manually edited and is best effort information at this time.

# Current Master

# v0.10.0 (2021-8-8)

__Infra Changes__
- [[Breaking Change] Zonal Redundancy for Airflow](https://community.opengroup.org/osdu/platform/deployment-and-operations/infra-azure-provisioning/-/issues/181)
- [Zonal Redundancy for Redis](https://community.opengroup.org/osdu/platform/deployment-and-operations/infra-azure-provisioning/-/issues/180)
- [Zonal redundancy for AKS and App Gateway](https://community.opengroup.org/osdu/platform/deployment-and-operations/infra-azure-provisioning/-/issues/179)

__Feature Changes__
- Added Retries and Logging for Legal Tags Cronjob
- Added Node.js application for LegalTags Update CRON Job

# v0.9.1 (2021-6-27)

__Service Onboarded__
- [Issue 95 - Policy Service](https://community.opengroup.org/osdu/platform/deployment-and-operations/infra-azure-provisioning/-/issues/95)

__Feature Changes__
- [Feature 142 - Added support for array of object search](https://community.opengroup.org/osdu/platform/system/indexer-service/-/merge_requests/142)
- [Feature 121 - Added support for nested search](https://community.opengroup.org/osdu/platform/system/search-service/-/merge_requests/121)

__Infra Changes__
- AKS version upgrade to 1.19.11
- [Feature 277 - Alerts framework for Monitoring](https://community.opengroup.org/osdu/platform/deployment-and-operations/infra-azure-provisioning/-/merge_requests/277)
- [Feature 169 - Container hardening for Java based services](https://community.opengroup.org/osdu/platform/deployment-and-operations/infra-azure-provisioning/-/issues/169)
- [Feature 159 - Added default JVM Parameters](https://community.opengroup.org/osdu/platform/deployment-and-operations/infra-azure-provisioning/-/issues/159)
- [Issue 163 - Architecture change- service resources- Add cosmos db and Storage account](https://community.opengroup.org/osdu/platform/deployment-and-operations/infra-azure-provisioning/-/issues/163)

# v0.8 (2021-4-9)

__Infra Changes__
- [Operationalize 104 - Backup and Restore](https://community.opengroup.org/osdu/platform/deployment-and-operations/infra-azure-provisioning/-/issues/104)
- [Feature 115 - Enable Custom HTTPS Certificates](https://community.opengroup.org/osdu/platform/deployment-and-operations/infra-azure-provisioning/-/issues/115)
- [Feature 121 - Added Default Dashboard](https://community.opengroup.org/osdu/platform/deployment-and-operations/infra-azure-provisioning/-/issues/121)
- [Feature 149 - Make auto-scale parameters of App Gateway configurable](https://community.opengroup.org/osdu/platform/deployment-and-operations/infra-azure-provisioning/-/issues/149)

# v0.7 (2021-3-11)

__Service Onboarded__
- [Issue 81 - Entitlements V2](https://community.opengroup.org/osdu/platform/deployment-and-operations/infra-azure-provisioning/-/issues/81)
  > Not integrated yet to other services until M5.

__Bug Fixes__
- [Bug 130 - Variable Script Change Indexer Service - STORAGE_QUERY_RECORD_HOST](https://community.opengroup.org/osdu/platform/deployment-and-operations/infra-azure-provisioning/-/issues/130)
- [Bug 129 - Envoy Filters Indentation formating](https://community.opengroup.org/osdu/platform/deployment-and-operations/infra-azure-provisioning/-/issues/129)
- [Bug 124 - Documentation SDMS](https://community.opengroup.org/osdu/platform/deployment-and-operations/infra-azure-provisioning/-/issues/124)
- [Bug 119 - Add Airflow python package `python-keycloak`](https://community.opengroup.org/osdu/platform/deployment-and-operations/infra-azure-provisioning/-/issues/119)


__Infra Changes__
- [Issue 135 - Airflow Default Variables](https://community.opengroup.org/osdu/platform/deployment-and-operations/infra-azure-provisioning/-/issues/135)
- [Arch 123 - Obsolete Cosmos DB Tables and add new v2 tables](https://community.opengroup.org/osdu/platform/deployment-and-operations/infra-azure-provisioning/-/issues/123)
- [Issue 127](https://community.opengroup.org/osdu/platform/deployment-and-operations/infra-azure-provisioning/-/issues/127)
- [Feature 126 - Add support to pass JAVA_OPTS to java command in DockerFile](https://community.opengroup.org/osdu/platform/deployment-and-operations/infra-azure-provisioning/-/issues/126)
- [Feature 125 - Enable Manifest Ingestion](https://community.opengroup.org/osdu/platform/deployment-and-operations/infra-azure-provisioning/-/issues/125)


# v0.5 (2021-2-11)

__Service Onboarded__
- [Issue 60 - Seismic DMS Service](https://community.opengroup.org/osdu/platform/deployment-and-operations/infra-azure-provisioning/-/issues/44)
- [Issue 111 - CSV DAGS](https://community.opengroup.org/osdu/platform/deployment-and-operations/infra-azure-provisioning/-/issues/111)

__Infra Changes__
- [Issue 106 - Arch Change - Data Partition - Ingestion Workflow Database and Storage new collections and fileshares](https://community.opengroup.org/osdu/platform/deployment-and-operations/infra-azure-provisioning/-/issues/106)

__Bug Fixes__
- [Bug 109 - Add Entitlement Role](https://community.opengroup.org/osdu/platform/deployment-and-operations/infra-azure-provisioning/-/issues/109#related-issues)
- [Bug 108 - Add VM Agent Max Nodes Option](https://community.opengroup.org/osdu/platform/deployment-and-operations/infra-azure-provisioning/-/issues/108)
- [Bug 103 - Enable opt-in airflow ui ingress](https://community.opengroup.org/osdu/platform/deployment-and-operations/infra-azure-provisioning/-/issues/103)
- [Bug 102 - Users with a lot of groups receive a 400 Bad Request when making API calls](https://community.opengroup.org/osdu/platform/deployment-and-operations/infra-azure-provisioning/-/issues/102)
- [Bug 101 - Comsos Graph module always requires a change on tf plan](https://community.opengroup.org/osdu/platform/deployment-and-operations/infra-azure-provisioning/-/issues/101)
- [Bug 100 - Airflow statsd not building in pipeline](https://community.opengroup.org/osdu/platform/deployment-and-operations/infra-azure-provisioning/-/issues/100)
- [Bug 99 - AKS and Postgres Diagnostics - All Metrics](https://community.opengroup.org/osdu/platform/deployment-and-operations/infra-azure-provisioning/-/issues/99)
- [Bug 97 - Rename Cosmos DB collections used by Schema Service](https://community.opengroup.org/osdu/platform/deployment-and-operations/infra-azure-provisioning/-/issues/97)


# v0.4.3 (2021-1-25)

__Service Onboarded__
- [Issue 60 - Schema Service](https://community.opengroup.org/osdu/platform/deployment-and-operations/infra-azure-provisioning/-/issues/60)
- [Issue 65 - CRS Conversion Service](https://community.opengroup.org/osdu/platform/deployment-and-operations/infra-azure-provisioning/-/issues/65)
- [Issue 53 - WKS Service](https://community.opengroup.org/osdu/platform/deployment-and-operations/infra-azure-provisioning/-/issues/53)
- [Issue 43 - Workflow Service](https://community.opengroup.org/osdu/platform/deployment-and-operations/infra-azure-provisioning/-/issues/43)


__Infra Changes__
- [Issue 75 - Upgrade Infrastructure tools and software dependencies](https://community.opengroup.org/osdu/platform/deployment-and-operations/infra-azure-provisioning/-/issues/75)  - _* Manual Intervention Required_
- [Issue 76 - Add Terraform Service Resource Template Feature Flags](https://community.opengroup.org/osdu/platform/deployment-and-operations/infra-azure-provisioning/-/issues/76)
- [Issue 80 - Feature Change - Data Partition - Enable CORS configuration for Blob Containers on Storage Accounts](https://community.opengroup.org/osdu/platform/deployment-and-operations/infra-azure-provisioning/-/issues/80)
- [Issue 77 - Architecture Change - Central Resources - Add Graph Database](https://community.opengroup.org/osdu/platform/deployment-and-operations/infra-azure-provisioning/-/issues/77)
- [Issue 84 - Architecture Change - Data Partition - Add dedicated Storage Account for use by Ingestion Service](https://community.opengroup.org/osdu/platform/deployment-and-operations/infra-azure-provisioning/-/issues/84/)

__Bug Fixes__
- [Bug 82 - AKS Template Plan Calculation](https://community.opengroup.org/osdu/platform/deployment-and-operations/infra-azure-provisioning/-/issues/82)
- [Bug 90 - Indexer Service ADO Pipeline](https://community.opengroup.org/osdu/platform/deployment-and-operations/infra-azure-provisioning/-/issues/90)
- [Bug 92 - CRS Conversion File Shares](https://community.opengroup.org/osdu/platform/deployment-and-operations/infra-azure-provisioning/-/issues/92)
- [Bug 94 - AKS Default Node Pool Disk Size](https://community.opengroup.org/osdu/platform/deployment-and-operations/infra-azure-provisioning/-/issues/94)



# v0.4.2 (2020-12-30)

__Service Onboarded__
- [Issue 55 - Unit Service](https://community.opengroup.org/osdu/platform/deployment-and-operations/infra-azure-provisioning/-/issues/55)
- [Issue 56 - CRS Catalog Service](https://community.opengroup.org/osdu/platform/deployment-and-operations/infra-azure-provisioning/-/issues/56)
- [Issue 54 - Register Service](https://community.opengroup.org/osdu/platform/deployment-and-operations/infra-azure-provisioning/-/issues/54)
- [Issue 52 - Notification Service](https://community.opengroup.org/osdu/platform/deployment-and-operations/infra-azure-provisioning/-/issues/52)

__Documentation Changes__
- [MR 90 - Documentation Tweaks and Fixing Environment Variables](https://community.opengroup.org/osdu/platform/deployment-and-operations/infra-azure-provisioning/-/merge_requests/90)
- [MR 92 - Airflow APACHE Licenses](https://community.opengroup.org/osdu/platform/deployment-and-operations/infra-azure-provisioning/-/merge_requests/92)
- [MR 94 - Fixing File Pipeline and Search URL Variable](https://community.opengroup.org/osdu/platform/deployment-and-operations/infra-azure-provisioning/-/merge_requests/94)
- [MR 95 - Updating Service Onboarding](https://community.opengroup.org/osdu/platform/deployment-and-operations/infra-azure-provisioning/-/merge_requests/95)
- [MR 103 - Updating Service Onboarding Template](https://community.opengroup.org/osdu/platform/deployment-and-operations/infra-azure-provisioning/-/merge_requests/103)
- [MR 108 - Initial FAQ](https://community.opengroup.org/osdu/platform/deployment-and-operations/infra-azure-provisioning/-/merge_requests/108)


__Chart Changes__
- [MR 110 - Airflow log monitoring](https://community.opengroup.org/osdu/platform/deployment-and-operations/infra-azure-provisioning/-/merge_requests/110)


__Tool Changes__
- [MR 101 - Partition Service Support - Storage Service](https://community.opengroup.org/osdu/platform/deployment-and-operations/infra-azure-provisioning/-/merge_requests/101)
- [MR 118 - Python Testing Variables](https://community.opengroup.org/osdu/platform/deployment-and-operations/infra-azure-provisioning/-/merge_requests/118)


__Infra Changes__
- [MR 97 - Adding a service Bus topic - WKS Service](https://community.opengroup.org/osdu/platform/deployment-and-operations/infra-azure-provisioning/-/merge_requests/97)
- [MR 99 - Adding KV Secret for Event Grid Topic Primary Keys - Storage Service](https://community.opengroup.org/osdu/platform/deployment-and-operations/infra-azure-provisioning/-/merge_requests/99)



# v0.4.1 (2020-11-30)

__Description__

_Additional Services Added._

__Branch/Tag__

[tag/0.4.1](https://community.opengroup.org/osdu/platform/deployment-and-operations/infra-azure-provisioning/-/tags/v0.4.1)


__Images__

| Service | Image | Tag |
| ------- | ----- | --- |
| Partition     | `community.opengroup.org:5555/osdu/platform/system/partition/partition-master` | 3a50a7048c7dd39ef689e87af6ee745f5a57b3b3 |
| Entitlements  | `community.opengroup.org:5555/osdu/platform/security-and-compliance/entitlements-azure/entitlements-azure-master` | 70b889b47be7ed01956db0305ad888e61e06387c |
| Legal         | `community.opengroup.org:5555/osdu/platform/security-and-compliance/legal/legal-master` | 70abc2ab72050a9795e63d6900f2b5f825173ad7 |
| Storage       | `community.opengroup.org:5555/osdu/platform/system/storage/storage-master` | 93b5636ba43bcd907c34ba61fcc00aba47349597 |
| Indexer-Queue | `community.opengroup.org:5555/osdu/platform/system/indexer-queue/indexer-queue-master` | 4b56366f90f2fb6ba904ab9ba672a0595e9a6a4b |
| Indexer       | `community.opengroup.org:5555/osdu/platform/system/indexer-service/indexer-service-master` | f0699e2af5e96eb1e853d6785f9abe97e87ba39d |
| Search        | `community.opengroup.org:5555/osdu/platform/system/search-service/search-service-master` | c42afcb11c0b36229cc2b2803f4e15958232d95a |
| Delivery      | `community.opengroup.org:5555/osdu/platform/system/delivery/delivery-master` | 16a935048c6e9ace219d08fd3feb718a4b1d7abf |
| File          | `community.opengroup.org:5555/osdu/platform/system/file/file-master` | 1144aa06e6b70df8e1c06ccc6331cb78a79951cc |


__Infrastructure Support__

- Airflow

__Devops Support__

- Airflow
- Python Testing Tasks

__Chart Support__

- osdu-airflow

__New Services__

- [Delivery](https://community.opengroup.org/osdu/platform/deployment-and-operations/infra-azure-provisioning/-/issues/21)
- [File](https://community.opengroup.org/osdu/platform/deployment-and-operations/infra-azure-provisioning/-/issues/40)



# v0.4.0 (2020-11-12)

__Description__

_Milestone 1 Tag Generated across all services._

__Branch/Tag__

[release/0.4](https://community.opengroup.org/osdu/platform/deployment-and-operations/infra-azure-provisioning/-/tree/release/0.4)

__Images__

| Service | Image | Tag |
| ------- | ----- | --- |
| Partition     | `community.opengroup.org:5555/osdu/platform/system/partition/partition-release-0-4` | 81976630aa9de9abd508a32a7f0ef1f9a773a1ab |
| Entitlements  | `community.opengroup.org:5555/osdu/platform/security-and-compliance/entitlements-azure/entitlements-azure-release-0-4` | 32fb4035378213354dedb90bb1549deb44e5f2df |
| Legal         | `community.opengroup.org:5555/osdu/platform/security-and-compliance/legal/legal-release-0-4` | 96dd3c699e0fa344a69e63acd75c83bafadab94f |
| Storage       | `community.opengroup.org:5555/osdu/platform/system/storage/storage-release-0-4` | 4eb302c39db1956d2e5098ec87399526176d14a5 |
| Indexer-Queue | `community.opengroup.org:5555/osdu/platform/system/indexer-queue/indexer-queue-release-0-4` | a3ea5d8629fed60058332672d7b871606041ee96 |
| Indexer       | `community.opengroup.org:5555/osdu/platform/system/indexer-service/indexer-service-release-0-4` | c1cde375c3c76e84290efb63405edf81ec964ff3 |
| Search        | `community.opengroup.org:5555/osdu/platform/system/search-service/search-service-release-0-4` | 834269ff32812c3cdfc42f315d3c7eb01fda622e |

__Infrastructure__

This infrastructure release is the initial porting of infrastructure from Github to Gitlab.

- Common Resources creation script
- Terraform Modules to support MVP Architecture
- Terraform Template osdu-r3-mvp/central_resources
- Terraform Template osdu-r3-mvp/data-partition
- Terraform Template osdu-r3-mvp/service-resources


__Devops__

- Common Devops Tasks and Templates to Support Infrastructure, Charts and Services
- Infrastructure Pipelines
- Custom Pipelines


__Charts__

- osdu-common
- osdu-istio
- osdu-istio-auth


__New Services__

- Partition
- Entitlements
- Legal
- Storage
- Indexer-Queue
- Indexer
- Search
