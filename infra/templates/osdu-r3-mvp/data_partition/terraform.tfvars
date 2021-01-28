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

# Database Settings
cosmosdb_consistency_level = "Session"
cosmos_databases = [
  {
    name       = "osdu-db"
    throughput = 12000
  }
]
cosmos_sql_collections = [
  {
    name               = "LegalTag"
    database_name      = "osdu-db"
    partition_key_path = "/id"
    unique_key_paths   = ["/runId"]
  },
  {
    name               = "StorageRecord"
    database_name      = "osdu-db"
    partition_key_path = "/id"
    unique_key_paths   = ["/runId"]
  },
  {
    name               = "StorageSchema"
    database_name      = "osdu-db"
    partition_key_path = "/kind"
    unique_key_paths   = ["/runId"]
  },
  {
    name               = "TenantInfo"
    database_name      = "osdu-db"
    partition_key_path = "/id"
    unique_key_paths   = ["/runId"]
  },
  {
    name               = "UserInfo"
    database_name      = "osdu-db"
    partition_key_path = "/id"
    unique_key_paths   = ["/runId"]
  },
  {
    name               = "Authority"
    database_name      = "osdu-db"
    partition_key_path = "/dataPartitionId"
    unique_key_paths   = ["/runId"]
  },
  {
    name               = "EntityType"
    database_name      = "osdu-db"
    partition_key_path = "/dataPartitionId"
    unique_key_paths   = ["/runId"]
  },
  {
    name               = "SchemaInfo"
    database_name      = "osdu-db"
    partition_key_path = "/dataPartitionId"
    unique_key_paths   = ["/runId"]
  },
  {
    name               = "Source"
    database_name      = "osdu-db"
    partition_key_path = "/dataPartitionId"
    unique_key_paths   = ["/runId"]
  },
  {
    name               = "RegisterAction"
    database_name      = "osdu-db"
    partition_key_path = "/dataPartitionId"
    unique_key_paths   = ["/runId"]
  },
  {
    name               = "RegisterDdms"
    database_name      = "osdu-db"
    partition_key_path = "/dataPartitionId"
    unique_key_paths   = ["/runId"]
  },
  {
    name               = "RegisterSubscription"
    database_name      = "osdu-db"
    partition_key_path = "/dataPartitionId"
    unique_key_paths   = ["/runId"]
  },
  {
    name               = "IngestionStrategy"
    database_name      = "osdu-db"
    partition_key_path = "/workflowType"
    unique_key_paths   = ["/runId"]
  },
  {
    name               = "WorkflowStatus"
    database_name      = "osdu-db"
    partition_key_path = "/workflowId"
    unique_key_paths   = ["/runId"]
  },
  {
    name               = "Workflow"
    database_name      = "osdu-db"
    partition_key_path = "/workflowId"
    unique_key_paths   = ["/runId"]
  },
  {
    name               = "WorkflowRun"
    database_name      = "osdu-db"
    partition_key_path = "/workflowId"
    unique_key_paths   = ["/runId"]
  },
  {
    name               = "RelationshipStatus"
    database_name      = "osdu-db"
    partition_key_path = "/id"
    unique_key_paths   = ["/runId"]
  },
  {
    name               = "MappingInfo"
    database_name      = "osdu-db"
    partition_key_path = "/sourceSchemaKind"
    unique_key_paths   = ["/runId"]
  },
  {
    name               = "WorkflowTasksSharingInfo"
    database_name      = "osdu-db"
    partition_key_path = "/workflowId"
    unique_key_paths   = ["/runId"]
  },
  {
    name               = "FileLocationEntity"
    database_name      = "osdu-db"
    partition_key_path = "/id"
    unique_key_paths   = ["/runId"]
  },
  {
    name               = "WorkflowCustomOperatorInfo"
    database_name      = "osdu-db"
    partition_key_path = "/operatorId"
    unique_key_paths   = ["/runId"]
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
  }
]
