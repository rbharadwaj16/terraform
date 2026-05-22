locals {
    context_name_parts = var.context == null ?  [] : compact([
        "rg",
       try(var.context.org, null),
        var.context.app,
        var.context.env,
        var.context.region,
        var.context.instance
    ])

    computed_name = length(local.context_name_parts) > 0 ? lower(join("-", local.context_name_parts)) : null

    resource_group_name = var.name != null ? lower(var.name) : local.computed_name

    location = lower(var.location)

}