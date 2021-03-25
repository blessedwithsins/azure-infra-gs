{
  "lenses": {
    "0": {
      "order": 0,
      "parts": {
        "0": {
          "position": {
            "x": 0,
            "y": 0,
            "colSpan": 2,
            "rowSpan": 1
          },
          "metadata": {
            "inputs": [
              {
                "name": "id",
                "value": "/subscriptions/${subscriptionId}/resourceGroups/${centralGroupPrefix}-rg/providers/Microsoft.Insights/components/${centralGroupPrefix}-ai"
              },
              {
                "name": "Version",
                "value": "1.0"
              }
            ],
            "type": "Extension/AppInsightsExtension/PartType/AspNetOverviewPinnedPart",
            "asset": {
              "idInputName": "id",
              "type": "ApplicationInsights"
            },
            "defaultMenuItemId": "overview"
          }
        },
        "1": {
          "position": {
            "x": 2,
            "y": 0,
            "colSpan": 1,
            "rowSpan": 1
          },
          "metadata": {
            "inputs": [
              {
                "name": "ComponentId",
                "value": {
                  "Name": "${centralGroupPrefix}-ai",
                  "ResourceGroup": "${centralGroupPrefix}-rg",
                  "SubscriptionId": "${subscriptionId}"
                }
              },
              {
                "name": "Version",
                "value": "1.0"
              }
            ],
            "type": "Extension/AppInsightsExtension/PartType/ProactiveDetectionAsyncPart",
            "asset": {
              "idInputName": "ComponentId",
              "type": "ApplicationInsights"
            },
            "defaultMenuItemId": "ProactiveDetection"
          }
        },
        "2": {
          "position": {
            "x": 3,
            "y": 0,
            "colSpan": 1,
            "rowSpan": 1
          },
          "metadata": {
            "inputs": [
              {
                "name": "ComponentId",
                "value": {
                  "Name": "${centralGroupPrefix}-ai",
                  "ResourceGroup": "${centralGroupPrefix}-rg",
                  "SubscriptionId": "${subscriptionId}"
                }
              },
              {
                "name": "ResourceId",
                "value": "/subscriptions/${subscriptionId}/resourceGroups/${centralGroupPrefix}-rg/providers/Microsoft.Insights/components/${centralGroupPrefix}-ai"
              }
            ],
            "type": "Extension/AppInsightsExtension/PartType/QuickPulseButtonSmallPart",
            "asset": {
              "idInputName": "ComponentId",
              "type": "ApplicationInsights"
            }
          }
        },
        "3": {
          "position": {
            "x": 4,
            "y": 0,
            "colSpan": 1,
            "rowSpan": 1
          },
          "metadata": {
            "inputs": [
              {
                "name": "ComponentId",
                "value": {
                  "Name": "${centralGroupPrefix}-ai",
                  "ResourceGroup": "${centralGroupPrefix}-rg",
                  "SubscriptionId": "${subscriptionId}"
                }
              },
              {
                "name": "TimeContext",
                "value": {
                  "createdTime": "2018-05-04T01:20:33.345Z",
                  "durationMs": 86400000,
                  "endTime": null,
                  "grain": 1,
                  "isInitialTime": true,
                  "useDashboardTimeRange": false
                }
              },
              {
                "name": "Version",
                "value": "1.0"
              }
            ],
            "type": "Extension/AppInsightsExtension/PartType/AvailabilityNavButtonPart",
            "asset": {
              "idInputName": "ComponentId",
              "type": "ApplicationInsights"
            }
          }
        },
        "4": {
          "position": {
            "x": 5,
            "y": 0,
            "colSpan": 1,
            "rowSpan": 1
          },
          "metadata": {
            "inputs": [
              {
                "name": "ComponentId",
                "value": {
                  "Name": "${centralGroupPrefix}-ai",
                  "ResourceGroup": "${centralGroupPrefix}-rg",
                  "SubscriptionId": "${subscriptionId}"
                }
              },
              {
                "name": "TimeContext",
                "value": {
                  "createdTime": "2018-05-08T18:47:35.237Z",
                  "durationMs": 86400000,
                  "endTime": null,
                  "grain": 1,
                  "isInitialTime": true,
                  "useDashboardTimeRange": false
                }
              },
              {
                "name": "ConfigurationId",
                "value": "78ce933e-e864-4b05-a27b-71fd55a6afad"
              }
            ],
            "type": "Extension/AppInsightsExtension/PartType/AppMapButtonPart",
            "asset": {
              "idInputName": "ComponentId",
              "type": "ApplicationInsights"
            }
          }
        },
        "5": {
          "position": {
            "x": 0,
            "y": 1,
            "colSpan": 3,
            "rowSpan": 1
          },
          "metadata": {
            "inputs": [],
            "type": "Extension/HubsExtension/PartType/MarkdownPart",
            "settings": {
              "content": {
                "settings": {
                  "content": "# Usage",
                  "subtitle": "",
                  "title": ""
                }
              }
            }
          }
        },
        "6": {
          "position": {
            "x": 3,
            "y": 1,
            "colSpan": 1,
            "rowSpan": 1
          },
          "metadata": {
            "inputs": [
              {
                "name": "ComponentId",
                "value": {
                  "Name": "${centralGroupPrefix}-ai",
                  "ResourceGroup": "${centralGroupPrefix}-rg",
                  "SubscriptionId": "${subscriptionId}"
                }
              },
              {
                "name": "TimeContext",
                "value": {
                  "createdTime": "2018-05-04T01:22:35.782Z",
                  "durationMs": 86400000,
                  "endTime": null,
                  "grain": 1,
                  "isInitialTime": true,
                  "useDashboardTimeRange": false
                }
              }
            ],
            "type": "Extension/AppInsightsExtension/PartType/UsageUsersOverviewPart",
            "asset": {
              "idInputName": "ComponentId",
              "type": "ApplicationInsights"
            }
          }
        },
        "7": {
          "position": {
            "x": 4,
            "y": 1,
            "colSpan": 3,
            "rowSpan": 1
          },
          "metadata": {
            "inputs": [],
            "type": "Extension/HubsExtension/PartType/MarkdownPart",
            "settings": {
              "content": {
                "settings": {
                  "content": "# Reliability",
                  "subtitle": "",
                  "title": ""
                }
              }
            }
          }
        },
        "8": {
          "position": {
            "x": 7,
            "y": 1,
            "colSpan": 1,
            "rowSpan": 1
          },
          "metadata": {
            "inputs": [
              {
                "name": "ResourceId",
                "value": "/subscriptions/${subscriptionId}/resourceGroups/${centralGroupPrefix}-rg/providers/Microsoft.Insights/components/${centralGroupPrefix}-ai"
              },
              {
                "name": "DataModel",
                "value": {
                  "timeContext": {
                    "createdTime": "2018-05-04T23:42:40.072Z",
                    "durationMs": 86400000,
                    "grain": 1,
                    "isInitialTime": false,
                    "useDashboardTimeRange": false
                  },
                  "version": "1.0.0"
                },
                "isOptional": true
              },
              {
                "name": "ConfigurationId",
                "value": "8a02f7bf-ac0f-40e1-afe9-f0e72cfee77f",
                "isOptional": true
              }
            ],
            "type": "Extension/AppInsightsExtension/PartType/CuratedBladeFailuresPinnedPart",
            "isAdapter": true,
            "asset": {
              "idInputName": "ResourceId",
              "type": "ApplicationInsights"
            },
            "defaultMenuItemId": "failures"
          }
        },
        "9": {
          "position": {
            "x": 8,
            "y": 1,
            "colSpan": 3,
            "rowSpan": 1
          },
          "metadata": {
            "inputs": [],
            "type": "Extension/HubsExtension/PartType/MarkdownPart",
            "settings": {
              "content": {
                "settings": {
                  "content": "# Responsiveness\r\n",
                  "subtitle": "",
                  "title": ""
                }
              }
            }
          }
        },
        "10": {
          "position": {
            "x": 11,
            "y": 1,
            "colSpan": 1,
            "rowSpan": 1
          },
          "metadata": {
            "inputs": [
              {
                "name": "ResourceId",
                "value": "/subscriptions/${subscriptionId}/resourceGroups/${centralGroupPrefix}-rg/providers/Microsoft.Insights/components/${centralGroupPrefix}-ai"
              },
              {
                "name": "DataModel",
                "value": {
                  "timeContext": {
                    "createdTime": "2018-05-04T23:43:37.804Z",
                    "durationMs": 86400000,
                    "grain": 1,
                    "isInitialTime": false,
                    "useDashboardTimeRange": false
                  },
                  "version": "1.0.0"
                },
                "isOptional": true
              },
              {
                "name": "ConfigurationId",
                "value": "2a8ede4f-2bee-4b9c-aed9-2db0e8a01865",
                "isOptional": true
              }
            ],
            "type": "Extension/AppInsightsExtension/PartType/CuratedBladePerformancePinnedPart",
            "isAdapter": true,
            "asset": {
              "idInputName": "ResourceId",
              "type": "ApplicationInsights"
            },
            "defaultMenuItemId": "performance"
          }
        },
        "11": {
          "position": {
            "x": 12,
            "y": 1,
            "colSpan": 3,
            "rowSpan": 1
          },
          "metadata": {
            "inputs": [],
            "type": "Extension/HubsExtension/PartType/MarkdownPart",
            "settings": {
              "content": {
                "settings": {
                  "content": "# Browser",
                  "subtitle": "",
                  "title": ""
                }
              }
            }
          }
        },
        "12": {
          "position": {
            "x": 15,
            "y": 1,
            "colSpan": 1,
            "rowSpan": 1
          },
          "metadata": {
            "inputs": [
              {
                "name": "ComponentId",
                "value": {
                  "Name": "${centralGroupPrefix}-ai",
                  "ResourceGroup": "${centralGroupPrefix}-rg",
                  "SubscriptionId": "${subscriptionId}"
                }
              },
              {
                "name": "MetricsExplorerJsonDefinitionId",
                "value": "BrowserPerformanceTimelineMetrics"
              },
              {
                "name": "TimeContext",
                "value": {
                  "createdTime": "2018-05-08T12:16:27.534Z",
                  "durationMs": 86400000,
                  "grain": 1,
                  "isInitialTime": false,
                  "useDashboardTimeRange": false
                }
              },
              {
                "name": "CurrentFilter",
                "value": {
                  "eventTypes": [
                    4,
                    1,
                    3,
                    5,
                    2,
                    6,
                    13
                  ],
                  "isPermissive": false,
                  "typeFacets": {}
                }
              },
              {
                "name": "id",
                "value": {
                  "Name": "${centralGroupPrefix}-ai",
                  "ResourceGroup": "${centralGroupPrefix}-rg",
                  "SubscriptionId": "${subscriptionId}"
                }
              },
              {
                "name": "Version",
                "value": "1.0"
              }
            ],
            "type": "Extension/AppInsightsExtension/PartType/MetricsExplorerBladePinnedPart",
            "asset": {
              "idInputName": "ComponentId",
              "type": "ApplicationInsights"
            },
            "defaultMenuItemId": "browser"
          }
        },
        "13": {
          "position": {
            "x": 0,
            "y": 2,
            "colSpan": 4,
            "rowSpan": 3
          },
          "metadata": {
            "inputs": [
              {
                "name": "options",
                "value": {
                  "chart": {
                    "metrics": [
                      {
                        "aggregationType": 5,
                        "metricVisualization": {
                          "color": "#47BDF5",
                          "displayName": "Sessions"
                        },
                        "name": "sessions/count",
                        "namespace": "microsoft.insights/components/kusto",
                        "resourceMetadata": {
                          "id": "/subscriptions/${subscriptionId}/resourceGroups/${centralGroupPrefix}-rg/providers/Microsoft.Insights/components/${centralGroupPrefix}-ai"
                        }
                      },
                      {
                        "aggregationType": 5,
                        "metricVisualization": {
                          "color": "#7E58FF",
                          "displayName": "Users"
                        },
                        "name": "users/count",
                        "namespace": "microsoft.insights/components/kusto",
                        "resourceMetadata": {
                          "id": "/subscriptions/${subscriptionId}/resourceGroups/${centralGroupPrefix}-rg/providers/Microsoft.Insights/components/${centralGroupPrefix}-ai"
                        }
                      }
                    ],
                    "openBladeOnClick": {
                      "destinationBlade": {
                        "bladeName": "ResourceMenuBlade",
                        "extensionName": "HubsExtension",
                        "parameters": {
                          "id": "/subscriptions/${subscriptionId}/resourceGroups/${centralGroupPrefix}-rg/providers/Microsoft.Insights/components/${centralGroupPrefix}-ai",
                          "menuid": "segmentationUsers"
                        }
                      },
                      "openBlade": true
                    },
                    "title": "Unique sessions and users",
                    "visualization": {
                      "axisVisualization": {
                        "x": {
                          "axisType": 2,
                          "isVisible": true
                        },
                        "y": {
                          "axisType": 1,
                          "isVisible": true
                        }
                      },
                      "chartType": 2,
                      "legendVisualization": {
                        "hideSubtitle": false,
                        "isVisible": true,
                        "position": 2
                      }
                    }
                  }
                }
              },
              {
                "name": "sharedTimeRange",
                "isOptional": true
              }
            ],
            "type": "Extension/HubsExtension/PartType/MonitorChartPart",
            "settings": {}
          }
        },
        "14": {
          "position": {
            "x": 4,
            "y": 2,
            "colSpan": 4,
            "rowSpan": 3
          },
          "metadata": {
            "inputs": [
              {
                "name": "options",
                "value": {
                  "chart": {
                    "metrics": [
                      {
                        "aggregationType": 7,
                        "metricVisualization": {
                          "color": "#EC008C",
                          "displayName": "Failed requests"
                        },
                        "name": "requests/failed",
                        "namespace": "microsoft.insights/components",
                        "resourceMetadata": {
                          "id": "/subscriptions/${subscriptionId}/resourceGroups/${centralGroupPrefix}-rg/providers/Microsoft.Insights/components/${centralGroupPrefix}-ai"
                        }
                      }
                    ],
                    "openBladeOnClick": {
                      "destinationBlade": {
                        "bladeName": "ResourceMenuBlade",
                        "extensionName": "HubsExtension",
                        "parameters": {
                          "id": "/subscriptions/${subscriptionId}/resourceGroups/${centralGroupPrefix}-rg/providers/Microsoft.Insights/components/${centralGroupPrefix}-ai",
                          "menuid": "failures"
                        }
                      },
                      "openBlade": true
                    },
                    "title": "Failed requests",
                    "visualization": {
                      "axisVisualization": {
                        "x": {
                          "axisType": 2,
                          "isVisible": true
                        },
                        "y": {
                          "axisType": 1,
                          "isVisible": true
                        }
                      },
                      "chartType": 3,
                      "legendVisualization": {
                        "hideSubtitle": false,
                        "isVisible": true,
                        "position": 2
                      }
                    }
                  }
                }
              },
              {
                "name": "sharedTimeRange",
                "isOptional": true
              }
            ],
            "type": "Extension/HubsExtension/PartType/MonitorChartPart",
            "settings": {}
          }
        },
        "15": {
          "position": {
            "x": 8,
            "y": 2,
            "colSpan": 4,
            "rowSpan": 3
          },
          "metadata": {
            "inputs": [
              {
                "name": "options",
                "value": {
                  "chart": {
                    "metrics": [
                      {
                        "aggregationType": 4,
                        "metricVisualization": {
                          "color": "#00BCF2",
                          "displayName": "Server response time"
                        },
                        "name": "requests/duration",
                        "namespace": "microsoft.insights/components",
                        "resourceMetadata": {
                          "id": "/subscriptions/${subscriptionId}/resourceGroups/${centralGroupPrefix}-rg/providers/Microsoft.Insights/components/${centralGroupPrefix}-ai"
                        }
                      }
                    ],
                    "openBladeOnClick": {
                      "destinationBlade": {
                        "bladeName": "ResourceMenuBlade",
                        "extensionName": "HubsExtension",
                        "parameters": {
                          "id": "/subscriptions/${subscriptionId}/resourceGroups/${centralGroupPrefix}-rg/providers/Microsoft.Insights/components/${centralGroupPrefix}-ai",
                          "menuid": "performance"
                        }
                      },
                      "openBlade": true
                    },
                    "title": "Server response time",
                    "visualization": {
                      "axisVisualization": {
                        "x": {
                          "axisType": 2,
                          "isVisible": true
                        },
                        "y": {
                          "axisType": 1,
                          "isVisible": true
                        }
                      },
                      "chartType": 2,
                      "legendVisualization": {
                        "hideSubtitle": false,
                        "isVisible": true,
                        "position": 2
                      }
                    }
                  }
                }
              },
              {
                "name": "sharedTimeRange",
                "isOptional": true
              }
            ],
            "type": "Extension/HubsExtension/PartType/MonitorChartPart",
            "settings": {}
          }
        },
        "16": {
          "position": {
            "x": 12,
            "y": 2,
            "colSpan": 4,
            "rowSpan": 3
          },
          "metadata": {
            "inputs": [
              {
                "name": "options",
                "value": {
                  "chart": {
                    "metrics": [
                      {
                        "aggregationType": 4,
                        "metricVisualization": {
                          "color": "#7E58FF",
                          "displayName": "Page load network connect time"
                        },
                        "name": "browserTimings/networkDuration",
                        "namespace": "microsoft.insights/components",
                        "resourceMetadata": {
                          "id": "/subscriptions/${subscriptionId}/resourceGroups/${centralGroupPrefix}-rg/providers/Microsoft.Insights/components/${centralGroupPrefix}-ai"
                        }
                      },
                      {
                        "aggregationType": 4,
                        "metricVisualization": {
                          "color": "#44F1C8",
                          "displayName": "Client processing time"
                        },
                        "name": "browserTimings/processingDuration",
                        "namespace": "microsoft.insights/components",
                        "resourceMetadata": {
                          "id": "/subscriptions/${subscriptionId}/resourceGroups/${centralGroupPrefix}-rg/providers/Microsoft.Insights/components/${centralGroupPrefix}-ai"
                        }
                      },
                      {
                        "aggregationType": 4,
                        "metricVisualization": {
                          "color": "#EB9371",
                          "displayName": "Send request time"
                        },
                        "name": "browserTimings/sendDuration",
                        "namespace": "microsoft.insights/components",
                        "resourceMetadata": {
                          "id": "/subscriptions/${subscriptionId}/resourceGroups/${centralGroupPrefix}-rg/providers/Microsoft.Insights/components/${centralGroupPrefix}-ai"
                        }
                      },
                      {
                        "aggregationType": 4,
                        "metricVisualization": {
                          "color": "#0672F1",
                          "displayName": "Receiving response time"
                        },
                        "name": "browserTimings/receiveDuration",
                        "namespace": "microsoft.insights/components",
                        "resourceMetadata": {
                          "id": "/subscriptions/${subscriptionId}/resourceGroups/${centralGroupPrefix}-rg/providers/Microsoft.Insights/components/${centralGroupPrefix}-ai"
                        }
                      }
                    ],
                    "title": "Average page load time breakdown",
                    "visualization": {
                      "axisVisualization": {
                        "x": {
                          "axisType": 2,
                          "isVisible": true
                        },
                        "y": {
                          "axisType": 1,
                          "isVisible": true
                        }
                      },
                      "chartType": 3,
                      "legendVisualization": {
                        "hideSubtitle": false,
                        "isVisible": true,
                        "position": 2
                      }
                    }
                  }
                }
              },
              {
                "name": "sharedTimeRange",
                "isOptional": true
              }
            ],
            "type": "Extension/HubsExtension/PartType/MonitorChartPart",
            "settings": {}
          }
        },
        "17": {
          "position": {
            "x": 0,
            "y": 5,
            "colSpan": 4,
            "rowSpan": 3
          },
          "metadata": {
            "inputs": [
              {
                "name": "options",
                "value": {
                  "chart": {
                    "metrics": [
                      {
                        "aggregationType": 4,
                        "metricVisualization": {
                          "color": "#47BDF5",
                          "displayName": "Availability"
                        },
                        "name": "availabilityResults/availabilityPercentage",
                        "namespace": "microsoft.insights/components",
                        "resourceMetadata": {
                          "id": "/subscriptions/${subscriptionId}/resourceGroups/${centralGroupPrefix}-rg/providers/Microsoft.Insights/components/${centralGroupPrefix}-ai"
                        }
                      }
                    ],
                    "openBladeOnClick": {
                      "destinationBlade": {
                        "bladeName": "ResourceMenuBlade",
                        "extensionName": "HubsExtension",
                        "parameters": {
                          "id": "/subscriptions/${subscriptionId}/resourceGroups/${centralGroupPrefix}-rg/providers/Microsoft.Insights/components/${centralGroupPrefix}-ai",
                          "menuid": "availability"
                        }
                      },
                      "openBlade": true
                    },
                    "title": "Average availability",
                    "visualization": {
                      "axisVisualization": {
                        "x": {
                          "axisType": 2,
                          "isVisible": true
                        },
                        "y": {
                          "axisType": 1,
                          "isVisible": true
                        }
                      },
                      "chartType": 3,
                      "legendVisualization": {
                        "hideSubtitle": false,
                        "isVisible": true,
                        "position": 2
                      }
                    }
                  }
                }
              },
              {
                "name": "sharedTimeRange",
                "isOptional": true
              }
            ],
            "type": "Extension/HubsExtension/PartType/MonitorChartPart",
            "settings": {}
          }
        },
        "18": {
          "position": {
            "x": 4,
            "y": 5,
            "colSpan": 4,
            "rowSpan": 3
          },
          "metadata": {
            "inputs": [
              {
                "name": "options",
                "value": {
                  "chart": {
                    "metrics": [
                      {
                        "aggregationType": 7,
                        "metricVisualization": {
                          "color": "#47BDF5",
                          "displayName": "Server exceptions"
                        },
                        "name": "exceptions/server",
                        "namespace": "microsoft.insights/components",
                        "resourceMetadata": {
                          "id": "/subscriptions/${subscriptionId}/resourceGroups/${centralGroupPrefix}-rg/providers/Microsoft.Insights/components/${centralGroupPrefix}-ai"
                        }
                      },
                      {
                        "aggregationType": 7,
                        "metricVisualization": {
                          "color": "#7E58FF",
                          "displayName": "Dependency failures"
                        },
                        "name": "dependencies/failed",
                        "namespace": "microsoft.insights/components",
                        "resourceMetadata": {
                          "id": "/subscriptions/${subscriptionId}/resourceGroups/${centralGroupPrefix}-rg/providers/Microsoft.Insights/components/${centralGroupPrefix}-ai"
                        }
                      }
                    ],
                    "title": "Server exceptions and Dependency failures",
                    "visualization": {
                      "axisVisualization": {
                        "x": {
                          "axisType": 2,
                          "isVisible": true
                        },
                        "y": {
                          "axisType": 1,
                          "isVisible": true
                        }
                      },
                      "chartType": 2,
                      "legendVisualization": {
                        "hideSubtitle": false,
                        "isVisible": true,
                        "position": 2
                      }
                    }
                  }
                }
              },
              {
                "name": "sharedTimeRange",
                "isOptional": true
              }
            ],
            "type": "Extension/HubsExtension/PartType/MonitorChartPart",
            "settings": {}
          }
        },
        "19": {
          "position": {
            "x": 8,
            "y": 5,
            "colSpan": 4,
            "rowSpan": 3
          },
          "metadata": {
            "inputs": [
              {
                "name": "options",
                "value": {
                  "chart": {
                    "metrics": [
                      {
                        "aggregationType": 4,
                        "metricVisualization": {
                          "color": "#47BDF5",
                          "displayName": "Processor time"
                        },
                        "name": "performanceCounters/processorCpuPercentage",
                        "namespace": "microsoft.insights/components",
                        "resourceMetadata": {
                          "id": "/subscriptions/${subscriptionId}/resourceGroups/${centralGroupPrefix}-rg/providers/Microsoft.Insights/components/${centralGroupPrefix}-ai"
                        }
                      },
                      {
                        "aggregationType": 4,
                        "metricVisualization": {
                          "color": "#7E58FF",
                          "displayName": "Process CPU"
                        },
                        "name": "performanceCounters/processCpuPercentage",
                        "namespace": "microsoft.insights/components",
                        "resourceMetadata": {
                          "id": "/subscriptions/${subscriptionId}/resourceGroups/${centralGroupPrefix}-rg/providers/Microsoft.Insights/components/${centralGroupPrefix}-ai"
                        }
                      }
                    ],
                    "title": "Average processor and process CPU utilization",
                    "visualization": {
                      "axisVisualization": {
                        "x": {
                          "axisType": 2,
                          "isVisible": true
                        },
                        "y": {
                          "axisType": 1,
                          "isVisible": true
                        }
                      },
                      "chartType": 2,
                      "legendVisualization": {
                        "hideSubtitle": false,
                        "isVisible": true,
                        "position": 2
                      }
                    }
                  }
                }
              },
              {
                "name": "sharedTimeRange",
                "isOptional": true
              }
            ],
            "type": "Extension/HubsExtension/PartType/MonitorChartPart",
            "settings": {}
          }
        },
        "20": {
          "position": {
            "x": 12,
            "y": 5,
            "colSpan": 4,
            "rowSpan": 3
          },
          "metadata": {
            "inputs": [
              {
                "name": "options",
                "value": {
                  "chart": {
                    "metrics": [
                      {
                        "aggregationType": 7,
                        "metricVisualization": {
                          "color": "#47BDF5",
                          "displayName": "Browser exceptions"
                        },
                        "name": "exceptions/browser",
                        "namespace": "microsoft.insights/components",
                        "resourceMetadata": {
                          "id": "/subscriptions/${subscriptionId}/resourceGroups/${centralGroupPrefix}-rg/providers/Microsoft.Insights/components/${centralGroupPrefix}-ai"
                        }
                      }
                    ],
                    "title": "Browser exceptions",
                    "visualization": {
                      "axisVisualization": {
                        "x": {
                          "axisType": 2,
                          "isVisible": true
                        },
                        "y": {
                          "axisType": 1,
                          "isVisible": true
                        }
                      },
                      "chartType": 2,
                      "legendVisualization": {
                        "hideSubtitle": false,
                        "isVisible": true,
                        "position": 2
                      }
                    }
                  }
                }
              },
              {
                "name": "sharedTimeRange",
                "isOptional": true
              }
            ],
            "type": "Extension/HubsExtension/PartType/MonitorChartPart",
            "settings": {}
          }
        },
        "21": {
          "position": {
            "x": 0,
            "y": 8,
            "colSpan": 4,
            "rowSpan": 3
          },
          "metadata": {
            "inputs": [
              {
                "name": "options",
                "value": {
                  "chart": {
                    "metrics": [
                      {
                        "aggregationType": 7,
                        "metricVisualization": {
                          "color": "#47BDF5",
                          "displayName": "Availability test results count"
                        },
                        "name": "availabilityResults/count",
                        "namespace": "microsoft.insights/components",
                        "resourceMetadata": {
                          "id": "/subscriptions/${subscriptionId}/resourceGroups/${centralGroupPrefix}-rg/providers/Microsoft.Insights/components/${centralGroupPrefix}-ai"
                        }
                      }
                    ],
                    "title": "Availability test results count",
                    "visualization": {
                      "axisVisualization": {
                        "x": {
                          "axisType": 2,
                          "isVisible": true
                        },
                        "y": {
                          "axisType": 1,
                          "isVisible": true
                        }
                      },
                      "chartType": 2,
                      "legendVisualization": {
                        "hideSubtitle": false,
                        "isVisible": true,
                        "position": 2
                      }
                    }
                  }
                }
              },
              {
                "name": "sharedTimeRange",
                "isOptional": true
              }
            ],
            "type": "Extension/HubsExtension/PartType/MonitorChartPart",
            "settings": {}
          }
        },
        "22": {
          "position": {
            "x": 4,
            "y": 8,
            "colSpan": 4,
            "rowSpan": 3
          },
          "metadata": {
            "inputs": [
              {
                "name": "options",
                "value": {
                  "chart": {
                    "metrics": [
                      {
                        "aggregationType": 4,
                        "metricVisualization": {
                          "color": "#47BDF5",
                          "displayName": "Process IO rate"
                        },
                        "name": "performanceCounters/processIOBytesPerSecond",
                        "namespace": "microsoft.insights/components",
                        "resourceMetadata": {
                          "id": "/subscriptions/${subscriptionId}/resourceGroups/${centralGroupPrefix}-rg/providers/Microsoft.Insights/components/${centralGroupPrefix}-ai"
                        }
                      }
                    ],
                    "title": "Average process I/O rate",
                    "visualization": {
                      "axisVisualization": {
                        "x": {
                          "axisType": 2,
                          "isVisible": true
                        },
                        "y": {
                          "axisType": 1,
                          "isVisible": true
                        }
                      },
                      "chartType": 2,
                      "legendVisualization": {
                        "hideSubtitle": false,
                        "isVisible": true,
                        "position": 2
                      }
                    }
                  }
                }
              },
              {
                "name": "sharedTimeRange",
                "isOptional": true
              }
            ],
            "type": "Extension/HubsExtension/PartType/MonitorChartPart",
            "settings": {}
          }
        },
        "23": {
          "position": {
            "x": 8,
            "y": 8,
            "colSpan": 4,
            "rowSpan": 3
          },
          "metadata": {
            "inputs": [
              {
                "name": "options",
                "value": {
                  "chart": {
                    "metrics": [
                      {
                        "aggregationType": 4,
                        "metricVisualization": {
                          "color": "#47BDF5",
                          "displayName": "Available memory"
                        },
                        "name": "performanceCounters/memoryAvailableBytes",
                        "namespace": "microsoft.insights/components",
                        "resourceMetadata": {
                          "id": "/subscriptions/${subscriptionId}/resourceGroups/${centralGroupPrefix}-rg/providers/Microsoft.Insights/components/${centralGroupPrefix}-ai"
                        }
                      }
                    ],
                    "title": "Average available memory",
                    "visualization": {
                      "axisVisualization": {
                        "x": {
                          "axisType": 2,
                          "isVisible": true
                        },
                        "y": {
                          "axisType": 1,
                          "isVisible": true
                        }
                      },
                      "chartType": 2,
                      "legendVisualization": {
                        "hideSubtitle": false,
                        "isVisible": true,
                        "position": 2
                      }
                    }
                  }
                }
              },
              {
                "name": "sharedTimeRange",
                "isOptional": true
              }
            ],
            "type": "Extension/HubsExtension/PartType/MonitorChartPart",
            "settings": {}
          }
        }
      }
    }
  },
  "metadata": {
    "model": {}
  }
}
