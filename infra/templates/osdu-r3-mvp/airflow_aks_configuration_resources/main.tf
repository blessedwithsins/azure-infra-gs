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
      version = "=2.64.0"
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
      version = "~> 2.3.2"
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

#-------------------------------
# Common Resources
#-------------------------------
data "azurerm_client_config" "current" {}
data "azurerm_subscription" "current" {}

data "terraform_remote_state" "data_resources" {
  backend = "azurerm"

  config = {
    storage_account_name = var.remote_state_account
    container_name       = var.remote_state_container
    key                  = format("terraform.tfstateenv:%s", var.data_resources_workspace_name)
  }
}

data "terraform_remote_state" "central_resources" {
  backend = "azurerm"

  config = {
    storage_account_name = var.remote_state_account
    container_name       = var.remote_state_container
    key                  = format("terraform.tfstateenv:%s", var.central_resources_workspace_name)
  }
}

// Hook-up kubectl Provider for Terraform
provider "kubernetes" {
  host                   = data.terraform_remote_state.data_resources.outputs.kube_config_block.0.host
  username               = data.terraform_remote_state.data_resources.outputs.kube_config_block.0.username
  password               = data.terraform_remote_state.data_resources.outputs.kube_config_block.0.password
  client_certificate     = base64decode(data.terraform_remote_state.data_resources.outputs.kube_config_block.0.client_certificate)
  client_key             = base64decode(data.terraform_remote_state.data_resources.outputs.kube_config_block.0.client_key)
  cluster_ca_certificate = base64decode(data.terraform_remote_state.data_resources.outputs.kube_config_block.0.cluster_ca_certificate)
}

// Hook-up helm Provider for Terraform
provider "helm" {
  kubernetes {
    host                   = data.terraform_remote_state.data_resources.outputs.kube_config_block.0.host
    username               = data.terraform_remote_state.data_resources.outputs.kube_config_block.0.username
    password               = data.terraform_remote_state.data_resources.outputs.kube_config_block.0.password
    client_certificate     = base64decode(data.terraform_remote_state.data_resources.outputs.kube_config_block.0.client_certificate)
    client_key             = base64decode(data.terraform_remote_state.data_resources.outputs.kube_config_block.0.client_key)
    cluster_ca_certificate = base64decode(data.terraform_remote_state.data_resources.outputs.kube_config_block.0.cluster_ca_certificate)
  }
}


#-------------------------------
# AKS Configuration Resources
#-------------------------------
module "aks_config_resources" {
  count  = var.feature_flag.deploy_airflow ? 1 : 0
  source = "../../../modules/providers/azure/aks_config_resources"

  log_analytics_id = data.terraform_remote_state.central_resources.outputs.log_analytics_id

  pod_identity_id  = data.terraform_remote_state.data_resources.outputs.osduidentity_id
  pod_principal_id = data.terraform_remote_state.data_resources.outputs.osduidentity_principal_id

  aks_cluster_name = data.terraform_remote_state.data_resources.outputs.aks_cluster_name

  # ----- AKS Config Map Settings -------
  container_registry_name = data.terraform_remote_state.data_resources.outputs.container_registry_name
  feature_flag            = var.feature_flag
  key_vault_name          = data.terraform_remote_state.data_resources.outputs.keyvault_id
  postgres_fqdn           = data.terraform_remote_state.data_resources.outputs.server_fqdn
  postgres_username       = var.postgres_username
  subscription_name       = data.azurerm_subscription.current.display_name
  tenant_id               = data.azurerm_client_config.current.tenant_id

}
