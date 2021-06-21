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

/*
.Synopsis
   Terraform Variable Configuration
.DESCRIPTION
   This file holds the Default Variable Configuration
*/

/*
The following items are recommended to override in custom.tfvars

1. Resource Tags
2. Kubernetes Version  ** Lock your version and manage your upgrades.
3. Agent VM Size       ** Current Default Recomendation.
4. Agent VM Count      ** Size as appropriate
5. Agent VM Disk       ** Size as appropriate
6. Feature Flags       ** Configure as desired

*/


prefix = "infra-mvp"

resource_tags = {
  contact = "pipeline"
}

# Kubernetes Settings
kubernetes_version = "1.18.17"
aks_agent_vm_size  = "Standard_E4s_v3"
aks_agent_vm_count = "5"
aks_agent_vm_disk  = 128
subnet_aks_prefix  = "10.10.2.0/23"


# Feature Toggles
feature_flag = {
  osdu_namespace = true
  flux           = true
  sa_lock        = true
}
