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

# Naming Items (required)

variable "name" {
  description = "The name of the storage account service."
  type        = string
}

variable "container_names" {
  description = "The list of storage container names to create. Names must be unique per storage account."
  type        = list(string)
}

variable "share_names" {
  description = "The list of storage file share names to create. Names must be unique per storage account."
  type        = list(string)
  default     = []
}

variable "queue_names" {
  description = "The list of storage queue names to create. Names must be unique per storage account."
  type        = list(string)
  default     = []
}

variable "resource_group_name" {
  description = "The name of the resource group."
  type        = string
}


# Tier Items (optional)

variable "performance_tier" {
  description = "Determines the level of performance required."
  type        = string
  default     = "Standard"
}

variable "kind" {
  description = "Storage account types that determine available features and pricing of Azure Storage. Use StorageV2 when possible."
  type        = string
  default     = "StorageV2"
}

variable "replication_type" {
  description = "Defines the type of replication to use for this storage account. Valid options are LRS*, GRS, RAGRS and ZRS."
  type        = string
  default     = "LRS"
}


# Configuration Items (optional)

variable "https" {
  description = "Boolean flag which forces HTTPS in order to ensure secure connections."
  type        = bool
  default     = true
}


# General Items (optional)

variable "resource_tags" {
  description = "Map of tags to apply to taggable resources in this module. By default the taggable resources are tagged with the name defined above and this map is merged in"
  type        = map(string)
  default     = {}
}

variable "retention_days" {
  description = "Number of days that to keep deleted blobs"
  type        = number
  default     = 30
}

# CORS Rules
variable "blob_cors_rule" {
  type = list(
    object(
      {
        # A list of origin domains that will be allowed by CORS.
        allowed_origins = list(string)
        # A list of http headers that are allowed to be executed by the origin. Valid options are DELETE, GET, HEAD, MERGE, POST, OPTIONS, PUT or PATCH.
        allowed_methods = list(string)
        # A list of headers that are allowed to be a part of the cross-origin request.
        allowed_headers = list(string)
        # A list of response headers that are exposed to CORS clients.
        exposed_headers = list(string)
        # The number of seconds the client should cache a preflight response.
        max_age_in_seconds = number
  }))
  default     = []
  description = "List of CORS Rules to be applied on the Blob Service."
}
