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
  host                   = module.aks.kube_config_block.0.host
  username               = module.aks.kube_config_block.0.username
  password               = module.aks.kube_config_block.0.password
  client_certificate     = base64decode(module.aks.kube_config_block.0.client_certificate)
  client_key             = base64decode(module.aks.kube_config_block.0.client_key)
  cluster_ca_certificate = base64decode(module.aks.kube_config_block.0.cluster_ca_certificate)
}

// Hook-up helm Provider for Terraform
provider "helm" {
  kubernetes {
    host                   = module.aks.kube_config_block.0.host
    username               = module.aks.kube_config_block.0.username
    password               = module.aks.kube_config_block.0.password
    client_certificate     = base64decode(module.aks.kube_config_block.0.client_certificate)
    client_key             = base64decode(module.aks.kube_config_block.0.client_key)
    cluster_ca_certificate = base64decode(module.aks.kube_config_block.0.cluster_ca_certificate)
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
  ssl_cert_name = "appgw-ssl-cert"
  tenant_id           = data.azurerm_client_config.current.tenant_id
  resource_group_name = format("%s-%s-%s-rg", var.prefix, local.workspace, random_string.workspace_scope.result)
  retention_policy    = var.log_retention_days == 0 ? false : true



  postgresql_name  = "${local.base_name}-pg"

  vnet_name           = "${local.base_name_60}-vnet"
  fe_subnet_name      = "${local.base_name_21}-fe-subnet"
  aks_subnet_name     = "${local.base_name_21}-aks-subnet"
  be_subnet_name      = "${local.base_name_21}-be-subnet"
  app_gw_name         = "${local.base_name_60}-gw"
  appgw_identity_name = format("%s-agic-identity", local.app_gw_name)


  aks_cluster_name  = "${local.base_name_60}-aks"
  aks_identity_name = format("%s-pod-identity", local.aks_cluster_name)
  aks_dns_prefix    = local.base_name_60

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
# User Assigned Identities
#-------------------------------

// Create an Identity for Pod Identity
resource "azurerm_user_assigned_identity" "podidentity" {
  name                = local.aks_identity_name
  resource_group_name = azurerm_resource_group.main.name
  location            = azurerm_resource_group.main.location
}

// Create and Identity for AGIC
resource "azurerm_user_assigned_identity" "agicidentity" {
  name                = local.appgw_identity_name
  resource_group_name = azurerm_resource_group.main.name
  location            = azurerm_resource_group.main.location
}

#-------------------------------
# Network
#-------------------------------
module "network" {
  source = "../../../modules/providers/azure/network"

  name                = local.vnet_name
  resource_group_name = azurerm_resource_group.main.name
  address_space       = var.address_space
  subnet_prefixes     = [var.subnet_fe_prefix, var.subnet_aks_prefix]
  subnet_names        = [local.fe_subnet_name, local.aks_subnet_name]
  subnet_service_endpoints = {
    (local.aks_subnet_name) = ["Microsoft.Storage",
      "Microsoft.Sql",
      "Microsoft.AzureCosmosDB",
      "Microsoft.KeyVault",
      "Microsoft.ServiceBus",
    "Microsoft.EventHub"]
  }

  resource_tags = var.resource_tags
}

module "appgateway" {
  source = "../../../modules/providers/azure/appgw"

  name                = local.app_gw_name
  resource_group_name = azurerm_resource_group.main.name

  vnet_name                       = module.network.name
  vnet_subnet_id                  = module.network.subnets.0
  keyvault_id                     = data.terraform_remote_state.central_resources.outputs.keyvault_id
  keyvault_secret_id              = data.terraform_remote_state.service_resources.outputs.ssl_certificate_secret_id
  ssl_certificate_name            = local.ssl_cert_name
  ssl_policy_type                 = var.ssl_policy_type
  ssl_policy_cipher_suites        = var.ssl_policy_cipher_suites
  ssl_policy_min_protocol_version = var.ssl_policy_min_protocol_version

  resource_tags = var.resource_tags
  min_capacity  = var.appgw_min_capacity
  max_capacity  = var.appgw_max_capacity
}

// Give AGIC Identity Access rights to Change the Application Gateway
resource "azurerm_role_assignment" "appgwcontributor" {
  principal_id         = azurerm_user_assigned_identity.agicidentity.principal_id
  scope                = module.appgateway.id
  role_definition_name = "Contributor"
}

// Give AGIC Identity the rights to look at the Resource Group
resource "azurerm_role_assignment" "agic_resourcegroup_reader" {
  principal_id         = azurerm_user_assigned_identity.agicidentity.principal_id
  scope                = azurerm_resource_group.main.id
  role_definition_name = "Reader"
}

// Give AGIC Identity rights to Operate the Gateway Identity
resource "azurerm_role_assignment" "agic_app_gw_mi" {
  principal_id         = azurerm_user_assigned_identity.agicidentity.principal_id
  scope                = module.appgateway.managed_identity_resource_id
  role_definition_name = "Managed Identity Operator"
}


#-------------------------------
# Azure AKS
#-------------------------------
module "aks" {
  source = "../../../modules/providers/azure/aks"

  name                = local.aks_cluster_name
  resource_group_name = azurerm_resource_group.main.name

  dns_prefix         = local.aks_dns_prefix
  agent_vm_count     = var.aks_agent_vm_count
  agent_vm_size      = var.aks_agent_vm_size
  agent_vm_disk      = var.aks_agent_vm_disk
  max_node_count     = var.aks_agent_vm_maxcount
  vnet_subnet_id     = module.network.subnets.1
  ssh_public_key     = file(var.ssh_public_key_file)
  kubernetes_version = var.kubernetes_version
  log_analytics_id   = data.terraform_remote_state.central_resources.outputs.log_analytics_id

  msi_enabled               = true
  oms_agent_enabled         = true
  auto_scaling_default_node = true
  kubeconfig_to_disk        = false
  enable_kube_dashboard     = false

  resource_tags = var.resource_tags
}

data "azurerm_resource_group" "aks_node_resource_group" {
  name = module.aks.node_resource_group
}

// Give AKS Access rights to Operate the Node Resource Group
resource "azurerm_role_assignment" "all_mi_operator" {
  principal_id         = module.aks.kubelet_object_id
  scope                = data.azurerm_resource_group.aks_node_resource_group.id
  role_definition_name = "Managed Identity Operator"
}

// Give AKS Access to Create and Remove VM's in Node Resource Group
resource "azurerm_role_assignment" "vm_contributor" {
  principal_id         = module.aks.kubelet_object_id
  scope                = data.azurerm_resource_group.aks_node_resource_group.id
  role_definition_name = "Virtual Machine Contributor"
}

// Give AKS Access to Pull from ACR
resource "azurerm_role_assignment" "acr_reader" {
  principal_id         = module.aks.kubelet_object_id
  scope                = data.terraform_remote_state.central_resources.outputs.container_registry_id
  role_definition_name = "AcrPull"
}

// Give AKS Rights to operate the AGIC Identity
resource "azurerm_role_assignment" "mi_ag_operator" {
  principal_id         = module.aks.kubelet_object_id
  scope                = azurerm_user_assigned_identity.agicidentity.id
  role_definition_name = "Managed Identity Operator"
}

// Give AKS Access Rights to operate the Pod Identity
resource "azurerm_role_assignment" "mi_operator" {
  principal_id         = module.aks.kubelet_object_id
  scope                = azurerm_user_assigned_identity.podidentity.id
  role_definition_name = "Managed Identity Operator"
}

// Give AKS Access Rights to operate the OSDU Identity
resource "azurerm_role_assignment" "osdu_identity_mi_operator" {
  principal_id         = module.aks.kubelet_object_id
  scope                = data.terraform_remote_state.central_resources.outputs.osdu_identity_id
  role_definition_name = "Managed Identity Operator"
}
