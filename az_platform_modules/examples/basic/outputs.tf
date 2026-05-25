output "resource_group_name" {
  description = "The name of the resource group."
  value       = module.resource_group.resource_group_name
}

output "resource_group_id" {
  description = "The resource ID of the resource group."
  value       = module.resource_group.resource_group_id
}

output "resource_group_location" {
  description = "The Azure location of the resource group."
  value       = module.resource_group.resource_group_location
}

output "resource_group_tags" {
  description = "The tags assigned to the resource group."
  value       = module.resource_group.resource_group_tags
}
