#-------------------------------
# PostgreSQL
#-------------------------------
resource "azurerm_monitor_diagnostic_setting" "postgres_diagnostics" {
  name                       = "postgres_diagnostics"
  target_resource_id         = module.postgreSQL.server_id
  log_analytics_workspace_id = module.log_analytics.id

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
  target_resource_id         = module.redis_cache.id
  log_analytics_workspace_id = module.log_analytics.id


  metric {
    category = "AllMetrics"

    retention_policy {
      days    = var.log_retention_days
      enabled = local.retention_policy
    }
  }
}