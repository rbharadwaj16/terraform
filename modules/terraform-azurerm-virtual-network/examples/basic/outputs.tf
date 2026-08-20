output "virtual_network_id" {
  description = "The ID of the virtual network."
  value       = module.virtual_network.virtual_network_id
}

output "subnet_ids" {
  description = "Subnet IDs keyed by the caller-defined subnet key."
  value       = module.virtual_network.subnet_ids
}
