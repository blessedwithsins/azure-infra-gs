#-------------------------------
# Private Variables
#-------------------------------
locals {
  storage_account_name = format("%s-storage", var.data_partition_name)
  storage_key_name     = format("%s-key", local.storage_account_name)

  config_storage_account_name    = "airflow-storage"
  config_storage_key_name        = "${local.config_storage_account_name}-key"
  config_storage_connection_name = "${local.config_storage_account_name}-connection"

  redis_queue_hostname      = "redis-queue-hostname"
  redis_queue_password_name = "redis-queue-password"

  logs_id_name  = "log-workspace-id"
  logs_key_name = "log-workspace-key"

}

// Add the Fernet Key to the Vault
resource "azurerm_key_vault_secret" "airflow_fernet_key_secret" {
  name         = "airflow-fernet-key"
  value        = base64encode(random_string.airflow_fernete_key_rnd.result)
  key_vault_id = module.keyvault.keyvault_id
}

// Add the Airflow Admin to the Vault
resource "azurerm_key_vault_secret" "airflow_admin_password" {
  name         = "airflow-admin-password"
  value        = local.airflow_admin_password
  key_vault_id = module.keyvault.keyvault_id
}

// Add the Airflow Admin Password to the Central Key Vault as well
resource "azurerm_key_vault_secret" "airflow_password" {
  name         = format("%s-airflow-password", var.data_partition_name)
  value        = local.airflow_admin_password
  key_vault_id = data.terraform_remote_state.central_resources.outputs.keyvault_id
}

// Add the Airflow Log Connection to the Vault
resource "azurerm_key_vault_secret" "airflow_remote_log_connection" {
  name         = "airflow-remote-log-connection"
  value        = format("wasb://%s:%s@", var.storage_account_name, urlencode(var.storage_account_key))
  key_vault_id = module.keyvault.keyvault_id
}

#-------------------------------
# PostgreSQL
#-------------------------------

locals {
  postgres_password_name = "postgres-password"
  postgres_password      = coalesce(var.postgres_password, random_password.postgres.result)
}

resource "azurerm_key_vault_secret" "postgres_password" {
  name         = local.postgres_password_name
  value        = local.postgres_password
  key_vault_id = module.keyvault.keyvault_id
}

resource "azurerm_key_vault_secret" "redis_queue_host" {
  name         = local.redis_queue_hostname
  value        = module.redis_queue.hostname
  key_vault_id = module.keyvault.keyvault_id
}

resource "azurerm_key_vault_secret" "redis_queue_password" {
  name         = local.redis_queue_password_name
  value        = module.redis_queue.primary_access_key
  key_vault_id = module.keyvault.keyvault_id
}

#-------------------------------
# Misc
#-------------------------------
resource "azurerm_key_vault_secret" "base_name_dp" {
  name         = "base-name-dp"
  value        = local.base_name_60
  key_vault_id = module.keyvault.keyvault_id
}

resource "azurerm_key_vault_secret" "tenant_id" {
  name         = format("%s-tenant-id", "data-partition")
  value        = data.azurerm_client_config.current.tenant_id
  key_vault_id = module.keyvault.keyvault_id
}

resource "azurerm_key_vault_secret" "subscription_id" {
  name         = format("%s-subscription-id", "data-partition")
  value        = data.azurerm_client_config.current.subscription_id
  key_vault_id = module.keyvault.keyvault_id
}

#-------------------------------
# OSDU Identity
#-------------------------------
resource "azurerm_key_vault_secret" "identity_id" {
  name         = "management-identity-id"
  value        = azurerm_user_assigned_identity.osduidentity.client_id
  key_vault_id = module.keyvault.keyvault_id
}

#-------------------------------
# Log Analytics
#-------------------------------
resource "azurerm_key_vault_secret" "workspace_id" {
  name         = local.logs_id_name
  value        = module.log_analytics.log_workspace_id
  key_vault_id = module.keyvault.keyvault_id
}

resource "azurerm_key_vault_secret" "workspace_key" {
  name         = local.logs_key_name
  value        = module.log_analytics.log_workspace_key
  key_vault_id = module.keyvault.keyvault_id
}

resource "azurerm_key_vault_secret" "config_storage_name" {
  name         = local.config_storage_account_name
  value        = var.storage_account_name
  key_vault_id = module.keyvault.keyvault_id
}

resource "azurerm_key_vault_secret" "config_storage_key" {
  name         = local.config_storage_key_name
  value        = var.storage_account_key
  key_vault_id = module.keyvault.keyvault_id
}

resource "azurerm_key_vault_secret" "config_storage_connection" {
  name         = local.config_storage_connection_name
  value        = format("DefaultEndpointsProtocol=https;AccountName=%s;AccountKey=%s;EndpointSuffix=core.windows.net", var.storage_account_name, var.storage_account_key)
  key_vault_id = module.keyvault.keyvault_id
}


// Data Partition name
resource "azurerm_key_vault_secret" "data_partition_name" {
  name         = "data-partition-name"
  value        = var.data_partition_name
  key_vault_id = module.keyvault.keyvault_id
}

// data source to output the value of secret
data "azurerm_key_vault_secret" "data_principal_id" {
  name         = "app-dev-sp-username"
  key_vault_id = var.cr_keyvault_id
}

// data source to output the value of secret
data "azurerm_key_vault_secret" "data_principal_secret" {
  name         = "app-dev-sp-password"
  key_vault_id = var.cr_keyvault_id
}

// data source to output the value of secret
data "azurerm_key_vault_secret" "data_application_id" {
  name         = "aad-client-id"
  key_vault_id = var.cr_keyvault_id
}

// data source to output the value of secret
data "azurerm_key_vault_secret" "data_insights" {
  name         = "appinsights-key"
  key_vault_id = var.cr_keyvault_id
}

resource "azurerm_key_vault_secret" "principal_id" {
  name         = "app-dev-sp-username"
  value        = data.azurerm_key_vault_secret.data_principal_id.value
  key_vault_id = module.keyvault.keyvault_id
}

resource "azurerm_key_vault_secret" "principal_secret" {
  name         = "app-dev-sp-password"
  value        = data.azurerm_key_vault_secret.data_principal_secret.value
  key_vault_id = module.keyvault.keyvault_id
}

resource "azurerm_key_vault_secret" "application_id" {
  name         = "aad-client-id"
  value        = data.azurerm_key_vault_secret.data_application_id.value
  key_vault_id = module.keyvault.keyvault_id
}

resource "azurerm_key_vault_secret" "azure_tenant_id" {
  name         = "app-dev-sp-tenant-id"
  value        = data.azurerm_client_config.current.tenant_id
  key_vault_id = module.keyvault.keyvault_id
}

resource "azurerm_key_vault_secret" "insights" {
  name         = "appinsights-key"
  value        = data.azurerm_key_vault_secret.data_insights.value
  key_vault_id = module.keyvault.keyvault_id
}