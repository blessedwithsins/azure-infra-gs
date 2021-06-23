variable "feature_flag" {
  description = "(Optional) A toggle for incubator features"
  type = object({
    osdu_namespace = bool
    flux           = bool
    sa_lock        = bool
  })
}

variable "pod_identity_id" {
  description = ""
  type        = string
}

variable "pod_principal_id" {
  description = ""
  type        = string
}

variable "aks_cluster_name" {
  description = ""
  type        = string
}

variable "tenant_id" {
  description = ""
  type        = string
}

variable "subscription_name" {
  description = ""
  type        = string
}

variable "postgres_username" {
  description = ""
  type        = string
}

variable "postgres_fqdn" {
  description = ""
  type        = string
}

variable "container_registry_name" {
  description = ""
  type        = string
}

variable "key_vault_name" {
  description = ""
  type        = string
}

variable "log_analytics_id" {
  description = ""
  type        = string
}
