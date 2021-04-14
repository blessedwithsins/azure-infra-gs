locals {
  aks_identity_name   = format("%s-pod-identity", var.aks_cluster_name)
  appgw_identity_name = format("%s-agic-identity", var.appgw_name)
}
#-------------------------------
# User Assigned Identities
#-------------------------------

// Create an Identity for Pod Identity
resource "azurerm_user_assigned_identity" "podidentity" {
  name                = local.aks_identity_name
  resource_group_name = var.resource_group_name
  location            = var.resource_group_location
}

// Create and Identity for AGIC
resource "azurerm_user_assigned_identity" "agicidentity" {
  name                = local.appgw_identity_name
  resource_group_name = var.resource_group_name
  location            = var.resource_group_location
}

#-------------------------------
# Network
#-------------------------------
module "network" {
  source = "../../../../modules/providers/azure/network"

  name                = var.vnet_name
  resource_group_name = var.resource_group_name
  address_space       = var.address_space
  subnet_prefixes     = [var.subnet_fe_prefix, var.subnet_aks_prefix]
  subnet_names        = [var.fe_subnet_name, var.aks_subnet_name]
  subnet_service_endpoints = {
    (var.aks_subnet_name) = ["Microsoft.Storage",
      "Microsoft.Sql",
      "Microsoft.AzureCosmosDB",
      "Microsoft.KeyVault",
      "Microsoft.ServiceBus",
    "Microsoft.EventHub"]
  }

  resource_tags = var.resource_tags
}

#-------------------------------
# App Gateway
#-------------------------------
module "appgateway" {
  source = "../../../../modules/providers/azure/appgw"

  name                = var.appgw_name
  resource_group_name = var.resource_group_name

  vnet_name                       = module.network.name
  vnet_subnet_id                  = module.network.subnets.0
  keyvault_id                     = var.keyvault_id
  keyvault_secret_id              = var.ssl_cert_secret_id
  ssl_certificate_name            = var.ssl_cert_name
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
  source = "../../../../modules/providers/azure/aks"

  name                = var.aks_cluster_name
  resource_group_name = var.resource_group_name

  dns_prefix         = var.aks_dns_prefix
  agent_vm_count     = var.aks_agent_vm_count
  agent_vm_size      = var.aks_agent_vm_size
  agent_vm_disk      = var.aks_agent_vm_disk
  max_node_count     = var.aks_agent_vm_maxcount
  vnet_subnet_id     = module.network.subnets.1
  ssh_public_key     = file(var.ssh_public_key_file)
  kubernetes_version = var.kubernetes_version
  log_analytics_id   = var.log_analytics_id

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
  scope                = var.container_registry_id
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
  scope                = var.osdu_identity_id
  role_definition_name = "Managed Identity Operator"
}

// Give AGIC Identity the rights to look at the Resource Group
resource "azurerm_role_assignment" "agic_resourcegroup_reader" {
  principal_id         = azurerm_user_assigned_identity.agicidentity.principal_id
  scope                = var.resource_group_id
  role_definition_name = "Reader"
}