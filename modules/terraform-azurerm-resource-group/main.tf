resource "azurerm_resource_group" "this" {
  name     = coalesce(local.resource_group_name, "__invalid_resource_group_name__")
  location = local.resource_group_location
  tags     = var.tags

  lifecycle {
    precondition {
      condition     = local.resource_group_name != null
      error_message = "Either name or context must be provided to determine the resource group name."
    }

    precondition {
      condition     = local.resource_group_name == null || length(local.resource_group_name) <= 90
      error_message = "The computed resource group name must be 90 characters or fewer."
    }

    precondition {
      condition     = local.resource_group_name == null || can(regex("^[a-z0-9_.()\\-]{1,90}$", local.resource_group_name))
      error_message = "The computed resource group name may contain lowercase letters, numbers, underscores, periods, parentheses, and hyphens."
    }

    precondition {
      condition     = local.resource_group_name == null || !endswith(local.resource_group_name, ".")
      error_message = "The computed resource group name cannot end with a period."
    }
  }
}
