output "kube_config" {
  sensitive = true
  value     = module.aks_deployment_resources.kube_config
}

output "kube_config_block" {
  sensitive = true
  value     = module.aks_deployment_resources.kube_config_block
}