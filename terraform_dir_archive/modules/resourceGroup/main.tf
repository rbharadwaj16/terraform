resource "azurerm_resource_group" "rg" {
  for_each = toset(var.rg_name)
  name     = "${var.owner}_${var.env}_${each.key}_${var.location_short}"
  location = var.location
  lifecycle {
    ignore_changes = [
      tags["Created"]
    ]
  }
  tags = {
    "Purpose" = var.purpose_tag #"Test"
    "Owner"   = var.owner_tag   #"raghavendra.bharadwaj@servian.com"
    "Client"  = var.client_tag     #"L&D"
  }
}

