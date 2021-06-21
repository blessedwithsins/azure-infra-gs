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
   Terraform Main Control
.DESCRIPTION
   This file holds the main control.
*/


// *** WARNING  ****
// This template includes locks and won't fully delete if locks aren't removed first.
// Lock: Storage
// Lock: CosmosDb
// *** WARNING  ****

// *** WARNING  ****
// This template makes changes into the Central Resources and the locks in Central have to be removed to delete.
// Lock: Key Vault
// *** WARNING  ****

terraform {
  required_version = ">= 0.14"

  backend "azurerm" {
    key = "terraform.tfstate"
  }

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "=2.41.0"
    }
    azuread = {
      source  = "hashicorp/azuread"
      version = "=1.1.1"
    }
    random = {
      source  = "hashicorp/random"
      version = "=2.3.1"
    }
    null = {
      source  = "hashicorp/null"
      version = "=3.0.0"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "~> 1.13.3"
    }
    helm = {
      source  = "hashicorp/helm"
      version = "=2.0.1"
    }
  }
}

#-------------------------------
# Providers
#-------------------------------
provider "azurerm" {
  features {}
}

// Hook-up kubectl Provider for Terraform
provider "kubernetes" {
  load_config_file       = false
  host                   = module.aks_deployment_resources.kube_config_block.0.host
  username               = module.aks_deployment_resources.kube_config_block.0.username
  password               = module.aks_deployment_resources.kube_config_block.0.password
  client_certificate     = base64decode(module.aks_deployment_resources.kube_config_block.0.client_certificate)
  client_key             = base64decode(module.aks_deployment_resources.kube_config_block.0.client_key)
  cluster_ca_certificate = base64decode(module.aks_deployment_resources.kube_config_block.0.cluster_ca_certificate)
}

// Hook-up helm Provider for Terraform
provider "helm" {
  kubernetes {
    host                   = module.aks_deployment_resources.kube_config_block.0.host
    username               = module.aks_deployment_resources.kube_config_block.0.username
    password               = module.aks_deployment_resources.kube_config_block.0.password
    client_certificate     = base64decode(module.aks_deployment_resources.kube_config_block.0.client_certificate)
    client_key             = base64decode(module.aks_deployment_resources.kube_config_block.0.client_key)
    cluster_ca_certificate = base64decode(module.aks_deployment_resources.kube_config_block.0.cluster_ca_certificate)
  }
}


#-------------------------------
# Private Variables
#-------------------------------
locals {
  // sanitize names
  prefix    = replace(trimspace(lower(var.prefix)), "_", "-")
  workspace = replace(trimspace(lower(terraform.workspace)), "-", "")
  suffix    = var.randomization_level > 0 ? "-${random_string.workspace_scope.result}" : ""
  partition = split("-", trimspace(lower(terraform.workspace)))[0]

  // base prefix for resources, prefix constraints documented here: https://docs.microsoft.com/en-us/azure/architecture/best-practices/naming-conventions
  base_name    = length(local.prefix) > 0 ? "${local.prefix}-${local.workspace}${local.suffix}" : "${local.workspace}${local.suffix}"
  base_name_21 = length(local.base_name) < 22 ? local.base_name : "${substr(local.base_name, 0, 21 - length(local.suffix))}${local.suffix}"
  base_name_46 = length(local.base_name) < 47 ? local.base_name : "${substr(local.base_name, 0, 46 - length(local.suffix))}${local.suffix}"
  base_name_60 = length(local.base_name) < 61 ? local.base_name : "${substr(local.base_name, 0, 60 - length(local.suffix))}${local.suffix}"
  base_name_76 = length(local.base_name) < 77 ? local.base_name : "${substr(local.base_name, 0, 76 - length(local.suffix))}${local.suffix}"
  base_name_83 = length(local.base_name) < 84 ? local.base_name : "${substr(local.base_name, 0, 83 - length(local.suffix))}${local.suffix}"

  resource_group_name = format("%s-%s-%s-rg", var.prefix, local.workspace, random_string.workspace_scope.result)
  retention_policy    = var.log_retention_days == 0 ? false : true

  kv_name                 = "${local.base_name_21}-kv"
  osdupod_identity_name   = "${local.base_name}-osdu-identity"
  container_registry_name = "${replace(local.base_name_21, "-", "")}cr"
  postgresql_name         = "${local.base_name}-pg"
  role                    = "Contributor"
  redis_cache_name        = "${local.base_name}-cache"

  vnet_name         = "${local.base_name_60}-vnet"
  fe_subnet_name    = "${local.base_name_21}-fe-subnet"
  aks_subnet_name   = "${local.base_name_21}-aks-subnet"
  aks_cluster_name  = "${local.base_name_21}-aks"
  aks_identity_name = format("%s-pod-identity", local.aks_cluster_name)
  aks_dns_prefix    = local.base_name_60
  logs_name         = "${local.base_name}-logs"

  storage_name        = "${replace(local.base_name_21, "-", "")}data"
  sdms_storage_name   = "${replace(local.base_name_21, "-", "")}sdms"
  ingest_storage_name = "${replace(local.base_name_21, "-", "")}ingest"
  cosmosdb_name       = "${local.base_name}-db"
  sb_namespace        = "${local.base_name_21}-bus"

  eg_sbtopic_subscriber               = "servicebusrecordstopic"
  eg_sbtopic_schema_subscriber        = "servicebusschemachangedtopic"
  eg_sbtopic_gsm_subscriber           = "servicebusstatuschangedtopic"
  eg_sbtopic_legaltags_subscriber     = "servicebuslegaltagschangedtopic"
  eventgrid_name                      = "${local.base_name_21}-grid"
  eventgrid_records_topic             = format("%s-recordstopic", local.eventgrid_name)
  eventgrid_schema_notification_topic = format("%s-schemachangedtopic", local.eventgrid_name)
  eventgrid_legaltags_topic           = format("%s-legaltagschangedtopic", local.eventgrid_name)
  eventgrid_gsm_topic                 = format("%s-statuschangedtopic", local.eventgrid_name)

  rbac_principals = [
    data.terraform_remote_state.central_resources.outputs.osdu_identity_principal_id,
    data.terraform_remote_state.central_resources.outputs.principal_objectId
  ]

  rbac_principals_airflow = [
    azurerm_user_assigned_identity.osduidentity.principal_id
  ]

  rbac_contributor_scopes = concat(
    [module.container_registry.container_registry_id],
    [module.keyvault.keyvault_id]
  )
}


#-------------------------------
# Common Resources
#-------------------------------
data "azurerm_client_config" "current" {}
data "azurerm_subscription" "current" {}

data "terraform_remote_state" "central_resources" {
  backend = "azurerm"

  config = {
    storage_account_name = var.remote_state_account
    container_name       = var.remote_state_container
    key                  = format("terraform.tfstateenv:%s", var.central_resources_workspace_name)
  }
}

data "terraform_remote_state" "service_resources" {
  backend = "azurerm"

  config = {
    storage_account_name = var.remote_state_account
    container_name       = var.remote_state_container
    key                  = format("terraform.tfstateenv:%s", var.service_resources_workspace_name)
  }
}

resource "random_string" "workspace_scope" {
  keepers = {
    # Generate a new id each time we switch to a new workspace or app id
    ws_name = replace(trimspace(lower(terraform.workspace)), "-", "")
    prefix  = replace(trimspace(lower(var.prefix)), "_", "-")
  }

  length  = max(1, var.randomization_level) // error for zero-length
  special = false
  upper   = false
}


#-------------------------------
# Resource Group
#-------------------------------
resource "azurerm_resource_group" "main" {
  name     = local.resource_group_name
  location = var.resource_group_location

  tags = var.resource_tags
  lifecycle { ignore_changes = [tags] }
}


#-------------------------------
# Storage
#-------------------------------
module "storage_account" {
  source = "../../../modules/providers/azure/storage-account"

  name                = local.storage_name
  resource_group_name = azurerm_resource_group.main.name
  container_names     = var.storage_containers
  kind                = "StorageV2"
  replication_type    = var.storage_replication_type

  resource_tags  = var.resource_tags
  blob_cors_rule = var.blob_cors_rule
}

// Add Access Control to Principal
resource "azurerm_role_assignment" "storage_access" {
  count = length(local.rbac_principals)

  role_definition_name = "Contributor"
  principal_id         = local.rbac_principals[count.index]
  scope                = module.storage_account.id
}

// Add Data Contributor Role to Principal
resource "azurerm_role_assignment" "storage_data_contributor" {
  count      = length(local.rbac_principals)
  depends_on = [azurerm_role_assignment.storage_access]

  role_definition_name = "Storage Blob Data Contributor"
  principal_id         = local.rbac_principals[count.index]
  scope                = module.storage_account.id
}

module "sdms_storage_account" {
  source = "../../../modules/providers/azure/storage-account"

  name                = local.sdms_storage_name
  resource_group_name = azurerm_resource_group.main.name
  container_names     = []
  kind                = "StorageV2"
  replication_type    = var.storage_replication_type

  resource_tags = merge(var.resource_tags, var.resource_tags_sdms)
}

// Add Access Control to Principal
resource "azurerm_role_assignment" "sdms_storage_access" {
  count = length(local.rbac_principals)

  role_definition_name = "Contributor"
  principal_id         = local.rbac_principals[count.index]
  scope                = module.sdms_storage_account.id
}

// Add Data Contributor Role to Principal
resource "azurerm_role_assignment" "sdms_storage_data_contributor" {
  count      = length(local.rbac_principals)
  depends_on = [azurerm_role_assignment.sdms_storage_access]

  role_definition_name = "Storage Blob Data Contributor"
  principal_id         = local.rbac_principals[count.index]
  scope                = module.sdms_storage_account.id
}

module "ingest_storage_account" {
  source = "../../../modules/providers/azure/storage-account"

  name                = local.ingest_storage_name
  resource_group_name = azurerm_resource_group.main.name
  container_names     = []
  kind                = "StorageV2"
  replication_type    = var.storage_replication_type

  resource_tags = var.resource_tags
}

// Add Access Control to Principal
resource "azurerm_role_assignment" "ingest_storage_access" {
  count = length(local.rbac_principals)

  role_definition_name = "Contributor"
  principal_id         = local.rbac_principals[count.index]
  scope                = module.ingest_storage_account.id
}

// Add Data Contributor Role to Principal
resource "azurerm_role_assignment" "ingest_storage_data_contributor" {
  count      = length(local.rbac_principals)
  depends_on = [azurerm_role_assignment.ingest_storage_access]

  role_definition_name = "Storage Blob Data Contributor"
  principal_id         = local.rbac_principals[count.index]
  scope                = module.ingest_storage_account.id
}

// Add Contributor Role Access
resource "azurerm_role_assignment" "storage_access_airflow" {
  count = length(local.rbac_principals_airflow)

  role_definition_name = local.role
  principal_id         = local.rbac_principals_airflow[count.index]
  scope                = module.storage_account.id
}

// Add Storage Queue Data Reader Role Access
resource "azurerm_role_assignment" "queue_reader" {
  count = length(local.rbac_principals_airflow)

  role_definition_name = "Storage Queue Data Reader"
  principal_id         = local.rbac_principals_airflow[count.index]
  scope                = module.storage_account.id
}

// Add Storage Queue Data Message Processor Role Access
resource "azurerm_role_assignment" "airflow_log_queue_processor_roles" {
  count = length(local.rbac_principals_airflow)

  role_definition_name = "Storage Queue Data Message Processor"
  principal_id         = local.rbac_principals_airflow[count.index]
  scope                = module.storage_account.id
}


#-------------------------------
# CosmosDB
#-------------------------------
module "cosmosdb_account" {
  source = "../../../modules/providers/azure/cosmosdb"

  name                     = local.cosmosdb_name
  resource_group_name      = azurerm_resource_group.main.name
  primary_replica_location = var.cosmosdb_replica_location
  automatic_failover       = var.cosmosdb_automatic_failover
  consistency_level        = var.cosmosdb_consistency_level
  databases                = var.cosmos_databases
  sql_collections          = var.cosmos_sql_collections

  resource_tags = var.resource_tags
}

// Add Access Control to Principal
resource "azurerm_role_assignment" "cosmos_access" {
  count = length(local.rbac_principals)

  role_definition_name = "Contributor"
  principal_id         = local.rbac_principals[count.index]
  scope                = module.cosmosdb_account.account_id
}


#-------------------------------
# Azure Service Bus
#-------------------------------
module "service_bus" {
  source = "../../../modules/providers/azure/service-bus"

  name                = local.sb_namespace
  resource_group_name = azurerm_resource_group.main.name
  sku                 = var.sb_sku
  topics              = var.sb_topics

  resource_tags = var.resource_tags
}

// Add Access Control to Principal
resource "azurerm_role_assignment" "sb_access" {
  count = length(local.rbac_principals)

  role_definition_name = "Azure Service Bus Data Sender"
  principal_id         = local.rbac_principals[count.index]
  scope                = module.service_bus.id
}


#-------------------------------
# Azure Event Grid
#-------------------------------
module "event_grid" {
  source = "../../../modules/providers/azure/event-grid"

  name                = local.eventgrid_name
  resource_group_name = azurerm_resource_group.main.name

  topics = [
    {
      name = local.eventgrid_records_topic
    },
    {
      name = local.eventgrid_legaltags_topic
    },
    {
      name = local.eventgrid_schema_notification_topic
    },
    {
      name = local.eventgrid_gsm_topic
    }
  ]

  resource_tags = var.resource_tags
}

// Add EventGrid EventSubscription Contributor access to Principal
resource "azurerm_role_assignment" "event_grid_topics_role" {
  count = length(local.rbac_principals)

  role_definition_name = "EventGrid EventSubscription Contributor"
  principal_id         = local.rbac_principals[count.index]
  scope                = lookup(module.event_grid.topics, local.eventgrid_records_topic)
}

// Add EventGrid EventSubscription Contributor access to Principal For Legal Tags
resource "azurerm_role_assignment" "event_grid_topics_role_legaltags" {
  count = length(local.rbac_principals)

  role_definition_name = "EventGrid EventSubscription Contributor"
  principal_id         = local.rbac_principals[count.index]
  scope                = lookup(module.event_grid.topics, local.eventgrid_legaltags_topic)
}

// Add a Service Bus Topic subscriber that is used by WKS service.
resource "azurerm_eventgrid_event_subscription" "service_bus_topic_subscriber" {
  name = local.eg_sbtopic_subscriber

  scope      = lookup(module.event_grid.topics, local.eventgrid_records_topic)
  depends_on = [module.service_bus.id]

  service_bus_topic_endpoint_id = lookup(module.service_bus.topicsmap, "recordstopiceg")
}

// Add a Service Bus Topic subscriber that act as EventHandler for legaltagschangedtopic
resource "azurerm_eventgrid_event_subscription" "service_bus_topic_subscriber_legaltags" {
  name                          = local.eg_sbtopic_legaltags_subscriber
  scope                         = lookup(module.event_grid.topics, local.eventgrid_legaltags_topic)
  depends_on                    = [module.service_bus.id]
  service_bus_topic_endpoint_id = lookup(module.service_bus.topicsmap, "legaltagschangedtopiceg")
}

// Add EventGrid EventSubscription Contributor access to Principal For Schema
resource "azurerm_role_assignment" "event_grid_topics_role_schema" {
  count = length(local.rbac_principals)

  role_definition_name = "EventGrid EventSubscription Contributor"
  principal_id         = local.rbac_principals[count.index]
  scope                = lookup(module.event_grid.topics, local.eventgrid_schema_notification_topic)
}

// Add a Service Bus Topic subscriber that act as EventHandler for schemachangedtopic
resource "azurerm_eventgrid_event_subscription" "service_bus_topic_subscriber_schema" {
  name                          = local.eg_sbtopic_schema_subscriber
  scope                         = lookup(module.event_grid.topics, local.eventgrid_schema_notification_topic)
  depends_on                    = [module.service_bus.id]
  service_bus_topic_endpoint_id = lookup(module.service_bus.topicsmap, "schemachangedtopiceg")
}

// Add EventGrid EventSubscription Contributor access to Principal 
resource "azurerm_role_assignment" "event_grid_topics_role_gsm" {
  count = length(local.rbac_principals)

  role_definition_name = "EventGrid EventSubscription Contributor"
  principal_id         = local.rbac_principals[count.index]
  scope                = lookup(module.event_grid.topics, local.eventgrid_gsm_topic)
}

// Add a Service Bus Topic subscriber that act as EventHandler for statuschangedtopic
resource "azurerm_eventgrid_event_subscription" "service_bus_topic_subscriber_gsm" {
  name = local.eg_sbtopic_gsm_subscriber

  scope      = lookup(module.event_grid.topics, local.eventgrid_gsm_topic)
  depends_on = [module.service_bus.id]

  service_bus_topic_endpoint_id = lookup(module.service_bus.topicsmap, "statuschangedtopiceg")
}

#-------------------------------
# Locks
#-------------------------------
resource "azurerm_management_lock" "sa_lock" {
  name       = "osdu_ds_sa_lock"
  scope      = module.storage_account.id
  lock_level = "CanNotDelete"
}

resource "azurerm_management_lock" "sdms_sa_lock" {
  name       = "osdu_sdms_sa_lock"
  scope      = module.sdms_storage_account.id
  lock_level = "CanNotDelete"
}

resource "azurerm_management_lock" "db_lock" {
  name       = "osdu_ds_db_lock"
  scope      = module.cosmosdb_account.properties.cosmosdb.id
  lock_level = "CanNotDelete"
}

resource "azurerm_management_lock" "ingest_sa_lock" {
  name       = "osdu_ingest_sa_lock"
  scope      = module.ingest_storage_account.id
  lock_level = "CanNotDelete"
}


#-------------------------------
# Key Vault for Airflow
#-------------------------------
module "keyvault" {
  source = "../../../modules/providers/azure/keyvault"

  keyvault_name       = local.kv_name
  resource_group_name = azurerm_resource_group.main.name
  secrets = {
    app-dev-sp-tenant-id = data.azurerm_client_config.current.tenant_id
  }

  resource_tags = var.resource_tags
}

module "keyvault_policy" {
  source = "../../../modules/providers/azure/keyvault-policy"

  vault_id  = module.keyvault.keyvault_id
  tenant_id = data.azurerm_client_config.current.tenant_id
  object_ids = [
    azurerm_user_assigned_identity.osduidentity.principal_id
  ]
  key_permissions         = ["get", "encrypt", "decrypt"]
  certificate_permissions = ["get"]
  secret_permissions      = ["get"]
}

resource "azurerm_role_assignment" "kv_roles" {
  count = length(local.rbac_principals_airflow)

  role_definition_name = "Reader"
  principal_id         = local.rbac_principals_airflow[count.index]
  scope                = module.keyvault.keyvault_id
}

#-------------------------------
# OSDU Identity
#-------------------------------
// Identity for OSDU Pod Identity
resource "azurerm_user_assigned_identity" "osduidentity" {
  name                = local.osdupod_identity_name
  resource_group_name = azurerm_resource_group.main.name
  location            = azurerm_resource_group.main.location

  tags = var.resource_tags
}

#-------------------------------
# Container Registry
#-------------------------------
module "container_registry" {
  source = "../../../modules/providers/azure/container-registry"

  container_registry_name = local.container_registry_name
  resource_group_name     = azurerm_resource_group.main.name

  container_registry_sku           = var.container_registry_sku
  container_registry_admin_enabled = false

  resource_tags = var.resource_tags
}


#-------------------------------
# PostgreSQL
#-------------------------------
resource "random_password" "postgres" {
  count = var.postgres_password == "" ? 1 : 0

  length           = 8
  special          = true
  override_special = "_%@"
  min_upper        = 1
  min_lower        = 1
  min_numeric      = 1
  min_special      = 1
}

module "postgreSQL" {
  source = "../../../modules/providers/azure/postgreSQL"

  resource_group_name       = azurerm_resource_group.main.name
  name                      = local.postgresql_name
  databases                 = var.postgres_databases
  admin_user                = var.postgres_username
  admin_password            = local.postgres_password
  sku                       = var.postgres_sku
  postgresql_configurations = var.postgres_configurations

  storage_mb                   = 5120
  server_version               = "10.0"
  backup_retention_days        = 7
  geo_redundant_backup_enabled = true
  auto_grow_enabled            = true
  ssl_enforcement_enabled      = true

  public_network_access = true
  firewall_rules = [{
    start_ip = "0.0.0.0"
    end_ip   = "0.0.0.0"
  }]

  resource_tags = var.resource_tags
}

// Add Contributor Role Access
resource "azurerm_role_assignment" "postgres_access" {
  count = length(local.rbac_principals_airflow)

  role_definition_name = local.role
  principal_id         = local.rbac_principals_airflow[count.index]
  scope                = module.postgreSQL.server_id
}

#-------------------------------
# Azure Redis Cache
#-------------------------------
module "redis_cache" {
  source = "../../../modules/providers/azure/redis-cache"

  name                = local.redis_cache_name
  resource_group_name = azurerm_resource_group.main.name
  capacity            = var.redis_capacity

  memory_features     = var.redis_config_memory
  premium_tier_config = var.redis_config_schedule

  resource_tags = var.resource_tags
}

// Add Contributor Role Access
resource "azurerm_role_assignment" "redis_cache" {
  count = length(local.rbac_principals_airflow)

  role_definition_name = local.role
  principal_id         = local.rbac_principals_airflow[count.index]
  scope                = module.redis_cache.id
}

#-------------------------------
# Log Analytics
#-------------------------------
module "log_analytics" {
  source = "../../../modules/providers/azure/log-analytics"

  name                = local.logs_name
  resource_group_name = azurerm_resource_group.main.name
  resource_tags       = var.resource_tags
}

#-------------------------------
# Deployment Resources
#-------------------------------
module "aks_deployment_resources" {
  source = "../../../modules/providers/azure/aks_deployment_resources"

  resource_group_name     = azurerm_resource_group.main.name
  resource_tags           = var.resource_tags
  resource_group_id       = azurerm_resource_group.main.id
  resource_group_location = var.resource_group_location

  # ----- VNET Settings -----
  vnet_name = local.vnet_name

  address_space     = var.address_space
  subnet_aks_prefix = var.subnet_aks_prefix
  subnet_fe_prefix  = var.subnet_fe_prefix

  fe_subnet_name  = local.fe_subnet_name
  aks_subnet_name = local.aks_subnet_name

  # ----- AKS Settings -------
  aks_cluster_name                     = local.aks_cluster_name
  aks_dns_prefix                       = local.aks_dns_prefix
  aks_agent_vm_count                   = var.aks_agent_vm_count
  aks_agent_vm_size                    = var.aks_agent_vm_size
  aks_agent_vm_disk                    = var.aks_agent_vm_disk
  aks_agent_vm_maxcount                = var.aks_agent_vm_maxcount
  ssh_public_key_file                  = var.ssh_public_key_file
  kubernetes_version                   = var.kubernetes_version
  log_retention_days                   = var.log_retention_days
  log_analytics_id                     = data.terraform_remote_state.central_resources.outputs.log_analytics_id
  container_registry_id_central        = data.terraform_remote_state.central_resources.outputs.container_registry_id
  container_registry_id_data_partition = module.container_registry.container_registry_id
  osdu_identity_id                     = azurerm_user_assigned_identity.osduidentity.id
  sr_aks_egress_ip_address             = data.terraform_remote_state.service_resources.outputs.aks_egress_ip_address
}

#-------------------------------
# AKS Configuration Resources
#-------------------------------
module "aks_config_resources" {
  source = "../../../modules/providers/azure/aks_config_resources"

  # Do not configure AKS and Helm until resources are fully created
  # https://github.com/hashicorp/terraform-provider-kubernetes/blob/6852542fca3894ef4dff397c5b7e7b0c4f32bbac/_examples/aks/README.md
  # https://github.com/hashicorp/terraform-provider-helm/issues/647
  depends_on = [module.aks_deployment_resources]

  pod_identity_id  = azurerm_user_assigned_identity.osduidentity.id
  pod_principal_id = azurerm_user_assigned_identity.osduidentity.principal_id

  aks_cluster_name = local.aks_cluster_name

  # ----- AKS Config Map Settings -------
  container_registry_name = module.container_registry.container_registry_name
  feature_flag            = var.feature_flag
  key_vault_name          = module.keyvault.keyvault_id
  postgres_fqdn           = module.postgreSQL.server_fqdn
  postgres_username       = var.postgres_username
  subscription_name       = data.azurerm_subscription.current.display_name
  tenant_id               = data.azurerm_client_config.current.tenant_id

}

module "keyvault_cr_dp_policy" {
  source = "../../../modules/providers/azure/keyvault-policy"

  vault_id  = data.terraform_remote_state.central_resources.outputs.keyvault_dp_id
  tenant_id = data.azurerm_client_config.current.tenant_id
  object_ids = [
    azurerm_user_assigned_identity.osduidentity.principal_id
  ]
  key_permissions         = ["get", "encrypt", "decrypt"]
  certificate_permissions = ["get"]
  secret_permissions      = ["get"]
}

resource "azurerm_role_assignment" "kv_cr_dp_roles" {
  count = length(local.rbac_principals_airflow)

  role_definition_name = "Reader"
  principal_id         = local.rbac_principals_airflow[count.index]
  scope                = data.terraform_remote_state.central_resources.outputs.keyvault_dp_id
}