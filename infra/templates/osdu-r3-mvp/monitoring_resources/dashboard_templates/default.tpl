{
  "lenses": {
    "0": {
      "order": 0,
      "parts": {
        "0": {
          "position": {
            "x": 0,
            "y": 0,
            "colSpan": 10,
            "rowSpan": 1
          },
          "metadata": {
            "inputs": [],
            "type": "Extension/HubsExtension/PartType/MarkdownPart",
            "settings": {
              "content": {
                "settings": {
                  "content": "# Ingress\n",
                  "title": "",
                  "subtitle": "",
                  "markdownSource": 1,
                  "markdownUri": null
                }
              }
            }
          }
        },
        "1": {
          "position": {
            "x": 10,
            "y": 0,
            "colSpan": 2,
            "rowSpan": 1
          },
          "metadata": {
            "inputs": [
              {
                "name": "ComponentId",
                "value": {
                  "Name": "NetworkInsights-ApplicationGatewayMetrics",
                  "ResourceId": "NetworkInsights-ApplicationGatewayMetrics",
                  "LinkedApplicationType": -2
                }
              },
              {
                "name": "ResourceIds",
                "value": [
                  "/subscriptions/${subscriptionId}/resourceGroups/${serviceGroupPrefix}-rg/providers/Microsoft.Network/applicationGateways/${serviceGroupPrefix}-gw"
                ],
                "isOptional": true
              },
              {
                "name": "Type",
                "value": "workbook",
                "isOptional": true
              },
              {
                "name": "TimeContext",
                "isOptional": true
              },
              {
                "name": "ConfigurationId",
                "value": "community-Workbooks/Network Insights/ApplicationGatewayWorkbooks/Network Insights ApplicationGateways Minified",
                "isOptional": true
              },
              {
                "name": "ViewerMode",
                "value": false,
                "isOptional": true
              },
              {
                "name": "GalleryResourceType",
                "value": "microsoft.network/applicationGateways",
                "isOptional": true
              },
              {
                "name": "NotebookParams",
                "isOptional": true
              },
              {
                "name": "Location",
                "isOptional": true
              },
              {
                "name": "Version",
                "value": "1.0",
                "isOptional": true
              }
            ],
            "type": "Extension/AppInsightsExtension/PartType/NotebookPinnedPart",
            "viewState": {
              "content": {
                "configurationId": "community-Workbooks/Network Insights/ApplicationGatewayWorkbooks/Network Insights ApplicationGateways Minified"
              }
            }
          }
        },
        "2": {
          "position": {
            "x": 12,
            "y": 0,
            "colSpan": 3,
            "rowSpan": 5
          },
          "metadata": {
            "inputs": [
              {
                "name": "resourceGroup",
                "isOptional": true
              },
              {
                "name": "id",
                "value": "/subscriptions/${subscriptionId}/resourceGroups/${serviceGroupPrefix}-rg",
                "isOptional": true
              }
            ],
            "type": "Extension/HubsExtension/PartType/ResourceGroupMapPinnedPart",
            "deepLink": "#@${tenantName}.onmicrosoft.com/resource/subscriptions/${subscriptionId}/resourceGroups/${serviceGroupPrefix}-rg/overview"
          }
        },
        "3": {
          "position": {
            "x": 15,
            "y": 0,
            "colSpan": 3,
            "rowSpan": 5
          },
          "metadata": {
            "inputs": [
              {
                "name": "resourceGroup",
                "isOptional": true
              },
              {
                "name": "id",
                "value": "/subscriptions/${subscriptionId}/resourceGroups/${partitionGroupPrefix}-rg",
                "isOptional": true
              }
            ],
            "type": "Extension/HubsExtension/PartType/ResourceGroupMapPinnedPart",
            "deepLink": "#@${tenantName}.onmicrosoft.com/resource/subscriptions/${subscriptionId}/resourceGroups/${partitionGroupPrefix}-rg/overview"
          }
        },
        "4": {
          "position": {
            "x": 18,
            "y": 0,
            "colSpan": 3,
            "rowSpan": 5
          },
          "metadata": {
            "inputs": [
              {
                "name": "resourceGroup",
                "isOptional": true
              },
              {
                "name": "id",
                "value": "/subscriptions/${subscriptionId}/resourceGroups/${centralGroupPrefix}-rg",
                "isOptional": true
              }
            ],
            "type": "Extension/HubsExtension/PartType/ResourceGroupMapPinnedPart",
            "deepLink": "#@${tenantName}.onmicrosoft.com/resource/subscriptions/${subscriptionId}/resourceGroups/${centralGroupPrefix}-rg/overview"
          }
        },
        "5": {
          "position": {
            "x": 21,
            "y": 0,
            "colSpan": 2,
            "rowSpan": 1
          },
          "metadata": {
            "inputs": [
              {
                "name": "ComponentId",
                "value": {
                  "SubscriptionId": "${subscriptionId}",
                  "ResourceGroup": "${centralGroupPrefix}-rg",
                  "Name": "KeyVaultAnalytics(${centralGroupPrefix}-logs)",
                  "LinkedApplicationType": -1,
                  "ResourceId": "/subscriptions/${subscriptionId}/resourceGroups/${centralGroupPrefix}-rg/providers/Microsoft.OperationsManagement/solutions/KeyVaultAnalytics(${centralGroupPrefix}-logs)",
                  "ResourceType": "microsoft.operationsmanagement/solutions",
                  "IsAzureFirst": true
                }
              },
              {
                "name": "ResourceIds",
                "value": [
                  "/subscriptions/${subscriptionId}/resourcegroups/${centralGroupPrefix}-rg/providers/Microsoft.OperationalInsights/workspaces/${centralGroupPrefix}-logs",
                  "/subscriptions/${subscriptionId}/resourceGroups/${centralGroupPrefix}-rg/providers/Microsoft.OperationsManagement/solutions/KeyVaultAnalytics(${centralGroupPrefix}-logs)"
                ],
                "isOptional": true
              },
              {
                "name": "Type",
                "value": "workbook",
                "isOptional": true
              },
              {
                "name": "TimeContext",
                "isOptional": true
              },
              {
                "name": "ConfigurationId",
                "value": "solutions-https://azmonsolutions.blob.core.windows.net/workbooktemplates/KeyVaultAnalytics/KeyVaultAnalytics.workbook",
                "isOptional": true
              },
              {
                "name": "ViewerMode",
                "value": false,
                "isOptional": true
              },
              {
                "name": "GalleryResourceType",
                "value": "KeyVaultAnalytics",
                "isOptional": true
              },
              {
                "name": "NotebookParams",
                "isOptional": true
              },
              {
                "name": "Location",
                "isOptional": true
              },
              {
                "name": "Version",
                "value": "1.0",
                "isOptional": true
              }
            ],
            "type": "Extension/AppInsightsExtension/PartType/NotebookPinnedPart",
            "viewState": {
              "content": {
                "configurationId": "solutions-https://azmonsolutions.blob.core.windows.net/workbooktemplates/KeyVaultAnalytics/KeyVaultAnalytics.workbook"
              }
            }
          }
        },
        "6": {
          "position": {
            "x": 0,
            "y": 1,
            "colSpan": 12,
            "rowSpan": 4
          },
          "metadata": {
            "inputs": [
              {
                "name": "sharedTimeRange",
                "isOptional": true
              },
              {
                "name": "options",
                "value": {
                  "chart": {
                    "metrics": [
                      {
                        "resourceMetadata": {
                          "id": "/subscriptions/${subscriptionId}/resourceGroups/${serviceGroupPrefix}-rg/providers/Microsoft.Network/applicationGateways/${serviceGroupPrefix}-gw"
                        },
                        "name": "TotalRequests",
                        "aggregationType": 1,
                        "metricVisualization": {
                          "displayName": "Total Requests",
                          "resourceDisplayName": "${serviceGroupPrefix}-gw"
                        }
                      }
                    ],
                    "title": "Sum Total Requests",
                    "titleKind": 2,
                    "visualization": {
                      "chartType": 2
                    },
                    "openBladeOnClick": {
                      "openBlade": true
                    }
                  }
                },
                "isOptional": true
              }
            ],
            "type": "Extension/HubsExtension/PartType/MonitorChartPart",
            "settings": {
              "content": {
                "options": {
                  "chart": {
                    "metrics": [
                      {
                        "resourceMetadata": {
                          "id": "/subscriptions/${subscriptionId}/resourceGroups/${serviceGroupPrefix}-rg/providers/Microsoft.Network/applicationGateways/${serviceGroupPrefix}-gw"
                        },
                        "name": "TotalRequests",
                        "aggregationType": 1,
                        "namespace": "microsoft.network/applicationgateways",
                        "metricVisualization": {
                          "displayName": "Total Requests",
                          "resourceDisplayName": "${serviceGroupPrefix}-gw"
                        }
                      }
                    ],
                    "title": "App Gateway Requests",
                    "titleKind": 2,
                    "visualization": {
                      "chartType": 2,
                      "legendVisualization": {
                        "isVisible": true,
                        "position": 2,
                        "hideSubtitle": false
                      },
                      "axisVisualization": {
                        "x": {
                          "isVisible": true,
                          "axisType": 2
                        },
                        "y": {
                          "isVisible": true,
                          "axisType": 1
                        }
                      },
                      "disablePinning": true
                    }
                  }
                }
              }
            }
          }
        },
        "7": {
          "position": {
            "x": 21,
            "y": 1,
            "colSpan": 2,
            "rowSpan": 1
          },
          "metadata": {
            "inputs": [
              {
                "name": "id",
                "value": "/subscriptions/${subscriptionId}/resourcegroups/${centralGroupPrefix}-rg/providers/Microsoft.OperationsManagement/solutions/AzureAppGatewayAnalytics(${centralGroupPrefix}-logs)"
              }
            ],
            "type": "Extension/Microsoft_OperationsManagementSuite_Workspace/PartType/SolutionPart",
            "asset": {
              "idInputName": "id",
              "type": "Solution"
            },
            "deepLink": "#@azureglobal1.onmicrosoft.com/resource/subscriptions/${subscriptionId}/resourcegroups/${centralGroupPrefix}-rg/providers/Microsoft.OperationsManagement/solutions/AzureAppGatewayAnalytics(${centralGroupPrefix}-logs)/Overview"
          }
        },
        "8": {
          "position": {
            "x": 21,
            "y": 2,
            "colSpan": 2,
            "rowSpan": 1
          },
          "metadata": {
            "inputs": [
              {
                "name": "id",
                "value": "/subscriptions/${subscriptionId}/resourcegroups/${centralGroupPrefix}-rg/providers/microsoft.operationalinsights/workspaces/${centralGroupPrefix}-logs"
              }
            ],
            "type": "Extension/Microsoft_OperationsManagementSuite_Workspace/PartType/WorkspacePart",
            "asset": {
              "idInputName": "id",
              "type": "Workspace"
            },
            "deepLink": "#@azureglobal1.onmicrosoft.com/resource/subscriptions/${subscriptionId}/resourceGroups/${centralGroupPrefix}-rg/providers/Microsoft.OperationalInsights/workspaces/${centralGroupPrefix}-logs/Overview"
          }
        },
        "9": {
          "position": {
            "x": 21,
            "y": 3,
            "colSpan": 2,
            "rowSpan": 1
          },
          "metadata": {
            "inputs": [
              {
                "name": "ResourceId",
                "value": "/subscriptions/${subscriptionId}/resourceGroups/${centralGroupPrefix}-rg/providers/Microsoft.Insights/components/${centralGroupPrefix}-ai"
              }
            ],
            "type": "Extension/AppInsightsExtension/PartType/CuratedBladePerformancePinnedPart",
            "isAdapter": true,
            "asset": {
              "idInputName": "ResourceId",
              "type": "ApplicationInsights"
            },
            "deepLink": "#@azureglobal1.onmicrosoft.com/resource/subscriptions/${subscriptionId}/resourceGroups/${centralGroupPrefix}-rg/providers/Microsoft.Insights/components/${centralGroupPrefix}-ai/performance"
          }
        },
        "10": {
          "position": {
            "x": 21,
            "y": 4,
            "colSpan": 2,
            "rowSpan": 1
          },
          "metadata": {
            "inputs": [
              {
                "name": "ResourceId",
                "value": "/subscriptions/${subscriptionId}/resourceGroups/${centralGroupPrefix}-rg/providers/Microsoft.Insights/components/${centralGroupPrefix}-ai"
              }
            ],
            "type": "Extension/AppInsightsExtension/PartType/CuratedBladeFailuresPinnedPart",
            "isAdapter": true,
            "asset": {
              "idInputName": "ResourceId",
              "type": "ApplicationInsights"
            },
            "deepLink": "#@azureglobal1.onmicrosoft.com/resource/subscriptions/${subscriptionId}/resourceGroups/${centralGroupPrefix}-rg/providers/Microsoft.Insights/components/${centralGroupPrefix}-ai/failures"
          }
        },
        "11": {
          "position": {
            "x": 0,
            "y": 5,
            "colSpan": 12,
            "rowSpan": 4
          },
          "metadata": {
            "inputs": [
              {
                "name": "sharedTimeRange",
                "isOptional": true
              },
              {
                "name": "options",
                "value": {
                  "chart": {
                    "metrics": [
                      {
                        "resourceMetadata": {
                          "id": "/subscriptions/${subscriptionId}/resourceGroups/${serviceGroupPrefix}-rg/providers/Microsoft.Network/applicationGateways/${serviceGroupPrefix}-gw"
                        },
                        "name": "Throughput",
                        "aggregationType": 1,
                        "metricVisualization": {
                          "displayName": "Throughput",
                          "resourceDisplayName": "${serviceGroupPrefix}-gw"
                        }
                      }
                    ],
                    "title": "Sum Throughput",
                    "titleKind": 2,
                    "visualization": {
                      "chartType": 2
                    },
                    "openBladeOnClick": {
                      "openBlade": true
                    }
                  }
                },
                "isOptional": true
              }
            ],
            "type": "Extension/HubsExtension/PartType/MonitorChartPart",
            "settings": {
              "content": {
                "options": {
                  "chart": {
                    "metrics": [
                      {
                        "resourceMetadata": {
                          "id": "/subscriptions/${subscriptionId}/resourceGroups/${serviceGroupPrefix}-rg/providers/Microsoft.Network/applicationGateways/${serviceGroupPrefix}-gw"
                        },
                        "name": "Throughput",
                        "aggregationType": 1,
                        "namespace": "microsoft.network/applicationgateways",
                        "metricVisualization": {
                          "displayName": "Throughput",
                          "resourceDisplayName": "${serviceGroupPrefix}-gw"
                        }
                      }
                    ],
                    "title": "App Gateway Throughput",
                    "titleKind": 2,
                    "visualization": {
                      "chartType": 2,
                      "legendVisualization": {
                        "isVisible": true,
                        "position": 2,
                        "hideSubtitle": false
                      },
                      "axisVisualization": {
                        "x": {
                          "isVisible": true,
                          "axisType": 2
                        },
                        "y": {
                          "isVisible": true,
                          "axisType": 1
                        }
                      },
                      "disablePinning": true
                    }
                  }
                }
              }
            }
          }
        },
        "12": {
          "position": {
            "x": 12,
            "y": 5,
            "colSpan": 4,
            "rowSpan": 4
          },
          "metadata": {
            "inputs": [
              {
                "name": "sharedTimeRange",
                "isOptional": true
              },
              {
                "name": "options",
                "value": {
                  "chart": {
                    "metrics": [
                      {
                        "resourceMetadata": {
                          "id": "/subscriptions/${subscriptionId}/resourceGroups/${centralGroupPrefix}-rg/providers/Microsoft.Insights/components/${centralGroupPrefix}-ai"
                        },
                        "name": "availabilityResults/availabilityPercentage",
                        "aggregationType": 4,
                        "namespace": "microsoft.insights/components",
                        "metricVisualization": {
                          "resourceDisplayName": "${centralGroupPrefix}-ai",
                          "color": "#54A300"
                        }
                      }
                    ],
                    "title": "Availability",
                    "titleKind": 2,
                    "visualization": {
                      "chartType": 2,
                      "axisVisualization": {
                        "y": {
                          "isVisible": true,
                          "min": 0,
                          "max": 100
                        },
                        "x": {
                          "isVisible": true
                        }
                      }
                    },
                    "openBladeOnClick": {
                      "openBlade": true,
                      "destinationBlade": {
                        "bladeName": "ResourceMenuBlade",
                        "parameters": {
                          "id": "/subscriptions/${subscriptionId}/resourceGroups/${centralGroupPrefix}-rg/providers/Microsoft.Insights/components/${centralGroupPrefix}-ai",
                          "menuid": "availability"
                        },
                        "extensionName": "HubsExtension",
                        "options": {
                          "parameters": {
                            "id": "/subscriptions/${subscriptionId}/resourceGroups/${centralGroupPrefix}-rg/providers/Microsoft.Insights/components/${centralGroupPrefix}-ai",
                            "menuid": "availability"
                          }
                        }
                      }
                    }
                  }
                },
                "isOptional": true
              }
            ],
            "type": "Extension/HubsExtension/PartType/MonitorChartPart",
            "settings": {
              "content": {
                "options": {
                  "chart": {
                    "metrics": [
                      {
                        "resourceMetadata": {
                          "id": "/subscriptions/${subscriptionId}/resourceGroups/${centralGroupPrefix}-rg/providers/Microsoft.Insights/components/${centralGroupPrefix}-ai"
                        },
                        "name": "availabilityResults/availabilityPercentage",
                        "aggregationType": 4,
                        "namespace": "microsoft.insights/components",
                        "metricVisualization": {
                          "resourceDisplayName": "${centralGroupPrefix}-ai",
                          "color": "#54A300"
                        }
                      }
                    ],
                    "title": "Availability",
                    "titleKind": 2,
                    "visualization": {
                      "chartType": 2,
                      "axisVisualization": {
                        "y": {
                          "isVisible": true,
                          "min": 0,
                          "max": 100
                        },
                        "x": {
                          "isVisible": true
                        }
                      },
                      "disablePinning": true
                    },
                    "openBladeOnClick": {
                      "openBlade": true,
                      "destinationBlade": {
                        "bladeName": "ResourceMenuBlade",
                        "parameters": {
                          "id": "/subscriptions/${subscriptionId}/resourceGroups/${centralGroupPrefix}-rg/providers/Microsoft.Insights/components/${centralGroupPrefix}-ai",
                          "menuid": "availability"
                        },
                        "extensionName": "HubsExtension",
                        "options": {
                          "parameters": {
                            "id": "/subscriptions/${subscriptionId}/resourceGroups/${centralGroupPrefix}-rg/providers/Microsoft.Insights/components/${centralGroupPrefix}-ai",
                            "menuid": "availability"
                          }
                        }
                      }
                    }
                  }
                }
              }
            }
          }
        },
        "13": {
          "position": {
            "x": 16,
            "y": 5,
            "colSpan": 7,
            "rowSpan": 4
          },
          "metadata": {
            "inputs": [
              {
                "name": "sharedTimeRange",
                "isOptional": true
              },
              {
                "name": "options",
                "value": {
                  "chart": {
                    "grouping": {
                      "dimension": "ActivityType"
                    },
                    "metrics": [
                      {
                        "aggregationType": 7,
                        "metricVisualization": {
                          "displayName": "Total Service Api Hits",
                          "resourceDisplayName": "${centralGroupPrefix}-kv"
                        },
                        "name": "ServiceApiHit",
                        "resourceMetadata": {
                          "id": "/subscriptions/${subscriptionId}/resourceGroups/${centralGroupPrefix}-rg/providers/Microsoft.KeyVault/vaults/${centralGroupPrefix}-kv"
                        }
                      }
                    ],
                    "openBladeOnClick": {
                      "openBlade": true
                    },
                    "title": "Total requests",
                    "titleKind": 2,
                    "visualization": {
                      "chartType": 2
                    }
                  }
                },
                "isOptional": true
              }
            ],
            "type": "Extension/HubsExtension/PartType/MonitorChartPart",
            "settings": {
              "content": {
                "options": {
                  "chart": {
                    "metrics": [
                      {
                        "resourceMetadata": {
                          "id": "/subscriptions/${subscriptionId}/resourceGroups/${centralGroupPrefix}-rg/providers/Microsoft.KeyVault/vaults/${centralGroupPrefix}-kv"
                        },
                        "name": "ServiceApiResult",
                        "aggregationType": 7,
                        "namespace": "microsoft.keyvault/vaults",
                        "metricVisualization": {
                          "displayName": "Total Service Api Results",
                          "resourceDisplayName": "${centralGroupPrefix}-kv"
                        }
                      }
                    ],
                    "title": "Key Vault Requests",
                    "titleKind": 2,
                    "visualization": {
                      "chartType": 2,
                      "legendVisualization": {
                        "hideSubtitle": false,
                        "isVisible": true,
                        "position": 2
                      },
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
                      "disablePinning": true
                    },
                    "grouping": {
                      "dimension": "ActivityType"
                    }
                  }
                }
              }
            }
          }
        },
        "14": {
          "position": {
            "x": 0,
            "y": 9,
            "colSpan": 7,
            "rowSpan": 1
          },
          "metadata": {
            "inputs": [],
            "type": "Extension/HubsExtension/PartType/MarkdownPart",
            "settings": {
              "content": {
                "settings": {
                  "content": "# Cluster",
                  "title": "",
                  "subtitle": "",
                  "markdownSource": 1,
                  "markdownUri": null
                }
              }
            }
          }
        },
        "15": {
          "position": {
            "x": 7,
            "y": 9,
            "colSpan": 2,
            "rowSpan": 1
          },
          "metadata": {
            "inputs": [
              {
                "name": "ComponentId",
                "value": {
                  "SubscriptionId": "${subscriptionId}",
                  "ResourceGroup": "${serviceGroupPrefix}-rg",
                  "Name": "${serviceGroupPrefix}-aks",
                  "LinkedApplicationType": -1,
                  "ResourceId": "/subscriptions/${subscriptionId}/resourceGroups/${serviceGroupPrefix}-rg/providers/Microsoft.ContainerService/managedClusters/${serviceGroupPrefix}-aks",
                  "ResourceType": "microsoft.containerservice/managedclusters",
                  "IsAzureFirst": true
                }
              },
              {
                "name": "ResourceIds",
                "value": [
                  "/subscriptions/${subscriptionId}/resourceGroups/${serviceGroupPrefix}-rg/providers/Microsoft.ContainerService/managedClusters/${serviceGroupPrefix}-aks"
                ],
                "isOptional": true
              },
              {
                "name": "Type",
                "value": "container-insights",
                "isOptional": true
              },
              {
                "name": "TimeContext",
                "isOptional": true
              },
              {
                "name": "ConfigurationId",
                "value": "Community-Workbooks/AKS/Deployments and HPAs",
                "isOptional": true
              },
              {
                "name": "ViewerMode",
                "value": false,
                "isOptional": true
              },
              {
                "name": "GalleryResourceType",
                "value": "microsoft.containerservice/managedclusters",
                "isOptional": true
              },
              {
                "name": "NotebookParams",
                "isOptional": true
              },
              {
                "name": "Location",
                "isOptional": true
              },
              {
                "name": "Version",
                "value": "1.0",
                "isOptional": true
              }
            ],
            "type": "Extension/AppInsightsExtension/PartType/NotebookPinnedPart",
            "viewState": {
              "content": {
                "configurationId": "Community-Workbooks/AKS/Deployments and HPAs"
              }
            }
          }
        },
        "16": {
          "position": {
            "x": 9,
            "y": 9,
            "colSpan": 6,
            "rowSpan": 1
          },
          "metadata": {
            "inputs": [],
            "type": "Extension/HubsExtension/PartType/MarkdownPart",
            "settings": {
              "content": {
                "settings": {
                  "content": "# Storage\n",
                  "title": "",
                  "subtitle": "",
                  "markdownSource": 1,
                  "markdownUri": null
                }
              }
            }
          }
        },
        "17": {
          "position": {
            "x": 15,
            "y": 9,
            "colSpan": 8,
            "rowSpan": 1
          },
          "metadata": {
            "inputs": [],
            "type": "Extension/HubsExtension/PartType/MarkdownPart",
            "settings": {
              "content": {
                "settings": {
                  "content": "# Application",
                  "title": "",
                  "subtitle": "",
                  "markdownSource": 1,
                  "markdownUri": null
                }
              }
            }
          }
        },
        "18": {
          "position": {
            "x": 0,
            "y": 10,
            "colSpan": 9,
            "rowSpan": 4
          },
          "metadata": {
            "inputs": [
              {
                "name": "queryParams",
                "value": {
                  "metricQueryId": "pod-count",
                  "clusterName": "${serviceGroupPrefix}-aks",
                  "clusterResourceId": "/subscriptions/${subscriptionId}/resourceGroups/${serviceGroupPrefix}-rg/providers/Microsoft.ContainerService/managedClusters/${serviceGroupPrefix}-aks",
                  "workspaceResourceId": "/subscriptions/${subscriptionId}/resourceGroups/${centralGroupPrefix}-rg/providers/Microsoft.OperationalInsights/workspaces/${centralGroupPrefix}-logs",
                  "timeRange": {
                    "options": {},
                    "relative": {
                      "duration": 21600000
                    }
                  }
                }
              },
              {
                "name": "bladeName",
                "value": "SingleCluster.ReactView"
              },
              {
                "name": "extensionName",
                "value": "Microsoft_Azure_Monitoring"
              },
              {
                "name": "bladeParams",
                "value": {
                  "armClusterPath": "/subscriptions/${subscriptionId}/resourceGroups/${serviceGroupPrefix}-rg/providers/Microsoft.ContainerService/managedClusters/${serviceGroupPrefix}-aks",
                  "armWorkspacePath": "/subscriptions/${subscriptionId}/resourceGroups/${centralGroupPrefix}-rg/providers/Microsoft.OperationalInsights/workspaces/${centralGroupPrefix}-logs",
                  "clusterRegion": "centralus",
                  "initiator": "ManagedClusterAsset.getMenuConfig",
                  "containerClusterResourceId": "/subscriptions/${subscriptionId}/resourceGroups/${serviceGroupPrefix}-rg/providers/Microsoft.ContainerService/managedClusters/${serviceGroupPrefix}-aks",
                  "containerClusterName": "${serviceGroupPrefix}-aks",
                  "workspaceResourceId": "/subscriptions/${subscriptionId}/resourceGroups/${centralGroupPrefix}-rg/providers/Microsoft.OperationalInsights/workspaces/${centralGroupPrefix}-logs"
                }
              },
              {
                "name": "defaultOptionPicks",
                "value": [
                  {
                    "id": "all",
                    "displayName": "Total",
                    "isSelected": false
                  },
                  {
                    "id": "pending",
                    "displayName": "Pending",
                    "isSelected": true
                  },
                  {
                    "id": "running",
                    "displayName": "Running",
                    "isSelected": true
                  },
                  {
                    "id": "unknown",
                    "displayName": "Unknown",
                    "isSelected": true
                  },
                  {
                    "id": "succeeded",
                    "displayName": "Succeeded",
                    "isSelected": true
                  },
                  {
                    "id": "failed",
                    "displayName": "Failed",
                    "isSelected": true
                  },
                  {
                    "id": "terminating",
                    "displayName": "Terminating",
                    "isSelected": true
                  }
                ]
              },
              {
                "name": "showOptionPicker",
                "value": true
              }
            ],
            "type": "Extension/Microsoft_Azure_Monitoring/PartType/ChartPart"
          }
        },
        "19": {
          "position": {
            "x": 9,
            "y": 10,
            "colSpan": 6,
            "rowSpan": 4
          },
          "metadata": {
            "inputs": [
              {
                "name": "sharedTimeRange",
                "isOptional": true
              },
              {
                "name": "options",
                "value": {
                  "chart": {
                    "metrics": [
                      {
                        "resourceMetadata": {
                          "id": "/subscriptions/${subscriptionId}/resourceGroups/${partitionGroupPrefix}-rg/providers/Microsoft.DocumentDB/databaseAccounts/${partitionGroupPrefix}-db"
                        },
                        "name": "TotalRequestUnits",
                        "aggregationType": 1,
                        "namespace": "microsoft.documentdb/databaseaccounts",
                        "metricVisualization": {
                          "displayName": "Total Request Units"
                        }
                      }
                    ],
                    "title": "Sum Total Request Units for ${partitionGroupPrefix}-db",
                    "titleKind": 1,
                    "visualization": {
                      "chartType": 2,
                      "legendVisualization": {
                        "isVisible": true,
                        "position": 2,
                        "hideSubtitle": false
                      },
                      "axisVisualization": {
                        "x": {
                          "isVisible": true,
                          "axisType": 2
                        },
                        "y": {
                          "isVisible": true,
                          "axisType": 1
                        }
                      }
                    },
                    "timespan": {
                      "relative": {
                        "duration": 86400000
                      },
                      "showUTCTime": false,
                      "grain": 1
                    }
                  }
                },
                "isOptional": true
              }
            ],
            "type": "Extension/HubsExtension/PartType/MonitorChartPart",
            "settings": {
              "content": {
                "options": {
                  "chart": {
                    "metrics": [
                      {
                        "resourceMetadata": {
                          "id": "/subscriptions/${subscriptionId}/resourceGroups/${partitionGroupPrefix}-rg/providers/Microsoft.DocumentDB/databaseAccounts/${partitionGroupPrefix}-db"
                        },
                        "name": "TotalRequestUnits",
                        "aggregationType": 1,
                        "namespace": "microsoft.documentdb/databaseaccounts",
                        "metricVisualization": {
                          "displayName": "Total Request Units"
                        }
                      }
                    ],
                    "title": "Data Partition Cosmos RU",
                    "titleKind": 2,
                    "visualization": {
                      "chartType": 2,
                      "legendVisualization": {
                        "isVisible": true,
                        "position": 2,
                        "hideSubtitle": false
                      },
                      "axisVisualization": {
                        "x": {
                          "isVisible": true,
                          "axisType": 2
                        },
                        "y": {
                          "isVisible": true,
                          "axisType": 1
                        }
                      },
                      "disablePinning": true
                    }
                  }
                }
              }
            }
          }
        },
        "20": {
          "position": {
            "x": 15,
            "y": 10,
            "colSpan": 8,
            "rowSpan": 4
          },
          "metadata": {
            "inputs": [
              {
                "name": "sharedTimeRange",
                "isOptional": true
              },
              {
                "name": "options",
                "value": {
                  "chart": {
                    "metrics": [
                      {
                        "resourceMetadata": {
                          "id": "/subscriptions/${subscriptionId}/resourceGroups/${centralGroupPrefix}-rg/providers/Microsoft.Insights/components/${centralGroupPrefix}-ai"
                        },
                        "name": "requests/failed",
                        "aggregationType": 7,
                        "namespace": "microsoft.insights/components",
                        "metricVisualization": {
                          "displayName": "Failed requests",
                          "resourceDisplayName": "${centralGroupPrefix}-ai",
                          "color": "#EC008C"
                        }
                      }
                    ],
                    "title": "Failed requests",
                    "titleKind": 2,
                    "visualization": {
                      "chartType": 3
                    },
                    "openBladeOnClick": {
                      "openBlade": true,
                      "destinationBlade": {
                        "bladeName": "ResourceMenuBlade",
                        "parameters": {
                          "id": "/subscriptions/${subscriptionId}/resourceGroups/${centralGroupPrefix}-rg/providers/Microsoft.Insights/components/${centralGroupPrefix}-ai",
                          "menuid": "failures"
                        },
                        "extensionName": "HubsExtension",
                        "options": {
                          "parameters": {
                            "id": "/subscriptions/${subscriptionId}/resourceGroups/${centralGroupPrefix}-rg/providers/Microsoft.Insights/components/${centralGroupPrefix}-ai",
                            "menuid": "failures"
                          }
                        }
                      }
                    }
                  }
                },
                "isOptional": true
              }
            ],
            "type": "Extension/HubsExtension/PartType/MonitorChartPart",
            "settings": {
              "content": {
                "options": {
                  "chart": {
                    "metrics": [
                      {
                        "resourceMetadata": {
                          "id": "/subscriptions/${subscriptionId}/resourceGroups/${centralGroupPrefix}-rg/providers/Microsoft.Insights/components/${centralGroupPrefix}-ai"
                        },
                        "name": "requests/failed",
                        "aggregationType": 7,
                        "namespace": "microsoft.insights/components",
                        "metricVisualization": {
                          "displayName": "Failed requests",
                          "resourceDisplayName": "${centralGroupPrefix}-ai",
                          "color": "#EC008C"
                        }
                      }
                    ],
                    "title": "Failed requests",
                    "titleKind": 2,
                    "visualization": {
                      "chartType": 3,
                      "disablePinning": true
                    },
                    "openBladeOnClick": {
                      "openBlade": true,
                      "destinationBlade": {
                        "bladeName": "ResourceMenuBlade",
                        "parameters": {
                          "id": "/subscriptions/${subscriptionId}/resourceGroups/${centralGroupPrefix}-rg/providers/Microsoft.Insights/components/${centralGroupPrefix}-ai",
                          "menuid": "failures"
                        },
                        "extensionName": "HubsExtension",
                        "options": {
                          "parameters": {
                            "id": "/subscriptions/${subscriptionId}/resourceGroups/${centralGroupPrefix}-rg/providers/Microsoft.Insights/components/${centralGroupPrefix}-ai",
                            "menuid": "failures"
                          }
                        }
                      }
                    }
                  }
                }
              }
            }
          }
        },
        "21": {
          "position": {
            "x": 0,
            "y": 14,
            "colSpan": 9,
            "rowSpan": 4
          },
          "metadata": {
            "inputs": [
              {
                "name": "queryParams",
                "value": {
                  "metricQueryId": "cpu",
                  "clusterName": "${serviceGroupPrefix}-aks",
                  "clusterResourceId": "/subscriptions/${subscriptionId}/resourceGroups/${serviceGroupPrefix}-rg/providers/Microsoft.ContainerService/managedClusters/${serviceGroupPrefix}-aks",
                  "workspaceResourceId": "/subscriptions/${subscriptionId}/resourceGroups/${centralGroupPrefix}-rg/providers/Microsoft.OperationalInsights/workspaces/${centralGroupPrefix}-logs",
                  "timeRange": {
                    "options": {},
                    "relative": {
                      "duration": 21600000
                    }
                  }
                }
              },
              {
                "name": "bladeName",
                "value": "SingleCluster.ReactView"
              },
              {
                "name": "extensionName",
                "value": "Microsoft_Azure_Monitoring"
              },
              {
                "name": "bladeParams",
                "value": {
                  "armClusterPath": "/subscriptions/${subscriptionId}/resourceGroups/${serviceGroupPrefix}-rg/providers/Microsoft.ContainerService/managedClusters/${serviceGroupPrefix}-aks",
                  "armWorkspacePath": "/subscriptions/${subscriptionId}/resourceGroups/${centralGroupPrefix}-rg/providers/Microsoft.OperationalInsights/workspaces/${centralGroupPrefix}-logs",
                  "clusterRegion": "centralus",
                  "initiator": "ManagedClusterAsset.getMenuConfig",
                  "containerClusterResourceId": "/subscriptions/${subscriptionId}/resourceGroups/${serviceGroupPrefix}-rg/providers/Microsoft.ContainerService/managedClusters/${serviceGroupPrefix}-aks",
                  "containerClusterName": "${serviceGroupPrefix}-aks",
                  "workspaceResourceId": "/subscriptions/${subscriptionId}/resourceGroups/${centralGroupPrefix}-rg/providers/Microsoft.OperationalInsights/workspaces/${centralGroupPrefix}-logs"
                }
              },
              {
                "name": "defaultOptionPicks",
                "value": [
                  {
                    "id": "Avg",
                    "displayName": "Avg",
                    "isSelected": true
                  },
                  {
                    "id": "Min",
                    "displayName": "Min",
                    "isSelected": false
                  },
                  {
                    "id": "P50",
                    "displayName": "50th",
                    "isSelected": false
                  },
                  {
                    "id": "P90",
                    "displayName": "90th",
                    "isSelected": false
                  },
                  {
                    "id": "P95",
                    "displayName": "95th",
                    "isSelected": false
                  },
                  {
                    "id": "Max",
                    "displayName": "Max",
                    "isSelected": true
                  }
                ]
              },
              {
                "name": "showOptionPicker",
                "value": true
              }
            ],
            "type": "Extension/Microsoft_Azure_Monitoring/PartType/ChartPart"
          }
        },
        "22": {
          "position": {
            "x": 9,
            "y": 14,
            "colSpan": 6,
            "rowSpan": 4
          },
          "metadata": {
            "inputs": [
              {
                "name": "sharedTimeRange",
                "isOptional": true
              },
              {
                "name": "options",
                "value": {
                  "chart": {
                    "metrics": [
                      {
                        "resourceMetadata": {
                          "id": "/subscriptions/${subscriptionId}/resourceGroups/${partitionGroupPrefix}-rg/providers/Microsoft.Storage/storageAccounts/${partitionStorage}"
                        },
                        "name": "Ingress",
                        "aggregationType": 1,
                        "namespace": "microsoft.storage/storageaccounts",
                        "metricVisualization": {
                          "displayName": "Ingress",
                          "resourceDisplayName": "${partitionStorage}"
                        }
                      }
                    ],
                    "title": "Total ingress",
                    "titleKind": 2,
                    "visualization": {
                      "chartType": 2
                    },
                    "openBladeOnClick": {
                      "openBlade": true
                    }
                  }
                },
                "isOptional": true
              }
            ],
            "type": "Extension/HubsExtension/PartType/MonitorChartPart",
            "settings": {
              "content": {
                "options": {
                  "chart": {
                    "metrics": [
                      {
                        "resourceMetadata": {
                          "id": "/subscriptions/${subscriptionId}/resourceGroups/${partitionGroupPrefix}-rg/providers/Microsoft.Storage/storageAccounts/${partitionStorage}"
                        },
                        "name": "Ingress",
                        "aggregationType": 1,
                        "namespace": "microsoft.storage/storageaccounts",
                        "metricVisualization": {
                          "displayName": "Ingress",
                          "resourceDisplayName": "${partitionStorage}"
                        }
                      }
                    ],
                    "title": "Data Partition Storage Ingress",
                    "titleKind": 2,
                    "visualization": {
                      "chartType": 2,
                      "legendVisualization": {
                        "isVisible": true,
                        "position": 2,
                        "hideSubtitle": false
                      },
                      "axisVisualization": {
                        "x": {
                          "isVisible": true,
                          "axisType": 2
                        },
                        "y": {
                          "isVisible": true,
                          "axisType": 1
                        }
                      },
                      "disablePinning": true
                    }
                  }
                }
              }
            }
          }
        },
        "23": {
          "position": {
            "x": 15,
            "y": 14,
            "colSpan": 8,
            "rowSpan": 4
          },
          "metadata": {
            "inputs": [
              {
                "name": "sharedTimeRange",
                "isOptional": true
              },
              {
                "name": "options",
                "value": {
                  "chart": {
                    "metrics": [
                      {
                        "resourceMetadata": {
                          "id": "/subscriptions/${subscriptionId}/resourceGroups/${centralGroupPrefix}-rg/providers/Microsoft.Insights/components/${centralGroupPrefix}-ai"
                        },
                        "name": "requests/duration",
                        "aggregationType": 4,
                        "namespace": "microsoft.insights/components",
                        "metricVisualization": {
                          "displayName": "Server response time",
                          "resourceDisplayName": "${centralGroupPrefix}-ai",
                          "color": "#0078D4"
                        }
                      }
                    ],
                    "title": "Server response time",
                    "titleKind": 2,
                    "visualization": {
                      "chartType": 2
                    },
                    "openBladeOnClick": {
                      "openBlade": true,
                      "destinationBlade": {
                        "bladeName": "ResourceMenuBlade",
                        "parameters": {
                          "id": "/subscriptions/${subscriptionId}/resourceGroups/${centralGroupPrefix}-rg/providers/Microsoft.Insights/components/${centralGroupPrefix}-ai",
                          "menuid": "performance"
                        },
                        "extensionName": "HubsExtension",
                        "options": {
                          "parameters": {
                            "id": "/subscriptions/${subscriptionId}/resourceGroups/${centralGroupPrefix}-rg/providers/Microsoft.Insights/components/${centralGroupPrefix}-ai",
                            "menuid": "performance"
                          }
                        }
                      }
                    }
                  }
                },
                "isOptional": true
              }
            ],
            "type": "Extension/HubsExtension/PartType/MonitorChartPart",
            "settings": {
              "content": {
                "options": {
                  "chart": {
                    "metrics": [
                      {
                        "resourceMetadata": {
                          "id": "/subscriptions/${subscriptionId}/resourceGroups/${centralGroupPrefix}-rg/providers/Microsoft.Insights/components/${centralGroupPrefix}-ai"
                        },
                        "name": "requests/duration",
                        "aggregationType": 4,
                        "namespace": "microsoft.insights/components",
                        "metricVisualization": {
                          "displayName": "Server response time",
                          "resourceDisplayName": "${centralGroupPrefix}-ai",
                          "color": "#0078D4"
                        }
                      }
                    ],
                    "title": "Server response time",
                    "titleKind": 2,
                    "visualization": {
                      "chartType": 2,
                      "disablePinning": true
                    },
                    "openBladeOnClick": {
                      "openBlade": true,
                      "destinationBlade": {
                        "bladeName": "ResourceMenuBlade",
                        "parameters": {
                          "id": "/subscriptions/${subscriptionId}/resourceGroups/${centralGroupPrefix}-rg/providers/Microsoft.Insights/components/${centralGroupPrefix}-ai",
                          "menuid": "performance"
                        },
                        "extensionName": "HubsExtension",
                        "options": {
                          "parameters": {
                            "id": "/subscriptions/${subscriptionId}/resourceGroups/${centralGroupPrefix}-rg/providers/Microsoft.Insights/components/${centralGroupPrefix}-ai",
                            "menuid": "performance"
                          }
                        }
                      }
                    }
                  }
                }
              }
            }
          }
        },
        "24": {
          "position": {
            "x": 0,
            "y": 18,
            "colSpan": 9,
            "rowSpan": 4
          },
          "metadata": {
            "inputs": [
              {
                "name": "queryParams",
                "value": {
                  "metricQueryId": "memory",
                  "clusterName": "${serviceGroupPrefix}-aks",
                  "clusterResourceId": "/subscriptions/${subscriptionId}/resourceGroups/${serviceGroupPrefix}-rg/providers/Microsoft.ContainerService/managedClusters/${serviceGroupPrefix}-aks",
                  "workspaceResourceId": "/subscriptions/${subscriptionId}/resourceGroups/${centralGroupPrefix}-rg/providers/Microsoft.OperationalInsights/workspaces/${centralGroupPrefix}-logs",
                  "timeRange": {
                    "options": {},
                    "relative": {
                      "duration": 21600000
                    }
                  }
                }
              },
              {
                "name": "bladeName",
                "value": "SingleCluster.ReactView"
              },
              {
                "name": "extensionName",
                "value": "Microsoft_Azure_Monitoring"
              },
              {
                "name": "bladeParams",
                "value": {
                  "armClusterPath": "/subscriptions/${subscriptionId}/resourceGroups/${serviceGroupPrefix}-rg/providers/Microsoft.ContainerService/managedClusters/${serviceGroupPrefix}-aks",
                  "armWorkspacePath": "/subscriptions/${subscriptionId}/resourceGroups/${centralGroupPrefix}-rg/providers/Microsoft.OperationalInsights/workspaces/${centralGroupPrefix}-logs",
                  "clusterRegion": "centralus",
                  "initiator": "ManagedClusterAsset.getMenuConfig",
                  "containerClusterResourceId": "/subscriptions/${subscriptionId}/resourceGroups/${serviceGroupPrefix}-rg/providers/Microsoft.ContainerService/managedClusters/${serviceGroupPrefix}-aks",
                  "containerClusterName": "${serviceGroupPrefix}-aks",
                  "workspaceResourceId": "/subscriptions/${subscriptionId}/resourceGroups/${centralGroupPrefix}-rg/providers/Microsoft.OperationalInsights/workspaces/${centralGroupPrefix}-logs"
                }
              },
              {
                "name": "defaultOptionPicks",
                "value": [
                  {
                    "id": "Avg",
                    "displayName": "Avg",
                    "isSelected": true
                  },
                  {
                    "id": "Min",
                    "displayName": "Min",
                    "isSelected": false
                  },
                  {
                    "id": "P50",
                    "displayName": "50th",
                    "isSelected": false
                  },
                  {
                    "id": "P90",
                    "displayName": "90th",
                    "isSelected": false
                  },
                  {
                    "id": "P95",
                    "displayName": "95th",
                    "isSelected": false
                  },
                  {
                    "id": "Max",
                    "displayName": "Max",
                    "isSelected": true
                  }
                ]
              },
              {
                "name": "showOptionPicker",
                "value": true
              }
            ],
            "type": "Extension/Microsoft_Azure_Monitoring/PartType/ChartPart"
          }
        },
        "25": {
          "position": {
            "x": 9,
            "y": 18,
            "colSpan": 6,
            "rowSpan": 4
          },
          "metadata": {
            "inputs": [
              {
                "name": "ComponentId",
                "value": "/subscriptions/${subscriptionId}/resourceGroups/${partitionGroupPrefix}-rg/providers/Microsoft.Storage/storageAccounts/${partitionStorage}",
                "isOptional": true
              },
              {
                "name": "TimeContext",
                "value": null,
                "isOptional": true
              },
              {
                "name": "ResourceIds",
                "isOptional": true
              },
              {
                "name": "ConfigurationId",
                "value": "Community-Workbooks/Individual Storage/Overview",
                "isOptional": true
              },
              {
                "name": "Type",
                "value": "storage-insights",
                "isOptional": true
              },
              {
                "name": "GalleryResourceType",
                "value": "microsoft.storage/storageaccounts",
                "isOptional": true
              },
              {
                "name": "PinName",
                "value": "Storage Account Overview",
                "isOptional": true
              },
              {
                "name": "StepSettings",
                "value": "{\"chartId\":\"workbook85d2d5d7-0e4c-4c24-8d42-47bf8300bdc0\",\"version\":\"MetricsItem/2.0\",\"size\":0,\"chartType\":2,\"resourceType\":\"microsoft.storage/storageaccounts\",\"metricScope\":0,\"resourceParameter\":\"Resource\",\"resourceIds\":[\"{Resource}\"],\"timeContextFromParameter\":\"TimeRange\",\"timeContext\":{\"durationMs\":14400000},\"metrics\":[{\"namespace\":\"microsoft.storage/storageaccounts\",\"metric\":\"microsoft.storage/storageaccounts-Transaction-SuccessE2ELatency\",\"aggregation\":4,\"splitBy\":null},{\"namespace\":\"microsoft.storage/storageaccounts\",\"metric\":\"microsoft.storage/storageaccounts-Transaction-SuccessServerLatency\",\"aggregation\":4}],\"title\":\"Success latency -  End-to-end & Server\",\"gridSettings\":{\"rowLimit\":10000}}",
                "isOptional": true
              },
              {
                "name": "ParameterValues",
                "value": {
                  "Resource": {
                    "type": 5,
                    "value": "/subscriptions/${subscriptionId}/resourceGroups/${partitionGroupPrefix}-rg/providers/Microsoft.Storage/storageAccounts/${partitionStorage}",
                    "formattedValue": "/subscriptions/${subscriptionId}/resourceGroups/${partitionGroupPrefix}-rg/providers/Microsoft.Storage/storageAccounts/${partitionStorage}",
                    "isPending": false,
                    "isWaiting": false,
                    "isFailed": false,
                    "labelValue": "Any one",
                    "displayName": "Storage Account",
                    "specialValue": "value::1"
                  },
                  "TimeRange": {
                    "type": 4,
                    "value": {
                      "durationMs": 14400000,
                      "createdTime": "2021-01-07T19:34:20.489Z",
                      "isInitialTime": false,
                      "grain": 1,
                      "useDashboardTimeRange": false
                    },
                    "formattedValue": "Last 4 hours",
                    "isPending": false,
                    "isWaiting": false,
                    "isFailed": false,
                    "labelValue": "Last 4 hours",
                    "displayName": "Time Range"
                  },
                  "tab": {
                    "type": 1,
                    "value": "overview",
                    "formattedValue": "overview"
                  }
                },
                "isOptional": true
              },
              {
                "name": "Location",
                "isOptional": true
              }
            ],
            "type": "Extension/AppInsightsExtension/PartType/PinnedNotebookMetricsPart"
          }
        },
        "26": {
          "position": {
            "x": 15,
            "y": 18,
            "colSpan": 8,
            "rowSpan": 4
          },
          "metadata": {
            "inputs": [
              {
                "name": "ComponentId",
                "value": "/subscriptions/${subscriptionId}/resourceGroups/${serviceGroupPrefix}-rg/providers/Microsoft.Cache/Redis/${serviceGroupPrefix}-cache",
                "isOptional": true
              },
              {
                "name": "TimeContext",
                "value": null,
                "isOptional": true
              },
              {
                "name": "ResourceIds",
                "isOptional": true
              },
              {
                "name": "ConfigurationId",
                "value": "Community-Workbooks/Resource Insights/RedisCache",
                "isOptional": true
              },
              {
                "name": "Type",
                "value": "rediscache-insights",
                "isOptional": true
              },
              {
                "name": "GalleryResourceType",
                "value": "microsoft.cache/redis",
                "isOptional": true
              },
              {
                "name": "PinName",
                "value": "",
                "isOptional": true
              },
              {
                "name": "StepSettings",
                "value": "{\"chartId\":\"workbook11988d6a-5d1d-48b8-83d0-044d7341608c\",\"version\":\"MetricsItem/2.0\",\"size\":0,\"chartType\":2,\"resourceType\":\"microsoft.cache/redis\",\"metricScope\":0,\"resourceParameter\":\"Resource\",\"resourceIds\":[\"{Resource}\"],\"timeContext\":{\"durationMs\":14400000},\"metrics\":[{\"namespace\":\"microsoft.cache/redis\",\"metric\":\"microsoft.cache/redis--cachehits\",\"aggregation\":1,\"splitBy\":null},{\"namespace\":\"microsoft.cache/redis\",\"metric\":\"microsoft.cache/redis--cachemisses\",\"aggregation\":1}],\"title\":\"Cache Hit and Miss\",\"showOpenInMe\":true,\"gridSettings\":{\"rowLimit\":10000}}",
                "isOptional": true
              },
              {
                "name": "ParameterValues",
                "value": {
                  "Resource": {
                    "type": 5,
                    "value": "/subscriptions/${subscriptionId}/resourceGroups/${serviceGroupPrefix}-rg/providers/Microsoft.Cache/Redis/${serviceGroupPrefix}-cache",
                    "formattedValue": "/subscriptions/${subscriptionId}/resourceGroups/${serviceGroupPrefix}-rg/providers/Microsoft.Cache/Redis/${serviceGroupPrefix}-cache",
                    "isPending": false,
                    "isWaiting": false,
                    "isFailed": false,
                    "labelValue": "Any one",
                    "displayName": "Redis Cache",
                    "specialValue": "value::1"
                  },
                  "TimeRange": {
                    "type": 4,
                    "value": {
                      "durationMs": 14400000,
                      "createdTime": "2021-01-07T20:43:33.779Z",
                      "isInitialTime": false,
                      "grain": 1,
                      "useDashboardTimeRange": false
                    },
                    "formattedValue": "Last 4 hours",
                    "isPending": false,
                    "isWaiting": false,
                    "isFailed": false,
                    "labelValue": "Last 4 hours",
                    "displayName": "Time Range"
                  },
                  "tab": {
                    "type": 1,
                    "value": "performance",
                    "formattedValue": "performance"
                  }
                },
                "isOptional": true
              },
              {
                "name": "Location",
                "isOptional": true
              }
            ],
            "type": "Extension/AppInsightsExtension/PartType/PinnedNotebookMetricsPart"
          }
        },
        "27": {
          "position": {
            "x": 0,
            "y": 22,
            "colSpan": 9,
            "rowSpan": 4
          },
          "metadata": {
            "inputs": [
              {
                "name": "ComponentId",
                "value": "/subscriptions/${subscriptionId}/resourceGroups/${serviceGroupPrefix}-rg/providers/Microsoft.ContainerService/managedClusters/${serviceGroupPrefix}-aks",
                "isOptional": true
              },
              {
                "name": "TimeContext",
                "value": null,
                "isOptional": true
              },
              {
                "name": "ResourceIds",
                "value": [
                  "/subscriptions/${subscriptionId}/resourceGroups/${serviceGroupPrefix}-rg/providers/Microsoft.ContainerService/managedClusters/${serviceGroupPrefix}-aks"
                ],
                "isOptional": true
              },
              {
                "name": "ConfigurationId",
                "value": "Community-Workbooks/AKS/Node Network",
                "isOptional": true
              },
              {
                "name": "Type",
                "value": "container-insights",
                "isOptional": true
              },
              {
                "name": "GalleryResourceType",
                "value": "microsoft.containerservice/managedclusters",
                "isOptional": true
              },
              {
                "name": "PinName",
                "value": "Network",
                "isOptional": true
              },
              {
                "name": "StepSettings",
                "value": "{\"version\":\"KqlItem/1.0\",\"query\":\"let bytesSentPerSecond = InsightsMetrics\\r\\n| where Origin == 'container.azm.ms/telegraf'\\r\\n| where Namespace == 'container.azm.ms/net'\\r\\n| where Name == 'bytes_sent'\\r\\n| extend Tags = todynamic(Tags)\\r\\n| extend ClusterId = tostring(Tags['container.azm.ms/clusterId']), HostName = tostring(Tags.hostName), Interface = tostring(Tags.interface)\\r\\n{clusterIdWhereClause}\\r\\n| where '*' in ({selectedNodes1}) or HostName in ({selectedNodes1})\\r\\n| where '*' in ({selectedInterfaces1}) or Interface in ({selectedInterfaces1})\\r\\n| extend partitionKey = strcat(HostName, '/', Interface)\\r\\n| order by partitionKey asc, TimeGenerated asc\\r\\n| serialize\\r\\n| extend PrevVal = iif(prev(partitionKey) != partitionKey, 0.0, prev(Val)), PrevTimeGenerated = iif(prev(partitionKey) != partitionKey, datetime(null), prev(TimeGenerated))\\r\\n| where isnotnull(PrevTimeGenerated) and PrevTimeGenerated != TimeGenerated\\r\\n| extend Rate = iif(PrevVal > Val, Val / (datetime_diff('Second', TimeGenerated, PrevTimeGenerated) * {unit}), (Val - PrevVal) / (datetime_diff('Second', TimeGenerated, PrevTimeGenerated) * {unit}))\\r\\n| where isnotnull(Rate)\\r\\n| project TimeGenerated, HostName, Interface, Rate;\\r\\nlet maxOn = indexof(\\\"{aggregation1}\\\", 'Max');\\r\\nlet avgOn = indexof(\\\"{aggregation1}\\\", 'Average');\\r\\nlet minOn = indexof(\\\"{aggregation1}\\\", 'Min');\\r\\nbytesSentPerSecond\\r\\n| make-series Val = iif(avgOn != -1, avg(Rate), iif(maxOn != -1, max(Rate), min(Rate))) default=0 on TimeGenerated from {timeRange:start} to {timeRange:end} step {timeRange:grain} by HostName, Interface\\r\\n| extend Name = strcat(HostName, Interface)\\r\\n| project-away HostName, Interface\",\"size\":0,\"aggregation\":1,\"showAnalytics\":true,\"timeContext\":{\"durationMs\":21600000},\"timeContextFromParameter\":\"timeRange\",\"queryType\":0,\"resourceType\":\"{resourceType}\",\"crossComponentResources\":[\"{resource}\"],\"visualization\":\"timechart\",\"tileSettings\":{\"showBorder\":false}}",
                "isOptional": true
              },
              {
                "name": "ParameterValues",
                "value": {
                  "timeRange": {
                    "type": 4,
                    "value": {
                      "durationMs": 21600000,
                      "createdTime": "2021-01-07T19:19:20.814Z",
                      "isInitialTime": false,
                      "grain": 1,
                      "useDashboardTimeRange": false
                    },
                    "formattedValue": "Last 6 hours",
                    "isPending": false,
                    "isWaiting": false,
                    "isFailed": false,
                    "labelValue": "Last 6 hours",
                    "displayName": "Time Range"
                  },
                  "resource": {
                    "type": 5,
                    "value": "/subscriptions/${subscriptionId}/resourceGroups/${serviceGroupPrefix}-rg/providers/Microsoft.ContainerService/managedClusters/${serviceGroupPrefix}-aks",
                    "formattedValue": "/subscriptions/${subscriptionId}/resourceGroups/${serviceGroupPrefix}-rg/providers/Microsoft.ContainerService/managedClusters/${serviceGroupPrefix}-aks",
                    "isPending": false,
                    "isWaiting": false,
                    "isFailed": false,
                    "labelValue": "Any one",
                    "displayName": "resource",
                    "specialValue": "value::1"
                  },
                  "resourceType": {
                    "type": 7,
                    "value": "microsoft.containerservice/managedclusters",
                    "formattedValue": "microsoft.containerservice/managedclusters",
                    "isPending": false,
                    "isWaiting": false,
                    "isFailed": false,
                    "labelValue": "Any one",
                    "displayName": "resourceType",
                    "specialValue": "value::1"
                  },
                  "clusterId": {
                    "type": 1,
                    "value": "/subscriptions/${subscriptionId}/resourceGroups/${serviceGroupPrefix}-rg/providers/Microsoft.ContainerService/managedClusters/${serviceGroupPrefix}-aks",
                    "formattedValue": "/subscriptions/${subscriptionId}/resourceGroups/${serviceGroupPrefix}-rg/providers/Microsoft.ContainerService/managedClusters/${serviceGroupPrefix}-aks",
                    "isPending": false,
                    "isWaiting": false,
                    "isFailed": false,
                    "labelValue": "/subscriptions/${subscriptionId}/resourceGroups/${serviceGroupPrefix}-rg/providers/Microsoft.ContainerService/managedClusters/${serviceGroupPrefix}-aks",
                    "displayName": "clusterId"
                  },
                  "clusterIdWhereClause": {
                    "type": 1,
                    "value": "| where \"a\" == \"a\"",
                    "formattedValue": "| where \"a\" == \"a\"",
                    "isPending": false,
                    "isWaiting": false,
                    "isFailed": false,
                    "labelValue": "| where \"a\" == \"a\"",
                    "displayName": "clusterIdWhereClause"
                  },
                  "unit": {
                    "type": 2,
                    "value": "1000000",
                    "formattedValue": "1000000",
                    "isPending": false,
                    "isWaiting": false,
                    "isFailed": false,
                    "labelValue": "Megabytes",
                    "displayName": "Unit"
                  },
                  "aggregation1": {
                    "type": 2,
                    "value": "Max",
                    "formattedValue": "Max",
                    "isPending": false,
                    "isWaiting": false,
                    "isFailed": false,
                    "labelValue": "Max",
                    "displayName": "Aggregation"
                  },
                  "selectedNodes1": {
                    "type": 2,
                    "value": [
                      "*"
                    ],
                    "formattedValue": "'*'",
                    "isPending": false,
                    "isWaiting": false,
                    "isFailed": false,
                    "labelValue": "All",
                    "displayName": "Node",
                    "specialValue": [
                      "value::all"
                    ]
                  },
                  "selectedInterfaces1": {
                    "type": 2,
                    "value": [
                      "eth0"
                    ],
                    "formattedValue": "'eth0'",
                    "isPending": false,
                    "isWaiting": false,
                    "isFailed": false,
                    "labelValue": "eth0",
                    "displayName": "Interface"
                  }
                },
                "isOptional": true
              },
              {
                "name": "Location",
                "isOptional": true
              }
            ],
            "type": "Extension/AppInsightsExtension/PartType/PinnedNotebookQueryPart"
          }
        },
        "28": {
          "position": {
            "x": 9,
            "y": 22,
            "colSpan": 3,
            "rowSpan": 4
          },
          "metadata": {
            "inputs": [
              {
                "name": "sharedTimeRange",
                "isOptional": true
              },
              {
                "name": "options",
                "value": {
                  "chart": {
                    "metrics": [
                      {
                        "aggregationType": 4,
                        "metricVisualization": {
                          "displayName": "Count of active messages in a Queue/Topic."
                        },
                        "name": "ActiveMessages",
                        "namespace": "microsoft.servicebus/namespaces",
                        "resourceMetadata": {
                          "id": "/subscriptions/${subscriptionId}/resourceGroups/${partitionGroupPrefix}-rg/providers/Microsoft.ServiceBus/namespaces/${partitionGroupPrefix}-bus"
                        }
                      }
                    ],
                    "timespan": {
                      "grain": 1,
                      "relative": {
                        "duration": 86400000
                      },
                      "showUTCTime": false
                    },
                    "title": "Avg Count of active messages in a Queue/Topic. for ${partitionGroupPrefix}-bus",
                    "titleKind": 1,
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
                },
                "isOptional": true
              }
            ],
            "type": "Extension/HubsExtension/PartType/MonitorChartPart",
            "settings": {
              "content": {
                "options": {
                  "chart": {
                    "metrics": [
                      {
                        "resourceMetadata": {
                          "id": "/subscriptions/${subscriptionId}/resourceGroups/${partitionGroupPrefix}-rg/providers/Microsoft.ServiceBus/namespaces/${partitionGroupPrefix}-bus"
                        },
                        "name": "ActiveMessages",
                        "aggregationType": 4,
                        "namespace": "microsoft.servicebus/namespaces",
                        "metricVisualization": {
                          "displayName": "Count of active messages in a Queue/Topic.",
                          "resourceDisplayName": "${partitionGroupPrefix}-bus"
                        }
                      }
                    ],
                    "title": "Message Count",
                    "titleKind": 2,
                    "visualization": {
                      "chartType": 2,
                      "legendVisualization": {
                        "hideSubtitle": false,
                        "isVisible": true,
                        "position": 2
                      },
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
                      "disablePinning": true
                    }
                  }
                }
              }
            }
          }
        },
        "29": {
          "position": {
            "x": 12,
            "y": 22,
            "colSpan": 3,
            "rowSpan": 4
          },
          "metadata": {
            "inputs": [
              {
                "name": "sharedTimeRange",
                "isOptional": true
              },
              {
                "name": "options",
                "value": {
                  "chart": {
                    "metrics": [
                      {
                        "aggregationType": 4,
                        "metricVisualization": {
                          "displayName": "Count of dead-lettered messages in a Queue/Topic."
                        },
                        "name": "DeadletteredMessages",
                        "namespace": "microsoft.servicebus/namespaces",
                        "resourceMetadata": {
                          "id": "/subscriptions/929e9ae0-7bb1-4563-a200-9863fe27cae4/resourceGroups/osdu-mvp-dp1scholl-mx8u-rg/providers/Microsoft.ServiceBus/namespaces/osdu-mvp-dp1scholl-mx8u-bus"
                        }
                      }
                    ],
                    "timespan": {
                      "grain": 1,
                      "relative": {
                        "duration": 86400000
                      },
                      "showUTCTime": false
                    },
                    "title": "Avg Count of dead-lettered messages in a Queue/Topic. for osdu-mvp-dp1scholl-mx8u-bus",
                    "titleKind": 1,
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
                },
                "isOptional": true
              }
            ],
            "type": "Extension/HubsExtension/PartType/MonitorChartPart",
            "settings": {
              "content": {
                "options": {
                  "chart": {
                    "metrics": [
                      {
                        "resourceMetadata": {
                          "id": "/subscriptions/929e9ae0-7bb1-4563-a200-9863fe27cae4/resourceGroups/osdu-mvp-dp1scholl-mx8u-rg/providers/Microsoft.ServiceBus/namespaces/osdu-mvp-dp1scho-mx8u-bus"
                        },
                        "name": "DeadletteredMessages",
                        "aggregationType": 4,
                        "namespace": "microsoft.servicebus/namespaces",
                        "metricVisualization": {
                          "displayName": "Count of dead-lettered messages in a Queue/Topic.",
                          "resourceDisplayName": "osdu-mvp-dp1scho-mx8u-bus"
                        }
                      }
                    ],
                    "title": "Avg Count of dead-lettered messages in a Queue/Topic. for osdu-mvp-dp1scho-mx8u-bus",
                    "titleKind": 1,
                    "visualization": {
                      "chartType": 2,
                      "legendVisualization": {
                        "hideSubtitle": false,
                        "isVisible": true,
                        "position": 2
                      },
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
                      "disablePinning": true
                    }
                  }
                }
              }
            }
          }
        },
        "30": {
          "position": {
            "x": 15,
            "y": 22,
            "colSpan": 6,
            "rowSpan": 4
          },
          "metadata": {
            "inputs": [
              {
                "name": "ResourceId",
                "value": "/subscriptions/${subscriptionId}/resourceGroups/${centralGroupPrefix}-rg/providers/Microsoft.Insights/components/${centralGroupPrefix}-ai"
              },
              {
                "name": "ComponentId",
                "value": {
                  "SubscriptionId": "${subscriptionId}",
                  "ResourceGroup": "${centralGroupPrefix}-rg",
                  "Name": "${centralGroupPrefix}-ai",
                  "LinkedApplicationType": 0,
                  "ResourceId": "/subscriptions/${subscriptionId}/resourceGroups/${centralGroupPrefix}-rg/providers/Microsoft.Insights/components/${centralGroupPrefix}-ai",
                  "ResourceType": "microsoft.insights/components",
                  "IsAzureFirst": false
                }
              },
              {
                "name": "TargetBlade",
                "value": "Performance"
              },
              {
                "name": "DataModel",
                "value": {
                  "version": "1.0.0",
                  "experience": 1,
                  "clientTypeMode": "Server",
                  "timeContext": {
                    "durationMs": 3600000,
                    "createdTime": "2021-01-07T20:36:58.22Z",
                    "endTime": null,
                    "isInitialTime": false,
                    "grain": 1,
                    "useDashboardTimeRange": false
                  },
                  "prefix": "let OperationIdsWithExceptionType = (excType: string) { exceptions | where timestamp > ago(1h) \n    | where tobool(iff(excType == \"null\", isempty(type), type == excType)) \n    | distinct operation_ParentId };\nlet OperationIdsWithFailedReqResponseCode = (respCode: string) { requests | where timestamp > ago(1h)\n    | where iff(respCode == \"null\", isempty(resultCode), resultCode == respCode) and success == false \n    | distinct id };\nlet OperationIdsWithFailedDependencyType = (depType: string) { dependencies | where timestamp > ago(1h)\n    | where iff(depType == \"null\", isempty(type), type == depType) and success == false \n    | distinct operation_ParentId };\nlet OperationIdsWithFailedDepResponseCode = (respCode: string) { dependencies | where timestamp > ago(1h)\n    | where iff(respCode == \"null\", isempty(resultCode), resultCode == respCode) and success == false \n    | distinct operation_ParentId };\nlet OperationIdsWithExceptionBrowser = (browser: string) { exceptions | where timestamp > ago(1h)\n    | where tobool(iff(browser == \"null\", isempty(client_Browser), client_Browser == browser)) \n    | distinct operation_ParentId };",
                  "percentile": 1,
                  "grain": "1m",
                  "selectedOperation": null,
                  "selectedOperationName": null,
                  "filters": []
                },
                "isOptional": true
              },
              {
                "name": "Version",
                "value": "1.0"
              }
            ],
            "type": "Extension/AppInsightsExtension/PartType/PerformanceCuratedPinnedChartPart",
            "asset": {
              "idInputName": "ResourceId",
              "type": "ApplicationInsights"
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
              "format": "local",
              "granularity": "auto",
              "relative": "4h"
            },
            "displayCache": {
              "name": "Local Time",
              "value": "Past 4 hours"
            },
            "filteredPartIds": [
              "StartboardPart-MonitorChartPart-8bb9f866-7756-4cf9-8647-95b1aeb1c689",
              "StartboardPart-MonitorChartPart-8bb9f866-7756-4cf9-8647-95b1aeb1c697",
              "StartboardPart-MonitorChartPart-8bb9f866-7756-4cf9-8647-95b1aeb1c699",
              "StartboardPart-MonitorChartPart-8bb9f866-7756-4cf9-8647-95b1aeb1c69b",
              "StartboardPart-ChartPart-8bb9f866-7756-4cf9-8647-95b1aeb1c6a5",
              "StartboardPart-MonitorChartPart-8bb9f866-7756-4cf9-8647-95b1aeb1c6a7",
              "StartboardPart-MonitorChartPart-8bb9f866-7756-4cf9-8647-95b1aeb1c6a9",
              "StartboardPart-ChartPart-8bb9f866-7756-4cf9-8647-95b1aeb1c6ab",
              "StartboardPart-MonitorChartPart-8bb9f866-7756-4cf9-8647-95b1aeb1c6ad",
              "StartboardPart-MonitorChartPart-8bb9f866-7756-4cf9-8647-95b1aeb1c6af",
              "StartboardPart-ChartPart-8bb9f866-7756-4cf9-8647-95b1aeb1c6b1",
              "StartboardPart-PinnedNotebookMetricsPart-8bb9f866-7756-4cf9-8647-95b1aeb1c6b3",
              "StartboardPart-PinnedNotebookMetricsPart-8bb9f866-7756-4cf9-8647-95b1aeb1c6b5",
              "StartboardPart-PinnedNotebookQueryPart-8bb9f866-7756-4cf9-8647-95b1aeb1c6b7",
              "StartboardPart-MonitorChartPart-8bb9f866-7756-4cf9-8647-95b1aeb1c6b9",
              "StartboardPart-MonitorChartPart-8bb9f866-7756-4cf9-8647-95b1aeb1c6bb"
            ]
          }
        }
      }
    }
  }
}
