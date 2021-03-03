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
   Terraform Variable Override Template
.DESCRIPTION
   This file holds a sample of variable overrides to be used by pipelines
*/

/*

prefix = "osdu-mvp"

resource_tags = {
  environment = "OSDU Demo"
}

cosmos_databases = [
  {
    name       = "osdu-db"
    throughput = 12000
  }
]

blob_cors_rule = [
  {
    allowed_headers = ["*"]
    allowed_origins = ["https://osdu-demo.contoso.org"]
    allowed_methods = ["GET","HEAD","POST","PUT","DELETE"]
    exposed_headers = ["*"]
    max_age_in_seconds = 3600
  }
]

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
]

*/
