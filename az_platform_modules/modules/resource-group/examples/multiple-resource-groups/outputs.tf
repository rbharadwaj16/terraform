output "resource_group_names" {
  description = "Resource group names keyed by the caller-defined resource group key."
  value = {
    for key, resource_group in module.resource_groups : key => resource_group.resource_group_name
  }
}

output "resource_group_ids" {
  description = "Resource group IDs keyed by the caller-defined resource group key."
  value = {
    for key, resource_group in module.resource_groups : key => resource_group.resource_group_id
  }
}
