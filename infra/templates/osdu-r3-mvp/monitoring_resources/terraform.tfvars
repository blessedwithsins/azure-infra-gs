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
  default         = true
  appinsights     = true
  airflow_infra   = true
  airflow_service = true
  airflow_dags    = true
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
  },
  #------------Airflow Alerts----------------#
  # Airflow Component Host Count Alert #
  airflow-scheduler-host-count-alert = {
    # Scope for log query.
    log-analytics-scope = true,
    service-name        = "airflow",
    alert-rule-name     = "airflow-scheduler-host-count-alert",
    description         = "Alert to trigger when the host count of airflow scheduler goes below the reqd count",
    # Alert based on metric measurement
    metric-type       = true
    enabled           = "true",
    severity          = 3,
    frequency         = 5,
    time-window       = 5,
    action-group-name = ["ProdActionGroup", "DevActionGroup"],
    query             = "KubePodInventory\n| where ControllerName contains \"airflow-scheduler\"\n| extend InstanceName = strcat(ClusterId, '/', ContainerName), ContainerName = strcat(ControllerName, '/', tostring(split(ContainerName, '/')[1])), PodName = Name\n| where PodStatus in ('Running')\n| where PodName contains \"airflow-scheduler\"\n| where ContainerName endswith \"airflow-scheduler\"\n| project Computer, InstanceName, ContainerName, PodName, PodStatus, TimeGenerated, Count = 1\n| parse kind=regex PodName with partitionId \"-airflow-scheduler-[[:graph:]]\"\n| extend dataPartitionID = case(partitionId == \"\", \"common-cluster\",\n    partitionId)\n| summarize AggregatedValue = avg(Count) by  bin(TimeGenerated, 5m), HostName = strcat(dataPartitionID, \"-\", \"airflow-scheduler\"), dataPartitionID",
    # Threshold value for Scheduler Host Count, which when is less than will raise alert
    trigger-threshold       = 1,
    trigger-operator        = "LessThan",
    metric-trigger-operator = "GreaterThan",
    # Number of times the threshold value is allowed to exceed
    metric-trigger-threshold = 1,
    # Type can be based on total breaches or consecutive breaches of threshold.
    metric-trigger-type   = "Consecutive",
    metric-trigger-column = "HostName"
  },
  airflow-web-host-count-alert = {
    # Scope for log query.
    log-analytics-scope = true,
    service-name        = "airflow",
    alert-rule-name     = "airflow-web-host-count-alert",
    description         = "Alert to trigger when the host count of airflow web goes below the reqd count",
    # Alert based on metric measurement
    metric-type       = true
    enabled           = "true",
    severity          = 3,
    frequency         = 5,
    time-window       = 5,
    action-group-name = ["ProdActionGroup", "DevActionGroup"],
    query             = "KubePodInventory\n| where ControllerName contains \"airflow-web\"\n| extend InstanceName = strcat(ClusterId, '/', ContainerName), ContainerName = strcat(ControllerName, '/', tostring(split(ContainerName, '/')[1])), PodName = Name\n| where PodStatus in ('Running')\n| where PodName contains \"airflow-web\"\n| where ContainerName endswith \"airflow-web\"\n| project Computer, InstanceName, ContainerName, PodName, PodStatus, TimeGenerated, Count = 1\n| parse kind=regex PodName with partitionId \"-airflow-web-[[:graph:]]\"\n| extend dataPartitionID = case(partitionId == \"\", \"common-cluster\",\n    partitionId)\n| summarize AggregatedValue = avg(Count) by  bin(TimeGenerated, 5m), HostName = strcat(dataPartitionID, \"-\", \"airflow-web\"), dataPartitionID",
    # Threshold value for Web Host Count, which when is less than will raise alert
    trigger-threshold       = 2,
    trigger-operator        = "LessThan",
    metric-trigger-operator = "GreaterThan",
    # Number of times the threshold value is allowed to exceed
    metric-trigger-threshold = 1,
    # Type can be based on total breaches or consecutive breaches of threshold.
    metric-trigger-type   = "Consecutive",
    metric-trigger-column = "HostName"
  },
  airflow-worker-host-count-alert = {
    # Scope for log query.
    log-analytics-scope = true,
    service-name        = "airflow",
    alert-rule-name     = "airflow-worker-host-count-alert",
    description         = "Alert to trigger when the host count of airflow worker goes below the reqd count",
    # Alert based on metric measurement
    metric-type       = true
    enabled           = "true",
    severity          = 3,
    frequency         = 5,
    time-window       = 5,
    action-group-name = ["ProdActionGroup", "DevActionGroup"],
    query             = "KubePodInventory\n| where ControllerName contains \"airflow-worker\"\n| extend InstanceName = strcat(ClusterId, '/', ContainerName), ContainerName = strcat(ControllerName, '/', tostring(split(ContainerName, '/')[1])), PodName = Name\n| where PodStatus in ('Running')\n| where PodName contains \"airflow-worker\"\n| where ContainerName endswith \"airflow-worker\"\n| project Computer, InstanceName, ContainerName, PodName, PodStatus, TimeGenerated, Count = 1\n| parse kind=regex PodName with partitionId \"-airflow-worker-[[:graph:]]\"\n| extend dataPartitionID = case(partitionId == \"\", \"common-cluster\",\n    partitionId)\n| summarize AggregatedValue = avg(Count) by  bin(TimeGenerated, 5m), HostName = strcat(dataPartitionID, \"-\", \"airflow-worker\"), dataPartitionID",
    # Threshold value for Worker Host Count, which when is less than will raise alert
    trigger-threshold       = 1,
    trigger-operator        = "LessThan",
    metric-trigger-operator = "GreaterThan",
    # Number of times the threshold value is allowed to exceed
    metric-trigger-threshold = 1,
    # Type can be based on total breaches or consecutive breaches of threshold.
    metric-trigger-type   = "Consecutive",
    metric-trigger-column = "HostName"
  },
  # Airflow Component Cpu Usage Alert #
  airflow-scheduler-CPU-Usage-alert = {
    # Scope for log query.
    log-analytics-scope = true,
    service-name        = "airflow",
    alert-rule-name     = "airflow-scheduler-CPU-Usage-alert",
    description         = "Alert to trigger when the CPU Usage of the Scheduler goes above the threshold limit",
    # Alert based on metric measurement
    metric-type       = true
    enabled           = "true",
    severity          = 3,
    frequency         = 5,
    time-window       = 5,
    action-group-name = ["ProdActionGroup", "DevActionGroup"],
    query             = "let capacityCounterName = 'cpuLimitNanoCores';\nlet usageCounterName = 'cpuUsageNanoCores';\nlet cloudRoleName= \"airflow-scheduler\";\nKubePodInventory\n| where ControllerName has cloudRoleName\n| extend InstanceName = strcat(ClusterId, '/', ContainerName), ContainerName = strcat(ControllerName, '/', tostring(split(ContainerName, '/')[1])), PodName = Name\n| where PodStatus in ('Running')\n| where PodName contains cloudRoleName\n| where ContainerName endswith cloudRoleName\n| distinct Computer, InstanceName, ContainerName, PodName\n| join\n    hint.strategy=shuffle (\n    Perf\n    | where ObjectName == 'K8SContainer'\n    | where CounterName == capacityCounterName\n    | summarize LimitValue = max(CounterValue) by Computer, InstanceName, bin(TimeGenerated, 15m)\n    | project Computer, InstanceName, LimitValue, limitA=100\n    )\n    on Computer, InstanceName\n| join kind=inner\n    hint.strategy=shuffle (\n    Perf\n    | where ObjectName == 'K8SContainer'\n    | where CounterName == usageCounterName\n    | project Computer, InstanceName, UsageValue = CounterValue,\nlimit=100, TimeGenerated\n)\non Computer, InstanceName\n| project PodName, TimeGenerated, UsagePercent = UsageValue * 100.0 / LimitValue\n| parse kind=regex PodName with partitionId \"-airflow-scheduler-[[:graph:]]\"\n| extend dataPartitionID = case(partitionId == \"\", \"common-cluster\",\npartitionId)\n| extend PodName = case(dataPartitionID == \"common-cluster\", strcat(dataPartitionID, \"-\" ,PodName),\nPodName)\n| summarize AggregatedValue=max(UsagePercent) by PodName, bin(TimeGenerated, 5m), dataPartitionID",
    # Threshold value for CPU usage which when exceeded will raise alert
    trigger-threshold       = 80,
    trigger-operator        = "GreaterThan",
    metric-trigger-operator = "GreaterThan",
    # Number of times the threshold value is allowed to exceed
    metric-trigger-threshold = 2,
    # Type can be based on total breaches or consecutive breaches of threshold.
    metric-trigger-type   = "Consecutive",
    metric-trigger-column = "PodName"
  },
  airflow-web-CPU-Usage-alert = {
    # Scope for log query.
    log-analytics-scope = true,
    service-name        = "airflow",
    alert-rule-name     = "airflow-web-CPU-Usage-alert",
    description         = "Alert to trigger when the CPU Usage of the Airflow Web goes above the threshold limit",
    # Alert based on metric measurement
    metric-type       = true
    enabled           = "true",
    severity          = 3,
    frequency         = 5,
    time-window       = 5,
    action-group-name = ["ProdActionGroup", "DevActionGroup"],
    query             = "let capacityCounterName = 'cpuLimitNanoCores';\nlet usageCounterName = 'cpuUsageNanoCores';\nlet cloudRoleName= \"airflow-web\";\nKubePodInventory\n| where ControllerName has cloudRoleName\n| extend InstanceName = strcat(ClusterId, '/', ContainerName), ContainerName = strcat(ControllerName, '/', tostring(split(ContainerName, '/')[1])), PodName = Name\n| where PodStatus in ('Running')\n| where PodName contains cloudRoleName\n| where ContainerName endswith cloudRoleName\n| distinct Computer, InstanceName, ContainerName, PodName\n| join\n    hint.strategy=shuffle (\n    Perf\n    | where ObjectName == 'K8SContainer'\n    | where CounterName == capacityCounterName\n    | summarize LimitValue = max(CounterValue) by Computer, InstanceName, bin(TimeGenerated, 15m)\n    | project Computer, InstanceName, LimitValue, limitA=100\n    )\n    on Computer, InstanceName\n| join kind=inner\n    hint.strategy=shuffle (\n    Perf\n    | where ObjectName == 'K8SContainer'\n    | where CounterName == usageCounterName\n    | project Computer, InstanceName, UsageValue = CounterValue,\nlimit=100, TimeGenerated\n)\non Computer, InstanceName\n| project PodName, TimeGenerated, UsagePercent = UsageValue * 100.0 / LimitValue\n| parse kind=regex PodName with partitionId \"-airflow-web-[[:graph:]]\"\n| extend dataPartitionID = case(partitionId == \"\", \"common-cluster\",\npartitionId)\n| extend PodName = case(dataPartitionID == \"common-cluster\", strcat(dataPartitionID, \"-\" ,PodName),\nPodName)\n| summarize AggregatedValue=max(UsagePercent) by PodName, bin(TimeGenerated, 5m), dataPartitionID",
    # Threshold value for CPU usage which when exceeded will raise alert
    trigger-threshold       = 80,
    trigger-operator        = "GreaterThan",
    metric-trigger-operator = "GreaterThan",
    # Number of times the threshold value is allowed to exceed
    metric-trigger-threshold = 2,
    # Type can be based on total breaches or consecutive breaches of threshold.
    metric-trigger-type   = "Consecutive",
    metric-trigger-column = "PodName"
  },
  airflow-worker-CPU-Usage-alert = {
    # Scope for log query.
    log-analytics-scope = true,
    service-name        = "airflow",
    alert-rule-name     = "airflow-worker-CPU-Usage-alert",
    description         = "Alert to trigger when the CPU Usage of the Airflow Worker goes above the threshold limit",
    # Alert based on metric measurement
    metric-type       = true
    enabled           = "true",
    severity          = 3,
    frequency         = 5,
    time-window       = 5,
    action-group-name = ["ProdActionGroup", "DevActionGroup"],
    query             = "let capacityCounterName = 'cpuLimitNanoCores';\nlet usageCounterName = 'cpuUsageNanoCores';\nlet cloudRoleName= \"airflow-worker\";\nKubePodInventory\n| where ControllerName has cloudRoleName\n| extend InstanceName = strcat(ClusterId, '/', ContainerName), ContainerName = strcat(ControllerName, '/', tostring(split(ContainerName, '/')[1])), PodName = Name\n| where PodStatus in ('Running')\n| where PodName contains cloudRoleName\n| where ContainerName endswith cloudRoleName\n| distinct Computer, InstanceName, ContainerName, PodName\n| join\n    hint.strategy=shuffle (\n    Perf\n    | where ObjectName == 'K8SContainer'\n    | where CounterName == capacityCounterName\n    | summarize LimitValue = max(CounterValue) by Computer, InstanceName, bin(TimeGenerated, 15m)\n    | project Computer, InstanceName, LimitValue, limitA=100\n    )\n    on Computer, InstanceName\n| join kind=inner\n    hint.strategy=shuffle (\n    Perf\n    | where ObjectName == 'K8SContainer'\n    | where CounterName == usageCounterName\n    | project Computer, InstanceName, UsageValue = CounterValue,\nlimit=100, TimeGenerated\n)\non Computer, InstanceName\n| project PodName, TimeGenerated, UsagePercent = UsageValue * 100.0 / LimitValue\n| parse kind=regex PodName with partitionId \"-airflow-worker-[[:graph:]]\"\n| extend dataPartitionID = case(partitionId == \"\", \"common-cluster\",\npartitionId)\n| extend PodName = case(dataPartitionID == \"common-cluster\", strcat(dataPartitionID, \"-\" ,PodName),\nPodName)\n| summarize AggregatedValue=max(UsagePercent) by PodName, bin(TimeGenerated, 5m), dataPartitionID",
    # Threshold value for CPU usage which when exceeded will raise alert
    trigger-threshold       = 80,
    trigger-operator        = "GreaterThan",
    metric-trigger-operator = "GreaterThan",
    # Number of times the threshold value is allowed to exceed
    metric-trigger-threshold = 2,
    # Type can be based on total breaches or consecutive breaches of threshold.
    metric-trigger-type   = "Consecutive",
    metric-trigger-column = "PodName"
  },
  airflow-postgres-CPU-Usage-alert = {
    # Scope for log query.
    log-analytics-scope = true,
    service-name        = "airflow",
    alert-rule-name     = "airflow-postgres-CPU-Usage-alert",
    description         = "Alert to trigger when the CPU Usage of the PostgreSQL Server goes above the threshold limit",
    # Alert based on metric measurement
    metric-type       = true
    enabled           = "true",
    severity          = 3,
    frequency         = 5,
    time-window       = 5,
    action-group-name = ["ProdActionGroup", "DevActionGroup"],
    query             = "KubePodInventory\n| where Name has \"airflow\"\n| parse kind=regex Name with partitionId \"-airflow-[[:graph:]]\"\n| extend dataPartitionID = case(partitionId == \"\", \"common-cluster\",\n    partitionId)\n| distinct dataPartitionID \n| extend dummy=1 \n| join kind=inner \n    (AzureMetrics\n    | where ResourceProvider == \"MICROSOFT.DBFORPOSTGRESQL\" \n    | parse kind=regex _ResourceId with @\"\\/subscriptions\\/([0-9a-zA-Z\\-])*\\/resourcegroups\\/([0-9a-zA-Z\\-])*\\/providers\\/microsoft\\.dbforpostgresql\\/servers\\/\" ResourceName\n    | extend dummy=1)\n    on dummy\n| where ResourceName contains dataPartitionID\n| project-away dummy, dummy1\n| where MetricName == \"cpu_percent\"\n| summarize AggregatedValue= avg(Average) by ResourceName, bin(TimeGenerated, 5m), MetricName, dataPartitionID",
    # Threshold value for CPU usage which when exceeded will raise alert
    trigger-threshold       = 85,
    trigger-operator        = "GreaterThan",
    metric-trigger-operator = "GreaterThan",
    # Number of times the threshold value is allowed to exceed
    metric-trigger-threshold = 2,
    # Type can be based on total breaches or consecutive breaches of threshold.
    metric-trigger-type   = "Consecutive",
    metric-trigger-column = "ResourceName"
  },
  # Airflow Component Memory Usage Alert #
  airflow-scheduler-memory-usage-alert = {
    # Scope for log query.
    log-analytics-scope = true,
    service-name        = "airflow",
    alert-rule-name     = "airflow-scheduler-memory-usage-alert",
    description         = "Alert to trigger when the Memory Usage of the Scheduler goes above the threshold limit",
    # Alert based on metric measurement
    metric-type       = true
    enabled           = "true",
    severity          = 3,
    frequency         = 5,
    time-window       = 5,
    action-group-name = ["ProdActionGroup", "DevActionGroup"],
    query             = "let capacityCounterName = 'memoryLimitBytes';\nlet usageCounterName = 'memoryRssBytes';\nlet cloudRoleName= \"airflow-scheduler\";\nKubePodInventory\n| where ControllerName has cloudRoleName\n| extend InstanceName = strcat(ClusterId, '/', ContainerName), ContainerName = strcat(ControllerName, '/', tostring(split(ContainerName, '/')[1])), PodName = Name\n| where PodStatus in ('Running')\n| where PodName contains cloudRoleName\n| where ContainerName endswith cloudRoleName\n| distinct Computer, InstanceName, ContainerName, PodName\n| join\n    hint.strategy=shuffle (\n    Perf\n    | where ObjectName == 'K8SContainer'\n    | where CounterName == capacityCounterName\n    | summarize LimitValue = max(CounterValue) by Computer, InstanceName, bin(TimeGenerated, 15m)\n    | project Computer, InstanceName, LimitValue, limitA=100\n    )\n    on Computer, InstanceName\n| join kind=inner\n    hint.strategy=shuffle (\n    Perf\n    | where ObjectName == 'K8SContainer'\n    | where CounterName == usageCounterName\n    | project Computer, InstanceName, UsageValue = CounterValue,\nlimit=100, TimeGenerated\n)\non Computer, InstanceName\n| project PodName, TimeGenerated, UsagePercent = UsageValue * 100.0 / LimitValue\n| parse kind=regex PodName with partitionId \"-airflow-scheduler-[[:graph:]]\"\n| extend dataPartitionID = case(partitionId == \"\", \"common-cluster\",\npartitionId)\n| extend PodName = case(dataPartitionID == \"common-cluster\", strcat(dataPartitionID, \"-\" ,PodName),\nPodName)\n| summarize AggregatedValue=max(UsagePercent) by PodName, bin(TimeGenerated, 5m), dataPartitionID",
    # Threshold value for Memory usage which when exceeded will raise alert
    trigger-threshold       = 80,
    trigger-operator        = "GreaterThan",
    metric-trigger-operator = "GreaterThan",
    # Number of times the threshold value is allowed to exceed
    metric-trigger-threshold = 2,
    # Type can be based on total breaches or consecutive breaches of threshold.
    metric-trigger-type   = "Consecutive",
    metric-trigger-column = "PodName"
  },
  airflow-web-memory-usage-alert = {
    # Scope for log query.
    log-analytics-scope = true,
    service-name        = "airflow",
    alert-rule-name     = "airflow-web-memory-usage-alert",
    description         = "Alert to trigger when the Memory Usage of the Airflow Web goes above the threshold limit",
    # Alert based on metric measurement
    metric-type       = true
    enabled           = "true",
    severity          = 3,
    frequency         = 5,
    time-window       = 5,
    action-group-name = ["ProdActionGroup", "DevActionGroup"],
    query             = "let capacityCounterName = 'memoryLimitBytes';\nlet usageCounterName = 'memoryRssBytes';\nlet cloudRoleName= \"airflow-web\";\nKubePodInventory\n| where ControllerName has cloudRoleName\n| extend InstanceName = strcat(ClusterId, '/', ContainerName), ContainerName = strcat(ControllerName, '/', tostring(split(ContainerName, '/')[1])), PodName = Name\n| where PodStatus in ('Running')\n| where PodName contains cloudRoleName\n| where ContainerName endswith cloudRoleName\n| distinct Computer, InstanceName, ContainerName, PodName\n| join\n    hint.strategy=shuffle (\n    Perf\n    | where ObjectName == 'K8SContainer'\n    | where CounterName == capacityCounterName\n    | summarize LimitValue = max(CounterValue) by Computer, InstanceName, bin(TimeGenerated, 15m)\n    | project Computer, InstanceName, LimitValue, limitA=100\n    )\n    on Computer, InstanceName\n| join kind=inner\n    hint.strategy=shuffle (\n    Perf\n    | where ObjectName == 'K8SContainer'\n    | where CounterName == usageCounterName\n    | project Computer, InstanceName, UsageValue = CounterValue,\nlimit=100, TimeGenerated\n)\non Computer, InstanceName\n| project PodName, TimeGenerated, UsagePercent = UsageValue * 100.0 / LimitValue\n| parse kind=regex PodName with partitionId \"-airflow-web-[[:graph:]]\"\n| extend dataPartitionID = case(partitionId == \"\", \"common-cluster\",\npartitionId)\n| extend PodName = case(dataPartitionID == \"common-cluster\", strcat(dataPartitionID, \"-\" ,PodName),\nPodName)\n| summarize AggregatedValue=max(UsagePercent) by PodName, bin(TimeGenerated, 5m), dataPartitionID",
    # Threshold value for Memory usage which when exceeded will raise alert
    trigger-threshold       = 80,
    trigger-operator        = "GreaterThan",
    metric-trigger-operator = "GreaterThan",
    # Number of times the threshold value is allowed to exceed
    metric-trigger-threshold = 2,
    # Type can be based on total breaches or consecutive breaches of threshold.
    metric-trigger-type   = "Consecutive",
    metric-trigger-column = "PodName"
  },
  airflow-worker-memory-usage-alert = {
    # Scope for log query.
    log-analytics-scope = true,
    service-name        = "airflow",
    alert-rule-name     = "airflow-worker-memory-usage-alert",
    description         = "Alert to trigger when the Memory Usage of the Airflow Worker goes above the threshold limit",
    # Alert based on metric measurement
    metric-type       = true
    enabled           = "true",
    severity          = 3,
    frequency         = 5,
    time-window       = 5,
    action-group-name = ["ProdActionGroup", "DevActionGroup"],
    query             = "let capacityCounterName = 'memoryLimitBytes';\nlet usageCounterName = 'memoryRssBytes';\nlet cloudRoleName= \"airflow-worker\";\nKubePodInventory\n| where ControllerName has cloudRoleName\n| extend InstanceName = strcat(ClusterId, '/', ContainerName), ContainerName = strcat(ControllerName, '/', tostring(split(ContainerName, '/')[1])), PodName = Name\n| where PodStatus in ('Running')\n| where PodName contains cloudRoleName\n| where ContainerName endswith cloudRoleName\n| distinct Computer, InstanceName, ContainerName, PodName\n| join\n    hint.strategy=shuffle (\n    Perf\n    | where ObjectName == 'K8SContainer'\n    | where CounterName == capacityCounterName\n    | summarize LimitValue = max(CounterValue) by Computer, InstanceName, bin(TimeGenerated, 15m)\n    | project Computer, InstanceName, LimitValue, limitA=100\n    )\n    on Computer, InstanceName\n| join kind=inner\n    hint.strategy=shuffle (\n    Perf\n    | where ObjectName == 'K8SContainer'\n    | where CounterName == usageCounterName\n    | project Computer, InstanceName, UsageValue = CounterValue,\nlimit=100, TimeGenerated\n)\non Computer, InstanceName\n| project PodName, TimeGenerated, UsagePercent = UsageValue * 100.0 / LimitValue\n| parse kind=regex PodName with partitionId \"-airflow-worker-[[:graph:]]\"\n| extend dataPartitionID = case(partitionId == \"\", \"common-cluster\",\npartitionId)\n| extend PodName = case(dataPartitionID == \"common-cluster\", strcat(dataPartitionID, \"-\" ,PodName),\nPodName)\n| summarize AggregatedValue=max(UsagePercent) by PodName, bin(TimeGenerated, 5m), dataPartitionID",
    # Threshold value for Memory usage which when exceeded will raise alert
    trigger-threshold       = 80,
    trigger-operator        = "GreaterThan",
    metric-trigger-operator = "GreaterThan",
    # Number of times the threshold value is allowed to exceed
    metric-trigger-threshold = 2,
    # Type can be based on total breaches or consecutive breaches of threshold.
    metric-trigger-type   = "Consecutive",
    metric-trigger-column = "PodName"
  },
  airflow-Redis-memory-usage-alert = {
    # Scope for log query.
    log-analytics-scope = true,
    service-name        = "airflow",
    alert-rule-name     = "airflow-redis-memory-usage-alert",
    description         = "Alert to trigger when the Memory Usage of redis goes above the threshold limit",
    # Alert based on metric measurement
    metric-type       = true
    enabled           = "true",
    severity          = 3,
    frequency         = 5,
    time-window       = 5,
    action-group-name = ["ProdActionGroup", "DevActionGroup"],
    query             = "KubePodInventory\n| where Name has \"airflow\"\n| parse kind=regex Name with partitionId \"-airflow-[[:graph:]]\"\n| extend dataPartitionID = case(partitionId == \"\", \"common-cluster\",\n    partitionId)\n| distinct dataPartitionID \n| extend dummy=1 \n| join kind=inner \n    (AzureMetrics\n    | where ResourceProvider == \"MICROSOFT.CACHE\" \n    | parse kind=regex _ResourceId with @\"\\/subscriptions\\/([0-9a-zA-Z\\-])*\\/resourcegroups\\/([0-9a-zA-Z\\-])*\\/providers\\/microsoft\\.cache\\/redis\\/\" ResourceName\n    | extend dummy=1)\n    on dummy\n| where ResourceName contains dataPartitionID\n| project-away dummy, dummy1\n| where MetricName == \"usedmemorypercentage\"\n| summarize AggregatedValue= avg(Average) by ResourceName, bin(TimeGenerated, 5m), MetricName, dataPartitionID",
    # Threshold value for Memory usage which when exceeded will raise alert
    trigger-threshold       = 80,
    trigger-operator        = "GreaterThan",
    metric-trigger-operator = "GreaterThan",
    # Number of times the threshold value is allowed to exceed
    metric-trigger-threshold = 2,
    # Type can be based on total breaches or consecutive breaches of threshold.
    metric-trigger-type   = "Consecutive",
    metric-trigger-column = "ResourceName"
  },
  # Airflow Service Alerts #
  airflow-service-error-rate-alert = {
    # Scope for log query.
    log-analytics-scope = true,
    service-name        = "airflow",
    alert-rule-name     = "airflow-service-error-rate-alert",
    description         = "Alert to trigger when error rate for 5xx goes above the threshold limit",
    # Alert based on metric measurement
    metric-type       = true
    enabled           = "true",
    severity          = 3,
    frequency         = 5,
    time-window       = 10,
    action-group-name = ["ProdActionGroup", "DevActionGroup"],
    query             = "let ContainerIdList = KubePodInventory\n    | where Name has \"airflow-web\"\n    | where strlen(ContainerID) > 0\n    | distinct ContainerID, PodLabel, Namespace, PodIp, Name;\nContainerLog\n| where ContainerID in (ContainerIdList)\n| where LogEntry contains \"HTTP/1.1\" and LogEntry !contains \"/airflow/health\"\n| lookup kind=leftouter (ContainerIdList) on ContainerID\n| project-away Image, ImageTag, Repository, Name, TimeOfCommand\n| project-rename PodName=Name1\n| parse kind=regex PodName with partitionId \"-airflow-web-[[:graph:]]\"\n| extend dataPartitionId = case(partitionId == \"\", \"common-cluster\",\n    partitionId)\n| parse kind=regex LogEntry with '[[:graph:]] HTTP/1.1\" ' values\n| extend status = toint(split(values, \" \")[0]), timeTaken = toint(split(values, \" \")[1])\n| extend HTTPStatus = case(status between (200 .. 299), \"2XX\",\n    status between (300 .. 399), \"3XX\",\n    status between (400 .. 499), \"4XX\",\n    status between (500 .. 599), \"5XX\",\n    \"XX\")\n| where HTTPStatus == \"5XX\"\n| summarize AggregatedValue = count() by HTTPStatus, bin(TimeGenerated, 5m), dataPartitionId",
    # Threshold value for Error Rate of 5XX errors which when exceeded will raise alert
    trigger-threshold       = 20,
    trigger-operator        = "GreaterThan",
    metric-trigger-operator = "GreaterThan",
    # Number of times the threshold value is allowed to exceed
    metric-trigger-threshold = 1,
    # Type can be based on total breaches or consecutive breaches of threshold.
    metric-trigger-type   = "Total",
    metric-trigger-column = "dataPartitionId"
  },
  airflow-scheduler-heartbeat-alert = {
    # Scope for log query.
    log-analytics-scope = false,
    service-name        = "airflow",
    alert-rule-name     = "airflow-scheduler-heartbeat-alert",
    description         = "Alert to trigger when scheduler heartbeat goes below the threshold limit",
    # Alert based on metric measurement
    metric-type       = true
    enabled           = "true",
    severity          = 3,
    frequency         = 5,
    time-window       = 5,
    action-group-name = ["ProdActionGroup", "DevActionGroup"],
    query             = "customMetrics\n| where name has \"scheduler_heartbeat\"\n| parse kind=regex name with @\"([0-9a-zA-Z_])*\\.\" partitionId @\"\\.scheduler_heartbeat\" \n| extend dataPartitionId = case(partitionId == \"\", \"common-cluster\",\n    partitionId)\n| summarize AggregatedValue= max(value) by bin(timestamp, 1m), HostName = strcat(dataPartitionId, \"-airflow-scheduler\"), dataPartitionId",
    # Threshold value for scheduler heartbeat which if it falls below will raise alert
    trigger-threshold       = 2,
    trigger-operator        = "LessThan",
    metric-trigger-operator = "GreaterThan",
    # Number of times the threshold value is allowed to exceed
    metric-trigger-threshold = 1,
    # Type can be based on total breaches or consecutive breaches of threshold.
    metric-trigger-type   = "Consecutive",
    metric-trigger-column = "HostName"
  },
  airflow-dag-processor-timeout-alert = {
    # Scope for log query.
    log-analytics-scope = false,
    service-name        = "airflow",
    alert-rule-name     = "airflow-dag-processor-timeout-alert",
    description         = "Alert to trigger when dag-processor timeouts occur",
    # Alert based on metric measurement
    metric-type       = true
    enabled           = "true",
    severity          = 3,
    frequency         = 5,
    time-window       = 5,
    action-group-name = ["ProdActionGroup", "DevActionGroup"],
    query             = "customMetrics\n| where name has \"dag_processing.processor_timeouts\"\n| parse kind=regex name with @\"([0-9a-zA-Z_])*\\.\" partitionId @\"\\.dag_processing\\.processor_timeouts\" \n| extend dataPartitionId = case(partitionId == \"\", \"common-cluster\",\n    partitionId)\n| summarize AggregatedValue = max(value) by bin(timestamp, 15m), Operation = strcat(dataPartitionId, \"-dag_processing.processor_timeouts\"), MetricName = \"dag_processing.processor_timeouts\", dataPartitionId",
    # Threshold value for processing timeouts which when occurs will raise alert
    trigger-threshold       = 0,
    trigger-operator        = "GreaterThan",
    metric-trigger-operator = "GreaterThan",
    # Number of times the threshold value is allowed to exceed
    metric-trigger-threshold = 1,
    # Type can be based on total breaches or consecutive breaches of threshold.
    metric-trigger-type   = "Consecutive",
    metric-trigger-column = "Operation"
  },
  airflow-import-errors-alert = {
    log-analytics-scope = false,
    service-name        = "airflow",
    alert-rule-name     = "airflow-import-errors-alert",
    description         = "Import Errors alert rule for airflow service",
    # Alert based on metric measurement
    metric-type       = true
    enabled           = "true",
    severity          = 3,
    frequency         = 5,
    time-window       = 5,
    action-group-name = ["ProdActionGroup", "DevActionGroup"],
    query             = "customMetrics\n| where name has \"dag_processing.import_errors\"\n| parse kind=regex name with @\"([0-9a-zA-Z_])*\\.\" partitionId @\"\\.dag_processing\\.import_errors\" \n| extend dataPartitionId = case(partitionId == \"\", \"common-cluster\",\n    partitionId)\n| summarize AggregatedValue = max(value) by bin(timestamp, 15m), Operation= strcat(\"MetricName: \", name, \" Data-Partition: \", dataPartitionId )\n",
    # Threshold value for Import Error which when exceeded will raise alert
    trigger-threshold       = 0,
    trigger-operator        = "GreaterThan",
    metric-trigger-operator = "GreaterThan",
    # Number of times the threshold value is allowed to exceed
    metric-trigger-threshold = 1,
    # Type can be based on total breaches or consecutive breaches of threshold.
    metric-trigger-type   = "Consecutive",
    metric-trigger-column = "Operation"
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