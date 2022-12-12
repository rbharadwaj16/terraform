data "azurerm_resource_group" "network_rg" {
  for_each = toset(var.network_rg)
  name     = "${var.owner}_${var.env}_${each.key}_${var.location_short}"
}

locals {
  network_rg_name = [for i in data.azurerm_resource_group.network_rg: i.name]
  network_rg_location = [for i in data.azurerm_resource_group.network_rg: i.location]
}
resource "azurerm_virtual_network" "vnet" {
  for_each            = var.vnet
  name                = "${var.owner}_${var.env}_${each.value["name"]}_${var.location_short}}"
  location            = local.network_rg_location
  resource_group_name = local.network_rg_name
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
