output "virtual_network_id" {
  description = "ID of the virtual network."
  value       = module.network.virtual_network_id
}

output "aks_subnet_id" {
  description = "ID of the AKS system subnet."
  value       = module.network.subnet_ids["aks_system"]
}
