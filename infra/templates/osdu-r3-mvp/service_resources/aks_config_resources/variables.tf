variable "resource_group_name" {
  description = "The address space that is used by the virtual network."
  type        = string
}

variable "aks_cluster_name" {
  description = "The address space that is used by the virtual network."
  type        = string
}

variable "appgw_name" {
  description = "The address space that is used by the virtual network."
  type        = string
}

variable "feature_flag" {
  description = "(Optional) A toggle for incubator features"
  type = object({
    osdu_namespace = bool
    flux           = bool
    sa_lock        = bool
  })
}

variable "postgres_username" {
  description = "The Administrator Login for the PostgreSQL Server. Changing this forces a new resource to be created."
  type        = string
}

variable "postgres_fqdn" {
  description = "The Administrator Login for the PostgreSQL Server. Changing this forces a new resource to be created."
  type        = string
}

variable "tenant_id" {
  description = "The Administrator Login for the PostgreSQL Server. Changing this forces a new resource to be created."
  type        = string
}

variable "subscription_id" {
  description = "The Administrator Login for the PostgreSQL Server. Changing this forces a new resource to be created."
  type        = string
}

variable "subscription_name" {
  description = "The Administrator Login for the PostgreSQL Server. Changing this forces a new resource to be created."
  type        = string
}

variable "container_registry_name" {
  description = "The Administrator Login for the PostgreSQL Server. Changing this forces a new resource to be created."
  type        = string
}

variable "key_vault_name" {
  description = "The Administrator Login for the PostgreSQL Server. Changing this forces a new resource to be created."
  type        = string
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
}

variable "gitops_path" {
  type        = string
  description = "(Optional) The path for flux to watch"
}

variable "pod_identity_id" {
  description = "The address space that is used by the virtual network."
  type        = string
}

variable "pod_principal_id" {
  description = "The address space that is used by the virtual network."
  type        = string
}

variable "agic_identity_id" {
  description = "The address space that is used by the virtual network."
  type        = string
}

variable "agic_client_id" {
  description = "The address space that is used by the virtual network."
  type        = string
}

variable "log_analytics_id" {
  description = "The address space that is used by the virtual network."
  type        = string
}
