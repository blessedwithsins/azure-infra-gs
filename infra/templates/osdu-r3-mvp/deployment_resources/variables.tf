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
   This file holds the Variable Configuration
*/


#-------------------------------
# Application Variables
#-------------------------------
variable "prefix" {
  description = "(Required) An identifier used to construct the names of all resources in this template."
  type        = string
}

variable "feature_flag" {
  description = "(Optional) A toggle for incubator features"
  type = object({
    osdu_namespace = bool
    flux           = bool
    sa_lock        = bool
  })
  default = {
    osdu_namespace = true
    flux           = true
    sa_lock        = true
  }
}

variable "randomization_level" {
  description = "Number of additional random characters to include in resource names to insulate against unexpected resource name collisions."
  type        = number
  default     = 4
}

variable "remote_state_account" {
  description = "Remote Terraform State Azure storage account name. This is typically set as an environment variable and used for the initial terraform init."
  type        = string
}

variable "remote_state_container" {
  description = "Remote Terraform State Azure storage container name. This is typically set as an environment variable and used for the initial terraform init."
  type        = string
}

variable "central_resources_workspace_name" {
  description = "(Required) The workspace name for the central_resources repository terraform environment / template to reference for this template."
  type        = string
}

variable "service_resources_workspace_name" {
  description = "(Required) The workspace name for the service_resources repository terraform environment / template to reference for this template."
  type        = string
}

variable "resource_group_location" {
  description = "(Required) The Azure region where all resources in this template should be created."
  type        = string
}

variable "resource_tags" {
  description = "Map of tags to apply to this template."
  type        = map(string)
  default     = {}
}

variable "log_retention_days" {
  description = "Number of days to retain logs."
  type        = number
  default     = 100
}


variable "dns_name" {
  description = "Default DNS Name for the Public IP"
  type        = string
  default     = "osdu.contoso.com"
}

variable "address_space" {
  description = "The address space that is used by the virtual network."
  type        = string
  default     = "10.10.0.0/16"
}

variable "subnet_fe_prefix" {
  description = "The address prefix to use for the frontend subnet."
  type        = string
  default     = "10.10.1.0/26"
}

variable "subnet_aks_prefix" {
  description = "The address prefix to use for the aks subnet."
  type        = string
  default     = "10.10.2.0/24"
}

variable "subnet_be_prefix" {
  description = "The address prefix to use for the backend subnet."
  type        = string
  default     = "10.10.3.0/28"
}

variable "aks_agent_vm_count" {
  description = "The initial number of agent pools / nodes allocated to the AKS cluster"
  type        = string
  default     = "3"
}

variable "aks_agent_vm_maxcount" {
  description = "The max number of nodes allocated to the AKS cluster"
  type        = string
  default     = "10"
}

variable "aks_agent_vm_size" {
  type        = string
  description = "The size of each VM in the Agent Pool (e.g. Standard_F1). Changing this forces a new resource to be created."
  default     = "Standard_D2s_v3"
}

variable "aks_agent_vm_disk" {
  description = "The initial sice of each VM OS Disk."
  type        = number
  default     = 30
}

variable "kubernetes_version" {
  type    = string
  default = "1.17.11"
}

variable "ssh_public_key_file" {
  type        = string
  description = "(Required) The SSH public key used to setup log-in credentials on the nodes in the AKS cluster."
}

variable "flux_recreate" {
  description = "Make any change to this value to trigger the recreation of the flux execution script."
  type        = string
  default     = "false"
}

variable "gitops_ssh_url" {
  type        = string
  description = "(Required) ssh git clone repository URL with Kubernetes manifests including services which runs in the cluster. Flux monitors this repo for Kubernetes manifest additions/changes periodically and apply them in the cluster."
}

variable "gitops_ssh_key_file" {
  type        = string
  description = "(Required) SSH key used to establish a connection to a private git repo containing the HLD manifest."
}

variable "gitops_branch" {
  type        = string
  description = "(Optional) The branch for flux to watch"
  default     = "master"
}

variable "gitops_path" {
  type        = string
  description = "(Optional) The path for flux to watch"
  default     = "providers/azure/hld-registry"
}

variable "ssl_policy_type" {
  description = "The Type of the Policy. Possible values are Predefined and Custom."
  type        = string
  default     = "Custom"
}

variable "ssl_policy_cipher_suites" {
  description = "A List of accepted cipher suites."
  type        = list(string)
  default     = ["TLS_ECDHE_ECDSA_WITH_AES_128_GCM_SHA256", "TLS_ECDHE_ECDSA_WITH_AES_256_GCM_SHA384", "TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384", "TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256"]
}

variable "ssl_policy_min_protocol_version" {
  description = "The minimal TLS version. Possible values are TLSv1_0, TLSv1_1 and TLSv1_2"
  type        = string
  default     = "TLSv1_2"
}

variable "appgw_min_capacity" {
  description = "Minimum number of instances to run in the App Gateway"
  type        = number
  default     = 2
}

variable "appgw_max_capacity" {
  description = "Maximum number of instances to run in the App Gateway"
  type        = number
  default     = 10
}
