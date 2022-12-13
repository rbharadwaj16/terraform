data "azurerm_resource_group" "network_rg" {
  for_each = toset(var.network_rg)
  name     = "${var.owner}_${var.env}_${each.key}_${var.location_short}"
}



resource "azurerm_virtual_network" "vnet" {
  for_each            = {for idx, val in setproduct(keys(var.vnet), var.network_rg): idx => val}
  name                = "${var.owner}_${var.env}_${var.vnet[each.value[0]].name}_${var.location_short}}"

  location            = data.azurerm_resource_group.network_rg[each.value[1]].location

  resource_group_name = data.azurerm_resource_group.network_rg[each.value[1]].name

  address_space       = var.vnet[each.value[0]].address_space
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