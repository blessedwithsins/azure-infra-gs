#-------------------------------
# AD Service Principal
#-------------------------------
resource "azuread_service_principal" "ad_app_sp" {
  application_id = module.ad_application.id
}
