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

provider "azurerm" {
  features {}
}

module "resource_group" {
  source = "../../resource-group"

  name     = "osdu-module"
  location = "eastus2"
}

module "app-insights" {
  source     = "../"
  depends_on = [module.resource_group]

  appinsights_name                 = "osdu-module-app-insights-${module.resource_group.random}"
  service_plan_resource_group_name = module.resource_group.name
  appinsights_application_type     = "java"

  resource_tags = {
    osdu = "module"
  }
}
