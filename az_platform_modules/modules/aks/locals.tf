locals {
  context_name_parts = var.context == null ? [] : compact([
    "aks",
    try(var.context.org, null),
    var.context.app,
    var.context.env,
    var.context.region,
    try(var.context.instance, null)
  ])

  computed_name = length(local.context_name_parts) > 0 ? lower(join("-", local.context_name_parts)) : null

  cluster_name = var.name != null ? lower(var.name) : local.computed_name
  dns_prefix   = var.dns_prefix != null ? lower(var.dns_prefix) : local.cluster_name
  location     = lower(var.location)

  node_pools = {
    for key, pool in var.node_pools : key => merge(pool, {
      name      = coalesce(try(pool.name, null), key)
      subnet_id = coalesce(try(pool.subnet_id, null), var.default_node_pool.subnet_id)
    })
  }
}
