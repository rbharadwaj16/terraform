output "virtual_network_id" {
  description = "The ID of the virtual network."
  value       = azurerm_virtual_network.this.id

}

output "virtual_network_name" {
  description = "The name of the virtual network."
  value       = azurerm_virtual_network.this.name
}

output "subnet_id" {
  description = "Subnet IDs"
  value = {
    for subnet_key, subnet in azurerm_subnet.this :
    subnet_key => subnet.id
  }
}
