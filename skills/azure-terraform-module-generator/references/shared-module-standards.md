# Shared Azure Terraform Module Standards

## Purpose
Use these standards for all reusable Azure Terraform modules in this repository.
These modules are intended for enterprise platform engineering, where a central platform team builds modules that can be consumed by application teams.

## Module Scope
Each primitive module must be single-purpose.
Examples:
- Resource Group module manages Resource Groups and directly related RG-scoped controls.
- Virtual Network module manages VNets and directly related networking child resources.
- Storage Account module manages Storage Accounts and directly related child/extension resources.
- AKS module manages AKS and directly related AKS configuration.
- Create a seperate folder under "modules" if a specific resource type folder doesn't exist.

Do not create unrelated infrastructure inside primitive modules.
Higher-level composition belongs in stack modules.

---

## Module Types
Use two levels of modules.

### Primitive resource modules
Primitive modules manage one Azure resource family and its directly related child or extension resources.
Examples:
- `terraform-azurerm-resource-group`
- `terraform-azurerm-virtual-network`
- `terraform-azurerm-storage-account`
- `terraform-azurerm-key-vault`
- `terraform-azurerm-aks`
Primitive modules should stay focused.

### Stack modules
Stack modules compose multiple primitive modules into an opinionated architecture.
Examples:
- `terraform-azurerm-stack-landing-zone`
- `terraform-azurerm-stack-aks-platform`
- `terraform-azurerm-stack-secure-app`
Do not put stack-level orchestration into primitive modules.

---

## Module Scope
Each primitive module must be single-purpose.
A primitive module should manage:
- one primary Azure resource type or resource family
- directly related child resources when they are part of that resource lifecycle
- directly related extension resources when explicitly enabled

A primitive module should not create unrelated infrastructure.

For example:

- A Resource Group module may manage the RG, optional RG lock, optional RG budget, and optional RG-scoped RBAC.
- A Virtual Network module may manage VNet, subnets, NSGs, route tables, and subnet associations if designed that way.
- A Storage Account module may manage the storage account and directly related containers, queues, network rules, private endpoints, diagnostics, or RBAC if explicitly enabled.
- An AKS module may manage the AKS cluster, node pools, identities, and cluster-related configuration.

Avoid mega-modules that create unrelated services.

---

## Provider Boundary

Reusable module roots must not configure providers.

Allowed in a reusable module root:

```hcl
terraform {
  required_version = ">= 1.6.0"

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 4.0"
    }
  }
}