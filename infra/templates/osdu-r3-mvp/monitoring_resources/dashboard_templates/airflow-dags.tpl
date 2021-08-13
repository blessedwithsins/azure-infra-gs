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
									"content": "# Airflow Dag Metrics",
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
										"/subscriptions/${subscriptionId}/resourceGroups/${centralGroupPrefix}-rg/providers/Microsoft.Insights/components/${centralGroupPrefix}-ai"
									]
								},
								"isOptional": true
							},
							{
								"name": "PartId",
								"value": "77de7db0-d225-4038-b41b-6b8205f7580b",
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
								"value": "customMetrics\n| where name has \"dag_processing.last_runtime\" \n| parse kind=regex name with @\"([0-9a-zA-Z_])*\\.\" clusterName @\"\\.dag_processing\\.last_runtime\\.([0-9a-zA-Z_])*\"\n| parse kind=regex name with @\"([0-9a-zA-Z_\\.])*\\.dag_processing\\.last_runtime\\.\" dagName\n| summarize DagProcessingTime = max(value) by timestamp, MetricName = \"dag_processing.last_runtime\", clusterName, dagName\n| render timechart \n",
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
								"value": "${centralGroupPrefix}-ai",
								"isOptional": true
							},
							{
								"name": "Dimensions",
								"value": {
									"aggregation": "Sum",
									"splitBy": [
										{
											"name": "MetricName",
											"type": "string"
										}
									],
									"xAxis": {
										"name": "timestamp",
										"type": "datetime"
									},
									"yAxis": [
										{
											"name": "DagProcessingTime",
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
											"name": "dagName",
											"type": "string"
										}
									],
									"xAxis": {
										"name": "timestamp",
										"type": "datetime"
									},
									"yAxis": [
										{
											"name": "DagProcessingTime",
											"type": "real"
										}
									]
								},
								"PartTitle": "Time taken for processing Dag File",
								"Query": "customMetrics\n| where name has \"dag_processing.last_runtime\" \n| parse kind=regex name with @\"([0-9a-zA-Z_])*\\.\" partitionId @\"\\.dag_processing\\.last_runtime\\.([0-9a-zA-Z_])*\"\n| extend clusterName = case(partitionId == \"\", \"common-cluster\",\n                       partitionId)\n| parse kind=regex name with @\"([0-9a-zA-Z_\\.])*\\.dag_processing\\.last_runtime\\.\" dagName\n| summarize DagProcessingTime = max(value) by timestamp, dagName, MetricName = \"dag_processing.last_runtime\", clusterName\n| render timechart \n\n"
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
										"/subscriptions/${subscriptionId}/resourceGroups/${centralGroupPrefix}-rg/providers/Microsoft.Insights/components/${centralGroupPrefix}-ai"
									]
								},
								"isOptional": true
							},
							{
								"name": "PartId",
								"value": "13e92e86-126b-4648-a561-3acffe5b1598",
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
								"value": "customMetrics\n| where name has \"dagrun.duration.success\" or name has \"dagrun.duration.failed\"\n| parse kind=regex name with @\"([0-9a-zA-Z_])*\\.\" clusterName @\"\\.dagrun\\.duration\\.([0-9a-zA-Z_\\.])*\"\n| parse kind=regex name with @\"([0-9a-zA-Z_])*\\.dagrun\\.duration\\.([0-9a-zA-Z_])*\\.\" dagName\n| extend duration = value/1000\n| summarize DagrunTime = max(duration) by timestamp, MetricName = \"dagrun.duration\", clusterName, dagName\n| render timechart \n\n",
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
								"value": "${centralGroupPrefix}-ai",
								"isOptional": true
							},
							{
								"name": "Dimensions",
								"value": {
									"aggregation": "Sum",
									"splitBy": [
										{
											"name": "MetricName",
											"type": "string"
										}
									],
									"xAxis": {
										"name": "timestamp",
										"type": "datetime"
									},
									"yAxis": [
										{
											"name": "DagrunTime",
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
								"Query": "customMetrics\n| where name has \"dagrun.duration.success\" or name has \"dagrun.duration.failed\"\n| parse kind=regex name with @\"([0-9a-zA-Z_])*\\.\" partitionId @\"\\.dagrun\\.duration\\.([0-9a-zA-Z_\\.])*\"\n| extend clusterName = case(partitionId == \"\", \"common-cluster\",\n                       partitionId)\n| parse kind=regex name with @\"([0-9a-zA-Z_])*\\.dagrun\\.duration\\.([0-9a-zA-Z_])*\\.\" dagName\n| extend duration = value/1000\n| summarize DagrunTime = max(duration) by timestamp, dagName, MetricName = \"dagrun.duration\", clusterName\n| render columnchart  \n\n",
								"ControlType": "FrameControlChart",
								"SpecificChart": "StackedColumn",
								"PartTitle": "Dagrun Duration",
								"Dimensions": {
									"aggregation": "Sum",
									"splitBy": [
										{
											"name": "dagName",
											"type": "string"
										}
									],
									"xAxis": {
										"name": "timestamp",
										"type": "datetime"
									},
									"yAxis": [
										{
											"name": "DagrunTime",
											"type": "real"
										}
									]
								}
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
										"/subscriptions/${subscriptionId}/resourceGroups/${centralGroupPrefix}-rg/providers/Microsoft.Insights/components/${centralGroupPrefix}-ai"
									]
								},
								"isOptional": true
							},
							{
								"name": "PartId",
								"value": "41c138fd-205d-48f3-977f-aa89cd135d1a",
								"isOptional": true
							},
							{
								"name": "Version",
								"value": "2.0",
								"isOptional": true
							},
							{
								"name": "TimeRange",
								"value": "P2D",
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
								"value": "customMetrics\n| where name matches regex @\"dag\\.([0-9a-zA-Z_])*\\.([0-9a-zA-Z_])*\\.duration\\z\" \n| parse kind=regex name with @\"([0-9a-zA-Z_])*\\.\" clusterName @\"\\.dag\\.([0-9a-zA-Z_\\.])*\\.duration\"\n| parse kind=regex name with @\"([0-9a-zA-Z_])*\\.dag\\.\" dagIdTaskId @\"\\.duration\"\n| extend duration = value/1000, dagName = split(dagIdTaskId,\".\")[0]\n| summarize TaskRunDuration = max(duration) by timestamp, MetricName = \"TaskRun Duration\", tostring(dagName), clusterName\n| render timechart \n\n",
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
								"value": "${centralGroupPrefix}-ai",
								"isOptional": true
							},
							{
								"name": "Dimensions",
								"value": {
									"aggregation": "Sum",
									"splitBy": [
										{
											"name": "MetricName",
											"type": "string"
										}
									],
									"xAxis": {
										"name": "timestamp",
										"type": "datetime"
									},
									"yAxis": [
										{
											"name": "TaskRunDuration",
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
								"Query": "customMetrics\n| where name matches regex @\"dag\\.([0-9a-zA-Z_])*\\.([0-9a-zA-Z_])*\\.duration\\z\" \n| parse kind=regex name with @\"([0-9a-zA-Z_])*\\.\" partitionId @\"\\.dag\\.([0-9a-zA-Z_\\.])*\\.duration\"\n| extend clusterName = case(partitionId == \"\", \"common-cluster\",\n                       partitionId)\n| parse kind=regex name with @\"([0-9a-zA-Z_])*\\.dag\\.\" dagIdTaskId @\"\\.duration\"\n| extend duration = value\n| summarize TaskRunDuration = max(duration) by timestamp, taskId = tostring(dagIdTaskId), clusterName, MetricName = \"TaskRun Duration\"\n| render columnchart  \n\n",
								"ControlType": "FrameControlChart",
								"SpecificChart": "StackedColumn",
								"PartTitle": "TaskRun Duration",
								"Dimensions": {
									"aggregation": "Sum",
									"splitBy": [
										{
											"name": "taskId",
											"type": "string"
										}
									],
									"xAxis": {
										"name": "timestamp",
										"type": "datetime"
									},
									"yAxis": [
										{
											"name": "TaskRunDuration",
											"type": "real"
										}
									]
								}
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
							"StartboardPart-LogsDashboardPart-71118fe6-96f2-4bfe-bdff-41dde9ad700a",
							"StartboardPart-LogsDashboardPart-71118fe6-96f2-4bfe-bdff-41dde9ad700c",
							"StartboardPart-LogsDashboardPart-71118fe6-96f2-4bfe-bdff-41dde9ad700e"
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
							"StartboardPart-LogsDashboardPart-c875862f-6b48-4cb6-bc31-930249a611f2",
							"StartboardPart-LogsDashboardPart-c875862f-6b48-4cb6-bc31-930249a611f4",
							"StartboardPart-LogsDashboardPart-c875862f-6b48-4cb6-bc31-930249a611f6"
						]
					},
					"dynamicFilter_dagName": {
						"model": {
							"operator": "equals",
							"values": []
						},
						"displayCache": {
							"name": "dagName",
							"value": "none"
						},
						"filteredPartIds": [
							"StartboardPart-LogsDashboardPart-c875862f-6b48-4cb6-bc31-930249a611f2",
							"StartboardPart-LogsDashboardPart-c875862f-6b48-4cb6-bc31-930249a611f4"
						]
					},
					"dynamicFilter_taskId": {
						"model": {
							"operator": "equals",
							"values": []
						},
						"displayCache": {
							"name": "taskId",
							"value": "none"
						},
						"filteredPartIds": [
							"StartboardPart-LogsDashboardPart-c875862f-6b48-4cb6-bc31-930249a611f6"
						]
					}
				}
			}
		}
	}
}