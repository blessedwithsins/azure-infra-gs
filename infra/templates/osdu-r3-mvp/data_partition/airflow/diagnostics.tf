#-------------------------------
# PostgreSQL
#-------------------------------
resource "azurerm_monitor_diagnostic_setting" "postgres_diagnostics" {
  name                       = "postgres_diagnostics"
  target_resource_id         = module.postgreSQL.server_id
  log_analytics_workspace_id = data.terraform_remote_state.central_resources.outputs.log_analytics_id

  log {
    category = "PostgreSQLLogs"

    retention_policy {
      days    = var.log_retention_days
      enabled = local.retention_policy
    }
  }

  log {
    category = "QueryStoreRuntimeStatistics"

    retention_policy {
      enabled = false
    }
  }

  log {
    category = "QueryStoreWaitStatistics"

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
# Azure Redis Cache
#-------------------------------
resource "azurerm_monitor_diagnostic_setting" "redis_diagnostics" {
  name                       = "redis_diagnostics"
  target_resource_id         = module.redis_queue.id
  log_analytics_workspace_id = data.terraform_remote_state.central_resources.outputs.log_analytics_id


  metric {
    category = "AllMetrics"

    retention_policy {
      days    = var.log_retention_days
      enabled = local.retention_policy
    }
  }
}