# //  Copyright © Microsoft Corporation
# //
# //  Licensed under the Apache License, Version 2.0 (the "License");
# //  you may not use this file except in compliance with the License.
# //  You may obtain a copy of the License at
# //
# //       http://www.apache.org/licenses/LICENSE-2.0
# //
# //  Unless required by applicable law or agreed to in writing, software
# //  distributed under the License is distributed on an "AS IS" BASIS,
# //  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# //  See the License for the specific language governing permissions and
# //  limitations under the License.


# /*
# .Synopsis
#    Terraform Security Control
# .DESCRIPTION
#    This file holds airflow specific settings.
# */


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

// Add the Fernet Key to the Vault
resource "azurerm_key_vault_secret" "airflow_fernet_key_secret" {
  name         = "airflow-fernet-key"
  value        = base64encode(random_string.airflow_fernete_key_rnd.result)
  key_vault_id = data.terraform_remote_state.central_resources.outputs.keyvault_id
}

// Add the Airflow Admin to the Vault
resource "azurerm_key_vault_secret" "airflow_admin_password" {
  name         = "airflow-admin-password"
  value        = local.airflow_admin_password
  key_vault_id = data.terraform_remote_state.central_resources.outputs.keyvault_id
}

// Create Fileshare and folder structure
resource "azurerm_storage_share" "airflow_share" {
  name                 = "airflowdags"
  storage_account_name = module.storage_account.name
  quota                = 50
}

resource "azurerm_storage_share_directory" "dags" {
  name                 = "dags"
  share_name           = azurerm_storage_share.airflow_share.name
  storage_account_name = module.storage_account.name
}

resource "azurerm_storage_share_directory" "plugins" {
  name                 = "plugins"
  share_name           = azurerm_storage_share.airflow_share.name
  storage_account_name = module.storage_account.name
}

resource "azurerm_storage_share_directory" "operators" {
  name                 = "plugins/operators"
  share_name           = azurerm_storage_share.airflow_share.name
  storage_account_name = module.storage_account.name
  depends_on           = [azurerm_storage_share_directory.plugins]
}

resource "azurerm_storage_share_directory" "hooks" {
  name                 = "plugins/hooks"
  share_name           = azurerm_storage_share.airflow_share.name
  storage_account_name = module.storage_account.name
  depends_on           = [azurerm_storage_share_directory.plugins]
}

resource "azurerm_storage_share_directory" "sensors" {
  name                 = "plugins/sensors"
  share_name           = azurerm_storage_share.airflow_share.name
  storage_account_name = module.storage_account.name
  depends_on           = [azurerm_storage_share_directory.plugins]
}

// Airflow log container
resource "azurerm_storage_container" "main" {
  name                  = "airflow-logs"
  storage_account_name  = module.storage_account.name
  container_access_type = "private"
}

// Airflow queue for blob create event
resource "azurerm_storage_queue" "main" {
  name                 = local.airflow_log_queue_name
  storage_account_name = module.storage_account.name
}

// Add the Airflow Log Connection to the Vault
resource "azurerm_key_vault_secret" "airflow_remote_log_connection" {
  name         = "airflow-remote-log-connection"
  value        = format("wasb://%s:%s@", module.storage_account.name, urlencode(module.storage_account.primary_access_key))
  key_vault_id = data.terraform_remote_state.central_resources.outputs.keyvault_id
}

// Add the Subscription to the Queue
resource "azurerm_eventgrid_event_subscription" "airflow_log_event_subscription" {
  name  = "airflowlogeventsubscription"
  scope = module.storage_account.id

  storage_queue_endpoint {
    storage_account_id = module.storage_account.id
    queue_name         = local.airflow_log_queue_name
  }

  included_event_types = ["Microsoft.Storage.BlobCreated"]

  subject_filter {
    subject_begins_with = "/blobServices/default/containers/airflow-logs/blobs"
  }

  depends_on = [azurerm_storage_queue.main]
}
