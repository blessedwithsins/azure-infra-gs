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