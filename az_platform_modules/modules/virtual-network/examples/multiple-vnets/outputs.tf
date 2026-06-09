output "virtual_network_ids" {
  description = "Virtual network IDs keyed by network key."
  value       = { for key, network in module.network : key => network.virtual_network_id }
}
