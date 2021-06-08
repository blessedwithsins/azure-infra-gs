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

}


resource "kubernetes_config_map" "osduconfigmap" {
  count = var.feature_flag.osdu_namespace ? 1 : 0

  metadata {
    name      = "osdu-svc-properties"
    namespace = local.osdu_ns
  }

  data = {
    ENV_TENANT_ID         = var.tenant_id
    ENV_SUBSCRIPTION_NAME = var.subscription_name
    ENV_REGISTRY          = var.container_registry_name
    ENV_KEYVAULT          = format("https://%s.vault.azure.net/", var.key_vault_name)
    ENV_LOG_WORKSPACE_ID  = var.log_analytics_id
    ENV_POSTGRES_USERNAME = var.postgres_username
    ENV_POSTGRES_HOSTNAME = var.postgres_fqdn
  }

  depends_on = [kubernetes_namespace.osdu]
}
