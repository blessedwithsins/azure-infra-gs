#-------------------------------
# Azure AKS
#-------------------------------
module "aks" {
  source = "../aks"

  name                = var.aks_cluster_name
  resource_group_name = var.resource_group_name

  dns_prefix         = var.aks_dns_prefix
  agent_vm_count     = var.aks_agent_vm_count
  agent_vm_size      = var.aks_agent_vm_size
  agent_vm_disk      = var.aks_agent_vm_disk
  max_node_count     = var.aks_agent_vm_maxcount
  vnet_subnet_id     = azurerm_subnet.aks_subnet.id
  ssh_public_key     = file(var.ssh_public_key_file)
  kubernetes_version = var.kubernetes_version
  log_analytics_id   = var.log_analytics_id

  msi_enabled               = true
  oms_agent_enabled         = true
  auto_scaling_default_node = true
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

// Give AKS Access to Pull from Central ACR
resource "azurerm_role_assignment" "acr_reader" {
  principal_id         = module.aks.kubelet_object_id
  scope                = var.container_registry_id_central
  role_definition_name = "AcrPull"
}

// Give AKS Access to Pull from Data partition ACR
resource "azurerm_role_assignment" "acr_reader_dp" {
  principal_id         = module.aks.kubelet_object_id
  scope                = var.container_registry_id_data_partition
  role_definition_name = "AcrPull"
}

// Give AKS Access Rights to operate the OSDU Identity
resource "azurerm_role_assignment" "osdu_identity_mi_operator" {
  principal_id         = module.aks.kubelet_object_id
  scope                = var.osdu_identity_id
  role_definition_name = "Managed Identity Operator"
}