resource "azurerm_subnet" "subnet" {
    for_each = var.subnets
    name = each.value["name"]
    resource_group_name = each.value["subnet_rg"]
    virtual_network_name = each.value["vnet_name"]
    address_prefixes = each.value["address_space"]  
}