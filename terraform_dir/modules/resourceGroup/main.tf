resource "azurerm_resource_group" "rg" {
    for_each = var.rg_name
    name = format("%s_[each.value]_%s_%s", var.owner, var.env, var.location_short)
    location = var.location
    lifecycle {
      ignore_changes = [
        tags["Created"]
      ]
    }
    tags = {
      "Purpose" = "Test"
      "Owner" = "raghavendra.bharadwaj@servian.com"
      "Client" = "L&D"
    }
}

