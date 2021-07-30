variable "resource_group_name" {
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

variable "container_registry_id_central" {
  description = "Container Registry in Central Resources"
  type        = string
}

variable "container_registry_id_data_partition" {
  description = "Container Registry in Data Partition"
  type        = string
}

variable "osdu_identity_id" {
  description = "The initial sice of each VM OS Disk."
  type        = string
}

variable "sr_aks_egress_ip_address" {
  description = "AKS egress ip for SR"
}

variable "base_name" {
  description = "Resource Base name"
}

variable "ssl_challenge_required" {
  description = "Flag to indicate whether http01 ssl challenge is required"
  type        = bool
}
