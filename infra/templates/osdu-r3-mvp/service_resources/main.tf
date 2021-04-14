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
   This file holds the main control and resoures for bootstraping an OSDU Azure Devops Project.
*/

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
  host                   = module.deployment_resources.kube_config_block.0.host
  username               = module.deployment_resources.kube_config_block.0.username
  password               = module.deployment_resources.kube_config_block.0.password
  client_certificate     = base64decode(module.deployment_resources.kube_config_block.0.client_certificate)
  client_key             = base64decode(module.deployment_resources.kube_config_block.0.client_key)
  cluster_ca_certificate = base64decode(module.deployment_resources.kube_config_block.0.cluster_ca_certificate)
}

// Hook-up helm Provider for Terraform
provider "helm" {
  kubernetes {
    host                   = module.deployment_resources.kube_config_block.0.host
    username               = module.deployment_resources.kube_config_block.0.username
    password               = module.deployment_resources.kube_config_block.0.password
    client_certificate     = base64decode(module.deployment_resources.kube_config_block.0.client_certificate)
    client_key             = base64decode(module.deployment_resources.kube_config_block.0.client_key)
    cluster_ca_certificate = base64decode(module.deployment_resources.kube_config_block.0.cluster_ca_certificate)
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

  // base prefix for resources, prefix constraints documented here: https://docs.microsoft.com/en-us/azure/architecture/best-practices/naming-conventions
  base_name    = length(local.prefix) > 0 ? "${local.prefix}-${local.workspace}${local.suffix}" : "${local.workspace}${local.suffix}"
  base_name_21 = length(local.base_name) < 22 ? local.base_name : "${substr(local.base_name, 0, 21 - length(local.suffix))}${local.suffix}"
  base_name_46 = length(local.base_name) < 47 ? local.base_name : "${substr(local.base_name, 0, 46 - length(local.suffix))}${local.suffix}"
  base_name_60 = length(local.base_name) < 61 ? local.base_name : "${substr(local.base_name, 0, 60 - length(local.suffix))}${local.suffix}"
  base_name_76 = length(local.base_name) < 77 ? local.base_name : "${substr(local.base_name, 0, 76 - length(local.suffix))}${local.suffix}"
  base_name_83 = length(local.base_name) < 84 ? local.base_name : "${substr(local.base_name, 0, 83 - length(local.suffix))}${local.suffix}"

  tenant_id           = data.azurerm_client_config.current.tenant_id
  resource_group_name = format("%s-%s-%s-rg", var.prefix, local.workspace, random_string.workspace_scope.result)
  retention_policy    = var.log_retention_days == 0 ? false : true

  storage_name = "${replace(local.base_name_21, "-", "")}config"

  redis_cache_name = "${local.base_name}-cache"
  postgresql_name  = "${local.base_name}-pg"

  vnet_name       = "${local.base_name_60}-vnet"
  fe_subnet_name  = "${local.base_name_21}-fe-subnet"
  aks_subnet_name = "${local.base_name_21}-aks-subnet"
  be_subnet_name  = "${local.base_name_21}-be-subnet"
  app_gw_name     = "${local.base_name_60}-gw"



  aks_cluster_name = "${local.base_name_60}-aks"

  aks_dns_prefix = local.base_name_60

  role = "Contributor"
  rbac_principals = [
    // OSDU Identity
    data.terraform_remote_state.central_resources.outputs.osdu_identity_principal_id,

    // Service Principal
    data.terraform_remote_state.central_resources.outputs.principal_objectId
  ]
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

resource "random_string" "workspace_scope" {
  keepers = {
    # Generate a new id each time we switch to a new workspace or app id
    ws_name    = replace(trimspace(lower(terraform.workspace)), "_", "-")
    cluster_id = replace(trimspace(lower(var.prefix)), "_", "-")
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

  lifecycle {
    ignore_changes = [tags]
  }
}

#-------------------------------
# Storage
#-------------------------------
module "storage_account" {
  source = "../../../modules/providers/azure/storage-account"

  name                = local.storage_name
  resource_group_name = azurerm_resource_group.main.name
  container_names     = var.storage_containers
  share_names         = var.storage_shares
  queue_names         = var.storage_queues
  kind                = "StorageV2"
  replication_type    = var.storage_replication_type

  resource_tags = var.resource_tags
}

// Add Contributor Role Access
resource "azurerm_role_assignment" "storage_access" {
  count = length(local.rbac_principals)

  role_definition_name = local.role
  principal_id         = local.rbac_principals[count.index]
  scope                = module.storage_account.id
}

// Add Storage Queue Data Reader Role Access
resource "azurerm_role_assignment" "queue_reader" {
  count = length(local.rbac_principals)

  role_definition_name = "Storage Queue Data Reader"
  principal_id         = local.rbac_principals[count.index]
  scope                = module.storage_account.id
}

// Add Storage Queue Data Message Processor Role Access
resource "azurerm_role_assignment" "airflow_log_queue_processor_roles" {
  count = length(local.rbac_principals)

  role_definition_name = "Storage Queue Data Message Processor"
  principal_id         = local.rbac_principals[count.index]
  scope                = module.storage_account.id
}

#-------------------------------
# Deployment Resources
#-------------------------------
module "deployment_resources" {
  source = "./deployment_resources"

  providers = {
    kubernetes = kubernetes
    helm       = helm
  }

  resource_group_name     = azurerm_resource_group.main.name
  resource_tags           = var.resource_tags
  resource_group_id       = azurerm_resource_group.main.id
  resource_group_location = var.resource_group_location

  # ----- VNET Settings -----
  vnet_name = local.vnet_name

  address_space     = var.address_space
  subnet_aks_prefix = var.subnet_aks_prefix
  subnet_be_prefix  = var.subnet_be_prefix
  subnet_fe_prefix  = var.subnet_fe_prefix

  fe_subnet_name  = local.fe_subnet_name
  aks_subnet_name = local.aks_subnet_name

  # ----- App Gateway Settings -----
  appgw_name                      = local.app_gw_name
  keyvault_id                     = data.terraform_remote_state.central_resources.outputs.keyvault_id
  ssl_cert_secret_id              = azurerm_key_vault_certificate.default.0.secret_id
  ssl_cert_name                   = local.ssl_cert_name
  ssl_policy_type                 = var.ssl_policy_type
  ssl_policy_cipher_suites        = var.ssl_policy_cipher_suites
  ssl_policy_min_protocol_version = var.ssl_policy_min_protocol_version
  appgw_min_capacity              = var.appgw_min_capacity
  appgw_max_capacity              = var.appgw_max_capacity

  # ----- AKS Settings -------
  aks_cluster_name      = local.aks_cluster_name
  aks_dns_prefix        = local.aks_dns_prefix
  aks_agent_vm_count    = var.aks_agent_vm_count
  aks_agent_vm_size     = var.aks_agent_vm_size
  aks_agent_vm_disk     = var.aks_agent_vm_disk
  aks_agent_vm_maxcount = var.aks_agent_vm_maxcount
  ssh_public_key_file   = var.ssh_public_key_file
  kubernetes_version    = var.kubernetes_version
  log_retention_days    = var.log_retention_days
  log_analytics_id      = data.terraform_remote_state.central_resources.outputs.log_analytics_id
  container_registry_id = data.terraform_remote_state.central_resources.outputs.container_registry_id
  osdu_identity_id      = data.terraform_remote_state.central_resources.outputs.osdu_identity_id
}

module "aks_config_resources" {
  source = "./aks_config_resources"

  # Do not configure AKS and Helm until resources are fully created
  # https://github.com/hashicorp/terraform-provider-kubernetes/blob/6852542fca3894ef4dff397c5b7e7b0c4f32bbac/_examples/aks/README.md
  # https://github.com/hashicorp/terraform-provider-helm/issues/647
  depends_on = [module.deployment_resources]

  providers = { kubernetes = kubernetes, helm = helm }

  log_analytics_id    = data.terraform_remote_state.central_resources.outputs.log_analytics_id
  resource_group_name = azurerm_resource_group.main.name

  pod_identity_id  = module.deployment_resources.pod_identity_id
  pod_principal_id = module.deployment_resources.pod_principal_id

  agic_identity_id = module.deployment_resources.agic_identity_id
  agic_client_id   = module.deployment_resources.agic_client_id

  appgw_name       = local.app_gw_name
  aks_cluster_name = local.aks_cluster_name

  # ----- AKS Config Map Settings -------
  container_registry_name = data.terraform_remote_state.central_resources.outputs.container_registry_name
  feature_flag            = var.feature_flag
  key_vault_name          = data.terraform_remote_state.central_resources.outputs.keyvault_name
  postgres_fqdn           = module.postgreSQL.server_fqdn
  postgres_username       = var.postgres_username
  subscription_name       = data.azurerm_subscription.current.display_name
  tenant_id               = data.azurerm_client_config.current.tenant_id

  subscription_id = data.azurerm_client_config.current.subscription_id

  gitops_branch       = var.gitops_branch
  gitops_path         = var.gitops_path
  gitops_ssh_key_file = var.gitops_ssh_key_file
  gitops_ssh_url      = var.gitops_ssh_url
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
  count = length(local.rbac_principals)

  role_definition_name = local.role
  principal_id         = local.rbac_principals[count.index]
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
  count = length(local.rbac_principals)

  role_definition_name = local.role
  principal_id         = local.rbac_principals[count.index]
  scope                = module.redis_cache.id
}


#-------------------------------
# Locks
#-------------------------------
resource "azurerm_management_lock" "sa_lock" {
  count = var.feature_flag.sa_lock ? 1 : 0

  name       = "osdu_file_share_lock"
  scope      = module.storage_account.id
  lock_level = "CanNotDelete"
}
