//  Copyright © Microsoft Corporation
//
//  Licensed under the Apache License, Version 2.0 (the "License");
//  you may not use this file except in compliance with the License.
//  You may obtain a copy of the License at
//
//       http://www.apache.org/licenses/LICENSE-2.0
//
//  Unless required by applicable law or agreed to in writing, software
//  distributed under the License is distributed on an "AS IS" BASIS,
//  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//  See the License for the specific language governing permissions and
//  limitations under the License.

/*
.Synopsis
   Terraform Variable Configuration
.DESCRIPTION
   This file holds the Default Variable Configuration
*/

/*
The following items are recommended to override in custom.tfvars

1. Resource Tags
2. Cosmos Database Throughput  ** Increase as necessary for Scaling purposes.

*/

prefix = "osdu-mvp"

data_partition_name = "opendes"

resource_tags = {
  contact = "pipeline"
}

# Storage Settings
storage_replication_type = "GZRS"
storage_containers = [
  "legal-service-azure-configuration",
  "opendes",
  "osdu-wks-mappings",
  "wdms-osdu",
  "file-staging-area",
  "file-persistent-area"
]
storage_containers_dp_airflow = [
  "airflow-logs"
]

# Database Settings
cosmosdb_consistency_level = "Session"
cosmos_databases = [
  {
    name       = "osdu-db"
    throughput = 12000
  },
  {
    name       = "status-db"
    throughput = 12000
  }
]

## Currently a strategy is in place for a period of time to not remove old collections no longer in use.
### Obsolete Tables
# - Workflow
# - WorkflowStatus
# - WorkflowRun
# - WorkflowTasksSharingInfo
## See override.tfvars for Greenfield DB setup.
cosmos_sql_collections = [
  {
    name                  = "LegalTag"
    database_name         = "osdu-db"
    partition_key_path    = "/id"
    partition_key_version = null
  },
  {
    name                  = "StorageRecord"
    database_name         = "osdu-db"
    partition_key_path    = "/id"
    partition_key_version = null
  },
  {
    name                  = "StorageSchema"
    database_name         = "osdu-db"
    partition_key_path    = "/kind"
    partition_key_version = null
  },
  {
    name                  = "TenantInfo"
    database_name         = "osdu-db"
    partition_key_path    = "/id"
    partition_key_version = null
  },
  {
    name                  = "UserInfo"
    database_name         = "osdu-db"
    partition_key_path    = "/id"
    partition_key_version = null
  },
  {
    name                  = "Authority"
    database_name         = "osdu-db"
    partition_key_path    = "/id"
    partition_key_version = null

  },
  {
    name                  = "EntityType"
    database_name         = "osdu-db"
    partition_key_path    = "/id"
    partition_key_version = null
  },
  {
    name                  = "SchemaInfo"
    database_name         = "osdu-db"
    partition_key_path    = "/partitionId"
    partition_key_version = null
  },
  {
    name                  = "Source"
    database_name         = "osdu-db"
    partition_key_path    = "/id"
    partition_key_version = null
  },
  {
    name                  = "RegisterAction"
    database_name         = "osdu-db"
    partition_key_path    = "/dataPartitionId"
    partition_key_version = null
  },
  {
    name                  = "RegisterDdms"
    database_name         = "osdu-db"
    partition_key_path    = "/dataPartitionId"
    partition_key_version = null
  },
  {
    name                  = "RegisterSubscription"
    database_name         = "osdu-db"
    partition_key_path    = "/dataPartitionId"
    partition_key_version = null
  },
  {
    name                  = "IngestionStrategy"
    database_name         = "osdu-db"
    partition_key_path    = "/workflowType"
    partition_key_version = null
  },
  {
    name                  = "WorkflowStatus"
    database_name         = "osdu-db"
    partition_key_path    = "/workflowId"
    partition_key_version = null
  },
  {
    name                  = "Workflow"
    database_name         = "osdu-db"
    partition_key_path    = "/workflowId"
    partition_key_version = null
  },
  {
    name                  = "WorkflowRun"
    database_name         = "osdu-db"
    partition_key_path    = "/workflowId"
    partition_key_version = null
  },
  {
    name                  = "RelationshipStatus"
    database_name         = "osdu-db"
    partition_key_path    = "/id"
    partition_key_version = null
  },
  {
    name                  = "MappingInfo"
    database_name         = "osdu-db"
    partition_key_path    = "/sourceSchemaKind"
    partition_key_version = null
  },
  {
    name                  = "WorkflowTasksSharingInfo"
    database_name         = "osdu-db"
    partition_key_path    = "/workflowId"
    partition_key_version = null
  },
  {
    name                  = "FileLocationEntity"
    database_name         = "osdu-db"
    partition_key_path    = "/id"
    partition_key_version = null
  },
  {
    name                  = "WorkflowCustomOperatorInfo"
    database_name         = "osdu-db"
    partition_key_path    = "/operatorId"
    partition_key_version = null
  },
  {
    name                  = "WorkflowV2"
    database_name         = "osdu-db"
    partition_key_path    = "/partitionKey"
    partition_key_version = 2
  },
  {
    name                  = "WorkflowRunV2"
    database_name         = "osdu-db"
    partition_key_path    = "/partitionKey"
    partition_key_version = 2
  },
  {
    name                  = "WorkflowCustomOperatorV2"
    database_name         = "osdu-db"
    partition_key_path    = "/partitionKey"
    partition_key_version = 2
  },
  {
    name                  = "WorkflowTasksSharingInfoV2"
    database_name         = "osdu-db"
    partition_key_path    = "/partitionKey"
    partition_key_version = 2
  },
  {
    name                  = "Status"
    database_name         = "status-db"
    partition_key_path    = "/correlationId"
    partition_key_version = null
  },
  {
    name                  = "DataSetDetails"
    database_name         = "status-db"
    partition_key_path    = "/correlationId"
    partition_key_version = null
  }
]


# Service Bus Settings
sb_topics = [
  {
    name                = "indexing-progress"
    enable_partitioning = true
    subscriptions = [
      {
        name               = "indexing-progresssubscription"
        max_delivery_count = 5
        lock_duration      = "PT5M"
        forward_to         = ""
      }
    ]
  },
  {
    name                = "legaltags"
    enable_partitioning = true
    subscriptions = [
      {
        name               = "compliance-change--integration-test"
        max_delivery_count = 1
        lock_duration      = "PT5M"
        forward_to         = ""
      },
      {
        name               = "legaltagsubscription"
        max_delivery_count = 5
        lock_duration      = "PT5M"
        forward_to         = ""
      }
    ]
  },
  {
    name                = "recordstopic"
    enable_partitioning = true
    subscriptions = [
      {
        name               = "recordstopicsubscription"
        max_delivery_count = 5
        lock_duration      = "PT5M"
        forward_to         = ""
      },
      {
        name               = "wkssubscription"
        max_delivery_count = 5
        lock_duration      = "PT5M"
        forward_to         = ""
      }
    ]
  },
  {
    name                = "recordstopicdownstream"
    enable_partitioning = true
    subscriptions = [
      {
        name               = "downstreamsub"
        max_delivery_count = 5
        lock_duration      = "PT5M"
        forward_to         = ""
      }
    ]
  },
  {
    name                = "recordstopiceg"
    enable_partitioning = true
    subscriptions = [
      {
        name               = "eg_sb_wkssubscription"
        max_delivery_count = 5
        lock_duration      = "PT5M"
        forward_to         = ""
      }
    ]
  },
  {
    name                = "schemachangedtopic"
    enable_partitioning = true
    subscriptions = [
      {
        name               = "schemachangedtopicsubscription"
        max_delivery_count = 5
        lock_duration      = "PT5M"
        forward_to         = ""
      }
    ]
  },
  {
    name                = "schemachangedtopiceg"
    enable_partitioning = true
    subscriptions = [
      {
        name               = "eg_sb_schemasubscription"
        max_delivery_count = 5
        lock_duration      = "PT5M"
        forward_to         = ""
      }
    ]
  },
  {
    name                = "legaltagschangedtopiceg"
    enable_partitioning = true
    subscriptions = [
      {
        name               = "eg_sb_legaltagssubscription"
        max_delivery_count = 5
        lock_duration      = "PT5M"
        forward_to         = ""
      }
    ]
  },
  {
    name                = "statuschangedtopic"
    enable_partitioning = true
    subscriptions = [
      {
        name               = "statuschangedtopicsubscription"
        max_delivery_count = 5
        lock_duration      = "PT5M"
        forward_to         = ""
      }
    ]
  },
  {
    name                = "statuschangedtopiceg"
    enable_partitioning = true
    subscriptions = [
      {
        name               = "eg_sb_statussubscription"
        max_delivery_count = 5
        lock_duration      = "PT5M"
        forward_to         = ""
      }
    ]
  }

]
