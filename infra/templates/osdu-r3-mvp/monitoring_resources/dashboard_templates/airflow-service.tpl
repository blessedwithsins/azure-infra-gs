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
                  "value": "let ContainerIdList = KubePodInventory\n| where Name has \"airflow-web\"\n| where strlen(ContainerID)>0\n| distinct ContainerID, PodLabel, Namespace, PodIp, Name;\nContainerLog\n| where ContainerID in (ContainerIdList)\n| where LogEntry contains \"HTTP/1.1\" and LogEntry !contains \"/airflow/health\"\n| lookup kind=leftouter (ContainerIdList) on ContainerID\n| project-away Image, ImageTag, Repository, Name, TimeOfCommand\n| project-rename PodName=Name1\n| parse kind=regex PodName with dataPartitionId \"-airflow-web-[[:graph:]]\"  \n| parse kind=regex LogEntry with '[[:graph:]] HTTP/1.1\" ' values\n| extend status = toint(split(values, \" \")[0]), timeTaken = toint(split(values, \" \")[1])\n| extend HTTPStatus = case(status between (200 .. 299), \"2XX\",\n                       status between (300 .. 399), \"3XX\",\n                       status between (400 .. 499), \"4XX\",\n                       status between (500 .. 599), \"5XX\",\n                       \"XX\")\n| where HTTPStatus == \"4XX\"\n| summarize count() by HTTPStatus, bin(TimeGenerated, 15m), dataPartitionId\n| render timechart\n\n",
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
                        "name": "count_",
                        "type": "long"
                      }
                    ],
                    "splitBy": [
                      {
                        "name": "HTTPStatus",
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
                  "Query": "let ContainerIdList = KubePodInventory\n| where Name has \"airflow-web\"\n| where strlen(ContainerID)>0\n| distinct ContainerID, PodLabel, Namespace, PodIp, Name;\nContainerLog\n| where ContainerID in (ContainerIdList)\n| where LogEntry contains \"HTTP/1.1\" and LogEntry !contains \"/airflow/health\"\n| lookup kind=leftouter (ContainerIdList) on ContainerID\n| project-away Image, ImageTag, Repository, Name, TimeOfCommand\n| project-rename PodName=Name1\n| parse kind=regex PodName with partitionId \"-airflow-web-[[:graph:]]\"\n| extend dataPartitionId = case(partitionId == \"\", \"sr\",\n                       partitionId)\n| parse kind=regex LogEntry with '[[:graph:]] HTTP/1.1\" ' values\n| extend status = toint(split(values, \" \")[0]), timeTaken = toint(split(values, \" \")[1])\n| extend HTTPStatus = case(status between (200 .. 299), \"2XX\",\n                       status between (300 .. 399), \"3XX\",\n                       status between (400 .. 499), \"4XX\",\n                       status between (500 .. 599), \"5XX\",\n                       \"XX\")\n| where HTTPStatus == \"4XX\"\n| summarize count() by HTTPStatus, bin(TimeGenerated, 15m), dataPartitionId\n| render timechart\n\n",
                  "PartTitle": "Number of 4XX Errors"
                }
              },
              "savedContainerState": {
                "partTitle": "Number of 4XX Errors",
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
                  "value": "let ContainerIdList = KubePodInventory\n| where Name has \"airflow-web\"\n| where strlen(ContainerID)>0\n| distinct ContainerID, PodLabel, Namespace, PodIp, Name;\nContainerLog\n| where ContainerID in (ContainerIdList)\n| where LogEntry contains \"HTTP/1.1\" and LogEntry !contains \"/airflow/health\"\n| lookup kind=leftouter (ContainerIdList) on ContainerID\n| project-away Image, ImageTag, Repository, Name, TimeOfCommand\n| project-rename PodName=Name1\n| parse kind=regex PodName with dataPartitionId \"-airflow-web-[[:graph:]]\"  \n| parse kind=regex LogEntry with '[[:graph:]] HTTP/1.1\" ' values\n| extend status = toint(split(values, \" \")[0]), timeTaken = toint(split(values, \" \")[1])\n| extend HTTPStatus = case(status between (200 .. 299), \"2XX\",\n                       status between (300 .. 399), \"3XX\",\n                       status between (400 .. 499), \"4XX\",\n                       status between (500 .. 599), \"5XX\",\n                       \"XX\")\n| where HTTPStatus == \"5XX\"\n| summarize count() by HTTPStatus, bin(TimeGenerated, 15m), dataPartitionId\n| render timechart\n\n",
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
                        "name": "count_",
                        "type": "long"
                      }
                    ],
                    "splitBy": [
                      {
                        "name": "HTTPStatus",
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
                  "Query": "let ContainerIdList = KubePodInventory\n| where Name has \"airflow-web\"\n| where strlen(ContainerID)>0\n| distinct ContainerID, PodLabel, Namespace, PodIp, Name;\nContainerLog\n| where ContainerID in (ContainerIdList)\n| where LogEntry contains \"HTTP/1.1\" and LogEntry !contains \"/airflow/health\"\n| lookup kind=leftouter (ContainerIdList) on ContainerID\n| project-away Image, ImageTag, Repository, Name, TimeOfCommand\n| project-rename PodName=Name1\n| parse kind=regex PodName with partitionId \"-airflow-web-[[:graph:]]\"\n| extend dataPartitionId = case(partitionId == \"\", \"sr\",\n                       partitionId)\n| parse kind=regex LogEntry with '[[:graph:]] HTTP/1.1\" ' values\n| extend status = toint(split(values, \" \")[0]), timeTaken = toint(split(values, \" \")[1])\n| extend HTTPStatus = case(status between (200 .. 299), \"2XX\",\n                       status between (300 .. 399), \"3XX\",\n                       status between (400 .. 499), \"4XX\",\n                       status between (500 .. 599), \"5XX\",\n                       \"XX\")\n| where HTTPStatus == \"5XX\"\n| summarize count() by HTTPStatus, bin(TimeGenerated, 15m), dataPartitionId\n| render timechart\n\n",
                  "PartTitle": "Number of 5XX Errors"
                }
              },
              "savedContainerState": {
                "partTitle": "Number of 5XX Errors",
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
                  "value": "let apiCall = \"POST /airflow/api/experimental/dags\";\nlet ContainerIdList = KubePodInventory\n| where Name has \"airflow-web\"\n| where strlen(ContainerID)>0\n| distinct ContainerID, PodLabel, Namespace, PodIp, Name;\nContainerLog\n| where ContainerID in (ContainerIdList)\n| where LogEntry contains \"HTTP/1.1\" and LogEntry contains apiCall \n| lookup kind=leftouter (ContainerIdList) on ContainerID\n| project-away Image, ImageTag, Repository, Name, TimeOfCommand\n| project-rename PodName=Name1\n| parse kind=regex PodName with dataPartitionId \"-airflow-web-[[:graph:]]\"  \n| parse kind=regex LogEntry with '[[:graph:]] HTTP/1.1\" ' values\n| extend timeTaken = toint(split(values, \" \")[1])\n| summarize TimeTaken = max(timeTaken) by bin(TimeGenerated, 15m), apiCall, dataPartitionId\n| render timechart\t\n\n",
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
                        "name": "TimeTaken",
                        "type": "int"
                      }
                    ],
                    "splitBy": [
                      {
                        "name": "Column1",
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
                  "Query": "let apiCall = \"POST /airflow/api/experimental/dags\";\nlet ContainerIdList = KubePodInventory\n| where Name has \"airflow-web\"\n| where strlen(ContainerID)>0\n| distinct ContainerID, PodLabel, Namespace, PodIp, Name;\nContainerLog\n| where ContainerID in (ContainerIdList)\n| where LogEntry contains \"HTTP/1.1\" and LogEntry contains apiCall \n| lookup kind=leftouter (ContainerIdList) on ContainerID\n| project-away Image, ImageTag, Repository, Name, TimeOfCommand\n| project-rename PodName=Name1\n| parse kind=regex PodName with partitionId \"-airflow-web-[[:graph:]]\"\n| extend dataPartitionId = case(partitionId == \"\", \"sr\",\n                       partitionId)\n| parse kind=regex LogEntry with '[[:graph:]] HTTP/1.1\" ' values\n| extend timeTaken = toint(split(values, \" \")[1])\n| summarize TimeTaken = max(timeTaken) by bin(TimeGenerated, 15m), apiCall, dataPartitionId\n| render timechart\t\n\n",
                  "PartTitle": "Latency of Trigger API"
                }
              },
              "savedContainerState": {
                "partTitle": "Latency of Trigger API",
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
                    "title": "",
                    "subtitle": ""
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
                  "value": "customMetrics\n| where name has \"ti_failures\"\n| parse kind=regex name with \"([0-9a-zA-Z_])*.\" dataPartitionId \".ti_failures\" \n| summarize DagBagSize = max(value) by bin(timestamp, 15m), dataPartitionId\n| render timechart \n",
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
                        "name": "dataPartitionId",
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
                  "Query": "customMetrics\n| where name has \"ti_failures\"\n| parse kind=regex name with @\"([0-9a-zA-Z_])*\\.\" partitionId @\"\\.ti_failures\" \n| extend dataPartitionId = case(partitionId == \"\", \"sr\",\n                       partitionId)\n| summarize TaskInstanceFailures = max(value) by bin(timestamp, 15m), MetricName=\"TaskInstance Failures\", dataPartitionId\n| render timechart \n\n",
                  "PartTitle": "Total Task Failures",
                  "Dimensions": {
                    "xAxis": {
                      "name": "timestamp",
                      "type": "datetime"
                    },
                    "yAxis": [
                      {
                        "name": "TaskInstanceFailures",
                        "type": "real"
                      }
                    ],
                    "splitBy": [
                      {
                        "name": "MetricName",
                        "type": "string"
                      }
                    ],
                    "aggregation": "Sum"
                  }
                }
              },
              "savedContainerState": {
                "partTitle": "Total Task Failures",
                "assetName": "${centralGroupPrefix}-ai"
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
                  "value": "customMetrics\n| where name has \"dagbag_size\"\n| parse kind=regex name with \"([0-9a-zA-Z_])*.\" dataPartitionId \".dagbag_size\" \n| summarize DagBagSize = max(value) by bin(timestamp, 15m), dataPartitionId\n| render timechart \n",
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
                        "name": "dataPartitionId",
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
                  "Query": "customMetrics\n| where name has \"dagbag_size\"\n| parse kind=regex name with @\"([0-9a-zA-Z_])*\\.\" partitionId @\"\\.dagbag_size\" \n| extend dataPartitionId = case(partitionId == \"\", \"sr\",\n                       partitionId)\n| summarize DagBagSize = max(value) by bin(timestamp, 15m), MetricName = \"dagbag_size\", dataPartitionId\n| render timechart \n\n",
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
                        "name": "MetricName",
                        "type": "string"
                      }
                    ],
                    "aggregation": "Sum"
                  }
                }
              },
              "savedContainerState": {
                "partTitle": "DagBag Size",
                "assetName": "${centralGroupPrefix}-ai"
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
                  "value": "customMetrics\n| where name has \"dag_processing.import_errors\"\n| parse kind=regex name with \"([0-9a-zA-Z_])*.\" dataPartitionId \".dag_processing.import_errors\" \n| summarize DagBagSize = max(value) by bin(timestamp, 15m), dataPartitionId\n| render timechart \n",
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
                    "splitBy": [],
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
                  "Query": "customMetrics\n| where name has \"dag_processing.import_errors\"\n| parse kind=regex name with @\"([0-9a-zA-Z_])*\\.\" partitionId @\"\\.dag_processing\\.import_errors\" \n| extend dataPartitionId = case(partitionId == \"\", \"sr\",\n                       partitionId)\n| summarize ImportErrors = max(value) by bin(timestamp, 15m),MetricName = \"Import_Errors\", dataPartitionId\n| render timechart ",
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
                        "name": "MetricName",
                        "type": "string"
                      }
                    ],
                    "aggregation": "Sum"
                  }
                }
              },
              "savedContainerState": {
                "partTitle": "Import Errors",
                "assetName": "${centralGroupPrefix}-ai"
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
                    "title": "",
                    "subtitle": ""
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
                  "value": "customMetrics\n| where name has \"dag_processing.processor_timeouts\"\n| parse kind=regex name with \"([0-9a-zA-Z_])*.\" dataPartitionId \".dag_processing.processor_timeouts\" \n| summarize ProcessorTimeouts = max(value) by bin(timestamp, 15m), dataPartitionId\n| render timechart \n",
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
                    "splitBy": [],
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
                  "Query": "customMetrics\n| where name has \"dag_processing.processor_timeouts\"\n| parse kind=regex name with @\"([0-9a-zA-Z_])*\\.\" partitionId @\"\\.dag_processing\\.processor_timeouts\" \n| extend dataPartitionId = case(partitionId == \"\", \"sr\",\n                       partitionId)\n| summarize ProcessorTimeouts = max(value) by bin(timestamp, 15m), MetricName = \"dag_processing.processor_timeouts\", dataPartitionId\n| render timechart \n",
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
                        "name": "MetricName",
                        "type": "string"
                      }
                    ],
                    "aggregation": "Sum"
                  }
                }
              },
              "savedContainerState": {
                "partTitle": "Processor Timeouts",
                "assetName": "${centralGroupPrefix}-ai"
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
                  "value": "customMetrics\n| where name has \"dag_processing.processes\"\n| parse kind=regex name with \"([0-9a-zA-Z_])*.\" dataPartitionId \".dag_processing.processes\" \n| summarize ConcurrentDagProcesses = max(value) by bin(timestamp, 15m), dataPartitionId\n| render timechart \n",
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
                    "splitBy": [],
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
                  "Query": "customMetrics\n| where name has \"dag_processing.processes\"\n| parse kind=regex name with @\"([0-9a-zA-Z_])*\\.\" partitionId @\"\\.dag_processing\\.processes\" \n| extend dataPartitionId = case(partitionId == \"\", \"sr\",\n                       partitionId)\n| summarize ConcurrentDagProcesses = max(value) by bin(timestamp, 15m), MetricName=\"dag_processing.processes\", dataPartitionId\n| render timechart \n\n",
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
                        "name": "MetricName",
                        "type": "string"
                      }
                    ],
                    "aggregation": "Sum"
                  }
                }
              },
              "savedContainerState": {
                "partTitle": "Concurrent Dag Processes",
                "assetName": "${centralGroupPrefix}-ai"
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
                    "title": "",
                    "subtitle": ""
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
                  "value": "customMetrics\n| where name has \"executor.running_tasks\"\n| parse kind=regex name with \"([0-9a-zA-Z_])*.\" dataPartitionId \".executor.running_tasks\" \n| summarize RunningTasks = max(value) by bin(timestamp, 15m), dataPartitionId\n| render timechart \n",
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
                    "splitBy": [],
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
                  "Query": "customMetrics\n| where name has \"executor.running_tasks\"\n| parse kind=regex name with @\"([0-9a-zA-Z_])*\\.\" partitionId @\"\\.executor\\.running_tasks\" \n| extend dataPartitionId = case(partitionId == \"\", \"sr\",\n                       partitionId)\n| summarize RunningTasks = max(value) by bin(timestamp, 15m), MetricName=\"executor.running_tasks\", dataPartitionId\n| render timechart \n",
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
                        "name": "MetricName",
                        "type": "string"
                      }
                    ],
                    "aggregation": "Sum"
                  }
                }
              },
              "savedContainerState": {
                "partTitle": "Running Tasks on Executor",
                "assetName": "${centralGroupPrefix}-ai"
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
                  "value": "customMetrics\n| where name has \"executor.open_slots\"\n| parse kind=regex name with \"([0-9a-zA-Z_])*.\" dataPartitionId \".executor.open_slots\" \n| summarize RunningTasks = max(value) by bin(timestamp, 15m), dataPartitionId\n| render timechart \n",
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
                        "name": "dataPartitionId",
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
                  "Query": "customMetrics\n| where name has \"executor.open_slots\"\n| parse kind=regex name with @\"([0-9a-zA-Z_])*\\.\" partitionId @\"\\.executor\\.open_slots\" \n| extend dataPartitionId = case(partitionId == \"\", \"sr\",\n                       partitionId)\n| summarize OpenSlots = max(value) by bin(timestamp, 15m), MetricName=\"executor.open_slots\", dataPartitionId\n| render timechart \n\n",
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
                        "name": "MetricName",
                        "type": "string"
                      }
                    ],
                    "aggregation": "Sum"
                  }
                }
              },
              "savedContainerState": {
                "partTitle": "Open Slots on Executor",
                "assetName": "${centralGroupPrefix}-ai"
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
                  "value": "customMetrics\n| where name has \"executor.queued_tasks\"\n| parse kind=regex name with \"([0-9a-zA-Z_])*.\" dataPartitionId \".executor.queued_tasks\" \n| summarize QueuedTasks = max(value) by bin(timestamp, 15m), dataPartitionId\n| render timechart \n",
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
                    "splitBy": [],
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
                  "Query": "customMetrics\n| where name has \"executor.queued_tasks\"\n| parse kind=regex name with @\"([0-9a-zA-Z_])*\\.\" partitionId @\"\\.executor\\.queued_tasks\"\n| extend dataPartitionId = case(partitionId == \"\", \"sr\",\n                       partitionId)\n| summarize QueuedTasks = max(value) by bin(timestamp, 15m), MetricName = \"executor.queued_tasks\", dataPartitionId\n| render timechart\n\n",
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
                        "name": "MetricName",
                        "type": "string"
                      }
                    ],
                    "aggregation": "Sum"
                  }
                }
              },
              "savedContainerState": {
                "partTitle": "Queued Tasks on Executor",
                "assetName": "${centralGroupPrefix}-ai"
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
                "StartboardPart-LogsDashboardPart-5f661255-7b67-43c0-9ef2-0d49e36dc648",
                "StartboardPart-LogsDashboardPart-5f661255-7b67-43c0-9ef2-0d49e36dc64a",
                "StartboardPart-LogsDashboardPart-5f661255-7b67-43c0-9ef2-0d49e36dc64c",
                "StartboardPart-LogsDashboardPart-5f661255-7b67-43c0-9ef2-0d49e36dc650",
                "StartboardPart-LogsDashboardPart-5f661255-7b67-43c0-9ef2-0d49e36dc652",
                "StartboardPart-LogsDashboardPart-5f661255-7b67-43c0-9ef2-0d49e36dc654",
                "StartboardPart-LogsDashboardPart-5f661255-7b67-43c0-9ef2-0d49e36dc658",
                "StartboardPart-LogsDashboardPart-5f661255-7b67-43c0-9ef2-0d49e36dc65a",
                "StartboardPart-LogsDashboardPart-5f661255-7b67-43c0-9ef2-0d49e36dc65e",
                "StartboardPart-LogsDashboardPart-5f661255-7b67-43c0-9ef2-0d49e36dc660",
                "StartboardPart-LogsDashboardPart-5f661255-7b67-43c0-9ef2-0d49e36dc662"
              ]
            },
            "dynamicFilter_dataPartitionId": {
              "model": {
                "operator": "equals",
                "values": []
              },
              "displayCache": {
                "name": "dataPartitionId",
                "value": "none"
              },
              "filteredPartIds": [
                "StartboardPart-LogsDashboardPart-5f661255-7b67-43c0-9ef2-0d49e36dc648",
                "StartboardPart-LogsDashboardPart-5f661255-7b67-43c0-9ef2-0d49e36dc64a",
                "StartboardPart-LogsDashboardPart-5f661255-7b67-43c0-9ef2-0d49e36dc64c",
                "StartboardPart-LogsDashboardPart-5f661255-7b67-43c0-9ef2-0d49e36dc650",
                "StartboardPart-LogsDashboardPart-5f661255-7b67-43c0-9ef2-0d49e36dc652",
                "StartboardPart-LogsDashboardPart-5f661255-7b67-43c0-9ef2-0d49e36dc654",
                "StartboardPart-LogsDashboardPart-5f661255-7b67-43c0-9ef2-0d49e36dc658",
                "StartboardPart-LogsDashboardPart-5f661255-7b67-43c0-9ef2-0d49e36dc65a",
                "StartboardPart-LogsDashboardPart-5f661255-7b67-43c0-9ef2-0d49e36dc65e",
                "StartboardPart-LogsDashboardPart-5f661255-7b67-43c0-9ef2-0d49e36dc660",
                "StartboardPart-LogsDashboardPart-5f661255-7b67-43c0-9ef2-0d49e36dc662"
              ]
            }
          }
        }
      }
    }
  }