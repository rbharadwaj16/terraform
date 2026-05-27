output "resource_group_name" {
  description = "The explicit name passed to the module."
  value       = module.resource_group.resource_group_name
}

output "resource_group_id" {
  description = "The resource ID of the resource group."
  value       = module.resource_group.resource_group_id
}
