resource "azurerm_virtual_network" "this" {
  name                = local.virtual_network_name
  resource_group_name = var.resource_group_name
  location            = local.location
  address_space       = var.address_space
  dns_servers         = var.dns_servers
  tags                = var.tags

  lifecycle {
    precondition {
      condition     = local.virtual_network_name != null
      error_message = "Virtual network name cannot be determined. Provide either name or context."
    }
  }
}

resource "azurerm_network_security_group" "this" {
  for_each = var.network_security_groups

  name                = coalesce(try(each.value.name, null), each.key)
  resource_group_name = var.resource_group_name
  location            = local.location
  tags                = var.tags
}

resource "azurerm_network_security_rule" "this" {
  for_each = local.nsg_security_rules

  name                                       = each.value.name
  priority                                   = each.value.priority
  direction                                  = each.value.direction
  access                                     = each.value.access
  protocol                                   = each.value.protocol
  source_port_range                          = try(each.value.source_port_range, null)
  source_port_ranges                         = try(each.value.source_port_ranges, null)
  destination_port_range                     = try(each.value.destination_port_range, null)
  destination_port_ranges                    = try(each.value.destination_port_ranges, null)
  source_address_prefix                      = try(each.value.source_address_prefix, null)
  source_address_prefixes                    = try(each.value.source_address_prefixes, null)
  destination_address_prefix                 = try(each.value.destination_address_prefix, null)
  destination_address_prefixes               = try(each.value.destination_address_prefixes, null)
  source_application_security_group_ids      = try(each.value.source_application_security_group_ids, null)
  destination_application_security_group_ids = try(each.value.destination_application_security_group_ids, null)
  description                                = try(each.value.description, null)
  resource_group_name                        = var.resource_group_name
  network_security_group_name                = azurerm_network_security_group.this[each.value.nsg_key].name
}

resource "azurerm_route_table" "this" {
  for_each = var.route_tables

  name                          = coalesce(try(each.value.name, null), each.key)
  resource_group_name           = var.resource_group_name
  location                      = local.location
  bgp_route_propagation_enabled = try(each.value.bgp_route_propagation_enabled, true)
  tags                          = var.tags
}

resource "azurerm_route" "this" {
  for_each = local.route_table_routes

  name                   = each.value.name
  resource_group_name    = var.resource_group_name
  route_table_name       = azurerm_route_table.this[each.value.route_table_key].name
  address_prefix         = each.value.address_prefix
  next_hop_type          = each.value.next_hop_type
  next_hop_in_ip_address = try(each.value.next_hop_in_ip_address, null)
}

resource "azurerm_subnet" "this" {
  for_each = local.subnets

  name                                          = each.value.name
  resource_group_name                           = var.resource_group_name
  virtual_network_name                          = azurerm_virtual_network.this.name
  address_prefixes                              = each.value.address_prefixes
  service_endpoints                             = try(each.value.service_endpoints, [])
  private_endpoint_network_policies             = try(each.value.private_endpoint_network_policies, null)
  private_link_service_network_policies_enabled = try(each.value.private_link_service_network_policies_enabled, null)

  dynamic "delegation" {
    for_each = try(each.value.delegation, null) == null ? [] : [each.value.delegation]

    content {
      name = delegation.value.name

      service_delegation {
        name    = delegation.value.service_delegation.name
        actions = try(delegation.value.service_delegation.actions, [])
      }
    }
  }
}

resource "azurerm_subnet_network_security_group_association" "this" {
  for_each = {
    for key, subnet in local.subnets : key => subnet
    if try(subnet.nsg_key, null) != null
  }

  subnet_id                 = azurerm_subnet.this[each.key].id
  network_security_group_id = azurerm_network_security_group.this[each.value.nsg_key].id
}

resource "azurerm_subnet_route_table_association" "this" {
  for_each = {
    for key, subnet in local.subnets : key => subnet
    if try(subnet.route_table_key, null) != null
  }

  subnet_id      = azurerm_subnet.this[each.key].id
  route_table_id = azurerm_route_table.this[each.value.route_table_key].id
}
