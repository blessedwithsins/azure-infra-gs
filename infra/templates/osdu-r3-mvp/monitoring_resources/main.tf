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
    random = {
      source  = "hashicorp/random"
      version = "=2.3.1"
    }
  }
}


#-------------------------------
# Providers
#-------------------------------
provider "azurerm" {
  features {}
}


#-------------------------------
# Private Variables
#-------------------------------
locals {
  // sanitize names
  prefix    = replace(trimspace(lower(var.prefix)), "_", "-")
  workspace = replace(trimspace(lower(terraform.workspace)), "-", "")
  suffix    = var.randomization_level > 0 ? "-${random_string.workspace_scope.result}" : ""

  base_name = length(local.prefix) > 0 ? "${local.prefix}-${local.workspace}${local.suffix}" : "${local.workspace}${local.suffix}"

  resource_group_name = format("%s-%s-%s-rg", var.prefix, local.workspace, random_string.workspace_scope.result)
  template_path       = "./dashboard_templates"
}

#-------------------------------
# Common Resources
#-------------------------------
data "azurerm_client_config" "current" {}

data "terraform_remote_state" "central_resources" {
  backend = "azurerm"

  config = {
    storage_account_name = var.remote_state_account
    container_name       = var.remote_state_container
    key                  = format("terraform.tfstateenv:%s", var.central_resources_workspace_name)
  }
}

data "terraform_remote_state" "partition_resources" {
  backend = "azurerm"

  config = {
    storage_account_name = var.remote_state_account
    container_name       = var.remote_state_container
    key                  = format("terraform.tfstateenv:%s", var.data_partition_resources_workspace_name)
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
# Dashboards
#-------------------------------

resource "azurerm_dashboard" "default_dashboard" {
  count = var.dashboards.default ? 1 : 0

  name                = "${local.base_name}-default-dash"
  resource_group_name = azurerm_resource_group.main.name
  location            = azurerm_resource_group.main.location
  tags                = var.resource_tags

  dashboard_properties = templatefile("${local.template_path}/default.tpl", {
    tenantName           = var.tenant_name
    subscriptionId       = data.azurerm_client_config.current.subscription_id
    centralGroupPrefix   = trim(data.terraform_remote_state.central_resources.outputs.central_resource_group_name, "-rg")
    partitionGroupPrefix = trim(data.terraform_remote_state.partition_resources.outputs.data_partition_group_name, "-rg")
    serviceGroupPrefix   = trim(data.terraform_remote_state.service_resources.outputs.services_resource_group_name, "-rg")
    partitionStorage     = data.terraform_remote_state.partition_resources.outputs.storage_account
  })
}


resource "azurerm_dashboard" "appinsights_dashboard" {
  count = var.dashboards.appinsights ? 1 : 0

  name                = "${local.base_name}-appinsights-dash"
  resource_group_name = azurerm_resource_group.main.name
  location            = azurerm_resource_group.main.location
  tags                = var.resource_tags

  dashboard_properties = templatefile("${local.template_path}/appinsights.tpl", {
    subscriptionId     = data.azurerm_client_config.current.subscription_id
    centralGroupPrefix = trim(data.terraform_remote_state.central_resources.outputs.central_resource_group_name, "-rg")
  })
}