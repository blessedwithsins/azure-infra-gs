variable "resource_group_name" {
  description = "The address space that is used by the virtual network."
  type        = string
}

variable "resource_group_id" {
  description = "The address space that is used by the virtual network."
  type        = string
}

variable "resource_group_location" {
  description = "The address space that is used by the virtual network."
  type        = string
}

variable "resource_tags" {
  description = "Map of tags to apply to this template."
  type        = map(string)
}

variable "vnet_name" {
  description = "The address space that is used by the virtual network."
  type        = string
}

variable "fe_subnet_name" {
  description = "The address space that is used by the virtual network."
  type        = string
}

variable "aks_subnet_name" {
  description = "The address space that is used by the virtual network."
  type        = string
}

variable "address_space" {
  description = "The address space that is used by the virtual network."
  type        = string
}

variable "subnet_fe_prefix" {
  description = "The address prefix to use for the frontend subnet."
  type        = string
}

variable "subnet_aks_prefix" {
  description = "The address prefix to use for the aks subnet."
  type        = string
}

variable "subnet_be_prefix" {
  description = "The address prefix to use for the backend subnet."
  type        = string
}

variable "appgw_name" {
  description = "The address space that is used by the virtual network."
  type        = string
}

variable "keyvault_id" {
  description = "The address space that is used by the virtual network."
  type        = string
}

variable "ssl_cert_secret_id" {
  description = "The address space that is used by the virtual network."
  type        = string
}

variable "ssl_cert_name" {
  description = "The address space that is used by the virtual network."
  type        = string
}

variable "ssl_policy_type" {
  description = "The Type of the Policy. Possible values are Predefined and Custom."
  type        = string
}

variable "ssl_policy_cipher_suites" {
  description = "A List of accepted cipher suites."
  type        = list(string)
}

variable "ssl_policy_min_protocol_version" {
  description = "The minimal TLS version. Possible values are TLSv1_0, TLSv1_1 and TLSv1_2"
  type        = string
}

variable "appgw_min_capacity" {
  description = "Minimum number of instances to run in the App Gateway"
  type        = number
}

variable "appgw_max_capacity" {
  description = "Maximum number of instances to run in the App Gateway"
  type        = number
}

variable "aks_cluster_name" {
  description = "The address space that is used by the virtual network."
  type        = string
}

variable "aks_dns_prefix" {
  description = "The address space that is used by the virtual network."
  type        = string
}

variable "log_analytics_id" {
  description = "The address space that is used by the virtual network."
  type        = string
}

variable "log_retention_days" {
  description = "Number of days to retain logs."
  type        = number
}

variable "aks_agent_vm_count" {
  description = "The initial number of agent pools / nodes allocated to the AKS cluster"
  type        = string
}

variable "aks_agent_vm_maxcount" {
  description = "The max number of nodes allocated to the AKS cluster"
  type        = string
}

variable "aks_agent_vm_size" {
  type        = string
  description = "The size of each VM in the Agent Pool (e.g. Standard_F1). Changing this forces a new resource to be created."
}

variable "aks_agent_vm_disk" {
  description = "The initial sice of each VM OS Disk."
  type        = number
}

variable "kubernetes_version" {
  type = string
}

variable "ssh_public_key_file" {
  type        = string
  description = "(Required) The SSH public key used to setup log-in credentials on the nodes in the AKS cluster."
}

variable "container_registry_id" {
  description = "The initial number of agent pools / nodes allocated to the AKS cluster"
  type        = string
}

variable "osdu_identity_id" {
  description = "The initial sice of each VM OS Disk."
  type        = string
}

