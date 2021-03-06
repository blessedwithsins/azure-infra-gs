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

locals {
  // topics_name_id_flattened is used to create the map of Topic Name to Topic Id.
  topics_name_id_flattened = flatten([
    for topic in azurerm_eventgrid_topic.main : [
      {
        key   = topic.name
        value = topic.id
      }
    ]
  ])

  // topics_name_key_flattened is used to create the map of Topic Name to Topic Primary Key.
  topics_name_key_flattened = flatten([
    for topic in azurerm_eventgrid_topic.main : [
      {
        key   = topic.name
        value = topic.primary_access_key
      }
    ]
  ])
}

output "name" {
  value       = azurerm_eventgrid_domain.main.name
  description = "The domain name."
}

output "id" {
  value       = azurerm_eventgrid_domain.main.id
  description = "The event grid domain id."
}

output "primary_access_key" {
  description = "The primary shared access key associated with the eventgrid Domain."
  value       = azurerm_eventgrid_domain.main.primary_access_key
}

output "topics" {
  description = "The Topic Name to Topic Id map for the given list of topics."
  value       = { for item in local.topics_name_id_flattened : item.key => item.value }
}

output "topic_accesskey_map" {
  description = "The Topic Name to Topic Access Key map for the given list of topics."
  value       = { for item in local.topics_name_key_flattened : item.key => item.value }
}