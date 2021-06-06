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
   This file holds the Variable Configuration
*/


#-------------------------------
# Application Variables
#-------------------------------
variable "prefix" {
  description = "The workspace prefix defining the project area for this terraform deployment."
  type        = string
}

variable "randomization_level" {
  description = "Number of additional random characters to include in resource names to insulate against unexpected resource name collisions."
  type        = number
  default     = 4
}

variable "remote_state_account" {
  description = "Remote Terraform State Azure storage account name. This is typically set as an environment variable and used for the initial terraform init."
  type        = string
}

variable "remote_state_container" {
  description = "Remote Terraform State Azure storage container name. This is typically set as an environment variable and used for the initial terraform init."
  type        = string
}

variable "central_resources_workspace_name" {
  description = "(Required) The workspace name for the central_resources repository terraform environment / template to reference for this template."
  type        = string
}

variable "resource_tags" {
  description = "Map of tags to apply to this template."
  type        = map(string)
  default     = {}
}

variable "resource_group_location" {
  description = "The Azure region where data storage resources in this template should be created."
  type        = string
}

variable "data_partition_name" {
  description = "The OSDU data Partition Name."
  type        = string
  default     = "opendes"
}

variable "log_retention_days" {
  description = "Number of days to retain logs."
  type        = number
  default     = 30
}

variable "storage_replication_type" {
  description = "Defines the type of replication to use for this storage account. Valid options are LRS*, GRS, RAGRS and ZRS."
  type        = string
  default     = "GZRS"
}

variable "storage_containers" {
  description = "The list of storage container names to create. Names must be unique per storage account."
  type        = list(string)
}

variable "blob_cors_rule" {
  type = list(
    object(
      {
        allowed_origins    = list(string)
        allowed_methods    = list(string)
        allowed_headers    = list(string)
        exposed_headers    = list(string)
        max_age_in_seconds = number
  }))
  default     = []
  description = "List of CORS Rules to be applied on the Blob Service."
}

variable "cosmosdb_replica_location" {
  description = "The name of the Azure region to host replicated data. i.e. 'East US' 'East US 2'. More locations can be found at https://azure.microsoft.com/en-us/global-infrastructure/locations/"
  type        = string
}

variable "cosmosdb_consistency_level" {
  description = "The level of consistency backed by SLAs for Cosmos database. Developers can chose from five well-defined consistency levels on the consistency spectrum."
  type        = string
  default     = "Session"
}

variable "cosmosdb_automatic_failover" {
  description = "Determines if automatic failover is enabled for CosmosDB."
  type        = bool
  default     = true
}

variable "cosmos_databases" {
  description = "The list of Cosmos DB SQL Databases."
  type = list(object({
    name       = string
    throughput = number
  }))
  default = []
}

variable "cosmos_sql_collections" {
  description = "The list of cosmos collection names to create. Names must be unique per cosmos instance."
  type = list(object({
    name                  = string
    database_name         = string
    partition_key_path    = string
    partition_key_version = number
  }))
  default = []
}

variable "sb_sku" {
  description = "The SKU of the namespace. The options are: `Basic`, `Standard`, `Premium`."
  type        = string
  default     = "Standard"
}

variable "sb_topics" {
  type = list(object({
    name                = string
    enable_partitioning = bool
    subscriptions = list(object({
      name               = string
      max_delivery_count = number
      lock_duration      = string
      forward_to         = string
    }))
  }))
  default = [
    {
      name                = "topic_test"
      enable_partitioning = true
      subscriptions = [
        {
          name               = "sub_test"
          max_delivery_count = 1
          lock_duration      = "PT5M"
          forward_to         = ""
        }
      ]
    }
  ]
}

variable "elasticsearch_endpoint" {
  type        = string
  description = "endpoint for elasticsearch cluster"
}

variable "elasticsearch_username" {
  type        = string
  description = "username for elasticsearch cluster"
}

variable "elasticsearch_password" {
  type        = string
  description = "password for elasticsearch cluster"
}

variable "container_registry_sku" {
  description = "(Optional) The SKU name of the the container registry. Possible values are Basic, Standard and Premium."
  type        = string
  default     = "Standard"
}

variable "principal_name" {
  description = "Existing Service Principal Name."
  type        = string
}

variable "principal_password" {
  description = "Existing Service Principal Password."
  type        = string
}

variable "principal_appId" {
  description = "Existing Service Principal AppId."
  type        = string
}

variable "principal_objectId" {
  description = "Existing Service Principal ObjectId."
  type        = string
}

variable "postgres_databases" {
  description = "The list of names of the PostgreSQL Database, which needs to be a valid PostgreSQL identifier. Changing this forces a new resource to be created."
  default = [
    "airflow"
  ]
}

variable "postgres_username" {
  description = "The Administrator Login for the PostgreSQL Server. Changing this forces a new resource to be created."
  type        = string
  default     = "osdu_admin"
}

variable "postgres_password" {
  description = "The Password associated with the administrator_login for the PostgreSQL Server."
  type        = string
  default     = ""
}

variable "postgres_sku" {
  description = "Name of the sku"
  type        = string
  default     = "GP_Gen5_4"
}

variable "postgres_configurations" {
  description = "A map with PostgreSQL configurations to enable."
  type        = map(string)
  default     = {}
}

variable "airflow_admin_password" {
  description = "Airflow admin password"
  type        = string
  default     = ""
}

variable "redis_config_schedule" {
  description = "Configures the weekly schedule for server patching (Patch Window lasts for 5 hours). Also enables a single cluster for premium tier and when enabled, the true cache capacity of a redis cluster is capacity * cache_shard_count. 10 is the maximum number of shards/nodes allowed."
  type = object({
    server_patch_day  = string
    server_patch_hour = number
    cache_shard_count = number
  })
  default = {
    server_patch_day  = "Friday"
    server_patch_hour = 17
    cache_shard_count = 0
  }
}

variable "redis_config_memory" {
  description = "Configures memory management for standard & premium tier accounts. All number values are in megabytes. maxmemory_policy_cfg property controls how Redis will select what to remove when maxmemory is reached."
  type = object({
    maxmemory_reserved              = number
    maxmemory_delta                 = number
    maxmemory_policy                = string
    maxfragmentationmemory_reserved = number
  })
  default = {
    maxmemory_reserved              = 50
    maxmemory_delta                 = 50
    maxmemory_policy                = "volatile-lru"
    maxfragmentationmemory_reserved = 50
  }
}

variable "redis_capacity" {
  description = "The size of the Redis cache to deploy. When premium account is enabled with clusters, the true capacity of the account cache is capacity * cache_shard_count"
  type        = number
  default     = 1
}

variable "aks_agent_vm_count" {
  description = "The initial number of agent pools / nodes allocated to the AKS cluster"
  type        = string
  default     = "3"
}

variable "aks_agent_vm_maxcount" {
  description = "The max number of nodes allocated to the AKS cluster"
  type        = string
  default     = "10"
}

variable "aks_agent_vm_size" {
  type        = string
  description = "The size of each VM in the Agent Pool (e.g. Standard_F1). Changing this forces a new resource to be created."
  default     = "Standard_D2s_v3"
}

variable "aks_agent_vm_disk" {
  description = "The initial sice of each VM OS Disk."
  type        = number
  default     = 30
}

variable "kubernetes_version" {
  type    = string
  default = "1.17.11"
}

variable "ssh_public_key_file" {
  type        = string
  description = "(Required) The SSH public key used to setup log-in credentials on the nodes in the AKS cluster."
}

variable "address_space" {
  description = "The address space that is used by the virtual network."
  type        = string
  default     = "10.10.0.0/16"
}

variable "subnet_fe_prefix" {
  description = "The address prefix to use for the frontend subnet."
  type        = string
  default     = "10.10.1.0/26"
}

variable "subnet_aks_prefix" {
  description = "The address prefix to use for the aks subnet."
  type        = string
  default     = "10.10.2.0/24"
}

variable "subnet_be_prefix" {
  description = "The address prefix to use for the backend subnet."
  type        = string
  default     = "10.10.3.0/28"
}

variable "feature_flag" {
  description = "(Optional) A toggle for incubator features"
  type = object({
    osdu_namespace = bool
    flux           = bool
    sa_lock        = bool
  })
  default = {
    osdu_namespace = true
    flux           = true
    sa_lock        = true
  }
}