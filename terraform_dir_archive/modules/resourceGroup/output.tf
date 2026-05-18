output "rg_id" {
    value = {for k,v in azurerm_resource_group.rg: k => v.id }
}

