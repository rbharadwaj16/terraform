# Azure Resource Group Terraform Module

This module creates a single Azure resource group for an application, workload, platform component, or shared service boundary.

It supports explicit naming first. When `name` is provided, the module uses that exact value. When `name` is not provided, the module computes a deterministic name from `context` in this shape:

```text
rg-<org>-<app>-<env>-<region>-<instance>
```

`org` and `instance` are optional. Generated names and locations are lowercased.

## Usage

```hcl
module "resource_group" {
  source = "../../"

  name     = "rg-orders-prod-eus-01"
  location = "eastus"

  tags = {
    workload    = "orders"
    environment = "prod"
  }
}
```

## Context Naming

```hcl
module "resource_group" {
  source = "../../"

  location = "eastus"

  context = {
    org      = "contoso"
    app      = "orders"
    env      = "prod"
    region   = "eus"
    instance = "01"
  }

  tags = {
    workload    = "orders"
    environment = "prod"
  }
}
```

The example above creates `rg-contoso-orders-prod-eus-01`.

## Design Notes

- The module manages only `azurerm_resource_group`.
- Provider configuration is intentionally left to examples, tests, and consuming stacks.
- Tags are applied exactly as provided by the caller.
- Locks, role assignments, and budgets are not included in this baseline checkpoint.

## Inputs

| Name | Description | Type | Default | Required |
| --- | --- | --- | --- | --- |
| `name` | Exact resource group name. When set, this overrides context-based naming. | `string` | `null` | no |
| `context` | Business context used to compute the resource group name when name is not provided. | `object` | `null` | no |
| `location` | Azure region where the resource group will be created. | `string` | n/a | yes |
| `tags` | Tags to apply to the resource group. | `map(string)` | `{}` | no |

Either `name` or `context` must be provided.

## Outputs

| Name | Description |
| --- | --- |
| `resource_group_name` | Name of the resource group. |
| `resource_group_id` | Resource ID of the resource group. |
| `resource_group_location` | Azure region of the resource group. |
| `resource_group_tags` | Tags applied to the resource group. |

## Validation

- `name` cannot be empty when provided.
- `context.app`, `context.env`, and `context.region` cannot be empty.
- Computed names must be 90 characters or fewer.
- Resource group names cannot end with a period.
- `location` cannot be empty.
