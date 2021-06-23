output "kube_config" {
  sensitive = true
  value     = module.aks_deployment_resources.kube_config
}

output "kube_config_block" {
  sensitive = true
  value     = module.aks_deployment_resources.kube_config_block
}

output "container_registry_name" {
  description = "The name of the azure container registry resource"
  value       = module.container_registry.container_registry_name
}

output "keyvault_id" {
  description = "The id of the Keyvault"
  value       = module.keyvault.keyvault_id
}

output "server_fqdn" {
  description = "The server FQDN"
  value       = module.postgreSQL.server_fqdn
}

output "osduidentity_id" {
  description = "The server FQDN"
  value       = azurerm_user_assigned_identity.osduidentity.id
}

output "osduidentity_principal_id" {
  description = "The server FQDN"
  value       = azurerm_user_assigned_identity.osduidentity.principal_id
}

output "aks_cluster_name" {
  description = ""
  value       = local.aks_cluster_name
}