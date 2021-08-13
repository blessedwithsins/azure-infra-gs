{
	"lenses": {
		"0": {
			"order": 0,
			"parts": {
				"0": {
					"position": {
						"x": 0,
						"y": 0,
						"colSpan": 4,
						"rowSpan": 1
					},
					"metadata": {
						"inputs": [],
						"type": "Extension/HubsExtension/PartType/MarkdownPart",
						"settings": {
							"content": {
								"settings": {
									"content": "# Airflow Web Server",
									"subtitle": "",
									"title": ""
								}
							}
						}
					}
				},
				"1": {
					"position": {
						"x": 0,
						"y": 1,
						"colSpan": 6,
						"rowSpan": 4
					},
					"metadata": {
						"inputs": [
							{
								"name": "resourceTypeMode",
								"isOptional": true
							},
							{
								"name": "ComponentId",
								"isOptional": true
							},
							{
								"name": "Scope",
								"value": {
									"resourceIds": [
										"/subscriptions/${subscriptionId}/resourceGroups/${centralGroupPrefix}-rg/providers/Microsoft.OperationalInsights/workspaces/${centralGroupPrefix}-logs"
									]
								},
								"isOptional": true
							},
							{
								"name": "PartId",
								"value": "3bececce-2bca-4c74-9f10-7973890c2a31",
								"isOptional": true
							},
							{
								"name": "Version",
								"value": "2.0",
								"isOptional": true
							},
							{
								"name": "TimeRange",
								"value": "P1D",
								"isOptional": true
							},
							{
								"name": "DashboardId",
								"isOptional": true
							},
							{
								"name": "DraftRequestParameters",
								"isOptional": true
							},
							{
								"name": "Query",
								"value": "let capacityCounterName = 'cpuLimitNanoCores';\nlet usageCounterName = 'cpuUsageNanoCores';\nlet cloudRoleName= \"airflow-web\";\nKubePodInventory\n| where \"a\" == \"a\"\n| where ControllerName has cloudRoleName\n| extend InstanceName = strcat(ClusterId, '/', ContainerName), ContainerName = strcat(ControllerName, '/', tostring(split(ContainerName, '/')[1])), PodName = Name\n| where PodStatus in ('Running')\n| where PodName contains cloudRoleName\n| where ContainerName has cloudRoleName\n| distinct Computer, InstanceName, ContainerName, PodName\n| join\n    hint.strategy=shuffle (\n    Perf\n    | where ObjectName == 'K8SContainer'\n    | where CounterName == capacityCounterName\n    | summarize LimitValue = max(CounterValue) by Computer, InstanceName, TimeGenerated\n    | project Computer, InstanceName, LimitValue, limitA=100\n    )\n    on Computer, InstanceName\n| join kind=inner\n    hint.strategy=shuffle (\n    Perf\n    | where ObjectName == 'K8SContainer'\n    | where CounterName == usageCounterName\n    | project Computer, InstanceName, UsageValue = CounterValue, limit=100, TimeGenerated\n)\non Computer, InstanceName\n| project PodName, TimeGenerated, UsagePercent = UsageValue * 100.0 / LimitValue\n| summarize CPUPercentage=max(UsagePercent) by TimeGenerated, PodName\n| render timechart\n",
								"isOptional": true
							},
							{
								"name": "ControlType",
								"value": "FrameControlChart",
								"isOptional": true
							},
							{
								"name": "SpecificChart",
								"value": "Line",
								"isOptional": true
							},
							{
								"name": "PartTitle",
								"value": "Analytics",
								"isOptional": true
							},
							{
								"name": "PartSubTitle",
								"value": "${centralGroupPrefix}-logs",
								"isOptional": true
							},
							{
								"name": "Dimensions",
								"value": {
									"aggregation": "Sum",
									"splitBy": [
										{
											"name": "PodName",
											"type": "string"
										}
									],
									"xAxis": {
										"name": "TimeGenerated",
										"type": "datetime"
									},
									"yAxis": [
										{
											"name": "CPUPercentage",
											"type": "real"
										}
									]
								},
								"isOptional": true
							},
							{
								"name": "LegendOptions",
								"value": {
									"isEnabled": true,
									"position": "Bottom"
								},
								"isOptional": true
							},
							{
								"name": "IsQueryContainTimeRange",
								"value": false,
								"isOptional": true
							}
						],
						"type": "Extension/Microsoft_OperationsManagementSuite_Workspace/PartType/LogsDashboardPart",
						"settings": {
							"content": {
								"Dimensions": {
									"aggregation": "Sum",
									"splitBy": [
										{
											"name": "PodName",
											"type": "string"
										}
									],
									"xAxis": {
										"name": "TimeGenerated",
										"type": "datetime"
									},
									"yAxis": [
										{
											"name": "CPUPercentage",
											"type": "real"
										}
									]
								},
								"PartTitle": "CPU Usage",
								"Query": "let capacityCounterName = 'cpuLimitNanoCores';\nlet usageCounterName = 'cpuUsageNanoCores';\nlet cloudRoleName= \"airflow-web\";\nKubePodInventory\n| where ControllerName has cloudRoleName\n| extend InstanceName = strcat(ClusterId, '/', ContainerName), ContainerName = strcat(ControllerName, '/', tostring(split(ContainerName, '/')[1])), PodName = Name\n| where PodStatus in ('Running')\n| where PodName contains cloudRoleName\n| where ContainerName endswith cloudRoleName\n| distinct Computer, InstanceName, ContainerName, PodName\n| join\n    hint.strategy=shuffle (\n    Perf\n    | where ObjectName == 'K8SContainer'\n    | where CounterName == capacityCounterName\n    | summarize LimitValue = max(CounterValue) by Computer, InstanceName, TimeGenerated\n    | project Computer, InstanceName, LimitValue, limitA=100\n    )\n    on Computer, InstanceName\n| join kind=inner\n    hint.strategy=shuffle (\n    Perf\n    | where ObjectName == 'K8SContainer'\n    | where CounterName == usageCounterName\n    | project Computer, InstanceName, UsageValue = CounterValue, limit=100, TimeGenerated\n)\non Computer, InstanceName\n| project PodName, TimeGenerated, UsagePercent = UsageValue * 100.0 / LimitValue\n| parse kind=regex PodName with partitionId \"-airflow-web-[[:graph:]]\"\n| extend clusterName = case(partitionId == \"\", \"common-cluster\",\n                       partitionId)\n| extend PodName = case(clusterName == \"common-cluster\", strcat(clusterName, \"-\" ,PodName),\nPodName)\n| summarize CPUPercentage=max(UsagePercent) by PodName, TimeGenerated, clusterName\n| render timechart\n\n"
							}
						}
					}
				},
				"2": {
					"position": {
						"x": 6,
						"y": 1,
						"colSpan": 6,
						"rowSpan": 4
					},
					"metadata": {
						"inputs": [
							{
								"name": "resourceTypeMode",
								"isOptional": true
							},
							{
								"name": "ComponentId",
								"isOptional": true
							},
							{
								"name": "Scope",
								"value": {
									"resourceIds": [
										"/subscriptions/${subscriptionId}/resourceGroups/${centralGroupPrefix}-rg/providers/Microsoft.OperationalInsights/workspaces/${centralGroupPrefix}-logs"
									]
								},
								"isOptional": true
							},
							{
								"name": "PartId",
								"value": "42eb8a59-5c38-44c1-a188-26660c1394e4",
								"isOptional": true
							},
							{
								"name": "Version",
								"value": "2.0",
								"isOptional": true
							},
							{
								"name": "TimeRange",
								"value": "P1D",
								"isOptional": true
							},
							{
								"name": "DashboardId",
								"isOptional": true
							},
							{
								"name": "DraftRequestParameters",
								"isOptional": true
							},
							{
								"name": "Query",
								"value": "let capacityCounterName = 'memoryLimitBytes';\nlet usageCounterName = 'memoryRssBytes';\nlet cloudRoleName= \"airflow-web\";\nKubePodInventory\n| where \"a\" == \"a\"\n| where ControllerName contains cloudRoleName\n| extend InstanceName = strcat(ClusterId, '/', ContainerName), ContainerName = strcat(ControllerName, '/', tostring(split(ContainerName, '/')[1])), PodName = Name\n| where PodStatus in ('Running')\n| where PodName contains cloudRoleName\n| where ContainerName endswith cloudRoleName\n| distinct Computer, InstanceName, ContainerName, PodName\n| join\n    hint.strategy=shuffle (\n    Perf\n    | where ObjectName == 'K8SContainer'\n    | where CounterName == capacityCounterName\n    | summarize LimitValue = max(CounterValue) by Computer, InstanceName, TimeGenerated\n    | project Computer, InstanceName, LimitValue, limitA=100\n    )\n    on Computer, InstanceName\n| join kind=inner\n    hint.strategy=shuffle (\n    Perf\n    | where ObjectName == 'K8SContainer'\n    | where CounterName == usageCounterName\n    | project Computer, InstanceName, UsageValue = CounterValue, limit=100, TimeGenerated)\non Computer, InstanceName\n| project PodName, TimeGenerated, UsageValue, LimitValue\n| summarize MemoryUsage=max(UsageValue) by TimeGenerated, PodName\n| render timechart\n\n",
								"isOptional": true
							},
							{
								"name": "ControlType",
								"value": "FrameControlChart",
								"isOptional": true
							},
							{
								"name": "SpecificChart",
								"value": "Line",
								"isOptional": true
							},
							{
								"name": "PartTitle",
								"value": "Analytics",
								"isOptional": true
							},
							{
								"name": "PartSubTitle",
								"value": "${centralGroupPrefix}-logs",
								"isOptional": true
							},
							{
								"name": "Dimensions",
								"value": {
									"aggregation": "Sum",
									"splitBy": [
										{
											"name": "PodName",
											"type": "string"
										}
									],
									"xAxis": {
										"name": "TimeGenerated",
										"type": "datetime"
									},
									"yAxis": [
										{
											"name": "MemoryUsage",
											"type": "real"
										}
									]
								},
								"isOptional": true
							},
							{
								"name": "LegendOptions",
								"value": {
									"isEnabled": true,
									"position": "Bottom"
								},
								"isOptional": true
							},
							{
								"name": "IsQueryContainTimeRange",
								"value": false,
								"isOptional": true
							}
						],
						"type": "Extension/Microsoft_OperationsManagementSuite_Workspace/PartType/LogsDashboardPart",
						"settings": {
							"content": {
								"Dimensions": {
									"aggregation": "Sum",
									"splitBy": [
										{
											"name": "PodName",
											"type": "string"
										}
									],
									"xAxis": {
										"name": "TimeGenerated",
										"type": "datetime"
									},
									"yAxis": [
										{
											"name": "MemoryUsage",
											"type": "real"
										}
									]
								},
								"PartTitle": "Memory Usage",
								"Query": "let capacityCounterName = 'memoryLimitBytes';\nlet usageCounterName = 'memoryRssBytes';\nlet cloudRoleName= \"airflow-web\";\nKubePodInventory\n| where ControllerName has cloudRoleName\n| extend InstanceName = strcat(ClusterId, '/', ContainerName), ContainerName = strcat(ControllerName, '/', tostring(split(ContainerName, '/')[1])), PodName = Name\n| where PodStatus in ('Running')\n| where PodName contains cloudRoleName\n| where ContainerName endswith cloudRoleName\n| distinct Computer, InstanceName, ContainerName, PodName\n| join\n    hint.strategy=shuffle (\n    Perf\n    | where ObjectName == 'K8SContainer'\n    | where CounterName == capacityCounterName\n    | summarize LimitValue = max(CounterValue) by Computer, InstanceName, TimeGenerated\n    | project Computer, InstanceName, LimitValue, limitA=100\n    )\n    on Computer, InstanceName\n| join kind=inner\n    hint.strategy=shuffle (\n    Perf\n    | where ObjectName == 'K8SContainer'\n    | where CounterName == usageCounterName\n    | project Computer, InstanceName, UsageValue = CounterValue, limit=100, TimeGenerated\n)\non Computer, InstanceName\n| project PodName, TimeGenerated, UsagePercent = UsageValue * 100.0 / LimitValue\n| parse kind=regex PodName with partitionId \"-airflow-web-[[:graph:]]\"\n| extend clusterName = case(partitionId == \"\", \"common-cluster\",\n                       partitionId)\n| extend PodName = case(clusterName == \"common-cluster\", strcat(clusterName, \"-\" ,PodName),\nPodName)\n| summarize MemoryUsage=max(UsagePercent) by PodName, TimeGenerated, clusterName\n| render timechart\n"
							}
						}
					}
				},
				"3": {
					"position": {
						"x": 12,
						"y": 1,
						"colSpan": 6,
						"rowSpan": 4
					},
					"metadata": {
						"inputs": [
							{
								"name": "resourceTypeMode",
								"isOptional": true
							},
							{
								"name": "ComponentId",
								"isOptional": true
							},
							{
								"name": "Scope",
								"value": {
									"resourceIds": [
										"/subscriptions/${subscriptionId}/resourceGroups/${centralGroupPrefix}-rg/providers/Microsoft.OperationalInsights/workspaces/${centralGroupPrefix}-logs"
									]
								},
								"isOptional": true
							},
							{
								"name": "PartId",
								"value": "35932ce7-20e3-4698-8f11-bb6bfb528401",
								"isOptional": true
							},
							{
								"name": "Version",
								"value": "2.0",
								"isOptional": true
							},
							{
								"name": "TimeRange",
								"value": "P1D",
								"isOptional": true
							},
							{
								"name": "DashboardId",
								"isOptional": true
							},
							{
								"name": "DraftRequestParameters",
								"isOptional": true
							},
							{
								"name": "Query",
								"value": "let cloudRoleName= \"airflow-web\";\nKubePodInventory\n| where \"a\" == \"a\"\n| where ControllerName contains cloudRoleName\n| extend InstanceName = strcat(ClusterId, '/', ContainerName), ContainerName = strcat(ControllerName, '/', tostring(split(ContainerName, '/')[1])), PodName = Name\n| where PodStatus in ('Running')\n| where PodName contains cloudRoleName\n| where ContainerName endswith cloudRoleName\n| project Computer, InstanceName, ContainerName, PodName, PodStatus, TimeGenerated, Count = 1, cloudRoleName\n| summarize HostCount = avg(Count) by TimeGenerated, cloudRoleName\n| render timechart;\n",
								"isOptional": true
							},
							{
								"name": "ControlType",
								"value": "FrameControlChart",
								"isOptional": true
							},
							{
								"name": "SpecificChart",
								"value": "Line",
								"isOptional": true
							},
							{
								"name": "PartTitle",
								"value": "Analytics",
								"isOptional": true
							},
							{
								"name": "PartSubTitle",
								"value": "${centralGroupPrefix}-logs",
								"isOptional": true
							},
							{
								"name": "Dimensions",
								"value": {
									"aggregation": "Sum",
									"splitBy": [
										{
											"name": "cloudRoleName",
											"type": "string"
										}
									],
									"xAxis": {
										"name": "TimeGenerated",
										"type": "datetime"
									},
									"yAxis": [
										{
											"name": "HostCount",
											"type": "real"
										}
									]
								},
								"isOptional": true
							},
							{
								"name": "LegendOptions",
								"value": {
									"isEnabled": true,
									"position": "Bottom"
								},
								"isOptional": true
							},
							{
								"name": "IsQueryContainTimeRange",
								"value": false,
								"isOptional": true
							}
						],
						"type": "Extension/Microsoft_OperationsManagementSuite_Workspace/PartType/LogsDashboardPart",
						"settings": {
							"content": {
								"Dimensions": {
									"aggregation": "Sum",
									"splitBy": [
										{
											"name": "HostName",
											"type": "string"
										}
									],
									"xAxis": {
										"name": "TimeGenerated",
										"type": "datetime"
									},
									"yAxis": [
										{
											"name": "HostCount",
											"type": "real"
										}
									]
								},
								"PartTitle": "Healthy Host Count",
								"Query": "let cloudRoleName= \"airflow-web\";\nKubePodInventory\n| where ControllerName contains cloudRoleName\n| extend InstanceName = strcat(ClusterId, '/', ContainerName), ContainerName = strcat(ControllerName, '/', tostring(split(ContainerName, '/')[1])), PodName = Name\n| where PodName contains cloudRoleName\n| where ContainerName endswith cloudRoleName\n| project Computer, InstanceName, ContainerName, PodName, PodStatus, TimeGenerated\n| extend Count = case (PodStatus == \"Running\", 1,\n        0)\n| parse kind=regex PodName with partitionId \"-airflow-web-[[:graph:]]\"\n| extend clusterName = case(partitionId == \"\", \"common-cluster\",\n                       partitionId)\n| extend PodName = case(clusterName == \"common-cluster\", strcat(clusterName, \"-\", PodName),\n    PodName)\n| summarize HostCount = avg(Count) by HostName = strcat(clusterName, \"-\", cloudRoleName), TimeGenerated, clusterName, PodName, PodStatus\n| render timechart\n\n"
							}
						}
					}
				},
				"4": {
					"position": {
						"x": 0,
						"y": 5,
						"colSpan": 4,
						"rowSpan": 1
					},
					"metadata": {
						"inputs": [],
						"type": "Extension/HubsExtension/PartType/MarkdownPart",
						"settings": {
							"content": {
								"settings": {
									"content": "# Airflow Scheduler",
									"subtitle": "",
									"title": ""
								}
							}
						}
					}
				},
				"5": {
					"position": {
						"x": 0,
						"y": 6,
						"colSpan": 6,
						"rowSpan": 4
					},
					"metadata": {
						"inputs": [
							{
								"name": "resourceTypeMode",
								"isOptional": true
							},
							{
								"name": "ComponentId",
								"isOptional": true
							},
							{
								"name": "Scope",
								"value": {
									"resourceIds": [
										"/subscriptions/${subscriptionId}/resourceGroups/${centralGroupPrefix}-rg/providers/Microsoft.OperationalInsights/workspaces/${centralGroupPrefix}-logs"
									]
								},
								"isOptional": true
							},
							{
								"name": "PartId",
								"value": "3bececce-2bca-4c74-9f10-7973890c2a31",
								"isOptional": true
							},
							{
								"name": "Version",
								"value": "2.0",
								"isOptional": true
							},
							{
								"name": "TimeRange",
								"value": "P1D",
								"isOptional": true
							},
							{
								"name": "DashboardId",
								"isOptional": true
							},
							{
								"name": "DraftRequestParameters",
								"isOptional": true
							},
							{
								"name": "Query",
								"value": "let capacityCounterName = 'cpuLimitNanoCores';\nlet usageCounterName = 'cpuUsageNanoCores';\nlet cloudRoleName= \"airflow-web\";\nKubePodInventory\n| where \"a\" == \"a\"\n| where ControllerName has cloudRoleName\n| extend InstanceName = strcat(ClusterId, '/', ContainerName), ContainerName = strcat(ControllerName, '/', tostring(split(ContainerName, '/')[1])), PodName = Name\n| where PodStatus in ('Running')\n| where PodName contains cloudRoleName\n| where ContainerName has cloudRoleName\n| distinct Computer, InstanceName, ContainerName, PodName\n| join\n    hint.strategy=shuffle (\n    Perf\n    | where ObjectName == 'K8SContainer'\n    | where CounterName == capacityCounterName\n    | summarize LimitValue = max(CounterValue) by Computer, InstanceName, TimeGenerated\n    | project Computer, InstanceName, LimitValue, limitA=100\n    )\n    on Computer, InstanceName\n| join kind=inner\n    hint.strategy=shuffle (\n    Perf\n    | where ObjectName == 'K8SContainer'\n    | where CounterName == usageCounterName\n    | project Computer, InstanceName, UsageValue = CounterValue, limit=100, TimeGenerated\n)\non Computer, InstanceName\n| project PodName, TimeGenerated, UsagePercent = UsageValue * 100.0 / LimitValue\n| summarize CPUPercentage=max(UsagePercent) by TimeGenerated, PodName\n| render timechart\n",
								"isOptional": true
							},
							{
								"name": "ControlType",
								"value": "FrameControlChart",
								"isOptional": true
							},
							{
								"name": "SpecificChart",
								"value": "Line",
								"isOptional": true
							},
							{
								"name": "PartTitle",
								"value": "Analytics",
								"isOptional": true
							},
							{
								"name": "PartSubTitle",
								"value": "${centralGroupPrefix}-logs",
								"isOptional": true
							},
							{
								"name": "Dimensions",
								"value": {
									"aggregation": "Sum",
									"splitBy": [
										{
											"name": "PodName",
											"type": "string"
										}
									],
									"xAxis": {
										"name": "TimeGenerated",
										"type": "datetime"
									},
									"yAxis": [
										{
											"name": "CPUPercentage",
											"type": "real"
										}
									]
								},
								"isOptional": true
							},
							{
								"name": "LegendOptions",
								"value": {
									"isEnabled": true,
									"position": "Bottom"
								},
								"isOptional": true
							},
							{
								"name": "IsQueryContainTimeRange",
								"value": false,
								"isOptional": true
							}
						],
						"type": "Extension/Microsoft_OperationsManagementSuite_Workspace/PartType/LogsDashboardPart",
						"settings": {
							"content": {
								"Dimensions": {
									"aggregation": "Sum",
									"splitBy": [
										{
											"name": "PodName",
											"type": "string"
										}
									],
									"xAxis": {
										"name": "TimeGenerated",
										"type": "datetime"
									},
									"yAxis": [
										{
											"name": "CPUPercentage",
											"type": "real"
										}
									]
								},
								"PartTitle": "CPU Usage",
								"Query": "let capacityCounterName = 'cpuLimitNanoCores';\nlet usageCounterName = 'cpuUsageNanoCores';\nlet cloudRoleName= \"airflow-scheduler\";\nKubePodInventory\n| where ControllerName has cloudRoleName\n| extend InstanceName = strcat(ClusterId, '/', ContainerName), ContainerName = strcat(ControllerName, '/', tostring(split(ContainerName, '/')[1])), PodName = Name\n| where PodStatus in ('Running')\n| where PodName contains cloudRoleName\n| where ContainerName endswith cloudRoleName\n| distinct Computer, InstanceName, ContainerName, PodName\n| join\n    hint.strategy=shuffle (\n    Perf\n    | where ObjectName == 'K8SContainer'\n    | where CounterName == capacityCounterName\n    | summarize LimitValue = max(CounterValue) by Computer, InstanceName, TimeGenerated\n    | project Computer, InstanceName, LimitValue, limitA=100\n    )\n    on Computer, InstanceName\n| join kind=inner\n    hint.strategy=shuffle (\n    Perf\n    | where ObjectName == 'K8SContainer'\n    | where CounterName == usageCounterName\n    | project Computer, InstanceName, UsageValue = CounterValue, limit=100, TimeGenerated\n)\non Computer, InstanceName\n| project PodName, TimeGenerated, UsagePercent = UsageValue * 100.0 / LimitValue\n| parse kind=regex PodName with partitionId \"-airflow-scheduler-[[:graph:]]\"\n| extend clusterName = case(partitionId == \"\", \"common-cluster\",\n                       partitionId)\n| extend PodName = case(clusterName == \"common-cluster\", strcat(clusterName, \"-\" ,PodName),\nPodName)\n| summarize CPUPercentage=max(UsagePercent) by PodName, TimeGenerated, clusterName\n| render timechart\n"
							}
						}
					}
				},
				"6": {
					"position": {
						"x": 6,
						"y": 6,
						"colSpan": 6,
						"rowSpan": 4
					},
					"metadata": {
						"inputs": [
							{
								"name": "resourceTypeMode",
								"isOptional": true
							},
							{
								"name": "ComponentId",
								"isOptional": true
							},
							{
								"name": "Scope",
								"value": {
									"resourceIds": [
										"/subscriptions/${subscriptionId}/resourceGroups/${centralGroupPrefix}-rg/providers/Microsoft.OperationalInsights/workspaces/${centralGroupPrefix}-logs"
									]
								},
								"isOptional": true
							},
							{
								"name": "PartId",
								"value": "42eb8a59-5c38-44c1-a188-26660c1394e4",
								"isOptional": true
							},
							{
								"name": "Version",
								"value": "2.0",
								"isOptional": true
							},
							{
								"name": "TimeRange",
								"value": "P1D",
								"isOptional": true
							},
							{
								"name": "DashboardId",
								"isOptional": true
							},
							{
								"name": "DraftRequestParameters",
								"isOptional": true
							},
							{
								"name": "Query",
								"value": "let capacityCounterName = 'memoryLimitBytes';\nlet usageCounterName = 'memoryRssBytes';\nlet cloudRoleName= \"airflow-web\";\nKubePodInventory\n| where \"a\" == \"a\"\n| where ControllerName contains cloudRoleName\n| extend InstanceName = strcat(ClusterId, '/', ContainerName), ContainerName = strcat(ControllerName, '/', tostring(split(ContainerName, '/')[1])), PodName = Name\n| where PodStatus in ('Running')\n| where PodName contains cloudRoleName\n| where ContainerName endswith cloudRoleName\n| distinct Computer, InstanceName, ContainerName, PodName\n| join\n    hint.strategy=shuffle (\n    Perf\n    | where ObjectName == 'K8SContainer'\n    | where CounterName == capacityCounterName\n    | summarize LimitValue = max(CounterValue) by Computer, InstanceName, TimeGenerated\n    | project Computer, InstanceName, LimitValue, limitA=100\n    )\n    on Computer, InstanceName\n| join kind=inner\n    hint.strategy=shuffle (\n    Perf\n    | where ObjectName == 'K8SContainer'\n    | where CounterName == usageCounterName\n    | project Computer, InstanceName, UsageValue = CounterValue, limit=100, TimeGenerated)\non Computer, InstanceName\n| project PodName, TimeGenerated, UsageValue, LimitValue\n| summarize MemoryUsage=max(UsageValue) by TimeGenerated, PodName\n| render timechart\n\n",
								"isOptional": true
							},
							{
								"name": "ControlType",
								"value": "FrameControlChart",
								"isOptional": true
							},
							{
								"name": "SpecificChart",
								"value": "Line",
								"isOptional": true
							},
							{
								"name": "PartTitle",
								"value": "Analytics",
								"isOptional": true
							},
							{
								"name": "PartSubTitle",
								"value": "${centralGroupPrefix}-logs",
								"isOptional": true
							},
							{
								"name": "Dimensions",
								"value": {
									"aggregation": "Sum",
									"splitBy": [
										{
											"name": "PodName",
											"type": "string"
										}
									],
									"xAxis": {
										"name": "TimeGenerated",
										"type": "datetime"
									},
									"yAxis": [
										{
											"name": "MemoryUsage",
											"type": "real"
										}
									]
								},
								"isOptional": true
							},
							{
								"name": "LegendOptions",
								"value": {
									"isEnabled": true,
									"position": "Bottom"
								},
								"isOptional": true
							},
							{
								"name": "IsQueryContainTimeRange",
								"value": false,
								"isOptional": true
							}
						],
						"type": "Extension/Microsoft_OperationsManagementSuite_Workspace/PartType/LogsDashboardPart",
						"settings": {
							"content": {
								"ControlType": "FrameControlChart",
								"Dimensions": {
									"aggregation": "Sum",
									"splitBy": [
										{
											"name": "PodName",
											"type": "string"
										}
									],
									"xAxis": {
										"name": "TimeGenerated",
										"type": "datetime"
									},
									"yAxis": [
										{
											"name": "MemoryUsage",
											"type": "real"
										}
									]
								},
								"PartTitle": "Memory Usage",
								"Query": "let capacityCounterName = 'memoryLimitBytes';\nlet usageCounterName = 'memoryRssBytes';\nlet cloudRoleName= \"airflow-scheduler\";\nKubePodInventory\n| where ControllerName has cloudRoleName\n| extend InstanceName = strcat(ClusterId, '/', ContainerName), ContainerName = strcat(ControllerName, '/', tostring(split(ContainerName, '/')[1])), PodName = Name\n| where PodStatus in ('Running')\n| where PodName contains cloudRoleName\n| where ContainerName endswith cloudRoleName\n| distinct Computer, InstanceName, ContainerName, PodName\n| join\n    hint.strategy=shuffle (\n    Perf\n    | where ObjectName == 'K8SContainer'\n    | where CounterName == capacityCounterName\n    | summarize LimitValue = max(CounterValue) by Computer, InstanceName, TimeGenerated\n    | project Computer, InstanceName, LimitValue, limitA=100\n    )\n    on Computer, InstanceName\n| join kind=inner\n    hint.strategy=shuffle (\n    Perf\n    | where ObjectName == 'K8SContainer'\n    | where CounterName == usageCounterName\n    | project Computer, InstanceName, UsageValue = CounterValue, limit=100, TimeGenerated\n)\non Computer, InstanceName\n| project PodName, TimeGenerated, UsagePercent = UsageValue * 100.0 / LimitValue\n| parse kind=regex PodName with partitionId \"-airflow-scheduler-[[:graph:]]\"\n| extend clusterName = case(partitionId == \"\", \"common-cluster\",\n                       partitionId)\n| extend PodName = case(clusterName == \"common-cluster\", strcat(clusterName, \"-\" ,PodName),\nPodName)\n| summarize MemoryUsage=max(UsagePercent) by PodName, TimeGenerated, clusterName\n| render timechart\n"
							}
						}
					}
				},
				"7": {
					"position": {
						"x": 12,
						"y": 6,
						"colSpan": 6,
						"rowSpan": 4
					},
					"metadata": {
						"inputs": [
							{
								"name": "resourceTypeMode",
								"isOptional": true
							},
							{
								"name": "ComponentId",
								"isOptional": true
							},
							{
								"name": "Scope",
								"value": {
									"resourceIds": [
										"/subscriptions/${subscriptionId}/resourceGroups/${centralGroupPrefix}-rg/providers/Microsoft.OperationalInsights/workspaces/${centralGroupPrefix}-logs"
									]
								},
								"isOptional": true
							},
							{
								"name": "PartId",
								"value": "35932ce7-20e3-4698-8f11-bb6bfb528401",
								"isOptional": true
							},
							{
								"name": "Version",
								"value": "2.0",
								"isOptional": true
							},
							{
								"name": "TimeRange",
								"value": "P1D",
								"isOptional": true
							},
							{
								"name": "DashboardId",
								"isOptional": true
							},
							{
								"name": "DraftRequestParameters",
								"isOptional": true
							},
							{
								"name": "Query",
								"value": "let cloudRoleName= \"airflow-web\";\nKubePodInventory\n| where \"a\" == \"a\"\n| where ControllerName contains cloudRoleName\n| extend InstanceName = strcat(ClusterId, '/', ContainerName), ContainerName = strcat(ControllerName, '/', tostring(split(ContainerName, '/')[1])), PodName = Name\n| where PodStatus in ('Running')\n| where PodName contains cloudRoleName\n| where ContainerName endswith cloudRoleName\n| project Computer, InstanceName, ContainerName, PodName, PodStatus, TimeGenerated, Count = 1, cloudRoleName\n| summarize HostCount = avg(Count) by TimeGenerated, cloudRoleName\n| render timechart;\n",
								"isOptional": true
							},
							{
								"name": "ControlType",
								"value": "FrameControlChart",
								"isOptional": true
							},
							{
								"name": "SpecificChart",
								"value": "Line",
								"isOptional": true
							},
							{
								"name": "PartTitle",
								"value": "Analytics",
								"isOptional": true
							},
							{
								"name": "PartSubTitle",
								"value": "${centralGroupPrefix}-logs",
								"isOptional": true
							},
							{
								"name": "Dimensions",
								"value": {
									"aggregation": "Sum",
									"splitBy": [
										{
											"name": "cloudRoleName",
											"type": "string"
										}
									],
									"xAxis": {
										"name": "TimeGenerated",
										"type": "datetime"
									},
									"yAxis": [
										{
											"name": "HostCount",
											"type": "real"
										}
									]
								},
								"isOptional": true
							},
							{
								"name": "LegendOptions",
								"value": {
									"isEnabled": true,
									"position": "Bottom"
								},
								"isOptional": true
							},
							{
								"name": "IsQueryContainTimeRange",
								"value": false,
								"isOptional": true
							}
						],
						"type": "Extension/Microsoft_OperationsManagementSuite_Workspace/PartType/LogsDashboardPart",
						"settings": {
							"content": {
								"Dimensions": {
									"aggregation": "Sum",
									"splitBy": [
										{
											"name": "HostName",
											"type": "string"
										}
									],
									"xAxis": {
										"name": "TimeGenerated",
										"type": "datetime"
									},
									"yAxis": [
										{
											"name": "HostCount",
											"type": "real"
										}
									]
								},
								"PartTitle": "Healthy Host Count",
								"Query": "let cloudRoleName= \"airflow-scheduler\";\nKubePodInventory\n| where ControllerName contains cloudRoleName\n| extend InstanceName = strcat(ClusterId, '/', ContainerName), ContainerName = strcat(ControllerName, '/', tostring(split(ContainerName, '/')[1])), PodName = Name\n| where PodName contains cloudRoleName\n| where ContainerName endswith cloudRoleName\n| project Computer, InstanceName, ContainerName, PodName, PodStatus, TimeGenerated\n| extend Count = case (PodStatus == \"Running\", 1,\n        0)\n| parse kind=regex PodName with partitionId \"-airflow-scheduler-[[:graph:]]\"\n| extend clusterName = case(partitionId == \"\", \"common-cluster\",\n                       partitionId)\n| extend PodName = case(clusterName == \"common-cluster\", strcat(clusterName, \"-\", PodName),\n    PodName)\n| summarize HostCount = avg(Count) by HostName = strcat(clusterName, \"-\", cloudRoleName), TimeGenerated, clusterName, PodName, PodStatus\n| render timechart;\n"
							}
						}
					}
				},
				"8": {
					"position": {
						"x": 0,
						"y": 10,
						"colSpan": 4,
						"rowSpan": 1
					},
					"metadata": {
						"inputs": [],
						"type": "Extension/HubsExtension/PartType/MarkdownPart",
						"settings": {
							"content": {
								"settings": {
									"content": "# Airflow Worker pods",
									"subtitle": "",
									"title": ""
								}
							}
						}
					}
				},
				"9": {
					"position": {
						"x": 0,
						"y": 11,
						"colSpan": 6,
						"rowSpan": 4
					},
					"metadata": {
						"inputs": [
							{
								"name": "resourceTypeMode",
								"isOptional": true
							},
							{
								"name": "ComponentId",
								"isOptional": true
							},
							{
								"name": "Scope",
								"value": {
									"resourceIds": [
										"/subscriptions/${subscriptionId}/resourceGroups/${centralGroupPrefix}-rg/providers/Microsoft.OperationalInsights/workspaces/${centralGroupPrefix}-logs"
									]
								},
								"isOptional": true
							},
							{
								"name": "PartId",
								"value": "3bececce-2bca-4c74-9f10-7973890c2a31",
								"isOptional": true
							},
							{
								"name": "Version",
								"value": "2.0",
								"isOptional": true
							},
							{
								"name": "TimeRange",
								"value": "P1D",
								"isOptional": true
							},
							{
								"name": "DashboardId",
								"isOptional": true
							},
							{
								"name": "DraftRequestParameters",
								"isOptional": true
							},
							{
								"name": "Query",
								"value": "let capacityCounterName = 'cpuLimitNanoCores';\nlet usageCounterName = 'cpuUsageNanoCores';\nlet cloudRoleName= \"airflow-web\";\nKubePodInventory\n| where \"a\" == \"a\"\n| where ControllerName has cloudRoleName\n| extend InstanceName = strcat(ClusterId, '/', ContainerName), ContainerName = strcat(ControllerName, '/', tostring(split(ContainerName, '/')[1])), PodName = Name\n| where PodStatus in ('Running')\n| where PodName contains cloudRoleName\n| where ContainerName has cloudRoleName\n| distinct Computer, InstanceName, ContainerName, PodName\n| join\n    hint.strategy=shuffle (\n    Perf\n    | where ObjectName == 'K8SContainer'\n    | where CounterName == capacityCounterName\n    | summarize LimitValue = max(CounterValue) by Computer, InstanceName, TimeGenerated\n    | project Computer, InstanceName, LimitValue, limitA=100\n    )\n    on Computer, InstanceName\n| join kind=inner\n    hint.strategy=shuffle (\n    Perf\n    | where ObjectName == 'K8SContainer'\n    | where CounterName == usageCounterName\n    | project Computer, InstanceName, UsageValue = CounterValue, limit=100, TimeGenerated\n)\non Computer, InstanceName\n| project PodName, TimeGenerated, UsagePercent = UsageValue * 100.0 / LimitValue\n| summarize CPUPercentage=max(UsagePercent) by TimeGenerated, PodName\n| render timechart\n",
								"isOptional": true
							},
							{
								"name": "ControlType",
								"value": "FrameControlChart",
								"isOptional": true
							},
							{
								"name": "SpecificChart",
								"value": "Line",
								"isOptional": true
							},
							{
								"name": "PartTitle",
								"value": "Analytics",
								"isOptional": true
							},
							{
								"name": "PartSubTitle",
								"value": "${centralGroupPrefix}-logs",
								"isOptional": true
							},
							{
								"name": "Dimensions",
								"value": {
									"aggregation": "Sum",
									"splitBy": [
										{
											"name": "PodName",
											"type": "string"
										}
									],
									"xAxis": {
										"name": "TimeGenerated",
										"type": "datetime"
									},
									"yAxis": [
										{
											"name": "CPUPercentage",
											"type": "real"
										}
									]
								},
								"isOptional": true
							},
							{
								"name": "LegendOptions",
								"value": {
									"isEnabled": true,
									"position": "Bottom"
								},
								"isOptional": true
							},
							{
								"name": "IsQueryContainTimeRange",
								"value": false,
								"isOptional": true
							}
						],
						"type": "Extension/Microsoft_OperationsManagementSuite_Workspace/PartType/LogsDashboardPart",
						"settings": {
							"content": {
								"Dimensions": {
									"aggregation": "Sum",
									"splitBy": [
										{
											"name": "PodName",
											"type": "string"
										}
									],
									"xAxis": {
										"name": "TimeGenerated",
										"type": "datetime"
									},
									"yAxis": [
										{
											"name": "CPUPercentage",
											"type": "real"
										}
									]
								},
								"PartTitle": "CPU Usage",
								"Query": "let capacityCounterName = 'cpuLimitNanoCores';\nlet usageCounterName = 'cpuUsageNanoCores';\nlet cloudRoleName= \"airflow-worker\";\nKubePodInventory\n| where ControllerName has cloudRoleName\n| extend InstanceName = strcat(ClusterId, '/', ContainerName), ContainerName = strcat(ControllerName, '/', tostring(split(ContainerName, '/')[1])), PodName = Name\n| where PodStatus in ('Running')\n| where PodName contains cloudRoleName\n| where ContainerName endswith cloudRoleName\n| distinct Computer, InstanceName, ContainerName, PodName\n| join\n    hint.strategy=shuffle (\n    Perf\n    | where ObjectName == 'K8SContainer'\n    | where CounterName == capacityCounterName\n    | summarize LimitValue = max(CounterValue) by Computer, InstanceName, TimeGenerated\n    | project Computer, InstanceName, LimitValue, limitA=100\n    )\n    on Computer, InstanceName\n| join kind=inner\n    hint.strategy=shuffle (\n    Perf\n    | where ObjectName == 'K8SContainer'\n    | where CounterName == usageCounterName\n    | project Computer, InstanceName, UsageValue = CounterValue, limit=100, TimeGenerated\n)\non Computer, InstanceName\n| project PodName, TimeGenerated, UsagePercent = UsageValue * 100.0 / LimitValue\n| parse kind=regex PodName with partitionId \"-airflow-worker-[[:graph:]]\"\n| extend clusterName = case(partitionId == \"\", \"common-cluster\",\n                       partitionId)\n| extend PodName = case(clusterName == \"common-cluster\", strcat(clusterName, \"-\" ,PodName),\nPodName)                       \n| summarize CPUPercentage=max(UsagePercent) by PodName, TimeGenerated, clusterName\n| render timechart\n"
							}
						}
					}
				},
				"10": {
					"position": {
						"x": 6,
						"y": 11,
						"colSpan": 6,
						"rowSpan": 4
					},
					"metadata": {
						"inputs": [
							{
								"name": "resourceTypeMode",
								"isOptional": true
							},
							{
								"name": "ComponentId",
								"isOptional": true
							},
							{
								"name": "Scope",
								"value": {
									"resourceIds": [
										"/subscriptions/${subscriptionId}/resourceGroups/${centralGroupPrefix}-rg/providers/Microsoft.OperationalInsights/workspaces/${centralGroupPrefix}-logs"
									]
								},
								"isOptional": true
							},
							{
								"name": "PartId",
								"value": "42eb8a59-5c38-44c1-a188-26660c1394e4",
								"isOptional": true
							},
							{
								"name": "Version",
								"value": "2.0",
								"isOptional": true
							},
							{
								"name": "TimeRange",
								"value": "P1D",
								"isOptional": true
							},
							{
								"name": "DashboardId",
								"isOptional": true
							},
							{
								"name": "DraftRequestParameters",
								"isOptional": true
							},
							{
								"name": "Query",
								"value": "let capacityCounterName = 'memoryLimitBytes';\nlet usageCounterName = 'memoryRssBytes';\nlet cloudRoleName= \"airflow-web\";\nKubePodInventory\n| where \"a\" == \"a\"\n| where ControllerName contains cloudRoleName\n| extend InstanceName = strcat(ClusterId, '/', ContainerName), ContainerName = strcat(ControllerName, '/', tostring(split(ContainerName, '/')[1])), PodName = Name\n| where PodStatus in ('Running')\n| where PodName contains cloudRoleName\n| where ContainerName endswith cloudRoleName\n| distinct Computer, InstanceName, ContainerName, PodName\n| join\n    hint.strategy=shuffle (\n    Perf\n    | where ObjectName == 'K8SContainer'\n    | where CounterName == capacityCounterName\n    | summarize LimitValue = max(CounterValue) by Computer, InstanceName, TimeGenerated\n    | project Computer, InstanceName, LimitValue, limitA=100\n    )\n    on Computer, InstanceName\n| join kind=inner\n    hint.strategy=shuffle (\n    Perf\n    | where ObjectName == 'K8SContainer'\n    | where CounterName == usageCounterName\n    | project Computer, InstanceName, UsageValue = CounterValue, limit=100, TimeGenerated)\non Computer, InstanceName\n| project PodName, TimeGenerated, UsageValue, LimitValue\n| summarize MemoryUsage=max(UsageValue) by TimeGenerated, PodName\n| render timechart\n\n",
								"isOptional": true
							},
							{
								"name": "ControlType",
								"value": "FrameControlChart",
								"isOptional": true
							},
							{
								"name": "SpecificChart",
								"value": "Line",
								"isOptional": true
							},
							{
								"name": "PartTitle",
								"value": "Analytics",
								"isOptional": true
							},
							{
								"name": "PartSubTitle",
								"value": "${centralGroupPrefix}-logs",
								"isOptional": true
							},
							{
								"name": "Dimensions",
								"value": {
									"aggregation": "Sum",
									"splitBy": [
										{
											"name": "PodName",
											"type": "string"
										}
									],
									"xAxis": {
										"name": "TimeGenerated",
										"type": "datetime"
									},
									"yAxis": [
										{
											"name": "MemoryUsage",
											"type": "real"
										}
									]
								},
								"isOptional": true
							},
							{
								"name": "LegendOptions",
								"value": {
									"isEnabled": true,
									"position": "Bottom"
								},
								"isOptional": true
							},
							{
								"name": "IsQueryContainTimeRange",
								"value": false,
								"isOptional": true
							}
						],
						"type": "Extension/Microsoft_OperationsManagementSuite_Workspace/PartType/LogsDashboardPart",
						"settings": {
							"content": {
								"Dimensions": {
									"aggregation": "Sum",
									"splitBy": [
										{
											"name": "PodName",
											"type": "string"
										}
									],
									"xAxis": {
										"name": "TimeGenerated",
										"type": "datetime"
									},
									"yAxis": [
										{
											"name": "MemoryUsage",
											"type": "real"
										}
									]
								},
								"PartTitle": "Memory Usage",
								"Query": "let capacityCounterName = 'memoryLimitBytes';\nlet usageCounterName = 'memoryRssBytes';\nlet cloudRoleName= \"airflow-worker\";\nKubePodInventory\n| where ControllerName has cloudRoleName\n| extend InstanceName = strcat(ClusterId, '/', ContainerName), ContainerName = strcat(ControllerName, '/', tostring(split(ContainerName, '/')[1])), PodName = Name\n| where PodStatus in ('Running')\n| where PodName contains cloudRoleName\n| where ContainerName endswith cloudRoleName\n| distinct Computer, InstanceName, ContainerName, PodName\n| join\n    hint.strategy=shuffle (\n    Perf\n    | where ObjectName == 'K8SContainer'\n    | where CounterName == capacityCounterName\n    | summarize LimitValue = max(CounterValue) by Computer, InstanceName, TimeGenerated\n    | project Computer, InstanceName, LimitValue, limitA=100\n    )\n    on Computer, InstanceName\n| join kind=inner\n    hint.strategy=shuffle (\n    Perf\n    | where ObjectName == 'K8SContainer'\n    | where CounterName == usageCounterName\n    | project Computer, InstanceName, UsageValue = CounterValue, limit=100, TimeGenerated\n)\non Computer, InstanceName\n| project PodName, TimeGenerated, UsagePercent = UsageValue * 100.0 / LimitValue\n| parse kind=regex PodName with partitionId \"-airflow-worker-[[:graph:]]\"\n| extend clusterName = case(partitionId == \"\", \"common-cluster\",\n                       partitionId)\n| extend PodName = case(clusterName == \"common-cluster\", strcat(clusterName, \"-\" ,PodName),\nPodName)\n| summarize MemoryUsage=max(UsagePercent) by PodName, TimeGenerated, clusterName\n| render timechart\n\n"
							}
						}
					}
				},
				"11": {
					"position": {
						"x": 12,
						"y": 11,
						"colSpan": 6,
						"rowSpan": 4
					},
					"metadata": {
						"inputs": [
							{
								"name": "resourceTypeMode",
								"isOptional": true
							},
							{
								"name": "ComponentId",
								"isOptional": true
							},
							{
								"name": "Scope",
								"value": {
									"resourceIds": [
										"/subscriptions/${subscriptionId}/resourceGroups/${centralGroupPrefix}-rg/providers/Microsoft.OperationalInsights/workspaces/${centralGroupPrefix}-logs"
									]
								},
								"isOptional": true
							},
							{
								"name": "PartId",
								"value": "35932ce7-20e3-4698-8f11-bb6bfb528401",
								"isOptional": true
							},
							{
								"name": "Version",
								"value": "2.0",
								"isOptional": true
							},
							{
								"name": "TimeRange",
								"value": "P1D",
								"isOptional": true
							},
							{
								"name": "DashboardId",
								"isOptional": true
							},
							{
								"name": "DraftRequestParameters",
								"isOptional": true
							},
							{
								"name": "Query",
								"value": "let cloudRoleName= \"airflow-web\";\nKubePodInventory\n| where \"a\" == \"a\"\n| where ControllerName contains cloudRoleName\n| extend InstanceName = strcat(ClusterId, '/', ContainerName), ContainerName = strcat(ControllerName, '/', tostring(split(ContainerName, '/')[1])), PodName = Name\n| where PodStatus in ('Running')\n| where PodName contains cloudRoleName\n| where ContainerName endswith cloudRoleName\n| project Computer, InstanceName, ContainerName, PodName, PodStatus, TimeGenerated, Count = 1, cloudRoleName\n| summarize HostCount = avg(Count) by TimeGenerated, cloudRoleName\n| render timechart;\n",
								"isOptional": true
							},
							{
								"name": "ControlType",
								"value": "FrameControlChart",
								"isOptional": true
							},
							{
								"name": "SpecificChart",
								"value": "Line",
								"isOptional": true
							},
							{
								"name": "PartTitle",
								"value": "Analytics",
								"isOptional": true
							},
							{
								"name": "PartSubTitle",
								"value": "${centralGroupPrefix}-logs",
								"isOptional": true
							},
							{
								"name": "Dimensions",
								"value": {
									"aggregation": "Sum",
									"splitBy": [
										{
											"name": "cloudRoleName",
											"type": "string"
										}
									],
									"xAxis": {
										"name": "TimeGenerated",
										"type": "datetime"
									},
									"yAxis": [
										{
											"name": "HostCount",
											"type": "real"
										}
									]
								},
								"isOptional": true
							},
							{
								"name": "LegendOptions",
								"value": {
									"isEnabled": true,
									"position": "Bottom"
								},
								"isOptional": true
							},
							{
								"name": "IsQueryContainTimeRange",
								"value": false,
								"isOptional": true
							}
						],
						"type": "Extension/Microsoft_OperationsManagementSuite_Workspace/PartType/LogsDashboardPart",
						"settings": {
							"content": {
								"Dimensions": {
									"aggregation": "Sum",
									"splitBy": [
										{
											"name": "HostName",
											"type": "string"
										}
									],
									"xAxis": {
										"name": "TimeGenerated",
										"type": "datetime"
									},
									"yAxis": [
										{
											"name": "HostCount",
											"type": "real"
										}
									]
								},
								"PartTitle": "Healthy Host Count",
								"Query": "let cloudRoleName= \"airflow-worker\";\nKubePodInventory\n| where ControllerName contains cloudRoleName\n| extend InstanceName = strcat(ClusterId, '/', ContainerName), ContainerName = strcat(ControllerName, '/', tostring(split(ContainerName, '/')[1])), PodName = Name\n| where PodName contains cloudRoleName\n| where ContainerName endswith cloudRoleName\n| project Computer, InstanceName, ContainerName, PodName, PodStatus, TimeGenerated\n| extend Count = case (PodStatus == \"Running\", 1,\n        0)\n| parse kind=regex PodName with partitionId \"-airflow-worker-[[:graph:]]\"\n| extend clusterName = case(partitionId == \"\", \"common-cluster\",\n                       partitionId)\n| extend PodName = case(clusterName == \"common-cluster\", strcat(clusterName, \"-\", PodName),\n    PodName)\n| summarize HostCount = avg(Count) by HostName = strcat(clusterName, \"-\", cloudRoleName), TimeGenerated, clusterName, PodName, PodStatus\n| render timechart;\n\n"
							}
						}
					}
				},
				"12": {
					"position": {
						"x": 0,
						"y": 15,
						"colSpan": 4,
						"rowSpan": 1
					},
					"metadata": {
						"inputs": [],
						"type": "Extension/HubsExtension/PartType/MarkdownPart",
						"settings": {
							"content": {
								"settings": {
									"content": "# PostgreSQL",
									"subtitle": "",
									"title": ""
								}
							}
						}
					}
				},
				"13": {
					"position": {
						"x": 0,
						"y": 16,
						"colSpan": 7,
						"rowSpan": 4
					},
					"metadata": {
						"inputs": [
							{
								"name": "resourceTypeMode",
								"isOptional": true
							},
							{
								"name": "ComponentId",
								"isOptional": true
							},
							{
								"name": "Scope",
								"value": {
									"resourceIds": [
										"/subscriptions/${subscriptionId}/resourceGroups/${centralGroupPrefix}-rg/providers/Microsoft.OperationalInsights/workspaces/${centralGroupPrefix}-logs"
									]
								},
								"isOptional": true
							},
							{
								"name": "PartId",
								"value": "2be4ef88-0361-4c50-9c14-b0f5b710d80e",
								"isOptional": true
							},
							{
								"name": "Version",
								"value": "2.0",
								"isOptional": true
							},
							{
								"name": "TimeRange",
								"value": "P1D",
								"isOptional": true
							},
							{
								"name": "DashboardId",
								"isOptional": true
							},
							{
								"name": "DraftRequestParameters",
								"isOptional": true
							},
							{
								"name": "Query",
								"value": "KubePodInventory\n| where Name has \"airflow\"\n| parse kind=regex Name with partitionId \"-airflow-[[:graph:]]\"\n| extend clusterName = case(partitionId == \"\", \"sr\",\n                       partitionId)\n| distinct clusterName \n| extend dummy=1 \n| join kind=inner \n    (AzureMetrics\n    | where ResourceProvider == \"MICROSOFT.DBFORPOSTGRESQL\" \n    | parse kind=regex _ResourceId with @\"\\/subscriptions\\/([0-9a-zA-Z\\-])*\\/resourcegroups\\/([0-9a-zA-Z\\-])*\\/providers\\/microsoft\\.dbforpostgresql\\/servers\\/\" ResourceName @\"\\-pg\\z\" \n    | extend dummy=1) on dummy\n| where ResourceName contains clusterName\n| extend clusterName = case(clusterName == \"sr\", \"common-cluster\",\n                       clusterName)\n| project-away dummy, dummy1\n| where MetricName == \"active_connections\"\n| summarize ActiveConnections = avg(Average) by ResourceName, TimeGenerated, MetricName, clusterName\n| render timechart \n",
								"isOptional": true
							},
							{
								"name": "ControlType",
								"value": "FrameControlChart",
								"isOptional": true
							},
							{
								"name": "SpecificChart",
								"value": "Line",
								"isOptional": true
							},
							{
								"name": "PartTitle",
								"value": "Analytics",
								"isOptional": true
							},
							{
								"name": "PartSubTitle",
								"value": "${centralGroupPrefix}-logs",
								"isOptional": true
							},
							{
								"name": "Dimensions",
								"value": {
									"aggregation": "Sum",
									"splitBy": [
										{
											"name": "ResourceName",
											"type": "string"
										}
									],
									"xAxis": {
										"name": "TimeGenerated",
										"type": "datetime"
									},
									"yAxis": [
										{
											"name": "ActiveConnections",
											"type": "real"
										}
									]
								},
								"isOptional": true
							},
							{
								"name": "LegendOptions",
								"value": {
									"isEnabled": true,
									"position": "Bottom"
								},
								"isOptional": true
							},
							{
								"name": "IsQueryContainTimeRange",
								"value": false,
								"isOptional": true
							}
						],
						"type": "Extension/Microsoft_OperationsManagementSuite_Workspace/PartType/LogsDashboardPart",
						"settings": {
							"content": {
								"PartTitle": "Average Active Connections",
								"Query": "KubePodInventory\n| where Name has \"airflow\"\n| parse kind=regex Name with partitionId \"-airflow-[[:graph:]]\"\n| extend clusterName = case(partitionId == \"\", \"sr\",\n                       partitionId)\n| distinct clusterName \n| extend dummy=1 \n| join kind=inner \n    (AzureMetrics\n    | where ResourceProvider == \"MICROSOFT.DBFORPOSTGRESQL\" \n    | parse kind=regex _ResourceId with @\"\\/subscriptions\\/([0-9a-zA-Z\\-])*\\/resourcegroups\\/([0-9a-zA-Z\\-])*\\/providers\\/microsoft\\.dbforpostgresql\\/servers\\/\" ResourceName\n    | extend dummy=1) on dummy\n| where ResourceName contains clusterName\n| extend clusterName = case(clusterName == \"sr\", \"common-cluster\",\n                       clusterName)\n| project-away dummy, dummy1\n| where MetricName == \"active_connections\"\n| summarize ActiveConnections = avg(Average) by ResourceName, TimeGenerated, MetricName, clusterName\n| render timechart \n"
							}
						}
					}
				},
				"14": {
					"position": {
						"x": 7,
						"y": 16,
						"colSpan": 7,
						"rowSpan": 4
					},
					"metadata": {
						"inputs": [
							{
								"name": "resourceTypeMode",
								"isOptional": true
							},
							{
								"name": "ComponentId",
								"isOptional": true
							},
							{
								"name": "Scope",
								"value": {
									"resourceIds": [
										"/subscriptions/${subscriptionId}/resourceGroups/${centralGroupPrefix}-rg/providers/Microsoft.OperationalInsights/workspaces/${centralGroupPrefix}-logs"
									]
								},
								"isOptional": true
							},
							{
								"name": "PartId",
								"value": "10ce4e15-3dda-488e-ba15-ac7f7ca422f2",
								"isOptional": true
							},
							{
								"name": "Version",
								"value": "2.0",
								"isOptional": true
							},
							{
								"name": "TimeRange",
								"value": "P1D",
								"isOptional": true
							},
							{
								"name": "DashboardId",
								"isOptional": true
							},
							{
								"name": "DraftRequestParameters",
								"isOptional": true
							},
							{
								"name": "Query",
								"value": "KubePodInventory\n| where Name has \"airflow\"\n| parse kind=regex Name with partitionId \"-airflow-[[:graph:]]\"\n| extend clusterName = case(partitionId == \"\", \"sr\",\n                       partitionId)\n| distinct clusterName \n| extend dummy=1 \n| join kind=inner \n    (AzureMetrics\n    | where ResourceProvider == \"MICROSOFT.DBFORPOSTGRESQL\" \n    | parse kind=regex _ResourceId with @\"\\/subscriptions\\/([0-9a-zA-Z\\-])*\\/resourcegroups\\/([0-9a-zA-Z\\-])*\\/providers\\/microsoft\\.dbforpostgresql\\/servers\\/\" ResourceName @\"\\-pg\\z\" \n    | extend dummy=1) on dummy\n| where ResourceName contains clusterName\n| extend clusterName = case(clusterName == \"sr\", \"common-cluster\",\n                       clusterName)\n| project-away dummy, dummy1\n| where MetricName == \"cpu_percent\"\n| summarize CPUPercent = avg(Average) by ResourceName, TimeGenerated, MetricName, clusterName\n| render timechart \n",
								"isOptional": true
							},
							{
								"name": "ControlType",
								"value": "FrameControlChart",
								"isOptional": true
							},
							{
								"name": "SpecificChart",
								"value": "Line",
								"isOptional": true
							},
							{
								"name": "PartTitle",
								"value": "Analytics",
								"isOptional": true
							},
							{
								"name": "PartSubTitle",
								"value": "${centralGroupPrefix}-logs",
								"isOptional": true
							},
							{
								"name": "Dimensions",
								"value": {
									"aggregation": "Sum",
									"splitBy": [
										{
											"name": "ResourceName",
											"type": "string"
										}
									],
									"xAxis": {
										"name": "TimeGenerated",
										"type": "datetime"
									},
									"yAxis": [
										{
											"name": "CPUPercent",
											"type": "real"
										}
									]
								},
								"isOptional": true
							},
							{
								"name": "LegendOptions",
								"value": {
									"isEnabled": true,
									"position": "Bottom"
								},
								"isOptional": true
							},
							{
								"name": "IsQueryContainTimeRange",
								"value": false,
								"isOptional": true
							}
						],
						"type": "Extension/Microsoft_OperationsManagementSuite_Workspace/PartType/LogsDashboardPart",
						"settings": {
							"content": {
								"PartTitle": "CPU Usage",
								"Query": "KubePodInventory\n| where Name has \"airflow\"\n| parse kind=regex Name with partitionId \"-airflow-[[:graph:]]\"\n| extend clusterName = case(partitionId == \"\", \"sr\",\n                       partitionId)\n| distinct clusterName \n| extend dummy=1 \n| join kind=inner \n    (AzureMetrics\n    | where ResourceProvider == \"MICROSOFT.DBFORPOSTGRESQL\" \n    | parse kind=regex _ResourceId with @\"\\/subscriptions\\/([0-9a-zA-Z\\-])*\\/resourcegroups\\/([0-9a-zA-Z\\-])*\\/providers\\/microsoft\\.dbforpostgresql\\/servers\\/\" ResourceName\n    | extend dummy=1) on dummy\n| where ResourceName contains clusterName\n| extend clusterName = case(clusterName == \"sr\", \"common-cluster\",\n                       clusterName)\n| project-away dummy, dummy1\n| where MetricName == \"cpu_percent\"\n| summarize CPUPercent = max(Maximum) by ResourceName, TimeGenerated, MetricName, clusterName\n| render timechart \n"
							}
						}
					}
				},
				"15": {
					"position": {
						"x": 0,
						"y": 20,
						"colSpan": 7,
						"rowSpan": 4
					},
					"metadata": {
						"inputs": [
							{
								"name": "resourceTypeMode",
								"isOptional": true
							},
							{
								"name": "ComponentId",
								"isOptional": true
							},
							{
								"name": "Scope",
								"value": {
									"resourceIds": [
										"/subscriptions/${subscriptionId}/resourceGroups/${centralGroupPrefix}-rg/providers/Microsoft.OperationalInsights/workspaces/${centralGroupPrefix}-logs"
									]
								},
								"isOptional": true
							},
							{
								"name": "PartId",
								"value": "1290e2b2-305e-4cf1-ba13-d260ed811daa",
								"isOptional": true
							},
							{
								"name": "Version",
								"value": "2.0",
								"isOptional": true
							},
							{
								"name": "TimeRange",
								"value": "P1D",
								"isOptional": true
							},
							{
								"name": "DashboardId",
								"isOptional": true
							},
							{
								"name": "DraftRequestParameters",
								"isOptional": true
							},
							{
								"name": "Query",
								"value": "KubePodInventory\n| where Name has \"airflow\"\n| parse kind=regex Name with partitionId \"-airflow-[[:graph:]]\"\n| extend clusterName = case(partitionId == \"\", \"sr\",\n                       partitionId)\n| distinct clusterName \n| extend dummy=1 \n| join kind=inner \n    (AzureMetrics\n    | where ResourceProvider == \"MICROSOFT.DBFORPOSTGRESQL\" \n    | parse kind=regex _ResourceId with @\"\\/subscriptions\\/([0-9a-zA-Z\\-])*\\/resourcegroups\\/([0-9a-zA-Z\\-])*\\/providers\\/microsoft\\.dbforpostgresql\\/servers\\/\" ResourceName @\"\\-pg\\z\" \n    | extend dummy=1) on dummy\n| where ResourceName contains clusterName\n| extend clusterName = case(clusterName == \"sr\", \"common-cluster\",\n                       clusterName)\n| project-away dummy, dummy1\n| where MetricName == \"memory_percent\"\n| summarize MemoryPercent = avg(Average) by ResourceName, TimeGenerated, MetricName, clusterName\n| render timechart \n",
								"isOptional": true
							},
							{
								"name": "ControlType",
								"value": "FrameControlChart",
								"isOptional": true
							},
							{
								"name": "SpecificChart",
								"value": "Line",
								"isOptional": true
							},
							{
								"name": "PartTitle",
								"value": "Analytics",
								"isOptional": true
							},
							{
								"name": "PartSubTitle",
								"value": "${centralGroupPrefix}-logs",
								"isOptional": true
							},
							{
								"name": "Dimensions",
								"value": {
									"aggregation": "Sum",
									"splitBy": [
										{
											"name": "ResourceName",
											"type": "string"
										}
									],
									"xAxis": {
										"name": "TimeGenerated",
										"type": "datetime"
									},
									"yAxis": [
										{
											"name": "MemoryPercent",
											"type": "real"
										}
									]
								},
								"isOptional": true
							},
							{
								"name": "LegendOptions",
								"value": {
									"isEnabled": true,
									"position": "Bottom"
								},
								"isOptional": true
							},
							{
								"name": "IsQueryContainTimeRange",
								"value": false,
								"isOptional": true
							}
						],
						"type": "Extension/Microsoft_OperationsManagementSuite_Workspace/PartType/LogsDashboardPart",
						"settings": {
							"content": {
								"PartTitle": "Average Memory Percent",
								"Query": "KubePodInventory\n| where Name has \"airflow\"\n| parse kind=regex Name with partitionId \"-airflow-[[:graph:]]\"\n| extend clusterName = case(partitionId == \"\", \"sr\",\n                       partitionId)\n| distinct clusterName \n| extend dummy=1 \n| join kind=inner \n    (AzureMetrics\n    | where ResourceProvider == \"MICROSOFT.DBFORPOSTGRESQL\" \n    | parse kind=regex _ResourceId with @\"\\/subscriptions\\/([0-9a-zA-Z\\-])*\\/resourcegroups\\/([0-9a-zA-Z\\-])*\\/providers\\/microsoft\\.dbforpostgresql\\/servers\\/\" ResourceName \n    | extend dummy=1) on dummy\n| where ResourceName contains clusterName\n| extend clusterName = case(clusterName == \"sr\", \"common-cluster\",\n                       clusterName)\n| project-away dummy, dummy1\n| where MetricName == \"memory_percent\"\n| summarize MemoryPercent = max(Maximum) by ResourceName, TimeGenerated, MetricName, clusterName\n| render timechart \n\n"
							}
						}
					}
				},
				"16": {
					"position": {
						"x": 7,
						"y": 20,
						"colSpan": 7,
						"rowSpan": 4
					},
					"metadata": {
						"inputs": [
							{
								"name": "resourceTypeMode",
								"isOptional": true
							},
							{
								"name": "ComponentId",
								"isOptional": true
							},
							{
								"name": "Scope",
								"value": {
									"resourceIds": [
										"/subscriptions/${subscriptionId}/resourceGroups/${centralGroupPrefix}-rg/providers/Microsoft.OperationalInsights/workspaces/${centralGroupPrefix}-logs"
									]
								},
								"isOptional": true
							},
							{
								"name": "PartId",
								"value": "04189a8e-37f3-4e9c-a2a1-be92d1b47b83",
								"isOptional": true
							},
							{
								"name": "Version",
								"value": "2.0",
								"isOptional": true
							},
							{
								"name": "TimeRange",
								"value": "P1D",
								"isOptional": true
							},
							{
								"name": "DashboardId",
								"isOptional": true
							},
							{
								"name": "DraftRequestParameters",
								"isOptional": true
							},
							{
								"name": "Query",
								"value": "KubePodInventory\n| where Name has \"airflow\"\n| parse kind=regex Name with partitionId \"-airflow-[[:graph:]]\"\n| extend clusterName = case(partitionId == \"\", \"sr\",\n                       partitionId)\n| distinct clusterName \n| extend dummy=1 \n| join kind=inner \n    (AzureMetrics\n    | where ResourceProvider == \"MICROSOFT.DBFORPOSTGRESQL\" \n    | parse kind=regex _ResourceId with @\"\\/subscriptions\\/([0-9a-zA-Z\\-])*\\/resourcegroups\\/([0-9a-zA-Z\\-])*\\/providers\\/microsoft\\.dbforpostgresql\\/servers\\/\" ResourceName @\"\\-pg\\z\" \n    | extend dummy=1) on dummy\n| where ResourceName contains clusterName\n| extend clusterName = case(clusterName == \"sr\", \"common-cluster\",\n                       clusterName)\n| project-away dummy, dummy1\n| where MetricName == \"storage_percent\"\n| summarize StoragePercent = avg(Average) by ResourceName, TimeGenerated, MetricName, clusterName\n| render timechart \n",
								"isOptional": true
							},
							{
								"name": "ControlType",
								"value": "FrameControlChart",
								"isOptional": true
							},
							{
								"name": "SpecificChart",
								"value": "Line",
								"isOptional": true
							},
							{
								"name": "PartTitle",
								"value": "Analytics",
								"isOptional": true
							},
							{
								"name": "PartSubTitle",
								"value": "${centralGroupPrefix}-logs",
								"isOptional": true
							},
							{
								"name": "Dimensions",
								"value": {
									"aggregation": "Sum",
									"splitBy": [
										{
											"name": "ResourceName",
											"type": "string"
										}
									],
									"xAxis": {
										"name": "TimeGenerated",
										"type": "datetime"
									},
									"yAxis": [
										{
											"name": "StoragePercent",
											"type": "real"
										}
									]
								},
								"isOptional": true
							},
							{
								"name": "LegendOptions",
								"value": {
									"isEnabled": true,
									"position": "Bottom"
								},
								"isOptional": true
							},
							{
								"name": "IsQueryContainTimeRange",
								"value": false,
								"isOptional": true
							}
						],
						"type": "Extension/Microsoft_OperationsManagementSuite_Workspace/PartType/LogsDashboardPart",
						"settings": {
							"content": {
								"PartTitle": "Average Storage Percent",
								"Query": "KubePodInventory\n| where Name has \"airflow\"\n| parse kind=regex Name with partitionId \"-airflow-[[:graph:]]\"\n| extend clusterName = case(partitionId == \"\", \"sr\",\n                       partitionId)\n| distinct clusterName \n| extend dummy=1 \n| join kind=inner \n    (AzureMetrics\n    | where ResourceProvider == \"MICROSOFT.DBFORPOSTGRESQL\" \n    | parse kind=regex _ResourceId with @\"\\/subscriptions\\/([0-9a-zA-Z\\-])*\\/resourcegroups\\/([0-9a-zA-Z\\-])*\\/providers\\/microsoft\\.dbforpostgresql\\/servers\\/\" ResourceName\n    | extend dummy=1) on dummy\n| where ResourceName contains clusterName\n| extend clusterName = case(clusterName == \"sr\", \"common-cluster\",\n                       clusterName)\n| project-away dummy, dummy1\n| where MetricName == \"storage_percent\"\n| summarize StoragePercent = max(Maximum) by ResourceName, TimeGenerated, MetricName, clusterName\n| render timechart \n"
							}
						}
					}
				},
				"17": {
					"position": {
						"x": 0,
						"y": 24,
						"colSpan": 4,
						"rowSpan": 1
					},
					"metadata": {
						"inputs": [],
						"type": "Extension/HubsExtension/PartType/MarkdownPart",
						"settings": {
							"content": {
								"settings": {
									"content": "# Redis",
									"subtitle": "",
									"title": ""
								}
							}
						}
					}
				},
				"18": {
					"position": {
						"x": 0,
						"y": 25,
						"colSpan": 6,
						"rowSpan": 4
					},
					"metadata": {
						"inputs": [
							{
								"name": "resourceTypeMode",
								"isOptional": true
							},
							{
								"name": "ComponentId",
								"isOptional": true
							},
							{
								"name": "Scope",
								"value": {
									"resourceIds": [
										"/subscriptions/${subscriptionId}/resourceGroups/${centralGroupPrefix}-rg/providers/Microsoft.OperationalInsights/workspaces/${centralGroupPrefix}-logs"
									]
								},
								"isOptional": true
							},
							{
								"name": "PartId",
								"value": "15965119-7ce3-48b2-9912-087fcd4877aa",
								"isOptional": true
							},
							{
								"name": "Version",
								"value": "2.0",
								"isOptional": true
							},
							{
								"name": "TimeRange",
								"value": "P1D",
								"isOptional": true
							},
							{
								"name": "DashboardId",
								"isOptional": true
							},
							{
								"name": "DraftRequestParameters",
								"isOptional": true
							},
							{
								"name": "Query",
								"value": "KubePodInventory\n| where Name has \"airflow\"\n| parse kind=regex Name with partitionId \"-airflow-[[:graph:]]\"\n| extend clusterName = case(partitionId == \"\", \"sr\",\n                       partitionId)\n| distinct clusterName \n| extend dummy=1 \n| join kind=inner \n    (AzureMetrics\n    | where ResourceProvider == \"MICROSOFT.CACHE\" \n    | parse kind=regex _ResourceId with @\"\\/subscriptions\\/([0-9a-zA-Z\\-])*\\/resourcegroups\\/([0-9a-zA-Z\\-])*\\/providers\\/microsoft\\.cache\\/redis\\/\" ResourceName\n    | extend dummy=1) on dummy\n| where ResourceName contains clusterName\n| project-away dummy, dummy1\n| extend clusterName = case(clusterName == \"sr\", \"common-cluster\",\n                       clusterName)\n| where MetricName == \"percentProcessorTime\"\n| summarize CPUPercent = avg(Average) by ResourceName, TimeGenerated, MetricName, clusterName\n| render timechart \n",
								"isOptional": true
							},
							{
								"name": "ControlType",
								"value": "FrameControlChart",
								"isOptional": true
							},
							{
								"name": "SpecificChart",
								"value": "Line",
								"isOptional": true
							},
							{
								"name": "PartTitle",
								"value": "Analytics",
								"isOptional": true
							},
							{
								"name": "PartSubTitle",
								"value": "${centralGroupPrefix}-logs",
								"isOptional": true
							},
							{
								"name": "Dimensions",
								"value": {
									"aggregation": "Sum",
									"splitBy": [
										{
											"name": "ResourceName",
											"type": "string"
										}
									],
									"xAxis": {
										"name": "TimeGenerated",
										"type": "datetime"
									},
									"yAxis": [
										{
											"name": "CPUPercent",
											"type": "real"
										}
									]
								},
								"isOptional": true
							},
							{
								"name": "LegendOptions",
								"value": {
									"isEnabled": true,
									"position": "Bottom"
								},
								"isOptional": true
							},
							{
								"name": "IsQueryContainTimeRange",
								"value": false,
								"isOptional": true
							}
						],
						"type": "Extension/Microsoft_OperationsManagementSuite_Workspace/PartType/LogsDashboardPart",
						"settings": {
							"content": {
								"PartTitle": "CPU Usage Percentage",
								"Query": "KubePodInventory\n| where Name has \"airflow\"\n| parse kind=regex Name with partitionId \"-airflow-[[:graph:]]\"\n| extend clusterName = case(partitionId == \"\", \"sr\",\n                       partitionId)\n| distinct clusterName \n| extend dummy=1 \n| join kind=inner \n    (AzureMetrics\n    | where ResourceProvider == \"MICROSOFT.CACHE\" \n    | parse kind=regex _ResourceId with @\"\\/subscriptions\\/([0-9a-zA-Z\\-])*\\/resourcegroups\\/([0-9a-zA-Z\\-])*\\/providers\\/microsoft\\.cache\\/redis\\/\" ResourceName\n    | extend dummy=1) on dummy\n| where ResourceName contains clusterName\n| where ResourceName contains \"queue\"\n| extend clusterName = case(clusterName == \"sr\", \"common-cluster\",\n                       clusterName)\n| project-away dummy, dummy1\n| where MetricName == \"percentProcessorTime\"\n| summarize CPUPercent = max(Maximum) by ResourceName, TimeGenerated, MetricName, clusterName\n| render timechart \n"
							}
						}
					}
				},
				"19": {
					"position": {
						"x": 6,
						"y": 25,
						"colSpan": 6,
						"rowSpan": 4
					},
					"metadata": {
						"inputs": [
							{
								"name": "resourceTypeMode",
								"isOptional": true
							},
							{
								"name": "ComponentId",
								"isOptional": true
							},
							{
								"name": "Scope",
								"value": {
									"resourceIds": [
										"/subscriptions/${subscriptionId}/resourceGroups/${centralGroupPrefix}-rg/providers/Microsoft.OperationalInsights/workspaces/${centralGroupPrefix}-logs"
									]
								},
								"isOptional": true
							},
							{
								"name": "PartId",
								"value": "5fc84d86-23c1-4441-9f12-ec11bfe134a2",
								"isOptional": true
							},
							{
								"name": "Version",
								"value": "2.0",
								"isOptional": true
							},
							{
								"name": "TimeRange",
								"value": "P1D",
								"isOptional": true
							},
							{
								"name": "DashboardId",
								"isOptional": true
							},
							{
								"name": "DraftRequestParameters",
								"isOptional": true
							},
							{
								"name": "Query",
								"value": "KubePodInventory\n| where Name has \"airflow\"\n| parse kind=regex Name with partitionId \"-airflow-[[:graph:]]\"\n| extend clusterName = case(partitionId == \"\", \"sr\",\n                       partitionId)\n| distinct clusterName \n| extend dummy=1 \n| join kind=inner \n    (AzureMetrics\n    | where ResourceProvider == \"MICROSOFT.CACHE\" \n    | parse kind=regex _ResourceId with @\"\\/subscriptions\\/([0-9a-zA-Z\\-])*\\/resourcegroups\\/([0-9a-zA-Z\\-])*\\/providers\\/microsoft\\.cache\\/redis\\/\" ResourceName\n    | extend dummy=1) on dummy\n| where ResourceName contains clusterName\n| where ResourceName contains \"queue\"\n| extend clusterName = case(clusterName == \"sr\", \"common-cluster\",\n                       clusterName)\n| project-away dummy, dummy1\n| where MetricName == \"connectedclients\"\n| summarize ConnectedClients = avg(Average) by ResourceName, TimeGenerated, MetricName, clusterName\n| render timechart \n",
								"isOptional": true
							},
							{
								"name": "ControlType",
								"value": "FrameControlChart",
								"isOptional": true
							},
							{
								"name": "SpecificChart",
								"value": "Line",
								"isOptional": true
							},
							{
								"name": "PartTitle",
								"value": "Analytics",
								"isOptional": true
							},
							{
								"name": "PartSubTitle",
								"value": "${centralGroupPrefix}-logs",
								"isOptional": true
							},
							{
								"name": "Dimensions",
								"value": {
									"aggregation": "Sum",
									"splitBy": [
										{
											"name": "ResourceName",
											"type": "string"
										}
									],
									"xAxis": {
										"name": "TimeGenerated",
										"type": "datetime"
									},
									"yAxis": [
										{
											"name": "ConnectedClients",
											"type": "real"
										}
									]
								},
								"isOptional": true
							},
							{
								"name": "LegendOptions",
								"value": {
									"isEnabled": true,
									"position": "Bottom"
								},
								"isOptional": true
							},
							{
								"name": "IsQueryContainTimeRange",
								"value": false,
								"isOptional": true
							}
						],
						"type": "Extension/Microsoft_OperationsManagementSuite_Workspace/PartType/LogsDashboardPart",
						"settings": {
							"content": {
								"Query": "KubePodInventory\n| where Name has \"airflow\"\n| parse kind=regex Name with partitionId \"-airflow-[[:graph:]]\"\n| extend clusterName = case(partitionId == \"\", \"sr\",\n                       partitionId)\n| distinct clusterName \n| extend dummy=1 \n| join kind=inner \n    (AzureMetrics\n    | where ResourceProvider == \"MICROSOFT.CACHE\" \n    | parse kind=regex _ResourceId with @\"\\/subscriptions\\/([0-9a-zA-Z\\-])*\\/resourcegroups\\/([0-9a-zA-Z\\-])*\\/providers\\/microsoft\\.cache\\/redis\\/\" ResourceName\n    | extend dummy=1) on dummy\n| where ResourceName contains clusterName\n| where ResourceName contains \"queue\"\n| project-away dummy, dummy1\n| extend clusterName = case(clusterName == \"sr\", \"common-cluster\",\n                       clusterName)\n| where MetricName == \"usedmemorypercentage\"\n| summarize MemoryUsage = max(Average) by ResourceName, TimeGenerated, MetricName, clusterName\n| render timechart\n\n",
								"PartTitle": "Memory Usage Percentage",
								"Dimensions": {
									"aggregation": "Sum",
									"splitBy": [
										{
											"name": "ResourceName",
											"type": "string"
										}
									],
									"xAxis": {
										"name": "TimeGenerated",
										"type": "datetime"
									},
									"yAxis": [
										{
											"name": "MemoryUsage",
											"type": "real"
										}
									]
								}
							}
						}
					}
				},
				"20": {
					"position": {
						"x": 12,
						"y": 25,
						"colSpan": 6,
						"rowSpan": 4
					},
					"metadata": {
						"inputs": [
							{
								"name": "resourceTypeMode",
								"isOptional": true
							},
							{
								"name": "ComponentId",
								"isOptional": true
							},
							{
								"name": "Scope",
								"value": {
									"resourceIds": [
										"/subscriptions/${subscriptionId}/resourceGroups/${centralGroupPrefix}-rg/providers/Microsoft.OperationalInsights/workspaces/${centralGroupPrefix}-logs"
									]
								},
								"isOptional": true
							},
							{
								"name": "PartId",
								"value": "66ede666-670f-4bbb-a665-e1fe610ab3c4",
								"isOptional": true
							},
							{
								"name": "Version",
								"value": "2.0",
								"isOptional": true
							},
							{
								"name": "TimeRange",
								"value": "P1D",
								"isOptional": true
							},
							{
								"name": "DashboardId",
								"isOptional": true
							},
							{
								"name": "DraftRequestParameters",
								"isOptional": true
							},
							{
								"name": "Query",
								"value": "KubePodInventory\n| where Name has \"airflow\"\n| parse kind=regex Name with partitionId \"-airflow-[[:graph:]]\"\n| extend clusterName = case(partitionId == \"\", \"sr\",\n                       partitionId)\n| distinct clusterName \n| extend dummy=1 \n| join kind=inner \n    (AzureMetrics\n    | where ResourceProvider == \"MICROSOFT.CACHE\" \n    | parse kind=regex _ResourceId with @\"\\/subscriptions\\/([0-9a-zA-Z\\-])*\\/resourcegroups\\/([0-9a-zA-Z\\-])*\\/providers\\/microsoft\\.cache\\/redis\\/\" ResourceName\n    | extend dummy=1) on dummy\n| where ResourceName contains clusterName\n| where ResourceName contains \"queue\"\n| project-away dummy, dummy1\n| extend clusterName = case(clusterName == \"sr\", \"common-cluster\",\n                       clusterName)\n| where MetricName == \"connectedclients\"\n| summarize ConnectedClients = avg(Average) by ResourceName, TimeGenerated, MetricName, clusterName\n| render timechart \n",
								"isOptional": true
							},
							{
								"name": "ControlType",
								"value": "FrameControlChart",
								"isOptional": true
							},
							{
								"name": "SpecificChart",
								"value": "Line",
								"isOptional": true
							},
							{
								"name": "PartTitle",
								"value": "Analytics",
								"isOptional": true
							},
							{
								"name": "PartSubTitle",
								"value": "${centralGroupPrefix}-logs",
								"isOptional": true
							},
							{
								"name": "Dimensions",
								"value": {
									"aggregation": "Sum",
									"splitBy": [
										{
											"name": "ResourceName",
											"type": "string"
										}
									],
									"xAxis": {
										"name": "TimeGenerated",
										"type": "datetime"
									},
									"yAxis": [
										{
											"name": "ConnectedClients",
											"type": "real"
										}
									]
								},
								"isOptional": true
							},
							{
								"name": "LegendOptions",
								"value": {
									"isEnabled": true,
									"position": "Bottom"
								},
								"isOptional": true
							},
							{
								"name": "IsQueryContainTimeRange",
								"value": false,
								"isOptional": true
							}
						],
						"type": "Extension/Microsoft_OperationsManagementSuite_Workspace/PartType/LogsDashboardPart",
						"settings": {
							"content": {
								"PartTitle": "Connected Clients Count",
								"Query": "KubePodInventory\n| where Name has \"airflow\"\n| parse kind=regex Name with partitionId \"-airflow-[[:graph:]]\"\n| extend clusterName = case(partitionId == \"\", \"sr\",\n                       partitionId)\n| distinct clusterName \n| extend dummy=1 \n| join kind=inner \n    (AzureMetrics\n    | where ResourceProvider == \"MICROSOFT.CACHE\" \n    | parse kind=regex _ResourceId with @\"\\/subscriptions\\/([0-9a-zA-Z\\-])*\\/resourcegroups\\/([0-9a-zA-Z\\-])*\\/providers\\/microsoft\\.cache\\/redis\\/\" ResourceName\n    | extend dummy=1) on dummy\n| where ResourceName contains clusterName\n| where ResourceName contains \"queue\"\n| extend clusterName = case(clusterName == \"sr\", \"common-cluster\",\n                       clusterName)\n| project-away dummy, dummy1\n| where MetricName == \"connectedclients\"\n| summarize ConnectedClients = max(Maximum) by ResourceName, TimeGenerated, MetricName, clusterName\n| render timechart \n\n"
							}
						}
					}
				}
			}
		}
	},
	"metadata": {
		"model": {
			"timeRange": {
				"value": {
					"relative": {
						"duration": 24,
						"timeUnit": 1
					}
				},
				"type": "MsPortalFx.Composition.Configuration.ValueTypes.TimeRange"
			},
			"filterLocale": {
				"value": "en-us"
			},
			"filters": {
				"value": {
					"MsPortalFx_TimeRange": {
						"model": {
							"format": "utc",
							"granularity": "auto",
							"relative": "3d"
						},
						"displayCache": {
							"name": "UTC Time",
							"value": "Past 3 days"
						},
						"filteredPartIds": [
							"StartboardPart-LogsDashboardPart-9035975b-6e62-4b52-945a-508ce88da00a",
							"StartboardPart-LogsDashboardPart-9035975b-6e62-4b52-945a-508ce88da00c",
							"StartboardPart-LogsDashboardPart-9035975b-6e62-4b52-945a-508ce88da00e",
							"StartboardPart-LogsDashboardPart-9035975b-6e62-4b52-945a-508ce88da012",
							"StartboardPart-LogsDashboardPart-9035975b-6e62-4b52-945a-508ce88da014",
							"StartboardPart-LogsDashboardPart-9035975b-6e62-4b52-945a-508ce88da016",
							"StartboardPart-LogsDashboardPart-9035975b-6e62-4b52-945a-508ce88da01a",
							"StartboardPart-LogsDashboardPart-9035975b-6e62-4b52-945a-508ce88da01c",
							"StartboardPart-LogsDashboardPart-9035975b-6e62-4b52-945a-508ce88da01e",
							"StartboardPart-LogsDashboardPart-9035975b-6e62-4b52-945a-508ce88da022",
							"StartboardPart-LogsDashboardPart-9035975b-6e62-4b52-945a-508ce88da024",
							"StartboardPart-LogsDashboardPart-9035975b-6e62-4b52-945a-508ce88da026",
							"StartboardPart-LogsDashboardPart-9035975b-6e62-4b52-945a-508ce88da028",
							"StartboardPart-LogsDashboardPart-9035975b-6e62-4b52-945a-508ce88da02c",
							"StartboardPart-LogsDashboardPart-9035975b-6e62-4b52-945a-508ce88da02e",
							"StartboardPart-LogsDashboardPart-9035975b-6e62-4b52-945a-508ce88da030"
						]
					},
					"dynamicFilter_PodName": {
						"model": {
							"operator": "equals",
							"values": []
						},
						"displayCache": {
							"name": "PodName",
							"value": "none"
						},
						"filteredPartIds": [
							"StartboardPart-LogsDashboardPart-9035975b-6e62-4b52-945a-508ce88da00a",
							"StartboardPart-LogsDashboardPart-9035975b-6e62-4b52-945a-508ce88da00c",
							"StartboardPart-LogsDashboardPart-9035975b-6e62-4b52-945a-508ce88da00e",
							"StartboardPart-LogsDashboardPart-9035975b-6e62-4b52-945a-508ce88da012",
							"StartboardPart-LogsDashboardPart-9035975b-6e62-4b52-945a-508ce88da014",
							"StartboardPart-LogsDashboardPart-9035975b-6e62-4b52-945a-508ce88da016",
							"StartboardPart-LogsDashboardPart-9035975b-6e62-4b52-945a-508ce88da01a",
							"StartboardPart-LogsDashboardPart-9035975b-6e62-4b52-945a-508ce88da01c",
							"StartboardPart-LogsDashboardPart-9035975b-6e62-4b52-945a-508ce88da01e"
						]
					},
					"dynamicFilter_clusterName": {
						"model": {
							"operator": "equals",
							"values": []
						},
						"displayCache": {
							"name": "clusterName",
							"value": "none"
						},
						"filteredPartIds": [
							"StartboardPart-LogsDashboardPart-9035975b-6e62-4b52-945a-508ce88da00a",
							"StartboardPart-LogsDashboardPart-9035975b-6e62-4b52-945a-508ce88da00c",
							"StartboardPart-LogsDashboardPart-9035975b-6e62-4b52-945a-508ce88da00e",
							"StartboardPart-LogsDashboardPart-9035975b-6e62-4b52-945a-508ce88da012",
							"StartboardPart-LogsDashboardPart-9035975b-6e62-4b52-945a-508ce88da014",
							"StartboardPart-LogsDashboardPart-9035975b-6e62-4b52-945a-508ce88da016",
							"StartboardPart-LogsDashboardPart-9035975b-6e62-4b52-945a-508ce88da01a",
							"StartboardPart-LogsDashboardPart-9035975b-6e62-4b52-945a-508ce88da01c",
							"StartboardPart-LogsDashboardPart-9035975b-6e62-4b52-945a-508ce88da01e",
							"StartboardPart-LogsDashboardPart-9035975b-6e62-4b52-945a-508ce88da022",
							"StartboardPart-LogsDashboardPart-9035975b-6e62-4b52-945a-508ce88da024",
							"StartboardPart-LogsDashboardPart-9035975b-6e62-4b52-945a-508ce88da026",
							"StartboardPart-LogsDashboardPart-9035975b-6e62-4b52-945a-508ce88da028",
							"StartboardPart-LogsDashboardPart-9035975b-6e62-4b52-945a-508ce88da02c",
							"StartboardPart-LogsDashboardPart-9035975b-6e62-4b52-945a-508ce88da02e",
							"StartboardPart-LogsDashboardPart-9035975b-6e62-4b52-945a-508ce88da030"
						]
					}
				}
			}
		}
	}
}