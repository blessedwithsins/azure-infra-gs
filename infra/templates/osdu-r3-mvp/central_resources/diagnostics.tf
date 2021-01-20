//  Copyright © Microsoft Corporation
//
//  Licensed under the Apache License, Version 2.0 (the "License");
//  you may not use this file except in compliance with the License.
//  You may obtain a copy of the License at
//
//       http://www.apache.org/licenses/LICENSE-2.0
//
//  Unless required by applicable law or agreed to in writing, software
//  distributed under the License is distributed on an "AS IS" BASIS,
//  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//  See the License for the specific language governing permissions and
//  limitations under the License.


/*
.Synopsis
   Terraform Diagnostics Control
.DESCRIPTION
   This file holds diagnostics settings.
*/

#-------------------------------
# Key Vault
#-------------------------------
resource "azurerm_monitor_diagnostic_setting" "kv_diagnostics" {
  name                       = "kv_diagnostics"
  target_resource_id         = module.keyvault.keyvault_id
  log_analytics_workspace_id = module.log_analytics.id

  log {
    category = "AuditEvent"

    retention_policy {
      enabled = false
    }
  }

  metric {
    category = "AllMetrics"

    retention_policy {
      days    = var.log_retention_days
      enabled = local.retention_policy
    }
  }
}


#-------------------------------
# Container Registry
#-------------------------------
resource "azurerm_monitor_diagnostic_setting" "acr_diagnostics" {
  name                       = "acr_diagnostics"
  target_resource_id         = module.container_registry.container_registry_id
  log_analytics_workspace_id = module.log_analytics.id

  log {
    category = "ContainerRegistryRepositoryEvents"
    enabled  = true

    retention_policy {
      days    = var.log_retention_days
      enabled = local.retention_policy
    }
  }

  log {
    category = "ContainerRegistryLoginEvents"
    enabled  = true

    retention_policy {
      days    = var.log_retention_days
      enabled = local.retention_policy
    }
  }

  metric {
    category = "AllMetrics"

    retention_policy {
      days    = var.log_retention_days
      enabled = local.retention_policy
    }
  }
}

#-------------------------------
# GraphDB
#-------------------------------
resource "azurerm_monitor_diagnostic_setting" "graph_diagnostics" {
  name                       = "graph_diagnostics"
  target_resource_id         = module.graph_account.account_id
  log_analytics_workspace_id = module.log_analytics.id

  // This one always off.
  log {
    category = "CassandraRequests"
    enabled  = false

    retention_policy {
      days    = 0
      enabled = false
    }
  }

  log {
    category = "ControlPlaneRequests"

    retention_policy {
      days    = var.log_retention_days
      enabled = local.retention_policy
    }
  }

  log {
    category = "DataPlaneRequests"
    enabled  = true

    retention_policy {
      days    = var.log_retention_days
      enabled = local.retention_policy
    }
  }

  // This one always off.
  log {
    category = "GremlinRequests"
    enabled  = true

    retention_policy {
      days    = var.log_retention_days
      enabled = local.retention_policy
    }
  }

  // This one always off.
  log {
    category = "MongoRequests"
    enabled  = false

    retention_policy {
      days    = 0
      enabled = false
    }
  }

  log {
    category = "PartitionKeyRUConsumption"

    retention_policy {
      days    = var.log_retention_days
      enabled = local.retention_policy
    }
  }

  log {
    category = "PartitionKeyStatistics"

    retention_policy {
      days    = var.log_retention_days
      enabled = local.retention_policy
    }
  }

  log {
    category = "QueryRuntimeStatistics"
    enabled  = true

    retention_policy {
      days    = var.log_retention_days
      enabled = local.retention_policy
    }
  }

  metric {
    category = "Requests"

    retention_policy {
      days    = var.log_retention_days
      enabled = local.retention_policy
    }
  }
}
