variable "feature_flag" {
  description = "(Optional) A toggle for incubator features"
  type = object({
    osdu_namespace = bool
  })
  default = {
    osdu_namespace = true
  }
}

variable "aks_cluster_name" {
  type = string
}