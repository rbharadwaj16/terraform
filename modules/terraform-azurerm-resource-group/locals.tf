locals {
  context_name_parts = var.context == null ? [] : compact([
    "rg",
    try(var.context.org, null),
    var.context.app,
    var.context.env,
    var.context.region,
    try(var.context.instance, null)
  ])

  context_resource_group_name = var.context == null ? null : lower(join("-", local.context_name_parts))
  resource_group_name         = var.name != null ? var.name : local.context_resource_group_name
  resource_group_location     = lower(var.location)
}
