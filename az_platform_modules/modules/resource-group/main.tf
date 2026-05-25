resource "azurerm_resource_group" "this" {
  name     = local.resource_group_name
  location = local.location
  tags     = var.tags

  lifecycle {
    precondition {
      condition     = local.resource_group_name != null
      error_message = "Resource group name cannot be determined. Please provide either a static name or a valid context."
    }
  }
}