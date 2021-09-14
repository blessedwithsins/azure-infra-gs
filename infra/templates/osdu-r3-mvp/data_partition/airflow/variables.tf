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

variable "remote_state_account" {
  description = "Remote Terraform State Azure storage account name. This is typically set as an environment variable and used for the initial terraform init."
  type        = string
}

variable "remote_state_container" {
  description = "Remote Terraform State Azure storage container name. This is typically set as an environment variable and used for the initial terraform init."
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

variable "central_resources_workspace_name" {
  description = "(Required) The workspace name for the central_resources repository terraform environment / template to reference for this template."
  type        = string
}

variable "container_registry_sku" {
  description = "(Optional) The SKU name of the the container registry. Possible values are Basic, Standard and Premium."
  type        = string
  default     = "Standard"
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
  default     = "GP_Gen5_8"
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
    server_patch_day  = "Saturday"
    server_patch_hour = 11
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
  default     = "Standard_E4s_v3"
}

variable "aks_agent_vm_disk" {
  description = "The initial sice of each VM OS Disk."
  type        = number
  default     = 128
}

variable "kubernetes_version" {
  type    = string
  default = "1.19.11"
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
  default     = "10.10.16.0/24"
}

variable "subnet_aks_prefix" {
  description = "The address prefix to use for the aks subnet."
  type        = string
  default     = "10.10.0.0/20"
}

variable "sr_aks_egress_ip_address" {
  description = "AKS egress ip for SR"
  default     = []
}

variable "storage_account_name" {
  type = string
}

variable "storage_account_id" {
  type = string
}

variable "resource_group_name" {
  type = string
}

variable "base_name" {
  type = string
}

variable "base_name_21" {
  type = string
}

variable "base_name_60" {
  type = string
}

variable "storage_account_key" {
  type = string
}

variable "ingest_storage_account_key" {
  type = string
}

variable "ingest_storage_account_name" {
  type = string
}

variable "redis_queue_sku_name" {
  description = "The Azure Cache for Redis pricing tier. Possible values are Basic, Standard and Premium. Azure currently charges by the minute for all pricing tiers."
  type        = string
  default     = "Premium"
}

variable "redis_queue_zones" {
  description = "A list of a one or more Availability Zones, where the Redis Cache should be allocated."
  type        = list(number)
  default     = [1, 2]
}

variable "cr_keyvault_id" {
  description = "Id for Keyvault in Central Resources"
  type        = string
}

variable "ssl_challenge_required" {
  description = "Flag to indicate whether http01 ssl challenge is required"
  type        = bool
}
