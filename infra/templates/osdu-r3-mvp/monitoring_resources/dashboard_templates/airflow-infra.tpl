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
								"value": "let capacityCounterName = 'cpuLimitNanoCores';\nlet usageCounterName = 'cpuUsageNanoCores';\nlet cloudRoleName= \"airflow-web\";\nKubePodInventory\n| where \"a\" == \"a\"\n| where ControllerName has cloudRoleName\n| extend InstanceName = strcat(ClusterId, '/', ContainerName), ContainerName = strcat(ControllerName, '/', tostring(split(ContainerName, '/')[1])), PodName = Name\n| where PodStatus in ('Running')\n| where PodName contains cloudRoleName\n| where ContainerName has cloudRoleName\n| distinct Computer, InstanceName, ContainerName, PodName\n| join\n    hint.strategy=shuffle (\n    Perf\n    | where ObjectName == 'K8SContainer'\n    | where CounterName == capacityCounterName\n    | summarize LimitValue = max(CounterValue) by Computer, InstanceName, bin(TimeGenerated, 15m)\n    | project Computer, InstanceName, LimitValue, limitA=100\n    )\n    on Computer, InstanceName\n| join kind=inner\n    hint.strategy=shuffle (\n    Perf\n    | where ObjectName == 'K8SContainer'\n    | where CounterName == usageCounterName\n    | project Computer, InstanceName, UsageValue = CounterValue, limit=100, TimeGenerated\n)\non Computer, InstanceName\n| project PodName, TimeGenerated, UsagePercent = UsageValue * 100.0 / LimitValue\n| summarize CPUPercentage=max(UsagePercent) by bin(TimeGenerated, 15m), PodName\n| render timechart\n",
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
								"Query": "let capacityCounterName = 'cpuLimitNanoCores';\nlet usageCounterName = 'cpuUsageNanoCores';\nlet cloudRoleName= \"airflow-web\";\nKubePodInventory\n| where ControllerName has cloudRoleName\n| extend InstanceName = strcat(ClusterId, '/', ContainerName), ContainerName = strcat(ControllerName, '/', tostring(split(ContainerName, '/')[1])), PodName = Name\n| where PodStatus in ('Running')\n| where PodName contains cloudRoleName\n| where ContainerName endswith cloudRoleName\n| distinct Computer, InstanceName, ContainerName, PodName\n| join\n    hint.strategy=shuffle (\n    Perf\n    | where ObjectName == 'K8SContainer'\n    | where CounterName == capacityCounterName\n    | summarize LimitValue = max(CounterValue) by Computer, InstanceName, bin(TimeGenerated, 15m)\n    | project Computer, InstanceName, LimitValue, limitA=100\n    )\n    on Computer, InstanceName\n| join kind=inner\n    hint.strategy=shuffle (\n    Perf\n    | where ObjectName == 'K8SContainer'\n    | where CounterName == usageCounterName\n    | project Computer, InstanceName, UsageValue = CounterValue, limit=100, TimeGenerated\n)\non Computer, InstanceName\n| project PodName, TimeGenerated, UsagePercent = UsageValue * 100.0 / LimitValue\n| parse kind=regex PodName with partitionId \"-airflow-web-[[:graph:]]\"\n| extend dataPartitionID = case(partitionId == \"\", \"sr\",\n                       partitionId)\n| summarize CPUPercentage=max(UsagePercent) by PodName, bin(TimeGenerated, 15m), dataPartitionID\n| render timechart\n\n",
								"PartTitle": "CPU Usage",
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
								}
							}
						},
						"savedContainerState": {
							"partTitle": "CPU Usage",
							"assetName": "${centralGroupPrefix}-logs"
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
								"value": "let capacityCounterName = 'memoryLimitBytes';\nlet usageCounterName = 'memoryRssBytes';\nlet cloudRoleName= \"airflow-web\";\nKubePodInventory\n| where \"a\" == \"a\"\n| where ControllerName contains cloudRoleName\n| extend InstanceName = strcat(ClusterId, '/', ContainerName), ContainerName = strcat(ControllerName, '/', tostring(split(ContainerName, '/')[1])), PodName = Name\n| where PodStatus in ('Running')\n| where PodName contains cloudRoleName\n| where ContainerName endswith cloudRoleName\n| distinct Computer, InstanceName, ContainerName, PodName\n| join\n    hint.strategy=shuffle (\n    Perf\n    | where ObjectName == 'K8SContainer'\n    | where CounterName == capacityCounterName\n    | summarize LimitValue = max(CounterValue) by Computer, InstanceName, bin(TimeGenerated, 15m)\n    | project Computer, InstanceName, LimitValue, limitA=100\n    )\n    on Computer, InstanceName\n| join kind=inner\n    hint.strategy=shuffle (\n    Perf\n    | where ObjectName == 'K8SContainer'\n    | where CounterName == usageCounterName\n    | project Computer, InstanceName, UsageValue = CounterValue, limit=100, TimeGenerated)\non Computer, InstanceName\n| project PodName, TimeGenerated, UsageValue, LimitValue\n| summarize MemoryUsage=max(UsageValue) by bin(TimeGenerated, 15m), PodName\n| render timechart\n\n",
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
								"Query": "let capacityCounterName = 'memoryLimitBytes';\nlet usageCounterName = 'memoryRssBytes';\nlet cloudRoleName= \"airflow-web\";\nKubePodInventory\n| where ControllerName has cloudRoleName\n| extend InstanceName = strcat(ClusterId, '/', ContainerName), ContainerName = strcat(ControllerName, '/', tostring(split(ContainerName, '/')[1])), PodName = Name\n| where PodStatus in ('Running')\n| where PodName contains cloudRoleName\n| where ContainerName endswith cloudRoleName\n| distinct Computer, InstanceName, ContainerName, PodName\n| join\n    hint.strategy=shuffle (\n    Perf\n    | where ObjectName == 'K8SContainer'\n    | where CounterName == capacityCounterName\n    | summarize LimitValue = max(CounterValue) by Computer, InstanceName, bin(TimeGenerated, 15m)\n    | project Computer, InstanceName, LimitValue, limitA=100\n    )\n    on Computer, InstanceName\n| join kind=inner\n    hint.strategy=shuffle (\n    Perf\n    | where ObjectName == 'K8SContainer'\n    | where CounterName == usageCounterName\n    | project Computer, InstanceName, UsageValue = CounterValue, limit=100, TimeGenerated\n)\non Computer, InstanceName\n| project PodName, TimeGenerated, UsagePercent = UsageValue * 100.0 / LimitValue\n| parse kind=regex PodName with partitionId \"-airflow-web-[[:graph:]]\"\n| extend dataPartitionID = case(partitionId == \"\", \"sr\",\n                       partitionId)\n| summarize MemoryUsage=max(UsagePercent) by PodName, bin(TimeGenerated, 15m), dataPartitionID\n| render timechart\n\n",
								"PartTitle": "Memory Usage",
								"Dimensions": {
									"xAxis": {
										"name": "TimeGenerated",
										"type": "datetime"
									},
									"yAxis": [
										{
											"name": "MemoryUsage",
											"type": "real"
										}
									],
									"splitBy": [
										{
											"name": "PodName",
											"type": "string"
										}
									],
									"aggregation": "Sum"
								}
							}
						},
						"savedContainerState": {
							"partTitle": "Memory Usage",
							"assetName": "${centralGroupPrefix}-logs"
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
								"value": "let cloudRoleName= \"airflow-web\";\nKubePodInventory\n| where \"a\" == \"a\"\n| where ControllerName contains cloudRoleName\n| extend InstanceName = strcat(ClusterId, '/', ContainerName), ContainerName = strcat(ControllerName, '/', tostring(split(ContainerName, '/')[1])), PodName = Name\n| where PodStatus in ('Running')\n| where PodName contains cloudRoleName\n| where ContainerName endswith cloudRoleName\n| project Computer, InstanceName, ContainerName, PodName, PodStatus, TimeGenerated, Count = 1, cloudRoleName\n| summarize HostCount = avg(Count) by bin(TimeGenerated, 15m), cloudRoleName\n| render timechart;\n",
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
								"Query": "let cloudRoleName= \"airflow-web\";\nKubePodInventory\n| where ControllerName contains cloudRoleName\n| extend InstanceName = strcat(ClusterId, '/', ContainerName), ContainerName = strcat(ControllerName, '/', tostring(split(ContainerName, '/')[1])), PodName = Name\n| where PodStatus in ('Running')\n| where PodName contains cloudRoleName\n| where ContainerName endswith cloudRoleName\n| project Computer, InstanceName, ContainerName, PodName, PodStatus, TimeGenerated, Count = 1\n| parse kind=regex PodName with partitionId \"-airflow-web-[[:graph:]]\"\n| extend dataPartitionID = case(partitionId == \"\", \"sr\",\n                       partitionId)\n| summarize HostCount = avg(Count) by HostName = strcat(dataPartitionID, \"-\", cloudRoleName), bin(TimeGenerated, 15m), dataPartitionID\n| render timechart;\n\n",
								"PartTitle": "Healthy Host Count",
								"Dimensions": {
									"xAxis": {
										"name": "TimeGenerated",
										"type": "datetime"
									},
									"yAxis": [
										{
											"name": "HostCount",
											"type": "real"
										}
									],
									"splitBy": [
										{
											"name": "HostName",
											"type": "string"
										}
									],
									"aggregation": "Sum"
								}
							}
						},
						"savedContainerState": {
							"partTitle": "Healthy Host Count",
							"assetName": "${centralGroupPrefix}-logs"
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
								"value": "let capacityCounterName = 'cpuLimitNanoCores';\nlet usageCounterName = 'cpuUsageNanoCores';\nlet cloudRoleName= \"airflow-web\";\nKubePodInventory\n| where \"a\" == \"a\"\n| where ControllerName has cloudRoleName\n| extend InstanceName = strcat(ClusterId, '/', ContainerName), ContainerName = strcat(ControllerName, '/', tostring(split(ContainerName, '/')[1])), PodName = Name\n| where PodStatus in ('Running')\n| where PodName contains cloudRoleName\n| where ContainerName has cloudRoleName\n| distinct Computer, InstanceName, ContainerName, PodName\n| join\n    hint.strategy=shuffle (\n    Perf\n    | where ObjectName == 'K8SContainer'\n    | where CounterName == capacityCounterName\n    | summarize LimitValue = max(CounterValue) by Computer, InstanceName, bin(TimeGenerated, 15m)\n    | project Computer, InstanceName, LimitValue, limitA=100\n    )\n    on Computer, InstanceName\n| join kind=inner\n    hint.strategy=shuffle (\n    Perf\n    | where ObjectName == 'K8SContainer'\n    | where CounterName == usageCounterName\n    | project Computer, InstanceName, UsageValue = CounterValue, limit=100, TimeGenerated\n)\non Computer, InstanceName\n| project PodName, TimeGenerated, UsagePercent = UsageValue * 100.0 / LimitValue\n| summarize CPUPercentage=max(UsagePercent) by bin(TimeGenerated, 15m), PodName\n| render timechart\n",
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
								"Query": "let capacityCounterName = 'cpuLimitNanoCores';\nlet usageCounterName = 'cpuUsageNanoCores';\nlet cloudRoleName= \"airflow-scheduler\";\nKubePodInventory\n| where ControllerName has cloudRoleName\n| extend InstanceName = strcat(ClusterId, '/', ContainerName), ContainerName = strcat(ControllerName, '/', tostring(split(ContainerName, '/')[1])), PodName = Name\n| where PodStatus in ('Running')\n| where PodName contains cloudRoleName\n| where ContainerName endswith cloudRoleName\n| distinct Computer, InstanceName, ContainerName, PodName\n| join\n    hint.strategy=shuffle (\n    Perf\n    | where ObjectName == 'K8SContainer'\n    | where CounterName == capacityCounterName\n    | summarize LimitValue = max(CounterValue) by Computer, InstanceName, bin(TimeGenerated, 15m)\n    | project Computer, InstanceName, LimitValue, limitA=100\n    )\n    on Computer, InstanceName\n| join kind=inner\n    hint.strategy=shuffle (\n    Perf\n    | where ObjectName == 'K8SContainer'\n    | where CounterName == usageCounterName\n    | project Computer, InstanceName, UsageValue = CounterValue, limit=100, TimeGenerated\n)\non Computer, InstanceName\n| project PodName, TimeGenerated, UsagePercent = UsageValue * 100.0 / LimitValue\n| parse kind=regex PodName with partitionId \"-airflow-scheduler-[[:graph:]]\"\n| extend dataPartitionID = case(partitionId == \"\", \"sr\",\n                       partitionId)\n| summarize CPUPercentage=max(UsagePercent) by PodName, bin(TimeGenerated, 15m), dataPartitionID\n| render timechart\n",
								"PartTitle": "CPU Usage",
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
								}
							}
						},
						"savedContainerState": {
							"partTitle": "CPU Usage",
							"assetName": "${centralGroupPrefix}-logs"
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
								"value": "let capacityCounterName = 'memoryLimitBytes';\nlet usageCounterName = 'memoryRssBytes';\nlet cloudRoleName= \"airflow-web\";\nKubePodInventory\n| where \"a\" == \"a\"\n| where ControllerName contains cloudRoleName\n| extend InstanceName = strcat(ClusterId, '/', ContainerName), ContainerName = strcat(ControllerName, '/', tostring(split(ContainerName, '/')[1])), PodName = Name\n| where PodStatus in ('Running')\n| where PodName contains cloudRoleName\n| where ContainerName endswith cloudRoleName\n| distinct Computer, InstanceName, ContainerName, PodName\n| join\n    hint.strategy=shuffle (\n    Perf\n    | where ObjectName == 'K8SContainer'\n    | where CounterName == capacityCounterName\n    | summarize LimitValue = max(CounterValue) by Computer, InstanceName, bin(TimeGenerated, 15m)\n    | project Computer, InstanceName, LimitValue, limitA=100\n    )\n    on Computer, InstanceName\n| join kind=inner\n    hint.strategy=shuffle (\n    Perf\n    | where ObjectName == 'K8SContainer'\n    | where CounterName == usageCounterName\n    | project Computer, InstanceName, UsageValue = CounterValue, limit=100, TimeGenerated)\non Computer, InstanceName\n| project PodName, TimeGenerated, UsageValue, LimitValue\n| summarize MemoryUsage=max(UsageValue) by bin(TimeGenerated, 15m), PodName\n| render timechart\n\n",
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
								"Query": "let capacityCounterName = 'memoryLimitBytes';\nlet usageCounterName = 'memoryRssBytes';\nlet cloudRoleName= \"airflow-scheduler\";\nKubePodInventory\n| where ControllerName has cloudRoleName\n| extend InstanceName = strcat(ClusterId, '/', ContainerName), ContainerName = strcat(ControllerName, '/', tostring(split(ContainerName, '/')[1])), PodName = Name\n| where PodStatus in ('Running')\n| where PodName contains cloudRoleName\n| where ContainerName endswith cloudRoleName\n| distinct Computer, InstanceName, ContainerName, PodName\n| join\n    hint.strategy=shuffle (\n    Perf\n    | where ObjectName == 'K8SContainer'\n    | where CounterName == capacityCounterName\n    | summarize LimitValue = max(CounterValue) by Computer, InstanceName, bin(TimeGenerated, 15m)\n    | project Computer, InstanceName, LimitValue, limitA=100\n    )\n    on Computer, InstanceName\n| join kind=inner\n    hint.strategy=shuffle (\n    Perf\n    | where ObjectName == 'K8SContainer'\n    | where CounterName == usageCounterName\n    | project Computer, InstanceName, UsageValue = CounterValue, limit=100, TimeGenerated\n)\non Computer, InstanceName\n| project PodName, TimeGenerated, UsagePercent = UsageValue * 100.0 / LimitValue\n| parse kind=regex PodName with partitionId \"-airflow-scheduler-[[:graph:]]\"\n| extend dataPartitionID = case(partitionId == \"\", \"sr\",\n                       partitionId)\n| summarize MemoryUsage=max(UsagePercent) by PodName, bin(TimeGenerated, 15m), dataPartitionID\n| render timechart\n",
								"ControlType": "FrameControlChart",
								"PartTitle": "Memory Usage",
								"Dimensions": {
									"xAxis": {
										"name": "TimeGenerated",
										"type": "datetime"
									},
									"yAxis": [
										{
											"name": "MemoryUsage",
											"type": "real"
										}
									],
									"splitBy": [
										{
											"name": "PodName",
											"type": "string"
										}
									],
									"aggregation": "Sum"
								}
							}
						},
						"savedContainerState": {
							"partTitle": "Memory Usage",
							"assetName": "${centralGroupPrefix}-logs"
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
								"value": "let cloudRoleName= \"airflow-web\";\nKubePodInventory\n| where \"a\" == \"a\"\n| where ControllerName contains cloudRoleName\n| extend InstanceName = strcat(ClusterId, '/', ContainerName), ContainerName = strcat(ControllerName, '/', tostring(split(ContainerName, '/')[1])), PodName = Name\n| where PodStatus in ('Running')\n| where PodName contains cloudRoleName\n| where ContainerName endswith cloudRoleName\n| project Computer, InstanceName, ContainerName, PodName, PodStatus, TimeGenerated, Count = 1, cloudRoleName\n| summarize HostCount = avg(Count) by bin(TimeGenerated, 15m), cloudRoleName\n| render timechart;\n",
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
								"Query": "let cloudRoleName= \"airflow-scheduler\";\nKubePodInventory\n| where ControllerName contains cloudRoleName\n| extend InstanceName = strcat(ClusterId, '/', ContainerName), ContainerName = strcat(ControllerName, '/', tostring(split(ContainerName, '/')[1])), PodName = Name\n| where PodStatus in ('Running')\n| where PodName contains cloudRoleName\n| where ContainerName endswith cloudRoleName\n| project Computer, InstanceName, ContainerName, PodName, PodStatus, TimeGenerated, Count = 1\n| parse kind=regex PodName with partitionId \"-airflow-scheduler-[[:graph:]]\"\n| extend dataPartitionID = case(partitionId == \"\", \"sr\",\n                       partitionId)\n| summarize HostCount = avg(Count) by HostName = strcat(dataPartitionID, \"-\", cloudRoleName), bin(TimeGenerated, 15m), dataPartitionID\n| render timechart;\n\n",
								"PartTitle": "Healthy Host Count",
								"Dimensions": {
									"xAxis": {
										"name": "TimeGenerated",
										"type": "datetime"
									},
									"yAxis": [
										{
											"name": "HostCount",
											"type": "real"
										}
									],
									"splitBy": [
										{
											"name": "HostName",
											"type": "string"
										}
									],
									"aggregation": "Sum"
								}
							}
						},
						"savedContainerState": {
							"partTitle": "Healthy Host Count",
							"assetName": "${centralGroupPrefix}-logs"
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
								"value": "let capacityCounterName = 'cpuLimitNanoCores';\nlet usageCounterName = 'cpuUsageNanoCores';\nlet cloudRoleName= \"airflow-web\";\nKubePodInventory\n| where \"a\" == \"a\"\n| where ControllerName has cloudRoleName\n| extend InstanceName = strcat(ClusterId, '/', ContainerName), ContainerName = strcat(ControllerName, '/', tostring(split(ContainerName, '/')[1])), PodName = Name\n| where PodStatus in ('Running')\n| where PodName contains cloudRoleName\n| where ContainerName has cloudRoleName\n| distinct Computer, InstanceName, ContainerName, PodName\n| join\n    hint.strategy=shuffle (\n    Perf\n    | where ObjectName == 'K8SContainer'\n    | where CounterName == capacityCounterName\n    | summarize LimitValue = max(CounterValue) by Computer, InstanceName, bin(TimeGenerated, 15m)\n    | project Computer, InstanceName, LimitValue, limitA=100\n    )\n    on Computer, InstanceName\n| join kind=inner\n    hint.strategy=shuffle (\n    Perf\n    | where ObjectName == 'K8SContainer'\n    | where CounterName == usageCounterName\n    | project Computer, InstanceName, UsageValue = CounterValue, limit=100, TimeGenerated\n)\non Computer, InstanceName\n| project PodName, TimeGenerated, UsagePercent = UsageValue * 100.0 / LimitValue\n| summarize CPUPercentage=max(UsagePercent) by bin(TimeGenerated, 15m), PodName\n| render timechart\n",
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
								"Query": "let capacityCounterName = 'cpuLimitNanoCores';\nlet usageCounterName = 'cpuUsageNanoCores';\nlet cloudRoleName= \"airflow-worker\";\nKubePodInventory\n| where ControllerName has cloudRoleName\n| extend InstanceName = strcat(ClusterId, '/', ContainerName), ContainerName = strcat(ControllerName, '/', tostring(split(ContainerName, '/')[1])), PodName = Name\n| where PodStatus in ('Running')\n| where PodName contains cloudRoleName\n| where ContainerName endswith cloudRoleName\n| distinct Computer, InstanceName, ContainerName, PodName\n| join\n    hint.strategy=shuffle (\n    Perf\n    | where ObjectName == 'K8SContainer'\n    | where CounterName == capacityCounterName\n    | summarize LimitValue = max(CounterValue) by Computer, InstanceName, bin(TimeGenerated, 15m)\n    | project Computer, InstanceName, LimitValue, limitA=100\n    )\n    on Computer, InstanceName\n| join kind=inner\n    hint.strategy=shuffle (\n    Perf\n    | where ObjectName == 'K8SContainer'\n    | where CounterName == usageCounterName\n    | project Computer, InstanceName, UsageValue = CounterValue, limit=100, TimeGenerated\n)\non Computer, InstanceName\n| project PodName, TimeGenerated, UsagePercent = UsageValue * 100.0 / LimitValue\n| parse kind=regex PodName with partitionId \"-airflow-worker-[[:graph:]]\"\n| extend dataPartitionID = case(partitionId == \"\", \"sr\",\n                       partitionId)\n| summarize CPUPercentage=max(UsagePercent) by PodName, bin(TimeGenerated, 15m), dataPartitionID\n| render timechart\n",
								"PartTitle": "CPU Usage",
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
								}
							}
						},
						"savedContainerState": {
							"partTitle": "CPU Usage",
							"assetName": "${centralGroupPrefix}-logs"
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
								"value": "let capacityCounterName = 'memoryLimitBytes';\nlet usageCounterName = 'memoryRssBytes';\nlet cloudRoleName= \"airflow-web\";\nKubePodInventory\n| where \"a\" == \"a\"\n| where ControllerName contains cloudRoleName\n| extend InstanceName = strcat(ClusterId, '/', ContainerName), ContainerName = strcat(ControllerName, '/', tostring(split(ContainerName, '/')[1])), PodName = Name\n| where PodStatus in ('Running')\n| where PodName contains cloudRoleName\n| where ContainerName endswith cloudRoleName\n| distinct Computer, InstanceName, ContainerName, PodName\n| join\n    hint.strategy=shuffle (\n    Perf\n    | where ObjectName == 'K8SContainer'\n    | where CounterName == capacityCounterName\n    | summarize LimitValue = max(CounterValue) by Computer, InstanceName, bin(TimeGenerated, 15m)\n    | project Computer, InstanceName, LimitValue, limitA=100\n    )\n    on Computer, InstanceName\n| join kind=inner\n    hint.strategy=shuffle (\n    Perf\n    | where ObjectName == 'K8SContainer'\n    | where CounterName == usageCounterName\n    | project Computer, InstanceName, UsageValue = CounterValue, limit=100, TimeGenerated)\non Computer, InstanceName\n| project PodName, TimeGenerated, UsageValue, LimitValue\n| summarize MemoryUsage=max(UsageValue) by bin(TimeGenerated, 15m), PodName\n| render timechart\n\n",
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
								"Query": "let capacityCounterName = 'memoryLimitBytes';\nlet usageCounterName = 'memoryRssBytes';\nlet cloudRoleName= \"airflow-worker\";\nKubePodInventory\n| where ControllerName has cloudRoleName\n| extend InstanceName = strcat(ClusterId, '/', ContainerName), ContainerName = strcat(ControllerName, '/', tostring(split(ContainerName, '/')[1])), PodName = Name\n| where PodStatus in ('Running')\n| where PodName contains cloudRoleName\n| where ContainerName endswith cloudRoleName\n| distinct Computer, InstanceName, ContainerName, PodName\n| join\n    hint.strategy=shuffle (\n    Perf\n    | where ObjectName == 'K8SContainer'\n    | where CounterName == capacityCounterName\n    | summarize LimitValue = max(CounterValue) by Computer, InstanceName, bin(TimeGenerated, 15m)\n    | project Computer, InstanceName, LimitValue, limitA=100\n    )\n    on Computer, InstanceName\n| join kind=inner\n    hint.strategy=shuffle (\n    Perf\n    | where ObjectName == 'K8SContainer'\n    | where CounterName == usageCounterName\n    | project Computer, InstanceName, UsageValue = CounterValue, limit=100, TimeGenerated\n)\non Computer, InstanceName\n| project PodName, TimeGenerated, UsagePercent = UsageValue * 100.0 / LimitValue\n| parse kind=regex PodName with partitionId \"-airflow-worker-[[:graph:]]\"\n| extend dataPartitionID = case(partitionId == \"\", \"sr\",\n                       partitionId)\n| summarize MemoryUsage=max(UsagePercent) by PodName, bin(TimeGenerated, 15m), dataPartitionID\n| render timechart\n\n",
								"PartTitle": "Memory Usage",
								"Dimensions": {
									"xAxis": {
										"name": "TimeGenerated",
										"type": "datetime"
									},
									"yAxis": [
										{
											"name": "MemoryUsage",
											"type": "real"
										}
									],
									"splitBy": [
										{
											"name": "PodName",
											"type": "string"
										}
									],
									"aggregation": "Sum"
								}
							}
						},
						"savedContainerState": {
							"partTitle": "Memory Usage",
							"assetName": "${centralGroupPrefix}-logs"
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
								"value": "let cloudRoleName= \"airflow-web\";\nKubePodInventory\n| where \"a\" == \"a\"\n| where ControllerName contains cloudRoleName\n| extend InstanceName = strcat(ClusterId, '/', ContainerName), ContainerName = strcat(ControllerName, '/', tostring(split(ContainerName, '/')[1])), PodName = Name\n| where PodStatus in ('Running')\n| where PodName contains cloudRoleName\n| where ContainerName endswith cloudRoleName\n| project Computer, InstanceName, ContainerName, PodName, PodStatus, TimeGenerated, Count = 1, cloudRoleName\n| summarize HostCount = avg(Count) by bin(TimeGenerated, 15m), cloudRoleName\n| render timechart;\n",
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
								"Query": "let cloudRoleName= \"airflow-worker\";\nKubePodInventory\n| where ControllerName contains cloudRoleName\n| extend InstanceName = strcat(ClusterId, '/', ContainerName), ContainerName = strcat(ControllerName, '/', tostring(split(ContainerName, '/')[1])), PodName = Name\n| where PodStatus in ('Running')\n| where PodName contains cloudRoleName\n| where ContainerName endswith cloudRoleName\n| project Computer, InstanceName, ContainerName, PodName, PodStatus, TimeGenerated, Count = 1\n| parse kind=regex PodName with partitionId \"-airflow-worker-[[:graph:]]\"\n| extend dataPartitionID = case(partitionId == \"\", \"sr\",\n                       partitionId)\n| summarize HostCount = avg(Count) by HostName = strcat(dataPartitionID, \"-\", cloudRoleName), bin(TimeGenerated, 15m), dataPartitionID\n| render timechart;\n\n",
								"PartTitle": "Healthy Host Count",
								"Dimensions": {
									"xAxis": {
										"name": "TimeGenerated",
										"type": "datetime"
									},
									"yAxis": [
										{
											"name": "HostCount",
											"type": "real"
										}
									],
									"splitBy": [
										{
											"name": "HostName",
											"type": "string"
										}
									],
									"aggregation": "Sum"
								}
							}
						},
						"savedContainerState": {
							"partTitle": "Healthy Host Count",
							"assetName": "${centralGroupPrefix}-logs"
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
								"value": "KubePodInventory\n| where Name has \"airflow\"\n| parse kind=regex Name with partitionId \"-airflow-[[:graph:]]\"\n| extend dataPartitionID = case(partitionId == \"\", \"sr\",\n                       partitionId)\n| distinct dataPartitionID \n| extend dummy=1 \n| join kind=inner \n    (AzureMetrics\n    | where ResourceProvider == \"MICROSOFT.DBFORPOSTGRESQL\" \n    | parse kind=regex _ResourceId with @\"\\/subscriptions\\/([0-9a-zA-Z\\-])*\\/resourcegroups\\/([0-9a-zA-Z\\-])*\\/providers\\/microsoft\\.dbforpostgresql\\/servers\\/\" ResourceName @\"\\-pg\\z\" \n    | extend dummy=1) on dummy\n| where ResourceName contains dataPartitionID\n| project-away dummy, dummy1\n| where MetricName == \"active_connections\"\n| summarize ActiveConnections = avg(Average) by ResourceName, bin(TimeGenerated, 15m), MetricName, dataPartitionID\n| render timechart \n",
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
									"xAxis": {
										"name": "TimeGenerated",
										"type": "datetime"
									},
									"yAxis": [
										{
											"name": "ActiveConnections",
											"type": "real"
										}
									],
									"splitBy": [
										{
											"name": "ResourceName",
											"type": "string"
										}
									],
									"aggregation": "Sum"
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
								"Query": "KubePodInventory\n| where Name has \"airflow\"\n| parse kind=regex Name with partitionId \"-airflow-[[:graph:]]\"\n| extend dataPartitionID = case(partitionId == \"\", \"sr\",\n                       partitionId)\n| distinct dataPartitionID \n| extend dummy=1 \n| join kind=inner \n    (AzureMetrics\n    | where ResourceProvider == \"MICROSOFT.DBFORPOSTGRESQL\" \n    | parse kind=regex _ResourceId with @\"\\/subscriptions\\/([0-9a-zA-Z\\-])*\\/resourcegroups\\/([0-9a-zA-Z\\-])*\\/providers\\/microsoft\\.dbforpostgresql\\/servers\\/\" ResourceName\n    | extend dummy=1) on dummy\n| where ResourceName contains dataPartitionID\n| project-away dummy, dummy1\n| where MetricName == \"active_connections\"\n| summarize ActiveConnections = avg(Average) by ResourceName, bin(TimeGenerated, 15m), MetricName, dataPartitionID\n| render timechart \n\n",
								"PartTitle": "Average Active Connections"
							}
						},
						"savedContainerState": {
							"partTitle": "Average Active Connections",
							"assetName": "${centralGroupPrefix}-logs"
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
								"value": "KubePodInventory\n| where Name has \"airflow\"\n| parse kind=regex Name with partitionId \"-airflow-[[:graph:]]\"\n| extend dataPartitionID = case(partitionId == \"\", \"sr\",\n                       partitionId)\n| distinct dataPartitionID \n| extend dummy=1 \n| join kind=inner \n    (AzureMetrics\n    | where ResourceProvider == \"MICROSOFT.DBFORPOSTGRESQL\" \n    | parse kind=regex _ResourceId with @\"\\/subscriptions\\/([0-9a-zA-Z\\-])*\\/resourcegroups\\/([0-9a-zA-Z\\-])*\\/providers\\/microsoft\\.dbforpostgresql\\/servers\\/\" ResourceName @\"\\-pg\\z\" \n    | extend dummy=1) on dummy\n| where ResourceName contains dataPartitionID\n| project-away dummy, dummy1\n| where MetricName == \"cpu_percent\"\n| summarize CPUPercent = avg(Average) by ResourceName, bin(TimeGenerated, 15m), MetricName, dataPartitionID\n| render timechart \n",
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
									"xAxis": {
										"name": "TimeGenerated",
										"type": "datetime"
									},
									"yAxis": [
										{
											"name": "CPUPercent",
											"type": "real"
										}
									],
									"splitBy": [
										{
											"name": "ResourceName",
											"type": "string"
										}
									],
									"aggregation": "Sum"
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
								"Query": "KubePodInventory\n| where Name has \"airflow\"\n| parse kind=regex Name with partitionId \"-airflow-[[:graph:]]\"\n| extend dataPartitionID = case(partitionId == \"\", \"sr\",\n                       partitionId)\n| distinct dataPartitionID \n| extend dummy=1 \n| join kind=inner \n    (AzureMetrics\n    | where ResourceProvider == \"MICROSOFT.DBFORPOSTGRESQL\" \n    | parse kind=regex _ResourceId with @\"\\/subscriptions\\/([0-9a-zA-Z\\-])*\\/resourcegroups\\/([0-9a-zA-Z\\-])*\\/providers\\/microsoft\\.dbforpostgresql\\/servers\\/\" ResourceName\n    | extend dummy=1) on dummy\n| where ResourceName contains dataPartitionID\n| project-away dummy, dummy1\n| where MetricName == \"cpu_percent\"\n| summarize CPUPercent = avg(Average) by ResourceName, bin(TimeGenerated, 15m), MetricName, dataPartitionID\n| render timechart \n\n",
								"PartTitle": "CPU Usage"
							}
						},
						"savedContainerState": {
							"partTitle": "CPU Usage",
							"assetName": "${centralGroupPrefix}-logs"
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
								"value": "KubePodInventory\n| where Name has \"airflow\"\n| parse kind=regex Name with partitionId \"-airflow-[[:graph:]]\"\n| extend dataPartitionID = case(partitionId == \"\", \"sr\",\n                       partitionId)\n| distinct dataPartitionID \n| extend dummy=1 \n| join kind=inner \n    (AzureMetrics\n    | where ResourceProvider == \"MICROSOFT.DBFORPOSTGRESQL\" \n    | parse kind=regex _ResourceId with @\"\\/subscriptions\\/([0-9a-zA-Z\\-])*\\/resourcegroups\\/([0-9a-zA-Z\\-])*\\/providers\\/microsoft\\.dbforpostgresql\\/servers\\/\" ResourceName @\"\\-pg\\z\" \n    | extend dummy=1) on dummy\n| where ResourceName contains dataPartitionID\n| project-away dummy, dummy1\n| where MetricName == \"memory_percent\"\n| summarize MemoryPercent = avg(Average) by ResourceName, bin(TimeGenerated, 15m), MetricName, dataPartitionID\n| render timechart \n",
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
									"xAxis": {
										"name": "TimeGenerated",
										"type": "datetime"
									},
									"yAxis": [
										{
											"name": "MemoryPercent",
											"type": "real"
										}
									],
									"splitBy": [
										{
											"name": "ResourceName",
											"type": "string"
										}
									],
									"aggregation": "Sum"
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
								"Query": "KubePodInventory\n| where Name has \"airflow\"\n| parse kind=regex Name with partitionId \"-airflow-[[:graph:]]\"\n| extend dataPartitionID = case(partitionId == \"\", \"sr\",\n                       partitionId)\n| distinct dataPartitionID \n| extend dummy=1 \n| join kind=inner \n    (AzureMetrics\n    | where ResourceProvider == \"MICROSOFT.DBFORPOSTGRESQL\" \n    | parse kind=regex _ResourceId with @\"\\/subscriptions\\/([0-9a-zA-Z\\-])*\\/resourcegroups\\/([0-9a-zA-Z\\-])*\\/providers\\/microsoft\\.dbforpostgresql\\/servers\\/\" ResourceName \n    | extend dummy=1) on dummy\n| where ResourceName contains dataPartitionID\n| project-away dummy, dummy1\n| where MetricName == \"memory_percent\"\n| summarize MemoryPercent = avg(Average) by ResourceName, bin(TimeGenerated, 15m), MetricName, dataPartitionID\n| render timechart \n\n",
								"PartTitle": "Average Memory Percent"
							}
						},
						"savedContainerState": {
							"partTitle": "Average Memory Percent",
							"assetName": "${centralGroupPrefix}-logs"
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
								"value": "KubePodInventory\n| where Name has \"airflow\"\n| parse kind=regex Name with partitionId \"-airflow-[[:graph:]]\"\n| extend dataPartitionID = case(partitionId == \"\", \"sr\",\n                       partitionId)\n| distinct dataPartitionID \n| extend dummy=1 \n| join kind=inner \n    (AzureMetrics\n    | where ResourceProvider == \"MICROSOFT.DBFORPOSTGRESQL\" \n    | parse kind=regex _ResourceId with @\"\\/subscriptions\\/([0-9a-zA-Z\\-])*\\/resourcegroups\\/([0-9a-zA-Z\\-])*\\/providers\\/microsoft\\.dbforpostgresql\\/servers\\/\" ResourceName @\"\\-pg\\z\" \n    | extend dummy=1) on dummy\n| where ResourceName contains dataPartitionID\n| project-away dummy, dummy1\n| where MetricName == \"storage_percent\"\n| summarize StoragePercent = avg(Average) by ResourceName, bin(TimeGenerated, 15m), MetricName, dataPartitionID\n| render timechart \n",
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
									"xAxis": {
										"name": "TimeGenerated",
										"type": "datetime"
									},
									"yAxis": [
										{
											"name": "StoragePercent",
											"type": "real"
										}
									],
									"splitBy": [
										{
											"name": "ResourceName",
											"type": "string"
										}
									],
									"aggregation": "Sum"
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
								"Query": "KubePodInventory\n| where Name has \"airflow\"\n| parse kind=regex Name with partitionId \"-airflow-[[:graph:]]\"\n| extend dataPartitionID = case(partitionId == \"\", \"sr\",\n                       partitionId)\n| distinct dataPartitionID \n| extend dummy=1 \n| join kind=inner \n    (AzureMetrics\n    | where ResourceProvider == \"MICROSOFT.DBFORPOSTGRESQL\" \n    | parse kind=regex _ResourceId with @\"\\/subscriptions\\/([0-9a-zA-Z\\-])*\\/resourcegroups\\/([0-9a-zA-Z\\-])*\\/providers\\/microsoft\\.dbforpostgresql\\/servers\\/\" ResourceName\n    | extend dummy=1) on dummy\n| where ResourceName contains dataPartitionID\n| project-away dummy, dummy1\n| where MetricName == \"storage_percent\"\n| summarize StoragePercent = avg(Average) by ResourceName, bin(TimeGenerated, 15m), MetricName, dataPartitionID\n| render timechart \n\n",
								"PartTitle": "Average Storage Percent"
							}
						},
						"savedContainerState": {
							"partTitle": "Average Storage Percent",
							"assetName": "${centralGroupPrefix}-logs"
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
								"value": "KubePodInventory\n| where Name has \"airflow\"\n| parse kind=regex Name with partitionId \"-airflow-[[:graph:]]\"\n| extend dataPartitionID = case(partitionId == \"\", \"sr\",\n                       partitionId)\n| distinct dataPartitionID \n| extend dummy=1 \n| join kind=inner \n    (AzureMetrics\n    | where ResourceProvider == \"MICROSOFT.CACHE\" \n    | parse kind=regex _ResourceId with @\"\\/subscriptions\\/([0-9a-zA-Z\\-])*\\/resourcegroups\\/([0-9a-zA-Z\\-])*\\/providers\\/microsoft\\.cache\\/redis\\/\" ResourceName\n    | extend dummy=1) on dummy\n| where ResourceName contains dataPartitionID\n| project-away dummy, dummy1\n| where MetricName == \"percentProcessorTime\"\n| summarize CPUPercent = avg(Average) by ResourceName, bin(TimeGenerated, 15m), MetricName, dataPartitionID\n| render timechart \n",
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
									"xAxis": {
										"name": "TimeGenerated",
										"type": "datetime"
									},
									"yAxis": [
										{
											"name": "CPUPercent",
											"type": "real"
										}
									],
									"splitBy": [
										{
											"name": "ResourceName",
											"type": "string"
										}
									],
									"aggregation": "Sum"
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
						"settings": {},
						"savedContainerState": {
							"partTitle": "Analytics",
							"assetName": "${centralGroupPrefix}-logs"
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
								"value": "KubePodInventory\n| where Name has \"airflow\"\n| parse kind=regex Name with partitionId \"-airflow-[[:graph:]]\"\n| extend dataPartitionID = case(partitionId == \"\", \"sr\",\n                       partitionId)\n| distinct dataPartitionID \n| extend dummy=1 \n| join kind=inner \n    (AzureMetrics\n    | where ResourceProvider == \"MICROSOFT.CACHE\" \n    | parse kind=regex _ResourceId with @\"\\/subscriptions\\/([0-9a-zA-Z\\-])*\\/resourcegroups\\/([0-9a-zA-Z\\-])*\\/providers\\/microsoft\\.cache\\/redis\\/\" ResourceName\n    | extend dummy=1) on dummy\n| where ResourceName contains dataPartitionID\n| project-away dummy, dummy1\n| where MetricName == \"connectedclients\"\n| summarize ConnectedClients = avg(Average) by ResourceName, bin(TimeGenerated, 15m), MetricName, dataPartitionID\n| render timechart \n",
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
									"xAxis": {
										"name": "TimeGenerated",
										"type": "datetime"
									},
									"yAxis": [
										{
											"name": "ConnectedClients",
											"type": "real"
										}
									],
									"splitBy": [
										{
											"name": "ResourceName",
											"type": "string"
										}
									],
									"aggregation": "Sum"
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
						"settings": {},
						"savedContainerState": {
							"partTitle": "Analytics",
							"assetName": "${centralGroupPrefix}-logs"
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
								"value": "KubePodInventory\n| where Name has \"airflow\"\n| parse kind=regex Name with partitionId \"-airflow-[[:graph:]]\"\n| extend dataPartitionID = case(partitionId == \"\", \"sr\",\n                       partitionId)\n| distinct dataPartitionID \n| extend dummy=1 \n| join kind=inner \n    (AzureMetrics\n    | where ResourceProvider == \"MICROSOFT.CACHE\" \n    | parse kind=regex _ResourceId with @\"\\/subscriptions\\/([0-9a-zA-Z\\-])*\\/resourcegroups\\/([0-9a-zA-Z\\-])*\\/providers\\/microsoft\\.cache\\/redis\\/\" ResourceName\n    | extend dummy=1) on dummy\n| where ResourceName contains dataPartitionID\n| project-away dummy, dummy1\n| where MetricName == \"connectedclients\"\n| summarize ConnectedClients = avg(Average) by ResourceName, bin(TimeGenerated, 15m), MetricName, dataPartitionID\n| render timechart \n",
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
									"xAxis": {
										"name": "TimeGenerated",
										"type": "datetime"
									},
									"yAxis": [
										{
											"name": "ConnectedClients",
											"type": "real"
										}
									],
									"splitBy": [
										{
											"name": "ResourceName",
											"type": "string"
										}
									],
									"aggregation": "Sum"
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
						"settings": {},
						"savedContainerState": {
							"partTitle": "Analytics",
							"assetName": "${centralGroupPrefix}-logs"
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
							"StartboardPart-LogsDashboardPart-1cdcbb91-41ea-49dd-bdaa-c1786d47fe5e",
							"StartboardPart-LogsDashboardPart-1cdcbb91-41ea-49dd-bdaa-c1786d47fe60",
							"StartboardPart-LogsDashboardPart-1cdcbb91-41ea-49dd-bdaa-c1786d47fe62",
							"StartboardPart-LogsDashboardPart-1cdcbb91-41ea-49dd-bdaa-c1786d47fe66",
							"StartboardPart-LogsDashboardPart-1cdcbb91-41ea-49dd-bdaa-c1786d47fe68",
							"StartboardPart-LogsDashboardPart-1cdcbb91-41ea-49dd-bdaa-c1786d47fe6a",
							"StartboardPart-LogsDashboardPart-1cdcbb91-41ea-49dd-bdaa-c1786d47fe6e",
							"StartboardPart-LogsDashboardPart-1cdcbb91-41ea-49dd-bdaa-c1786d47fe70",
							"StartboardPart-LogsDashboardPart-1cdcbb91-41ea-49dd-bdaa-c1786d47fe72",
							"StartboardPart-LogsDashboardPart-1cdcbb91-41ea-49dd-bdaa-c1786d47fe76",
							"StartboardPart-LogsDashboardPart-1cdcbb91-41ea-49dd-bdaa-c1786d47fe78",
							"StartboardPart-LogsDashboardPart-1cdcbb91-41ea-49dd-bdaa-c1786d47fe7a",
							"StartboardPart-LogsDashboardPart-1cdcbb91-41ea-49dd-bdaa-c1786d47fe7c",
							"StartboardPart-LogsDashboardPart-1cdcbb91-41ea-49dd-bdaa-c1786d47fe80",
							"StartboardPart-LogsDashboardPart-1cdcbb91-41ea-49dd-bdaa-c1786d47fe82",
							"StartboardPart-LogsDashboardPart-1cdcbb91-41ea-49dd-bdaa-c1786d47fe84"
						]
					},
					"dynamicFilter_dataPartitionID": {
						"model": {
							"operator": "equals",
							"values": []
						},
						"displayCache": {
							"name": "dataPartitionID",
							"value": "none"
						},
						"filteredPartIds": [
							"StartboardPart-LogsDashboardPart-1cdcbb91-41ea-49dd-bdaa-c1786d47fe5e",
							"StartboardPart-LogsDashboardPart-1cdcbb91-41ea-49dd-bdaa-c1786d47fe60",
							"StartboardPart-LogsDashboardPart-1cdcbb91-41ea-49dd-bdaa-c1786d47fe62",
							"StartboardPart-LogsDashboardPart-1cdcbb91-41ea-49dd-bdaa-c1786d47fe66",
							"StartboardPart-LogsDashboardPart-1cdcbb91-41ea-49dd-bdaa-c1786d47fe68",
							"StartboardPart-LogsDashboardPart-1cdcbb91-41ea-49dd-bdaa-c1786d47fe6a",
							"StartboardPart-LogsDashboardPart-1cdcbb91-41ea-49dd-bdaa-c1786d47fe6e",
							"StartboardPart-LogsDashboardPart-1cdcbb91-41ea-49dd-bdaa-c1786d47fe70",
							"StartboardPart-LogsDashboardPart-1cdcbb91-41ea-49dd-bdaa-c1786d47fe72",
							"StartboardPart-LogsDashboardPart-1cdcbb91-41ea-49dd-bdaa-c1786d47fe76",
							"StartboardPart-LogsDashboardPart-1cdcbb91-41ea-49dd-bdaa-c1786d47fe78",
							"StartboardPart-LogsDashboardPart-1cdcbb91-41ea-49dd-bdaa-c1786d47fe7a",
							"StartboardPart-LogsDashboardPart-1cdcbb91-41ea-49dd-bdaa-c1786d47fe7c",
							"StartboardPart-LogsDashboardPart-1cdcbb91-41ea-49dd-bdaa-c1786d47fe80",
							"StartboardPart-LogsDashboardPart-1cdcbb91-41ea-49dd-bdaa-c1786d47fe82",
							"StartboardPart-LogsDashboardPart-1cdcbb91-41ea-49dd-bdaa-c1786d47fe84"
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
							"StartboardPart-LogsDashboardPart-1cdcbb91-41ea-49dd-bdaa-c1786d47fe5e",
							"StartboardPart-LogsDashboardPart-1cdcbb91-41ea-49dd-bdaa-c1786d47fe60",
							"StartboardPart-LogsDashboardPart-1cdcbb91-41ea-49dd-bdaa-c1786d47fe66",
							"StartboardPart-LogsDashboardPart-1cdcbb91-41ea-49dd-bdaa-c1786d47fe68",
							"StartboardPart-LogsDashboardPart-1cdcbb91-41ea-49dd-bdaa-c1786d47fe6e",
							"StartboardPart-LogsDashboardPart-1cdcbb91-41ea-49dd-bdaa-c1786d47fe70"
						]
					}
				}
			}
		}
	}
}