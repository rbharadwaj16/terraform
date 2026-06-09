# Azure Network Module Reference

## Purpose

Use this reference when generating, reviewing, or extending reusable Azure virtual network modules.

The network module is a primitive resource module for the virtual network resource family. It should create a predictable network boundary that can host workloads such as AKS without hiding landing-zone or hub-spoke decisions inside the primitive module.

## Module Type

This is a primitive resource module.

It may manage:

- `azurerm_virtual_network`
- `azurerm_subnet`
- optional subnet network security groups
- optional subnet route tables
- optional subnet delegations and service endpoints
- optional VNet peerings when explicitly modeled

It should not manage:

- resource groups
- AKS clusters
- private DNS zones unless deliberately scoped as a network child feature
- firewalls, gateways, bastions, or NAT gateways unless the module has been explicitly widened
- landing-zone policy, management groups, or subscription governance

## Baseline Contract

The module should support:

- explicit virtual network name through `name`
- computed virtual network name through `context`
- required `resource_group_name`
- required `location`
- required `address_space`
- `subnets` as a map keyed by stable caller-defined names
- optional NSGs and route tables as maps keyed by stable caller-defined names
- optional subnet associations to NSGs and route tables by key
- optional `tags`

Current preferred naming shape:

```text
vnet-<org>-<app>-<env>-<region>-<instance>
```

Subnet names may default to the caller map key, but each subnet should allow `name` override.

## AKS Hosting Guidance

For AKS hosting, the network module should make this easy:

- create one or more dedicated AKS subnets
- output subnet IDs keyed by input subnet key
- avoid creating AKS role assignments automatically
- let the AKS module or stack module decide identity and RBAC bindings
- allow route tables and NSGs without forcing them by default
- keep address planning explicit; do not invent CIDR ranges inside the module

## Input Guidance

Use maps for repeated child resources:

```hcl
variable "subnets" {
  description = "Subnets to create, keyed by stable caller-defined names."
  type = map(object({
    name                                      = optional(string)
    address_prefixes                          = list(string)
    service_endpoints                         = optional(set(string), [])
    private_endpoint_network_policies         = optional(string)
    private_link_service_network_policies_enabled = optional(bool)
    nsg_key                                   = optional(string)
    route_table_key                           = optional(string)
  }))
}
```

Rules:

- do not use list indexes for subnets, routes, or security rules
- require CIDR input from callers
- validate mutually referenced keys where practical
- avoid broad allow rules by default
- avoid hard-coded enterprise IP ranges

## Outputs

Output at least:

- virtual network name and ID
- address space
- subnets map with name, ID, and address prefixes
- NSG IDs map when NSGs are created
- route table IDs map when route tables are created

## Examples And Tests

Required examples:

- `basic`: VNet with a single AKS subnet
- `complete`: multiple subnets with NSG and route table associations
- `multiple-vnets`: caller-side `for_each`

Testing should include static validation and plan assertions for:

- VNet creation
- subnet map key stability
- optional NSG and route table resources
- subnet associations only when keys are supplied
