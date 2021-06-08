output "kube_config" {
  sensitive = true
  value     = module.aks.kube_config
}

output "kube_config_block" {
  sensitive = true
  value     = module.aks.kube_config_block
}