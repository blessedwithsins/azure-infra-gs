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
# Application Gateway Ingress Controller
#-------------------------------
locals {
  helm_agic_name    = "agic"
  helm_agic_ns      = "agic"
  helm_agic_repo    = "https://appgwingress.blob.core.windows.net/ingress-azure-helm-package/"
  helm_agic_version = "1.3.0"
}


resource "kubernetes_namespace" "agic" {
  metadata {
    name = local.helm_agic_ns
  }
}

resource "helm_release" "agic" {
  name       = local.helm_agic_name
  repository = local.helm_agic_repo
  chart      = "ingress-azure"
  version    = local.helm_agic_version
  namespace  = kubernetes_namespace.agic.metadata.0.name


  set {
    name  = "appgw.subscriptionId"
    value = var.subscription_id
  }

  set {
    name  = "appgw.resourceGroup"
    value = var.resource_group_name
  }

  set {
    name  = "appgw.name"
    value = var.appgw_name
  }

  set {
    name  = "armAuth.identityResourceID"
    value = var.agic_identity_id
  }

  set {
    name  = "armAuth.identityClientID"
    value = var.agic_client_id
  }

  set {
    name  = "armAuth.type"
    value = "aadPodIdentity"
  }

  set {
    name  = "appgw.shared"
    value = false
  }

  set {
    name  = "appgw.usePrivateIP"
    value = false
  }

  set {
    name  = "rbac.enabled"
    value = true
  }

  set {
    name  = "verbosityLevel"
    value = 5
  }

  depends_on = [helm_release.aad_pod_id]
}
