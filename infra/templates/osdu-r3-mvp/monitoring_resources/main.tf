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

terraform {
  required_version = ">= 0.14"

  backend "azurerm" {
    key = "terraform.tfstate"
  }

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "=2.64.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "=2.3.1"
    }
  }
}


#-------------------------------
# Providers
#-------------------------------
provider "azurerm" {
  features {}
}


#-------------------------------
# Private Variables
#-------------------------------
locals {
  // sanitize names
  prefix    = replace(trimspace(lower(var.prefix)), "_", "-")
  workspace = replace(trimspace(lower(terraform.workspace)), "-", "")
  suffix    = var.randomization_level > 0 ? "-${random_string.workspace_scope.result}" : ""

  base_name = length(local.prefix) > 0 ? "${local.prefix}-${local.workspace}${local.suffix}" : "${local.workspace}${local.suffix}"

  resource_group_name = format("%s-%s-%s-rg", var.prefix, local.workspace, random_string.workspace_scope.result)
  template_path       = "./dashboard_templates"

  central_group_prefix   = trim(data.terraform_remote_state.central_resources.outputs.central_resource_group_name, "-rg")
  partition_group_prefix = trim(data.terraform_remote_state.partition_resources.outputs.data_partition_group_name, "-rg")
  service_group_prefix   = trim(data.terraform_remote_state.service_resources.outputs.services_resource_group_name, "-rg")

  log_analytics_resource_id = "/subscriptions/${data.azurerm_client_config.current.subscription_id}/resourceGroups/${local.central_group_prefix}-rg/providers/Microsoft.OperationalInsights/workspaces/${local.central_group_prefix}-logs"
  appinsights_resource_id   = "/subscriptions/${data.azurerm_client_config.current.subscription_id}/resourceGroups/${local.central_group_prefix}-rg/providers/Microsoft.Insights/components/${local.central_group_prefix}-ai"
  action-group-id-prefix    = "/subscriptions/${data.azurerm_client_config.current.subscription_id}/resourceGroups/${azurerm_resource_group.main.name}/providers/microsoft.insights/actiongroups/"
}

#-------------------------------
# Common Resources
#-------------------------------
data "azurerm_client_config" "current" {}

data "terraform_remote_state" "central_resources" {
  backend = "azurerm"

  config = {
    storage_account_name = var.remote_state_account
    container_name       = var.remote_state_container
    key                  = format("terraform.tfstateenv:%s", var.central_resources_workspace_name)
  }
}

data "terraform_remote_state" "partition_resources" {
  backend = "azurerm"

  config = {
    storage_account_name = var.remote_state_account
    container_name       = var.remote_state_container
    key                  = format("terraform.tfstateenv:%s", var.data_partition_resources_workspace_name)
  }
}

data "terraform_remote_state" "service_resources" {
  backend = "azurerm"

  config = {
    storage_account_name = var.remote_state_account
    container_name       = var.remote_state_container
    key                  = format("terraform.tfstateenv:%s", var.service_resources_workspace_name)
  }
}

resource "random_string" "workspace_scope" {
  keepers = {
    # Generate a new id each time we switch to a new workspace or app id
    ws_name    = replace(trimspace(lower(terraform.workspace)), "_", "-")
    cluster_id = replace(trimspace(lower(var.prefix)), "_", "-")
  }

  length  = max(1, var.randomization_level) // error for zero-length
  special = false
  upper   = false
}

#-------------------------------
# Resource Group
#-------------------------------
resource "azurerm_resource_group" "main" {
  name     = local.resource_group_name
  location = var.resource_group_location

  tags = var.resource_tags

  lifecycle {
    ignore_changes = [tags]
  }
}


#-------------------------------
# Dashboards
#-------------------------------

resource "azurerm_dashboard" "default_dashboard" {
  count = var.dashboards.default ? 1 : 0

  name                = "${local.base_name}-default-dash"
  resource_group_name = azurerm_resource_group.main.name
  location            = azurerm_resource_group.main.location
  tags                = var.resource_tags

  dashboard_properties = templatefile("${local.template_path}/default.tpl", {
    tenantName           = var.tenant_name
    subscriptionId       = data.azurerm_client_config.current.subscription_id
    centralGroupPrefix   = local.central_group_prefix
    partitionGroupPrefix = local.partition_group_prefix
    serviceGroupPrefix   = local.service_group_prefix
    partitionStorage     = data.terraform_remote_state.partition_resources.outputs.storage_account
  })
}

resource "azurerm_dashboard" "airflow_infra_dashboard" {
  count = var.dashboards.airflow_infra ? 1 : 0

  name                = "${local.base_name}-airflow-infra-dash"
  resource_group_name = azurerm_resource_group.main.name
  location            = azurerm_resource_group.main.location
  tags                = var.resource_tags

  dashboard_properties = templatefile("${local.template_path}/airflow-infra.tpl", {
    subscriptionId     = data.azurerm_client_config.current.subscription_id
    centralGroupPrefix = local.central_group_prefix
  })
}

resource "azurerm_dashboard" "airflow_service_dashboard" {
  count = var.dashboards.airflow_service ? 1 : 0

  name                = "${local.base_name}-airflow-service-dash"
  resource_group_name = azurerm_resource_group.main.name
  location            = azurerm_resource_group.main.location
  tags                = var.resource_tags

  dashboard_properties = templatefile("${local.template_path}/airflow-service.tpl", {
    subscriptionId     = data.azurerm_client_config.current.subscription_id
    centralGroupPrefix = local.central_group_prefix
  })
}

resource "azurerm_dashboard" "airflow_dags_dashboard" {
  count = var.dashboards.airflow_dags ? 1 : 0

  name                = "${local.base_name}-airflow-dags-dash"
  resource_group_name = azurerm_resource_group.main.name
  location            = azurerm_resource_group.main.location
  tags                = var.resource_tags

  dashboard_properties = templatefile("${local.template_path}/airflow-dags.tpl", {
    subscriptionId     = data.azurerm_client_config.current.subscription_id
    centralGroupPrefix = local.central_group_prefix
  })
}

resource "azurerm_dashboard" "appinsights_dashboard" {
  count = var.dashboards.appinsights ? 1 : 0

  name                = "${local.base_name}-appinsights-dash"
  resource_group_name = azurerm_resource_group.main.name
  location            = azurerm_resource_group.main.location
  tags                = var.resource_tags

  dashboard_properties = templatefile("${local.template_path}/appinsights.tpl", {
    subscriptionId     = data.azurerm_client_config.current.subscription_id
    centralGroupPrefix = local.central_group_prefix
  })
}

#-------------------------------
# Action Groups
#-------------------------------
resource "azurerm_monitor_action_group" "action-groups" {
  for_each            = var.action-groups
  name                = "${local.base_name}-${each.value.name}"
  resource_group_name = azurerm_resource_group.main.name
  short_name          = each.value.short-name

  # There can be 0 or more email receivers
  dynamic "email_receiver" {
    for_each = each.value.email-receiver
    content {
      name                    = email_receiver.value.name
      email_address           = email_receiver.value.email-address
      use_common_alert_schema = false
    }
  }

  # There can be 0 or more sms receivers
  dynamic "sms_receiver" {
    for_each = each.value.sms-receiver
    content {
      name         = sms_receiver.value.name
      country_code = sms_receiver.value.country-code
      phone_number = sms_receiver.value.phone
    }
  }
}

#-------------------------------
# Custom Log Search Type Alerts
#-------------------------------
resource "azurerm_monitor_scheduled_query_rules_alert" "alerts" {
  for_each            = var.log-alerts
  name                = "${each.value.alert-rule-name}-${local.base_name}"
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name

  action {
    action_group = [for name in each.value.action-group-name :
      format("%s${local.base_name}-%s", local.action-group-id-prefix, name)
    ]
  }

  data_source_id = each.value.log-analytics-scope ? local.log_analytics_resource_id : local.appinsights_resource_id

  description = each.value.description
  enabled     = each.value.enabled
  query       = each.value.query
  severity    = each.value.severity
  frequency   = each.value.frequency
  time_window = each.value.time-window
  trigger {
    operator  = each.value.trigger-operator
    threshold = each.value.trigger-threshold
    dynamic "metric_trigger" {
      # create this block only if alert is of `metric` type
      for_each = each.value.metric-type ? [1] : []
      content {
        operator            = each.value.metric-trigger-operator
        threshold           = each.value.metric-trigger-threshold
        metric_trigger_type = each.value.metric-trigger-type
        metric_column       = each.value.metric-trigger-column
      }
    }
  }
}

#-------------------------------
# Metric Type Alerts
#-------------------------------
resource "azurerm_monitor_metric_alert" "example" {
  for_each            = var.metric-alerts
  name                = "${each.value.name}-${local.base_name}"
  resource_group_name = azurerm_resource_group.main.name
  # A set of strings of resource IDs at which the metric criteria should be applied
  scopes        = ["/subscriptions/${data.azurerm_client_config.current.subscription_id}/resourceGroups/${local.central_group_prefix}-rg/providers/Microsoft.Insights/components/${local.central_group_prefix}-ai"]
  description   = each.value.description
  enabled       = each.value.enabled
  severity      = each.value.severity
  frequency     = each.value.frequency
  window_size   = each.value.window-size
  auto_mitigate = each.value.auto-mitigate

  criteria {
    metric_namespace = each.value.criteria-metric-namespace
    metric_name      = each.value.criteria-metric-name
    aggregation      = each.value.criteria-aggregation
    operator         = each.value.criteria-operator
    threshold        = each.value.criteria-threshold
  }

  # Add multiple action blocks if multiple action groups are to be associated
  dynamic "action" {
    for_each = each.value.action-groups
    content {
      action_group_id = format("%s${local.base_name}-%s", local.action-group-id-prefix, action.value)
    }
  }
}
