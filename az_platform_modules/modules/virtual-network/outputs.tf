output "virtual_network_name" {
  description = "Name of the virtual network."
  value       = azurerm_virtual_network.this.name
}

output "virtual_network_id" {
  description = "ID of the virtual network."
  value       = azurerm_virtual_network.this.id
}

output "virtual_network_address_space" {
  description = "Address spaces assigned to the virtual network."
  value       = azurerm_virtual_network.this.address_space
}

output "subnets" {
  description = "Subnets created by this module, keyed by input subnet key."
  value = {
    for key, subnet in azurerm_subnet.this : key => {
      name             = subnet.name
      id               = subnet.id
      address_prefixes = subnet.address_prefixes
    }
  }
}

output "subnet_ids" {
  description = "Subnet IDs keyed by input subnet key."
  value       = { for key, subnet in azurerm_subnet.this : key => subnet.id }
}

output "network_security_group_ids" {
  description = "Network security group IDs keyed by input NSG key."
  value       = { for key, nsg in azurerm_network_security_group.this : key => nsg.id }
}

output "route_table_ids" {
  description = "Route table IDs keyed by input route table key."
  value       = { for key, route_table in azurerm_route_table.this : key => route_table.id }
}
