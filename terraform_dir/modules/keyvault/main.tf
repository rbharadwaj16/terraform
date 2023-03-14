# data "azurerm_resource_group" "azure_kv" {
#     name = "${var.owner}_${var.env}_${var.purpose}_${var.location_short}"
# }

data "azurerm_client_config" "current" {}

resource "azurerm_key_vault" "kv" {
  for_each                      = var.kv_mappings
  name                          = "${var.owner}_${var.env}_${each.value}_${var.location_short}"
  location                      = var.location
  resource_group_name           = "${var.owner}_${var.env}_${each.key}_${var.location_short}"
  sku_name                      = standard
  tenant_id                     = data.azurerm_client_config.current.tenant_id
  access_policy                 = []
  public_network_access_enabled = true

}
