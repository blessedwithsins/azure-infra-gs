#-------------------------------
# Private Variables
#-------------------------------

locals {
  base_name               = var.base_name
  base_name_21            = var.base_name_21
  base_name_60            = var.base_name_60
  resource_group_name     = var.resource_group_name
  postgresql_name         = "${local.base_name}-pg"
  role                    = "Contributor"
  keyvault_name           = "${local.base_name_21}-kv"
  osdupod_identity_name   = "${local.base_name}-osdu-identity"
  container_registry_name = "${replace(local.base_name_21, "-", "")}cr"
  redis_cache_name        = "${local.base_name}-cache"
  logs_name               = "${local.base_name}-logs"
  vnet_name               = "${local.base_name_60}-vnet"
  fe_subnet_name          = "${local.base_name_21}-fe-subnet"
  aks_subnet_name         = "${local.base_name_21}-aks-subnet"
  aks_cluster_name        = "${local.base_name_21}-aks"
  aks_identity_name       = format("%s-pod-identity", local.aks_cluster_name)
  aks_dns_prefix          = local.base_name_60
  retention_policy        = var.log_retention_days == 0 ? false : true
  rbac_principals_airflow = [
    azurerm_user_assigned_identity.osduidentity.principal_id
  ]

}

#-------------------------------
# Common Resources
#-------------------------------
data "azurerm_client_config" "current" {}
data "azurerm_subscription" "current" {}

data "terraform_remote_state" "central_resources" {
  backend = "azurerm"

  config = {
    storage_account_name = var.remote_state_account
    container_name       = var.remote_state_container
    key                  = format("terraform.tfstateenv:%s", var.central_resources_workspace_name)
  }
}

#-------------------------------
# Airflow
#-------------------------------

locals {
  airflow_admin_password = coalesce(var.airflow_admin_password, random_password.airflow_admin_password[0].result)
  airflow_log_queue_name = "airflowlogqueue"
}

resource "random_password" "airflow_admin_password" {
  count = var.airflow_admin_password == "" ? 1 : 0

  length           = 8
  special          = true
  override_special = "_%@"
  min_upper        = 1
  min_lower        = 1
  min_numeric      = 1
  min_special      = 1
}

resource "random_string" "airflow_fernete_key_rnd" {
  keepers = {
    postgresql_name = local.postgresql_name
  }
  length      = 32
  special     = true
  min_upper   = 1
  min_lower   = 1
  min_numeric = 1
  min_special = 1
}


// Create Fileshare and folder structure
resource "azurerm_storage_share" "airflow_share" {
  name                 = "airflowdags"
  storage_account_name = var.storage_account_name
  quota                = 50
}

resource "azurerm_storage_share_directory" "dags" {
  name                 = "dags"
  share_name           = azurerm_storage_share.airflow_share.name
  storage_account_name = var.storage_account_name
}

resource "azurerm_storage_share_directory" "plugins" {
  name                 = "plugins"
  share_name           = azurerm_storage_share.airflow_share.name
  storage_account_name = var.storage_account_name
}

resource "azurerm_storage_share_directory" "operators" {
  name                 = "plugins/operators"
  share_name           = azurerm_storage_share.airflow_share.name
  storage_account_name = var.storage_account_name
  depends_on           = [azurerm_storage_share_directory.plugins]
}

resource "azurerm_storage_share_directory" "hooks" {
  name                 = "plugins/hooks"
  share_name           = azurerm_storage_share.airflow_share.name
  storage_account_name = var.storage_account_name
  depends_on           = [azurerm_storage_share_directory.plugins]
}

resource "azurerm_storage_share_directory" "sensors" {
  name                 = "plugins/sensors"
  share_name           = azurerm_storage_share.airflow_share.name
  storage_account_name = var.storage_account_name
  depends_on           = [azurerm_storage_share_directory.plugins]
}

// Airflow log container
resource "azurerm_storage_container" "main" {
  name                  = "airflow-logs"
  storage_account_name  = var.storage_account_name
  container_access_type = "private"
}

// Airflow queue for blob create event
resource "azurerm_storage_queue" "main" {
  name                 = local.airflow_log_queue_name
  storage_account_name = var.storage_account_name
}

// Add the Subscription to the Queue
resource "azurerm_eventgrid_event_subscription" "airflow_log_event_subscription" {
  name  = "airflowlogeventsubscription"
  scope = var.storage_account_id

  storage_queue_endpoint {
    storage_account_id = var.storage_account_id
    queue_name         = local.airflow_log_queue_name
  }

  included_event_types = ["Microsoft.Storage.BlobCreated"]

  subject_filter {
    subject_begins_with = "/blobServices/default/containers/airflow-logs/blobs"
  }

  depends_on = [azurerm_storage_queue.main]
}

// Add Contributor Role Access
resource "azurerm_role_assignment" "storage_access_airflow" {
  count = length(local.rbac_principals_airflow)

  role_definition_name = local.role
  principal_id         = local.rbac_principals_airflow[count.index]
  scope                = var.storage_account_id
}

// Add Storage Queue Data Reader Role Access
resource "azurerm_role_assignment" "queue_reader" {
  count = length(local.rbac_principals_airflow)

  role_definition_name = "Storage Queue Data Reader"
  principal_id         = local.rbac_principals_airflow[count.index]
  scope                = var.storage_account_id
}

// Add Storage Queue Data Message Processor Role Access
resource "azurerm_role_assignment" "airflow_log_queue_processor_roles" {
  count = length(local.rbac_principals_airflow)

  role_definition_name = "Storage Queue Data Message Processor"
  principal_id         = local.rbac_principals_airflow[count.index]
  scope                = var.storage_account_id
}

#-------------------------------
# Key Vault for Airflow
#-------------------------------
module "keyvault" {
  source = "../../../../modules/providers/azure/keyvault"

  keyvault_name       = local.keyvault_name
  resource_group_name = var.resource_group_name
  secrets = {
    app-dev-sp-tenant-id = data.azurerm_client_config.current.tenant_id
  }

  resource_tags = var.resource_tags
}

module "keyvault_policy" {
  source = "../../../../modules/providers/azure/keyvault-policy"

  vault_id  = module.keyvault.keyvault_id
  tenant_id = data.azurerm_client_config.current.tenant_id
  object_ids = [
    azurerm_user_assigned_identity.osduidentity.principal_id
  ]
  key_permissions         = ["get", "encrypt", "decrypt"]
  certificate_permissions = ["get"]
  secret_permissions      = ["get"]
}

resource "azurerm_role_assignment" "kv_roles" {
  count = length(local.rbac_principals_airflow)

  role_definition_name = "Reader"
  principal_id         = local.rbac_principals_airflow[count.index]
  scope                = module.keyvault.keyvault_id
}

#-------------------------------
# OSDU Identity
#-------------------------------
// Identity for OSDU Pod Identity
resource "azurerm_user_assigned_identity" "osduidentity" {
  name                = local.osdupod_identity_name
  resource_group_name = local.resource_group_name
  location            = var.resource_group_location

  tags = var.resource_tags
}

#-------------------------------
# Container Registry
#-------------------------------
module "container_registry" {
  source = "../../../../modules/providers/azure/container-registry"

  container_registry_name = local.container_registry_name
  resource_group_name     = local.resource_group_name

  container_registry_sku           = var.container_registry_sku
  container_registry_admin_enabled = false

  resource_tags = var.resource_tags
}


#-------------------------------
# PostgreSQL
#-------------------------------
resource "random_password" "postgres" {
  count = var.postgres_password == "" ? 1 : 0

  length           = 8
  special          = true
  override_special = "_%@"
  min_upper        = 1
  min_lower        = 1
  min_numeric      = 1
  min_special      = 1
}

module "postgreSQL" {
  source = "../../../../modules/providers/azure/postgreSQL"

  resource_group_name       = local.resource_group_name
  name                      = local.postgresql_name
  databases                 = var.postgres_databases
  admin_user                = var.postgres_username
  admin_password            = local.postgres_password
  sku                       = var.postgres_sku
  postgresql_configurations = var.postgres_configurations

  storage_mb                   = 5120
  server_version               = "10.0"
  backup_retention_days        = 7
  geo_redundant_backup_enabled = true
  auto_grow_enabled            = true
  ssl_enforcement_enabled      = true

  public_network_access = true
  firewall_rules = [{
    start_ip = "0.0.0.0"
    end_ip   = "0.0.0.0"
  }]

  resource_tags = var.resource_tags
}

// Add Contributor Role Access
resource "azurerm_role_assignment" "postgres_access" {
  count = length(local.rbac_principals_airflow)

  role_definition_name = local.role
  principal_id         = local.rbac_principals_airflow[count.index]
  scope                = module.postgreSQL.server_id
}

#-------------------------------
# Azure Redis Cache
#-------------------------------
module "redis_cache" {
  source = "../../../../modules/providers/azure/redis-cache"

  name                = local.redis_cache_name
  resource_group_name = local.resource_group_name
  capacity            = var.redis_capacity

  memory_features     = var.redis_config_memory
  premium_tier_config = var.redis_config_schedule

  resource_tags = var.resource_tags
}

// Add Contributor Role Access
resource "azurerm_role_assignment" "redis_cache" {
  count = length(local.rbac_principals_airflow)

  role_definition_name = local.role
  principal_id         = local.rbac_principals_airflow[count.index]
  scope                = module.redis_cache.id
}

#-------------------------------
# Log Analytics
#-------------------------------
module "log_analytics" {
  source = "../../../../modules/providers/azure/log-analytics"

  name                = local.logs_name
  resource_group_name = local.resource_group_name
  resource_tags       = var.resource_tags
}

#-------------------------------
# Deployment Resources
#-------------------------------
module "aks_deployment_resources" {
  source = "../../../../modules/providers/azure/aks_deployment_resources"

  resource_group_name     = local.resource_group_name
  resource_tags           = var.resource_tags
  resource_group_id       = var.resource_group_id
  resource_group_location = var.resource_group_location

  # ----- VNET Settings -----
  vnet_name = local.vnet_name

  address_space     = var.address_space
  subnet_aks_prefix = var.subnet_aks_prefix
  subnet_fe_prefix  = var.subnet_fe_prefix

  fe_subnet_name  = local.fe_subnet_name
  aks_subnet_name = local.aks_subnet_name

  # ----- AKS Settings -------
  aks_cluster_name                     = local.aks_cluster_name
  aks_dns_prefix                       = local.aks_dns_prefix
  aks_agent_vm_count                   = var.aks_agent_vm_count
  aks_agent_vm_size                    = var.aks_agent_vm_size
  aks_agent_vm_disk                    = var.aks_agent_vm_disk
  aks_agent_vm_maxcount                = var.aks_agent_vm_maxcount
  ssh_public_key_file                  = var.ssh_public_key_file
  kubernetes_version                   = var.kubernetes_version
  log_retention_days                   = var.log_retention_days
  log_analytics_id                     = data.terraform_remote_state.central_resources.outputs.log_analytics_id
  container_registry_id_central        = data.terraform_remote_state.central_resources.outputs.container_registry_id
  container_registry_id_data_partition = module.container_registry.container_registry_id
  osdu_identity_id                     = azurerm_user_assigned_identity.osduidentity.id
}

#-------------------------------
# AKS Configuration Resources
#-------------------------------
module "aks_config_resources" {
  source = "../../../../modules/providers/azure/aks_config_resources"

  # Do not configure AKS and Helm until resources are fully created
  # https://github.com/hashicorp/terraform-provider-kubernetes/blob/6852542fca3894ef4dff397c5b7e7b0c4f32bbac/_examples/aks/README.md
  # https://github.com/hashicorp/terraform-provider-helm/issues/647
  depends_on = [module.aks_deployment_resources]

  log_analytics_id = data.terraform_remote_state.central_resources.outputs.log_analytics_id

  pod_identity_id  = azurerm_user_assigned_identity.osduidentity.id
  pod_principal_id = azurerm_user_assigned_identity.osduidentity.principal_id

  aks_cluster_name = local.aks_cluster_name

  # ----- AKS Config Map Settings -------
  container_registry_name = module.container_registry.container_registry_name
  feature_flag            = var.feature_flag
  key_vault_name          = module.keyvault.keyvault_id
  postgres_fqdn           = module.postgreSQL.server_fqdn
  postgres_username       = var.postgres_username
  subscription_name       = data.azurerm_subscription.current.display_name
  tenant_id               = data.azurerm_client_config.current.tenant_id

}