resource "azurerm_resource_group" "rg" {
    for_each = toset (var.rg_name)
    name = var.owner_var.env_each.key
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

