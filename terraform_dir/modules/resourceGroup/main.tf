resource "azurerm_resource_group" "rg" {
    for_each = var.rg_name
    name = format("%s_%s_%s_%s", var.owner, each.key, var.env, var.location_short)
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

