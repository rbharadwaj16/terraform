output "resource_group_name" {
  description = "The name computed from the minimal context."
  value       = module.resource_group.resource_group_name
}

output "resource_group_location" {
  description = "The Azure location of the resource group."
  value       = module.resource_group.resource_group_location
}
