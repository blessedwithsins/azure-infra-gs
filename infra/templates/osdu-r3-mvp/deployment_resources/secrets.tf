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
   Terraform Secrets Control
.DESCRIPTION
   This file holds Key Vault Secrets.
*/

#-------------------------------
# Misc
#-------------------------------
resource "azurerm_key_vault_secret" "base_name_sr" {
  name         = "base-name-sr"
  value        = local.base_name_60
  key_vault_id = data.terraform_remote_state.central_resources.outputs.keyvault_id
}


#-------------------------------
# Storage
#-------------------------------
locals {
  storage_account_name    = "airflow-storage"
  storage_key_name        = "${local.storage_account_name}-key"
  storage_connection_name = "${local.storage_account_name}-connection"
}

resource "azurerm_key_vault_secret" "storage_connection" {
  name         = local.storage_connection_name
  value        = format("DefaultEndpointsProtocol=https;AccountName=%s;AccountKey=%s;EndpointSuffix=core.windows.net", module.storage_account.name, module.storage_account.primary_access_key)
  key_vault_id = data.terraform_remote_state.central_resources.outputs.keyvault_id
}



#-------------------------------
# Network
#-------------------------------
locals {
  ssl_cert_name = "appgw-ssl-cert"
}

resource "azurerm_key_vault_certificate" "default" {
  count = var.ssl_certificate_file == "" ? 1 : 0

  name         = local.ssl_cert_name
  key_vault_id = data.terraform_remote_state.central_resources.outputs.keyvault_id

  certificate_policy {
    issuer_parameters {
      name = "Self"
    }

    key_properties {
      exportable = true
      key_size   = 2048
      key_type   = "RSA"
      reuse_key  = true
    }

    lifetime_action {
      action {
        action_type = "AutoRenew"
      }

      trigger {
        days_before_expiry = 30
      }
    }

    secret_properties {
      content_type = "application/x-pkcs12"
    }

    x509_certificate_properties {
      # Server Authentication = 1.3.6.1.5.5.7.3.1
      # Client Authentication = 1.3.6.1.5.5.7.3.2
      extended_key_usage = ["1.3.6.1.5.5.7.3.1"]

      key_usage = [
        "cRLSign",
        "dataEncipherment",
        "digitalSignature",
        "keyAgreement",
        "keyCertSign",
        "keyEncipherment",
      ]

      subject_alternative_names {
        dns_names = [var.dns_name, "${local.base_name}-gw.${azurerm_resource_group.main.location}.cloudapp.azure.com"]
      }

      subject            = "CN=*.contoso.com"
      validity_in_months = 12
    }
  }

  lifecycle {
    ignore_changes = all
  }
}


