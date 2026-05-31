output "resource_group_names" {
  description = "Names of the resource groups."
  value = {
    for key, rg in module.resource_group : key => rg.resource_group_name
  }
}
