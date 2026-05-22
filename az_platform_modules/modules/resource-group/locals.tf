locals {
    context_name_parts = var.context == null ?  [] : compact([
        "rg",
        var.context.org,
        var.context.app,
        var.context.env,
        var.context.region,
        var.context.instance
    ])

    computed_name = length(context_name_parts) > 0 ? lower(join("-", context_name_parts)) : null

    resource_group_name = var.name != null ? var.name : local.computed_name

    location = lower(var.location)

}