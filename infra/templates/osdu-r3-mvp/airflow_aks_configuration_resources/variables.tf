variable "remote_state_account" {
  description = "Remote Terraform State Azure storage account name. This is typically set as an environment variable and used for the initial terraform init."
  type        = string
}

variable "remote_state_container" {
  description = "Remote Terraform State Azure storage container name. This is typically set as an environment variable and used for the initial terraform init."
  type        = string
}

variable "data_resources_workspace_name" {
  description = "(Required) The workspace name for the data_resources repository terraform environment / template to reference for this template."
  type        = string
}

variable "central_resources_workspace_name" {
  description = "(Required) The workspace name for the central_resources repository terraform environment / template to reference for this template."
  type        = string
}

variable "feature_flag" {
  description = "(Optional) A toggle for incubator features"
  type = object({
    osdu_namespace = bool
    flux           = bool
    sa_lock        = bool
    deploy_airflow = bool
  })
  default = {
    osdu_namespace = true
    flux           = true
    sa_lock        = true
    deploy_airflow = true
  }
}

variable "postgres_username" {
  description = "The Administrator Login for the PostgreSQL Server. Changing this forces a new resource to be created."
  type        = string
  default     = "osdu_admin"
}