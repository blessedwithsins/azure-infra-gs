// Network Output Items for Integration Tests
output "appgw_name" {
  description = "Application gateway's name"
  value       = module.appgateway.name
}

output "kube_config" {
  sensitive = true
  value     = module.aks.kube_config
}

output "kube_config_block" {
  sensitive = true
  value     = module.aks.kube_config_block
}

output "pod_identity_id" {
  sensitive = true
  value     = azurerm_user_assigned_identity.podidentity.id
}

output "pod_principal_id" {
  sensitive = true
  value     = azurerm_user_assigned_identity.podidentity.principal_id
}

output "agic_identity_id" {
  sensitive = true
  value     = azurerm_user_assigned_identity.agicidentity.id
}

output "agic_client_id" {
  sensitive = true
  value     = azurerm_user_assigned_identity.agicidentity.client_id
}
