//  Copyright � Microsoft Corporation
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

variable "prefix" {
  description = "(Required) An identifier used to construct the names of all resources in this template."
  type        = string
}

variable "dashboards" {
  description = "(Optional) A toggle for dashboards"
  type = object({
    default     = bool
    appinsights = bool
  })
  default = {
    default     = true
    appinsights = true
  }
}

variable "randomization_level" {
  description = "Number of additional random characters to include in resource names to insulate against unexpected resource name collisions."
  type        = number
  default     = 4
}

variable "central_resources_workspace_name" {
  description = "(Required) The workspace name for the central_resources repository terraform environment / template to reference for this template."
  type        = string
}

variable "service_resources_workspace_name" {
  description = "(Required) The workspace name for the service_resources repository terraform environment / template to reference for this template."
  type        = string
}

variable "data_partition_resources_workspace_name" {
  description = "(Required) The workspace name for the data_partition_resources repository terraform environment / template to reference for this template."
  type        = string
}

variable "remote_state_account" {
  description = "Remote Terraform State Azure storage account name. This is typically set as an environment variable and used for the initial terraform init."
  type        = string
}

variable "remote_state_container" {
  description = "Remote Terraform State Azure storage container name. This is typically set as an environment variable and used for the initial terraform init."
  type        = string
}

variable "resource_group_location" {
  description = "(Required) The Azure region where all resources in this template should be created."
  type        = string
}

variable "resource_tags" {
  description = "Map of tags to apply to this template."
  type        = map(string)
  default     = {}
}

variable "tenant_name" {
  description = "(Required) The Azure AD tenant name."
  type        = string
}

variable "action-groups" {
  type = map(object({
    name       = string,
    short-name = string,
    # List of 0 or more email notification receivers
    email-receiver = list(object({
      name                = string,
      email-address       = string,
      common-alert-schema = bool
    })),
    # List of 0 or more SMS notification receivers
    sms-receiver = list(object({
      name         = string,
      country-code = string,
      phone        = string
    }))
  }))
}

variable "log-alerts" {
  type = map(object({
    service-name    = string,
    alert-rule-name = string,
    description     = string,
    # Metric Type: Alert can be based on metric measurement or based on number of results. 'metric-type' will be true if Alert is based on metric measurement.
    metric-type = bool,
    # Enabled: Alert can be enabled or disabled here. To delete alert altogether, remove the particular key-value pair corresponding to the alert from the collection.
    enabled = string,
    # Severity: 0 - critical, 1 - Error, 2 - Warning, 3 - Informational, 4 - Verbose
    severity = number,
    # Frequency: How often the query should be run
    frequency = number,
    # Time window for which data needs to be fetched for query
    time-window = number,
    # action-group-name: The names in this list must be consistent with names provided in action group map above.
    action-group-name = list(string),
    # query: The log query.
    query = string,
    # Threshold value for the log result
    trigger-threshold = number,
    # Operator used to compare the result value against the threshold.
    trigger-operator = string,

    # Type is `any` for the below keys as they need to be null if alert is based on number of results.
    metric-trigger-operator = any,
    # metric-trigger-threshold: Number of violations to trigger alert.
    metric-trigger-threshold = any,
    # Metric trigger type: 'Consecutive' or 'Total' breaches of threshold.
    metric-trigger-type = any,
    # Metric trigger column: column name on which aggregation is done
    metric-trigger-column = any
  }))
}

variable "metric-alerts" {
  type = map(object({
    name        = string,
    description = string,
    enabled     = string,
    # Severity: 0 - critical, 1 - Error, 2 - Warning, 3 - Informational, 4 - Verbose
    severity = number,
    # Frequency: The evaluation frequency of this Metric Alert, represented in ISO 8601 duration format
    frequency = string,
    # The period of time that is used to monitor alert activity, represented in ISO 8601 duration format
    window-size = string,
    # Action group names in the form of a map
    action-groups = map(string),
    # Resolve the alert when the condition is not met anymore. Defaults to true.
    auto-mitigate = bool,
    # One of the metric namespaces to be monitored
    criteria-metric-namespace = string,
    # One of the metric names to be monitored
    criteria-metric-name = string,
    # The statistic that runs over the metric values. Possible values are Average, Count, Minimum, Maximum and Total
    criteria-aggregation = string,
    # The criteria operator. Possible values are Equals, NotEquals, GreaterThan, GreaterThanOrEqual, LessThan and LessThanOrEqual
    criteria-operator = string,
    # The criteria threshold value that activates the alert
    criteria-threshold = number
  }))
}