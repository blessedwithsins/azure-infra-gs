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
   Terraform Output Configuration
.DESCRIPTION
   This file holds the Output Configuration
*/

#-------------------------------
# Output Variables
#-------------------------------
output "data_partition_group_name" {
  description = "The name of the resource group"
  value       = azurerm_resource_group.main.name
}

output "data_partition_group_id" {
  description = "The resource id for the provisioned resource group"
  value       = azurerm_resource_group.main.id
}

output "storage_account" {
  description = "The name of the storage account."
  value       = module.storage_account.name
}

output "storage_account_id" {
  description = "The resource id of the storage account instance"
  value       = module.storage_account.id
}

output "storage_containers" {
  description = "Map of storage account containers."
  value       = module.storage_account.containers
}

output "cosmosdb_account_name" {
  description = "The name of the CosmosDB account."
  value       = module.cosmosdb_account.account_name
}

output "cosmosdb_properties" {
  description = "Properties of the deployed CosmosDB account."
  sensitive   = true
  value       = module.cosmosdb_account.properties
}

output "eventgrid_topics" {
  description = "Properties of the event grid topics."
  value       = module.event_grid.topics
}

output "kube_config_block" {
  sensitive = true
  value     = var.feature_flag.deploy_airflow?module.airflow[0].kube_config_block: null
}

output "container_registry_name" {
  description = "The name of the azure container registry resource"
  value       = var.feature_flag.deploy_airflow?module.airflow[0].container_registry_name:""
}

output "keyvault_id" {
  description = "The id of the Keyvault"
  value       = var.feature_flag.deploy_airflow?module.airflow[0].keyvault_id:""
}

output "server_fqdn" {
  description = "The server FQDN"
  value       = var.feature_flag.deploy_airflow?module.airflow[0].server_fqdn:""
}

output "osduidentity_id" {
  description = "The server FQDN"
  value       = var.feature_flag.deploy_airflow?module.airflow[0].osduidentity_id:""
}

output "osduidentity_principal_id" {
  description = "The server FQDN"
  value       = var.feature_flag.deploy_airflow?module.airflow[0].osduidentity_principal_id:""
}

output "aks_cluster_name" {
  description = ""
  value       = var.feature_flag.deploy_airflow?module.airflow[0].aks_cluster_name:""
}