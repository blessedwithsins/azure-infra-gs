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


#-------------------------------
# Kubernetes Config Map
#-------------------------------
locals {
  osdu_ns = "osdu"
}

resource "kubernetes_namespace" "osdu" {
  count = var.feature_flag.osdu_namespace ? 1 : 0

  metadata {
    name = local.osdu_ns
    labels = {
      "istio-injection" = "enabled"
    }
  }

  depends_on = [module.aks]
}


resource "kubernetes_config_map" "osduconfigmap" {
  count = var.feature_flag.osdu_namespace ? 1 : 0

  metadata {
    name      = "osdu-svc-properties"
    namespace = local.osdu_ns
  }

  data = {
    ENV_TENANT_ID         = data.azurerm_client_config.current.tenant_id
    ENV_SUBSCRIPTION_NAME = data.azurerm_subscription.current.display_name
    ENV_REGISTRY          = data.terraform_remote_state.central_resources.outputs.container_registry_name
    ENV_KEYVAULT          = format("https://%s.vault.azure.net/", data.terraform_remote_state.central_resources.outputs.keyvault_name)
    ENV_LOG_WORKSPACE_ID  = data.terraform_remote_state.central_resources.outputs.log_analytics_id
    ENV_POSTGRES_USERNAME = var.postgres_username
    ENV_POSTGRES_HOSTNAME = module.postgreSQL.server_fqdn
  }

  depends_on = [kubernetes_namespace.osdu]
}

resource "kubernetes_config_map" "appgw_configmap" {
  count = var.feature_flag.autoscaling ? 1 : 0

  metadata {
    name      = "osdu-istio-appgw-cert"
    namespace = local.osdu_ns
  }
  data = {
    ENV_SR_GROUP_NAME = azurerm_resource_group.main.name
    ENV_KEYVAULT_NAME = data.terraform_remote_state.central_resources.outputs.keyvault_name
    ENV_CLUSTER_NAME  = module.aks.name
    ENV_APPGW_NAME    = module.istio_appgateway[count.index].name
  }
  depends_on = [kubernetes_namespace.osdu, module.istio_appgateway]
}
