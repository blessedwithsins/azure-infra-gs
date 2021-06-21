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

prefix      = "osdu-mvp"
tenant_name = "azureglobal1"

dashboards = {
  default     = true
  appinsights = true
}

# Populated below is a collection of sample action groups.
action-groups = {
  DevActionGroup = {
    name       = "DevActionGroup",
    short-name = "dev-ag",
    email-receiver = [
      {
        name                = "primary receiver",
        email-address       = "dummy@microsoft.com",
        common-alert-schema = false
      }
    ],
    sms-receiver = []
  },
  ProdActionGroup = {
    name           = "ProdActionGroup",
    short-name     = "prod-ag",
    email-receiver = [],
    sms-receiver = [
      {
        name         = "local support",
        country-code = "91",
        phone        = "9898989898"
      }
    ]
  }
}

# Populated below is data to configure two sample alerts - one based on metric measurement and the other based on number of results.
log-alerts = {
  #------------Storage Service Alerts----------------#
  storage-cpu-alert = {
    service-name    = "storage",
    alert-rule-name = "CPU-Soft-Limit",
    description     = "CPU Soft limit alert rule for storage service",
    # Alert based on metric measurement
    metric-type       = true
    enabled           = "false",
    severity          = 3,
    frequency         = 15,
    time-window       = 15,
    action-group-name = ["ProdActionGroup", "DevActionGroup"],
    query             = "performanceCounters\n| where cloud_RoleName == \"storage\"\n| where category == \"Processor\" and name == \"% Processor Time\"\n| summarize AggregatedValue = avg(value) by bin(timestamp, 15min)",
    # Threshold value for CPU usage which when exceeded will raise alert
    trigger-threshold       = 60,
    trigger-operator        = "GreaterThan",
    metric-trigger-operator = "GreaterThan",
    # Number of times the threshold value is allowed to exceed
    metric-trigger-threshold = 0,
    # Type can be based on total breaches or consecutive breaches of threshold.
    metric-trigger-type   = "Total",
    metric-trigger-column = "timestamp"
  },
  storage-put-record-duration = {
    service-name    = "storage",
    alert-rule-name = "Put-Record-Duration",
    description     = "Alert for duration of storage service PUT record API call",
    # Alert based on Number of results hence metric-type is false
    metric-type       = false
    enabled           = "true",
    severity          = 3,
    frequency         = 5,
    time-window       = 5,
    action-group-name = ["DevActionGroup"],
    query             = "requests\n| where cloud_RoleName == \"storage\"\n| where name == \"PUT RecordApi/createOrUpdateRecords \"\n| where duration/1000 > 60\n",
    # Number of results > 1 => alert is triggered.
    trigger-threshold = 1,
    trigger-operator  = "GreaterThan",
    #------ Supply dummy values for below variables since it is not a metric based alert -----#
    metric-trigger-operator  = null,
    metric-trigger-threshold = null,
    metric-trigger-type      = null,
    metric-trigger-column    = null
  }
}

# Sample Metric Type Alert data
metric-alerts = {
  osdu-airflow-collect-dags = {
    name        = "OSDU_AirflowCollectDags",
    description = "Airflow Alert for average time taken to collect dags",
    enabled     = "true",
    severity    = 3,
    frequency   = "PT15M",
    window-size = "PT15M",
    action-groups = {
      1 = "DevActionGroup",
      2 = "ProdActionGroup"
    },
    auto-mitigate             = true,
    criteria-metric-namespace = "azure.applicationinsights",
    criteria-metric-name      = "osdu_airflow.collect_dags",
    criteria-aggregation      = "Average",
    criteria-operator         = "GreaterThan",
    criteria-threshold        = 50
  }
}