output "virtual_network_id" {
  description = "ID of the virtual network."
  value       = module.network.virtual_network_id
}

output "subnet_ids" {
  description = "Subnet IDs keyed by subnet key."
  value       = module.network.subnet_ids
}

output "network_security_group_ids" {
  description = "Network security group IDs keyed by NSG key."
  value       = module.network.network_security_group_ids
}
