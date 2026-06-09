# Azure AKS Module

Creates an Azure Kubernetes Service cluster with a default node pool, optional additional node pools, managed identity, Azure networking, optional add-ons, optional diagnostics, and optional role assignments.

This is a primitive AKS module. It does not create resource groups, virtual networks, subnets, Log Analytics workspaces, private DNS zones, or Kubernetes workloads.

## Basic Usage

```hcl
module "aks" {
  source = "./modules/aks"

  name                = "aks-contoso-payments-dev-eus-01"
  resource_group_name = "rg-contoso-payments-dev-eus-01"
  location            = "eastus"

  default_node_pool = {
    vm_size   = "Standard_D2s_v5"
    subnet_id = module.network.subnet_ids["aks_system"]
  }
}
```

## Design Notes

- `name` wins over context-based naming.
- Network dependencies are explicit through subnet IDs.
- Additional node pools use caller-defined map keys for stable addresses.
- AKS is treated as plan-only by default for tests because it is slow and cost-bearing.
- Kubeconfig is intentionally not output by default.
