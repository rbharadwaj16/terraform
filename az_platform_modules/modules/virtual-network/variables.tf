variable "name" {
  description = "Exact virtual network name. When set, this overrides context-based naming."
  type        = string
  default     = null

  validation {
    condition     = var.name == null || length(trimspace(var.name)) > 0
    error_message = "When provided, name must not be empty."
  }
}

variable "context" {
  description = "Business context used to compute the virtual network name when name is not provided."
  type = object({
    org      = optional(string)
    app      = string
    env      = string
    region   = string
    instance = optional(string)
  })
  default = null
}

variable "resource_group_name" {
  description = "Name of the resource group where the virtual network resources will be created."
  type        = string
}

variable "location" {
  description = "Azure region where the virtual network will be created."
  type        = string
}

variable "address_space" {
  description = "Address spaces for the virtual network."
  type        = list(string)

  validation {
    condition     = length(var.address_space) > 0
    error_message = "address_space must contain at least one CIDR range."
  }
}

variable "dns_servers" {
  description = "Optional DNS server IP addresses for the virtual network. Set to null to use Azure-provided DNS."
  type        = list(string)
  default     = null
}

variable "subnets" {
  description = "Subnets to create, keyed by stable caller-defined names."
  type = map(object({
    name                                          = optional(string)
    address_prefixes                              = list(string)
    service_endpoints                             = optional(set(string), [])
    private_endpoint_network_policies             = optional(string)
    private_link_service_network_policies_enabled = optional(bool)
    nsg_key                                       = optional(string)
    route_table_key                               = optional(string)
    delegation = optional(object({
      name = string
      service_delegation = object({
        name    = string
        actions = optional(set(string), [])
      })
    }))
  }))

  validation {
    condition     = length(var.subnets) > 0
    error_message = "At least one subnet must be defined."
  }

  validation {
    condition = alltrue([
      for subnet in values(var.subnets) : length(subnet.address_prefixes) > 0
    ])
    error_message = "Each subnet must include at least one address prefix."
  }

  validation {
    condition = alltrue([
      for subnet in values(var.subnets) :
      try(subnet.nsg_key, null) == null || contains(keys(var.network_security_groups), subnet.nsg_key)
    ])
    error_message = "Each subnet nsg_key must reference a key in network_security_groups."
  }

  validation {
    condition = alltrue([
      for subnet in values(var.subnets) :
      try(subnet.route_table_key, null) == null || contains(keys(var.route_tables), subnet.route_table_key)
    ])
    error_message = "Each subnet route_table_key must reference a key in route_tables."
  }
}

variable "network_security_groups" {
  description = "Network security groups to create, keyed by stable caller-defined names."
  type = map(object({
    name = optional(string)
    security_rules = optional(map(object({
      name                                       = optional(string)
      priority                                   = number
      direction                                  = string
      access                                     = string
      protocol                                   = string
      source_port_range                          = optional(string)
      source_port_ranges                         = optional(set(string))
      destination_port_range                     = optional(string)
      destination_port_ranges                    = optional(set(string))
      source_address_prefix                      = optional(string)
      source_address_prefixes                    = optional(set(string))
      destination_address_prefix                 = optional(string)
      destination_address_prefixes               = optional(set(string))
      source_application_security_group_ids      = optional(set(string))
      destination_application_security_group_ids = optional(set(string))
      description                                = optional(string)
    })), {})
  }))
  default = {}
}

variable "route_tables" {
  description = "Route tables to create, keyed by stable caller-defined names."
  type = map(object({
    name                          = optional(string)
    bgp_route_propagation_enabled = optional(bool, true)
    routes = optional(map(object({
      name                   = optional(string)
      address_prefix         = string
      next_hop_type          = string
      next_hop_in_ip_address = optional(string)
    })), {})
  }))
  default = {}
}

variable "tags" {
  description = "Tags to apply to taggable resources."
  type        = map(string)
  default     = {}
}
