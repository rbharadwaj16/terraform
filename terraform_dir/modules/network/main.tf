data "azurerm_resource_group" "network_rg" {
  for_each = toset(var.network_rg)
  name     = "${var.owner}_${var.env}_${each.key}_${var.location_short}"
}


resource "azurerm_virtual_network" "vnet" {
  for_each            = var.vnet
  name                = "${var.owner}_${var.env}_${each.value["name"]}_${var.location_short}}"
  location            = "data.azurerm_resource_group.network_rg.${each.key}.location"
  resource_group_name = "data.azurerm_resource_group.network_rg.${each.key}.name"
  address_space       = each.value["address_space"]
  lifecycle {
    ignore_changes = [
      tags["Created"]
    ]
  }
  tags = {
    "Purpose" = var.purpose_tag #"Test"
    "Owner"   = var.owner_tag   #"raghavendra.bharadwaj@servian.com"
    "Client"  = var.client_tag      #"L&D"
  }
}
