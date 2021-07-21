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
   This file holds a variable override sample to be used by pipelines
*/

/*

feature_flag = {
  osdu_namespace = false
  flux           = false
  sa_lock        = false
  autoscaling    = false
}

prefix = "osdu-mvp"

resource_tags = {
  environment = "OSDU Demo"
}

# Kubernetes Settings
kubernetes_version = "1.19.11"
aks_agent_vm_size  = "Standard_E4s_v3"
aks_agent_vm_count = "5"
subnet_aks_prefix  = "10.10.2.0/23"

# cosmos DB SQL collections
cosmos_sql_collections = [
  {
    name                  = "Authority"
    database_name         = "osdu-system-db"
    partition_key_path    = "/id"
    partition_key_version = null

  },
  {
    name                  = "EntityType"
    database_name         = "osdu-system-db"
    partition_key_path    = "/id"
    partition_key_version = null
  },
  {
    name                  = "SchemaInfo"
    database_name         = "osdu-system-db"
    partition_key_path    = "/partitionId"
    partition_key_version = null
  },
  {
    name                  = "Source"
    database_name         = "osdu-system-db"
    partition_key_path    = "/id"
    partition_key_version = null
  },
  {
    name                  = "WorkflowV2"
    database_name         = "osdu-system-db"
    partition_key_path    = "/partitionKey"
    partition_key_version = 2
  },
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

*/
