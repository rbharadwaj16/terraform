locals {
  context_name_parts = var.context == null ? [] : compact([
    "vnet",
    try(var.context.org, null),
    var.context.app,
    var.context.env,
    var.context.region,
    try(var.context.instance, null)
  ])

  computed_name = length(local.context_name_parts) > 0 ? lower(join("-", local.context_name_parts)) : null

  virtual_network_name = var.name != null ? lower(var.name) : local.computed_name
  location             = lower(var.location)

  subnets = {
    for key, subnet in var.subnets : key => merge(subnet, {
      name = coalesce(try(subnet.name, null), key)
    })
  }

  nsg_security_rules = length(var.network_security_groups) == 0 ? {} : merge([
    for nsg_key, nsg in var.network_security_groups : {
      for rule_key, rule in try(nsg.security_rules, {}) : "${nsg_key}.${rule_key}" => merge(rule, {
        nsg_key = nsg_key
        name    = coalesce(try(rule.name, null), rule_key)
      })
    }
  ]...)

  route_table_routes = length(var.route_tables) == 0 ? {} : merge([
    for route_table_key, route_table in var.route_tables : {
      for route_key, route in try(route_table.routes, {}) : "${route_table_key}.${route_key}" => merge(route, {
        route_table_key = route_table_key
        name            = coalesce(try(route.name, null), route_key)
      })
    }
  ]...)
}
