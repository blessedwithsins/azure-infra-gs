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
                  "value": "123039cc-0534-41e5-b621-e5770e131880",
                  "isOptional": true
                },
                {
                  "name": "Version",
                  "value": "2.0",
                  "isOptional": true
                },
                {
                  "name": "TimeRange",
                  "value": "P7D",
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
                  "value": "let ContainerIdList = KubePodInventory\n| where Name has \"airflow-web\"\n| where strlen(ContainerID)>0\n| distinct ContainerID, PodLabel, Namespace, PodIp, Name;\nContainerLog\n| where ContainerID in (ContainerIdList)\n| where LogEntry contains \"HTTP/1.1\" and LogEntry !contains \"/airflow/health\"\n| lookup kind=leftouter (ContainerIdList) on ContainerID\n| project-away Image, ImageTag, Repository, Name, TimeOfCommand\n| project-rename PodName=Name1\n| parse kind=regex PodName with clusterName \"-airflow-web-[[:graph:]]\"  \n| parse kind=regex LogEntry with '[[:graph:]] HTTP/1.1\" ' values\n| extend status = toint(split(values, \" \")[0]), timeTaken = toint(split(values, \" \")[1])\n| extend HTTPStatus = case(status between (200 .. 299), \"2XX\",\n                       status between (300 .. 399), \"3XX\",\n                       status between (400 .. 499), \"4XX\",\n                       status between (500 .. 599), \"5XX\",\n                       \"XX\")\n| where HTTPStatus == \"4XX\"\n| summarize ErrorCount = count() by clusterName, bin(TimeGenerated, 1m), HTTPStatus\n| render timechart\n\n",
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
                        "name": "clusterName",
                        "type": "string"
                      }
                    ],
                    "xAxis": {
                      "name": "TimeGenerated",
                      "type": "datetime"
                    },
                    "yAxis": [
                      {
                        "name": "count_",
                        "type": "long"
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
                  "Query": "let ContainerIdList = KubePodInventory\n| where Name has \"airflow-web\"\n| where strlen(ContainerID)>0\n| distinct ContainerID, PodLabel, Namespace, PodIp, Name;\nContainerLog\n| where ContainerID in (ContainerIdList)\n| where LogEntry contains \"HTTP/1.1\" and LogEntry !contains \"/airflow/health\"\n| lookup kind=leftouter (ContainerIdList) on ContainerID\n| project-away Image, ImageTag, Repository, Name, TimeOfCommand\n| project-rename PodName=Name1\n| parse kind=regex PodName with partitionId \"-airflow-web-[[:graph:]]\"\n| extend clusterName = case(partitionId == \"\", \"common-cluster\",\n                       partitionId)\n| parse kind=regex LogEntry with '[[:graph:]] HTTP/1.1\" ' values\n| extend status = toint(split(values, \" \")[0]), timeTaken = toint(split(values, \" \")[1])\n| extend HTTPStatus = case(status between (200 .. 299), \"2XX\",\n                       status between (300 .. 399), \"3XX\",\n                       status between (400 .. 499), \"4XX\",\n                       status between (500 .. 599), \"5XX\",\n                       \"XX\")\n| where HTTPStatus == \"4XX\"\n| summarize ErrorCount = count() by clusterName, bin(TimeGenerated, 1m), HTTPStatus\n| render timechart\n\n",
                  "ControlType": "FrameControlChart",
                  "PartTitle": "Number of 4XX Errors",
                  "Dimensions": {
                    "xAxis": {
                      "name": "TimeGenerated",
                      "type": "datetime"
                    },
                    "yAxis": [
                      {
                        "name": "ErrorCount",
                        "type": "long"
                      }
                    ],
                    "splitBy": [
                      {
                        "name": "clusterName",
                        "type": "string"
                      }
                    ],
                    "aggregation": "Sum"
                  }
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
                  "value": "16412735-8591-4697-968c-8879615855fb",
                  "isOptional": true
                },
                {
                  "name": "Version",
                  "value": "2.0",
                  "isOptional": true
                },
                {
                  "name": "TimeRange",
                  "value": "2021-05-14T13:40:09.000Z/2021-06-14T13:40:09.030Z",
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
                  "value": "let ContainerIdList = KubePodInventory\n| where Name has \"airflow-web\"\n| where strlen(ContainerID)>0\n| distinct ContainerID, PodLabel, Namespace, PodIp, Name;\nContainerLog\n| where ContainerID in (ContainerIdList)\n| where LogEntry contains \"HTTP/1.1\" and LogEntry !contains \"/airflow/health\"\n| lookup kind=leftouter (ContainerIdList) on ContainerID\n| project-away Image, ImageTag, Repository, Name, TimeOfCommand\n| project-rename PodName=Name1\n| parse kind=regex PodName with clusterName \"-airflow-web-[[:graph:]]\"  \n| parse kind=regex LogEntry with '[[:graph:]] HTTP/1.1\" ' values\n| extend status = toint(split(values, \" \")[0]), timeTaken = toint(split(values, \" \")[1])\n| extend HTTPStatus = case(status between (200 .. 299), \"2XX\",\n                       status between (300 .. 399), \"3XX\",\n                       status between (400 .. 499), \"4XX\",\n                       status between (500 .. 599), \"5XX\",\n                       \"XX\")\n| where HTTPStatus == \"5XX\"\n| summarize ErrorCount = count() by clusterName, bin(TimeGenerated, 1m), HTTPStatus\n| render timechart\n\n",
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
                        "name": "clusterName",
                        "type": "string"
                      }
                    ],
                    "xAxis": {
                      "name": "TimeGenerated",
                      "type": "datetime"
                    },
                    "yAxis": [
                      {
                        "name": "count_",
                        "type": "long"
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
                  "Query": "let ContainerIdList = KubePodInventory\n| where Name has \"airflow-web\"\n| where strlen(ContainerID)>0\n| distinct ContainerID, PodLabel, Namespace, PodIp, Name;\nContainerLog\n| where ContainerID in (ContainerIdList)\n| where LogEntry contains \"HTTP/1.1\" and LogEntry !contains \"/airflow/health\"\n| lookup kind=leftouter (ContainerIdList) on ContainerID\n| project-away Image, ImageTag, Repository, Name, TimeOfCommand\n| project-rename PodName=Name1\n| parse kind=regex PodName with partitionId \"-airflow-web-[[:graph:]]\"\n| extend clusterName = case(partitionId == \"\", \"common-cluster\",\n                       partitionId)\n| parse kind=regex LogEntry with '[[:graph:]] HTTP/1.1\" ' values\n| extend status = toint(split(values, \" \")[0]), timeTaken = toint(split(values, \" \")[1])\n| extend HTTPStatus = case(status between (200 .. 299), \"2XX\",\n                       status between (300 .. 399), \"3XX\",\n                       status between (400 .. 499), \"4XX\",\n                       status between (500 .. 599), \"5XX\",\n                       \"XX\")\n| where HTTPStatus == \"5XX\"\n| summarize ErrorCount = count() by clusterName, bin(TimeGenerated, 1m), HTTPStatus\n| render timechart\n\n",
                  "PartTitle": "Number of 5XX Errors",
                  "Dimensions": {
                    "xAxis": {
                      "name": "TimeGenerated",
                      "type": "datetime"
                    },
                    "yAxis": [
                      {
                        "name": "ErrorCount",
                        "type": "long"
                      }
                    ],
                    "splitBy": [
                      {
                        "name": "clusterName",
                        "type": "string"
                      }
                    ],
                    "aggregation": "Sum"
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
                      "/subscriptions/${subscriptionId}/resourceGroups/${centralGroupPrefix}-rg/providers/Microsoft.OperationalInsights/workspaces/${centralGroupPrefix}-logs"
                    ]
                  },
                  "isOptional": true
                },
                {
                  "name": "PartId",
                  "value": "0f68060e-5074-401e-b107-e925c31416fb",
                  "isOptional": true
                },
                {
                  "name": "Version",
                  "value": "2.0",
                  "isOptional": true
                },
                {
                  "name": "TimeRange",
                  "value": "2021-05-14T12:22:33.000Z/2021-06-14T12:22:33.439Z",
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
                  "value": "let apiCall = \"POST /airflow/api/experimental/dags\";\nlet ContainerIdList = KubePodInventory\n| where Name has \"airflow-web\"\n| where strlen(ContainerID)>0\n| distinct ContainerID, PodLabel, Namespace, PodIp, Name;\nContainerLog\n| where ContainerID in (ContainerIdList)\n| where LogEntry contains \"HTTP/1.1\" and LogEntry contains apiCall \n| lookup kind=leftouter (ContainerIdList) on ContainerID\n| project-away Image, ImageTag, Repository, Name, TimeOfCommand\n| project-rename PodName=Name1\n| parse kind=regex PodName with clusterName \"-airflow-web-[[:graph:]]\"  \n| parse kind=regex LogEntry with '[[:graph:]] HTTP/1.1\" ' values\n| extend timeTaken = toint(split(values, \" \")[1])\n| summarize TimeTaken = max(timeTaken) by clusterName, apiCall, TimeGenerated\n| render timechart\t\n\n",
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
                        "name": "Column1",
                        "type": "string"
                      }
                    ],
                    "xAxis": {
                      "name": "TimeGenerated",
                      "type": "datetime"
                    },
                    "yAxis": [
                      {
                        "name": "TimeTaken",
                        "type": "int"
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
                  "Query": "let apiCall = \"POST /airflow/api/experimental/dags\";\nlet ContainerIdList = KubePodInventory\n| where Name has \"airflow-web\"\n| where strlen(ContainerID)>0\n| distinct ContainerID, PodLabel, Namespace, PodIp, Name;\nContainerLog\n| where ContainerID in (ContainerIdList)\n| where LogEntry contains \"HTTP/1.1\" and LogEntry contains apiCall \n| lookup kind=leftouter (ContainerIdList) on ContainerID\n| project-away Image, ImageTag, Repository, Name, TimeOfCommand\n| project-rename PodName=Name1\n| parse kind=regex PodName with partitionId \"-airflow-web-[[:graph:]]\"\n| extend clusterName = case(partitionId == \"\", \"common-cluster\",\n                       partitionId)\n| parse kind=regex LogEntry with '[[:graph:]] HTTP/1.1\" ' values\n| extend timeTaken = toint(split(values, \" \")[1])\n| summarize TimeTaken = max(timeTaken) by clusterName, apiCall, TimeGenerated\n| render timechart\t\n\n",
                  "PartTitle": "Latency of Trigger API",
                  "Dimensions": {
                    "xAxis": {
                      "name": "TimeGenerated",
                      "type": "datetime"
                    },
                    "yAxis": [
                      {
                        "name": "TimeTaken",
                        "type": "int"
                      }
                    ],
                    "splitBy": [
                      {
                        "name": "clusterName",
                        "type": "string"
                      }
                    ],
                    "aggregation": "Sum"
                  }
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
                      "/subscriptions/${subscriptionId}/resourceGroups/${centralGroupPrefix}-rg/providers/Microsoft.Insights/components/${centralGroupPrefix}-ai"
                    ]
                  },
                  "isOptional": true
                },
                {
                  "name": "PartId",
                  "value": "7f68583e-046e-4978-a205-ae0e3e124757",
                  "isOptional": true
                },
                {
                  "name": "Version",
                  "value": "2.0",
                  "isOptional": true
                },
                {
                  "name": "TimeRange",
                  "value": "2021-05-23T14:22:18.000Z/2021-05-25T14:22:18.000Z",
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
                  "value": "customMetrics\n| where name has \"ti_failures\"\n| parse kind=regex name with \"([0-9a-zA-Z_])*.\" clusterName \".ti_failures\" \n| summarize DagBagSize = max(value) by timestamp, clusterName\n| render timechart \n",
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
                        "name": "clusterName",
                        "type": "string"
                      }
                    ],
                    "xAxis": {
                      "name": "timestamp",
                      "type": "datetime"
                    },
                    "yAxis": [
                      {
                        "name": "DagBagSize",
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
                        "name": "TaskInstanceFailures",
                        "type": "real"
                      }
                    ]
                  },
                  "PartTitle": "Total Task Failures",
                  "Query": "customMetrics\n| where name has \"ti_failures\"\n| parse kind=regex name with @\"([0-9a-zA-Z_])*\\.\" partitionId @\"\\.ti_failures\" \n| extend clusterName = case(partitionId == \"\", \"common-cluster\",\n                       partitionId)\n| summarize TaskInstanceFailures = max(value) by timestamp, clusterName, MetricName=\"TaskInstance Failures\"\n| render timechart \n\n"
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
                      "/subscriptions/${subscriptionId}/resourceGroups/${centralGroupPrefix}-rg/providers/Microsoft.Insights/components/${centralGroupPrefix}-ai"
                    ]
                  },
                  "isOptional": true
                },
                {
                  "name": "PartId",
                  "value": "979f2f4e-4354-4d8e-a510-df7a07535898",
                  "isOptional": true
                },
                {
                  "name": "Version",
                  "value": "2.0",
                  "isOptional": true
                },
                {
                  "name": "TimeRange",
                  "value": "2021-05-23T14:22:18.000Z/2021-05-25T14:22:18.000Z",
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
                  "value": "customMetrics\n| where name has \"dagbag_size\"\n| parse kind=regex name with \"([0-9a-zA-Z_])*.\" clusterName \".dagbag_size\" \n| summarize DagBagSize = max(value) by timestamp, clusterName\n| render timechart \n",
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
                        "name": "clusterName",
                        "type": "string"
                      }
                    ],
                    "xAxis": {
                      "name": "timestamp",
                      "type": "datetime"
                    },
                    "yAxis": [
                      {
                        "name": "DagBagSize",
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
                  "Query": "customMetrics\n| where name has \"dagbag_size\"\n| parse kind=regex name with @\"([0-9a-zA-Z_])*\\.\" partitionId @\"\\.dagbag_size\" \n| extend clusterName = case(partitionId == \"\", \"common-cluster\",\n                       partitionId)\n| summarize DagBagSize = max(value) by timestamp, clusterName, MetricName = \"dagbag_size\"\n| render timechart \n\n",
                  "PartTitle": "DagBag Size",
                  "Dimensions": {
                    "xAxis": {
                      "name": "timestamp",
                      "type": "datetime"
                    },
                    "yAxis": [
                      {
                        "name": "DagBagSize",
                        "type": "real"
                      }
                    ],
                    "splitBy": [
                      {
                        "name": "clusterName",
                        "type": "string"
                      }
                    ],
                    "aggregation": "Sum"
                  }
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
                      "/subscriptions/${subscriptionId}/resourceGroups/${centralGroupPrefix}-rg/providers/Microsoft.Insights/components/${centralGroupPrefix}-ai"
                    ]
                  },
                  "isOptional": true
                },
                {
                  "name": "PartId",
                  "value": "49bb92bc-100e-4797-a013-66d54af0d117",
                  "isOptional": true
                },
                {
                  "name": "Version",
                  "value": "2.0",
                  "isOptional": true
                },
                {
                  "name": "TimeRange",
                  "value": "2021-05-23T14:22:18.000Z/2021-05-25T14:22:18.000Z",
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
                  "value": "customMetrics\n| where name has \"dag_processing.import_errors\"\n| parse kind=regex name with \"([0-9a-zA-Z_])*.\" clusterName \".dag_processing.import_errors\" \n| summarize DagBagSize = max(value) by timestamp, clusterName\n| render timechart \n",
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
                    "splitBy": [],
                    "xAxis": {
                      "name": "timestamp",
                      "type": "datetime"
                    },
                    "yAxis": [
                      {
                        "name": "DagBagSize",
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
                  "Query": "customMetrics\n| where name has \"dag_processing.import_errors\"\n| parse kind=regex name with @\"([0-9a-zA-Z_])*\\.\" partitionId @\"\\.dag_processing\\.import_errors\" \n| extend clusterName = case(partitionId == \"\", \"common-cluster\",\n                       partitionId)\n| summarize ImportErrors = abs(max(value)) by timestamp, clusterName, MetricName = \"Import_Errors\"\n| render timechart \n",
                  "PartTitle": "Import Errors",
                  "Dimensions": {
                    "xAxis": {
                      "name": "timestamp",
                      "type": "datetime"
                    },
                    "yAxis": [
                      {
                        "name": "ImportErrors",
                        "type": "real"
                      }
                    ],
                    "splitBy": [
                      {
                        "name": "clusterName",
                        "type": "string"
                      }
                    ],
                    "aggregation": "Sum"
                  }
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
                    "content": "# Airflow Dag Processor",
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
                      "/subscriptions/${subscriptionId}/resourceGroups/${centralGroupPrefix}-rg/providers/Microsoft.Insights/components/${centralGroupPrefix}-ai"
                    ]
                  },
                  "isOptional": true
                },
                {
                  "name": "PartId",
                  "value": "46cf4b1c-57a7-4e7a-b11a-99883b3b9a2f",
                  "isOptional": true
                },
                {
                  "name": "Version",
                  "value": "2.0",
                  "isOptional": true
                },
                {
                  "name": "TimeRange",
                  "value": "2021-05-23T14:22:18.000Z/2021-05-25T14:22:18.000Z",
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
                  "value": "customMetrics\n| where name has \"dag_processing.processor_timeouts\"\n| parse kind=regex name with \"([0-9a-zA-Z_])*.\" clusterName \".dag_processing.processor_timeouts\" \n| summarize ProcessorTimeouts = max(value) by timestamp, clusterName\n| render timechart \n",
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
                    "splitBy": [],
                    "xAxis": {
                      "name": "timestamp",
                      "type": "datetime"
                    },
                    "yAxis": [
                      {
                        "name": "ProcessorTimeouts",
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
                  "Query": "customMetrics\n| where name has \"dag_processing.processor_timeouts\"\n| parse kind=regex name with @\"([0-9a-zA-Z_])*\\.\" partitionId @\"\\.dag_processing\\.processor_timeouts\" \n| extend clusterName = case(partitionId == \"\", \"common-cluster\",\n                       partitionId)\n| summarize ProcessorTimeouts = max(value) by timestamp, clusterName, MetricName = \"dag_processing.processor_timeouts\"\n| render timechart \n\n",
                  "PartTitle": "Processor Timeouts",
                  "Dimensions": {
                    "xAxis": {
                      "name": "timestamp",
                      "type": "datetime"
                    },
                    "yAxis": [
                      {
                        "name": "ProcessorTimeouts",
                        "type": "real"
                      }
                    ],
                    "splitBy": [
                      {
                        "name": "clusterName",
                        "type": "string"
                      }
                    ],
                    "aggregation": "Sum"
                  }
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
                      "/subscriptions/${subscriptionId}/resourceGroups/${centralGroupPrefix}-rg/providers/Microsoft.Insights/components/${centralGroupPrefix}-ai"
                    ]
                  },
                  "isOptional": true
                },
                {
                  "name": "PartId",
                  "value": "5b24a169-6d2f-4fac-814d-017e33115973",
                  "isOptional": true
                },
                {
                  "name": "Version",
                  "value": "2.0",
                  "isOptional": true
                },
                {
                  "name": "TimeRange",
                  "value": "2021-05-23T14:22:18.000Z/2021-05-25T14:22:18.000Z",
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
                  "value": "customMetrics\n| where name has \"dag_processing.processes\"\n| parse kind=regex name with \"([0-9a-zA-Z_])*.\" clusterName \".dag_processing.processes\" \n| summarize ConcurrentDagProcesses = max(value) by timestamp, clusterName\n| render timechart \n",
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
                    "splitBy": [],
                    "xAxis": {
                      "name": "timestamp",
                      "type": "datetime"
                    },
                    "yAxis": [
                      {
                        "name": "ConcurrentDagProcesses",
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
                  "Query": "customMetrics\n| where name has \"dag_processing.processes\"\n| parse kind=regex name with @\"([0-9a-zA-Z_])*\\.\" partitionId @\"\\.dag_processing\\.processes\" \n| extend clusterName = case(partitionId == \"\", \"common-cluster\",\n                       partitionId)\n| summarize ConcurrentDagProcesses = max(value) by timestamp, clusterName, MetricName=\"dag_processing.processes\"\n| render timechart \n\n",
                  "PartTitle": "Concurrent Dag Processes",
                  "Dimensions": {
                    "xAxis": {
                      "name": "timestamp",
                      "type": "datetime"
                    },
                    "yAxis": [
                      {
                        "name": "ConcurrentDagProcesses",
                        "type": "real"
                      }
                    ],
                    "splitBy": [
                      {
                        "name": "clusterName",
                        "type": "string"
                      }
                    ],
                    "aggregation": "Sum"
                  }
                }
              }
            }
          },
          "11": {
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
                    "content": "# Airflow Executor",
                    "subtitle": "",
                    "title": ""
                  }
                }
              }
            }
          },
          "12": {
            "position": {
              "x": 0,
              "y": 16,
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
                  "value": "0b2f5062-5ecd-47cf-9613-00163f411b75",
                  "isOptional": true
                },
                {
                  "name": "Version",
                  "value": "2.0",
                  "isOptional": true
                },
                {
                  "name": "TimeRange",
                  "value": "2021-05-23T14:22:18.000Z/2021-05-25T14:22:18.000Z",
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
                  "value": "customMetrics\n| where name has \"executor.running_tasks\"\n| parse kind=regex name with \"([0-9a-zA-Z_])*.\" clusterName \".executor.running_tasks\" \n| summarize RunningTasks = max(value) by timestamp, clusterName\n| render timechart \n",
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
                    "splitBy": [],
                    "xAxis": {
                      "name": "timestamp",
                      "type": "datetime"
                    },
                    "yAxis": [
                      {
                        "name": "RunningTasks",
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
                  "Query": "customMetrics\n| where name has \"executor.running_tasks\"\n| parse kind=regex name with @\"([0-9a-zA-Z_])*\\.\" partitionId @\"\\.executor\\.running_tasks\" \n| extend clusterName = case(partitionId == \"\", \"common-cluster\",\n                       partitionId)\n| summarize RunningTasks = max(value) by timestamp, clusterName, MetricName=\"executor.running_tasks\"\n| render timechart \n\n",
                  "PartTitle": "Running Tasks on Executor",
                  "Dimensions": {
                    "xAxis": {
                      "name": "timestamp",
                      "type": "datetime"
                    },
                    "yAxis": [
                      {
                        "name": "RunningTasks",
                        "type": "real"
                      }
                    ],
                    "splitBy": [
                      {
                        "name": "clusterName",
                        "type": "string"
                      }
                    ],
                    "aggregation": "Sum"
                  }
                }
              }
            }
          },
          "13": {
            "position": {
              "x": 6,
              "y": 16,
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
                  "value": "6c0f8926-e38e-43b5-92a2-71a8615dd7e2",
                  "isOptional": true
                },
                {
                  "name": "Version",
                  "value": "2.0",
                  "isOptional": true
                },
                {
                  "name": "TimeRange",
                  "value": "2021-05-23T14:22:18.000Z/2021-05-25T14:22:18.000Z",
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
                  "value": "customMetrics\n| where name has \"executor.open_slots\"\n| parse kind=regex name with \"([0-9a-zA-Z_])*.\" clusterName \".executor.open_slots\" \n| summarize RunningTasks = max(value) by timestamp, clusterName\n| render timechart \n",
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
                        "name": "clusterName",
                        "type": "string"
                      }
                    ],
                    "xAxis": {
                      "name": "timestamp",
                      "type": "datetime"
                    },
                    "yAxis": [
                      {
                        "name": "RunningTasks",
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
                  "Query": "customMetrics\n| where name has \"executor.open_slots\"\n| parse kind=regex name with @\"([0-9a-zA-Z_])*\\.\" partitionId @\"\\.executor\\.open_slots\" \n| extend clusterName = case(partitionId == \"\", \"common-cluster\",\n                       partitionId)\n| summarize OpenSlots = max(value) by timestamp, clusterName, MetricName=\"executor.open_slots\"\n| render timechart \n\n",
                  "PartTitle": "Open Slots on Executor",
                  "Dimensions": {
                    "xAxis": {
                      "name": "timestamp",
                      "type": "datetime"
                    },
                    "yAxis": [
                      {
                        "name": "OpenSlots",
                        "type": "real"
                      }
                    ],
                    "splitBy": [
                      {
                        "name": "clusterName",
                        "type": "string"
                      }
                    ],
                    "aggregation": "Sum"
                  }
                }
              }
            }
          },
          "14": {
            "position": {
              "x": 12,
              "y": 16,
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
                  "value": "9c35e81d-3bd3-4241-8381-e828ce4d260d",
                  "isOptional": true
                },
                {
                  "name": "Version",
                  "value": "2.0",
                  "isOptional": true
                },
                {
                  "name": "TimeRange",
                  "value": "2021-05-23T14:22:18.000Z/2021-05-25T14:22:18.000Z",
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
                  "value": "customMetrics\n| where name has \"executor.queued_tasks\"\n| parse kind=regex name with \"([0-9a-zA-Z_])*.\" clusterName \".executor.queued_tasks\" \n| summarize QueuedTasks = max(value) by timestamp, clusterName\n| render timechart \n",
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
                    "splitBy": [],
                    "xAxis": {
                      "name": "timestamp",
                      "type": "datetime"
                    },
                    "yAxis": [
                      {
                        "name": "QueuedTasks",
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
                  "Query": "customMetrics\n| where name has \"executor.queued_tasks\"\n| parse kind=regex name with @\"([0-9a-zA-Z_])*\\.\" partitionId @\"\\.executor\\.queued_tasks\"\n| extend clusterName = case(partitionId == \"\", \"common-cluster\",\n                       partitionId)\n| summarize QueuedTasks = max(value) by timestamp, clusterName, MetricName = \"executor.queued_tasks\"\n| render timechart\n\n",
                  "PartTitle": "Queued Tasks on Executor",
                  "Dimensions": {
                    "xAxis": {
                      "name": "timestamp",
                      "type": "datetime"
                    },
                    "yAxis": [
                      {
                        "name": "QueuedTasks",
                        "type": "real"
                      }
                    ],
                    "splitBy": [
                      {
                        "name": "clusterName",
                        "type": "string"
                      }
                    ],
                    "aggregation": "Sum"
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
                "StartboardPart-LogsDashboardPart-9fb65ba7-2a17-47dd-a4e1-11ead5a69009",
                "StartboardPart-LogsDashboardPart-9fb65ba7-2a17-47dd-a4e1-11ead5a6900b",
                "StartboardPart-LogsDashboardPart-9fb65ba7-2a17-47dd-a4e1-11ead5a6900d",
                "StartboardPart-LogsDashboardPart-9fb65ba7-2a17-47dd-a4e1-11ead5a69011",
                "StartboardPart-LogsDashboardPart-9fb65ba7-2a17-47dd-a4e1-11ead5a69013",
                "StartboardPart-LogsDashboardPart-9fb65ba7-2a17-47dd-a4e1-11ead5a69015",
                "StartboardPart-LogsDashboardPart-9fb65ba7-2a17-47dd-a4e1-11ead5a69019",
                "StartboardPart-LogsDashboardPart-9fb65ba7-2a17-47dd-a4e1-11ead5a6901b",
                "StartboardPart-LogsDashboardPart-9fb65ba7-2a17-47dd-a4e1-11ead5a6901f",
                "StartboardPart-LogsDashboardPart-9fb65ba7-2a17-47dd-a4e1-11ead5a69021",
                "StartboardPart-LogsDashboardPart-9fb65ba7-2a17-47dd-a4e1-11ead5a69023"
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
                "StartboardPart-LogsDashboardPart-9fb65ba7-2a17-47dd-a4e1-11ead5a69009",
                "StartboardPart-LogsDashboardPart-9fb65ba7-2a17-47dd-a4e1-11ead5a6900b",
                "StartboardPart-LogsDashboardPart-9fb65ba7-2a17-47dd-a4e1-11ead5a69013",
                "StartboardPart-LogsDashboardPart-9fb65ba7-2a17-47dd-a4e1-11ead5a69015",
                "StartboardPart-LogsDashboardPart-9fb65ba7-2a17-47dd-a4e1-11ead5a69019",
                "StartboardPart-LogsDashboardPart-9fb65ba7-2a17-47dd-a4e1-11ead5a6901b",
                "StartboardPart-LogsDashboardPart-9fb65ba7-2a17-47dd-a4e1-11ead5a6901f",
                "StartboardPart-LogsDashboardPart-9fb65ba7-2a17-47dd-a4e1-11ead5a69021",
                "StartboardPart-LogsDashboardPart-9fb65ba7-2a17-47dd-a4e1-11ead5a69023"
              ]
            }
          }
        }
      }
    }
}