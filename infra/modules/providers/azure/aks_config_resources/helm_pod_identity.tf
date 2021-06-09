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
# Pod Identity
#-------------------------------
locals {
  pod_identity_name         = "${var.aks_cluster_name}-pod-identity"
  helm_pod_identity_name    = "aad-pod-identity"
  helm_pod_identity_ns      = "podidentity"
  helm_pod_identity_repo    = "https://raw.githubusercontent.com/Azure/aad-pod-identity/master/charts"
  helm_pod_identity_version = "3.0.0"
}

resource "kubernetes_namespace" "pod_identity" {
  metadata {
    name = local.helm_pod_identity_ns
  }

}

resource "helm_release" "aad_pod_id" {
  name       = local.helm_pod_identity_name
  repository = local.helm_pod_identity_repo
  chart      = "aad-pod-identity"
  version    = local.helm_pod_identity_version
  namespace  = kubernetes_namespace.pod_identity.metadata.0.name

  # set {
  #   name  = "azureIdentities[0].name"
  #   value = "podidentity"
  # }

  //  set {
  //    name  = "azureIdentities.podidentity.enabled"
  //    value = true
  //  }
  //
  //  set {
  //    name  = "azureIdentities.podidentity.namespace"
  //    value = kubernetes_namespace.pod_identity.metadata.0.name
  //  }
  //
  //  set {
  //    name  = "azureIdentities.podidentity.type"
  //    value = 0
  //  }
  //
  //  set {
  //    name  = "azureIdentities.podidentity.resourceID"
  //    value = var.pod_identity_id
  //  }
  //
  //  set {
  //    name  = "azureIdentities.podidentity.clientID"
  //    value = var.pod_principal_id
  //  }
  //
  //  set {
  //    name  = "azureIdentities.podidentity.binding.selector"
  //    value = "podidentity"
  //  }
  //
  //  set {
  //    name  = "azureIdentities.podidentity.binding.name"
  //    value = "podidentitybinding"
  //  }

  depends_on = [kubernetes_namespace.pod_identity]
}
