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

*/

prefix = "osdu-mvp"

resource_tags = {
  contact = "pipeline"
}

# Storage Settings
storage_replication_type = "LRS"

# Database Settings
cosmosdb_consistency_level = "Session"
cosmos_graph_databases = [
  {
    name       = "osdu-graph"
    throughput = 4000
  }
]

cosmos_graphs = [
  {
    name               = "Entitlements"
    database_name      = "osdu-graph"
    partition_key_path = "/dataPartitionId"
  }
]
