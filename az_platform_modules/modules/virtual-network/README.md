# Azure Virtual Network Module

Creates an Azure virtual network with caller-defined subnets and optional subnet-level network security groups and route tables.

This is a primitive network module. It does not create resource groups, AKS clusters, gateways, firewalls, NAT gateways, or landing-zone governance.

## Basic Usage

```hcl
module "network" {
  source = "./modules/virtual-network"

  name                = "vnet-contoso-aks-dev-eus-01"
  resource_group_name = "rg-contoso-aks-dev-eus-01"
  location            = "eastus"
  address_space       = ["10.40.0.0/16"]

  subnets = {
    aks_system = {
      name             = "snet-aks-system"
      address_prefixes = ["10.40.0.0/22"]
    }
  }
}
```

## Design Notes

- `name` wins over context-based naming.
- Subnets, NSGs, routes, and route tables use map keys for stable Terraform addresses.
- The module outputs subnet IDs keyed by input key so AKS and other workload modules can consume explicit dependencies.
- NSG and route table associations are opt-in per subnet.
