# Azure Kubernetes Service Terraform Module

This module creates one Azure Kubernetes Service cluster with a required default node pool that is attached to an existing subnet.

## Scope

This initial version manages:

- one AKS cluster
- one required default node pool
- a system-assigned cluster identity
- tags

It intentionally does not yet manage additional node pools, private clusters, Azure RBAC, workload identity, diagnostics, or role assignments. Those will be added in later learning checkpoints.

## Usage

```hcl
module "aks" {
  source = "../../"

  aks_name            = "aks-ai-inference-dev-eus-01"
  resource_group_name = "rg-ai-inference-dev-eus-01"
  location            = "eastus"
  dns_prefix          = "aks-ai-inference-dev-eus-01"

  default_node_pool = {
    name           = "system"
    vm_size        = "Standard_D4s_v5"
    node_count     = 1
    vnet_subnet_id = "/subscriptions/<subscription-id>/resourceGroups/<resource-group>/providers/Microsoft.Network/virtualNetworks/<vnet-name>/subnets/<subnet-name>"
  }

  tags = {
    environment = "dev"
    workload    = "ai-inference"
  }
}
```

## Outputs

| Name | Description |
| --- | --- |
| `id` | Resource ID of the AKS cluster. |
| `name` | Name of the AKS cluster. |
| `kubelet_identity_object_id` | Object ID of the managed identity used by kubelets. Use this later for the ACR `AcrPull` role assignment. |

## Design Notes

- The module consumes an existing resource group and subnet. It does not create network dependencies.
- The default node pool is part of the AKS cluster resource and therefore belongs inside this module.
- The module deliberately does not expose kubeconfig because it is sensitive and is not needed for downstream Azure resource integration.
