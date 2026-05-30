# Resource Group Module Reference

## Purpose

Use this reference when generating, reviewing, or extending the reusable Azure Resource Group module.

The Resource Group module is a primitive module. Its primary responsibility is to create and manage Azure resource groups with predictable naming, location, tags, and optional resource-group-scoped controls when those controls are explicitly in scope.

This module should remain small, stable, and easy for application teams to consume.

## Mental Model

Treat a resource group as the boundary container for a workload, platform component, or shared service.

The module should answer one simple consumer question:

> "Create the resource group boundary I need, using either the exact name I provide or the enterprise naming context I provide."

Do not turn the Resource Group module into a landing-zone module. Resource groups are often the first dependency for other modules, so this module must be predictable, low-risk, and easy to call many times.

## Module Type

This is a primitive resource module.

It may manage:

- `azurerm_resource_group`
- optional resource group lock
- optional resource group budget
- optional resource group-scoped role assignments

It should not manage:

- virtual networks
- subnets
- private DNS zones
- key vaults
- storage accounts
- AKS clusters
- Azure Policy assignments at broad scope
- subscription-level governance
- management group resources

Those belong in their own primitive modules or in stack modules.

## Current Baseline Contract

The current module contract supports:

- explicit resource group name through `name`
- computed resource group name through `context`
- required Azure `location`
- optional `tags`
- output of resource group name, ID, location, and tags

Current naming behavior:

- `name` wins when provided.
- `context` is used only when `name` is not provided.
- computed name shape is `rg-<org>-<app>-<env>-<region>-<instance>`.
- `org` and `instance` are optional.
- generated names are lowercased.
- location is lowercased.

## Recommended Inputs

Minimum inputs:

```hcl
variable "name" {
  description = "Exact resource group name. When set, this overrides context-based naming."
  type        = string
  default     = null
}

variable "context" {
  description = "Business context used to compute the resource group name when name is not provided."
  type = object({
    org      = optional(string)
    app      = string
    env      = string
    region   = string
    instance = optional(string)
  })
  default = null
}

variable "location" {
  description = "Azure region where the resource group will be created."
  type        = string
}

variable "tags" {
  description = "Tags to apply to the resource group."
  type        = map(string)
  default     = {}
}
```

Recommended future optional inputs:

```hcl
variable "lock" {
  description = "Resource group lock configuration. Set to null to skip lock creation."
  type = object({
    name  = optional(string)
    level = string
    notes = optional(string)
  })
  default = null
}

variable "role_assignments" {
  description = "Resource group-scoped role assignments, keyed by stable caller-defined names."
  type = map(object({
    principal_id         = string
    role_definition_id   = optional(string)
    role_definition_name = optional(string)
    principal_type       = optional(string)
  }))
  default = {}
}

variable "budget" {
  description = "Resource group budget configuration. Set to null to skip budget creation."
  type = object({
    name        = optional(string)
    amount      = number
    time_grain  = optional(string, "Monthly")
    start_date  = string
    end_date    = optional(string)
    contact_emails = optional(set(string), [])
  })
  default = null
}
```

Only add optional inputs when the module implementation and examples are added in the same checkpoint.

## Naming Standards

Support explicit naming first.

Rules:

- `name` must override context-based naming.
- If neither `name` nor `context` can produce a name, fail with a clear precondition or validation error.
- Computed names must be deterministic.
- Do not use random suffixes.
- Do not make the resource group name depend on tags, location display name, SKU-like values, or optional features.
- Avoid silently truncating names.

Preferred context naming shape:

```text
rg-<org>-<app>-<env>-<region>-<instance>
```

If `org` is omitted:

```text
rg-<app>-<env>-<region>-<instance>
```

If `instance` is omitted:

```text
rg-<org>-<app>-<env>-<region>
```

Example:

```hcl
context = {
  org      = "contoso"
  app      = "orders"
  env      = "prod"
  region   = "eus"
  instance = "01"
}
```

Expected name:

```text
rg-contoso-orders-prod-eus-01
```

## Validation Guidance

Useful validations:

- `name` cannot be empty when set.
- `context.app`, `context.env`, and `context.region` cannot be empty.
- computed name must satisfy Azure resource group name limits.
- `location` cannot be empty.
- role assignment items must provide exactly one of `role_definition_id` or `role_definition_name`.
- lock level must be one of `CanNotDelete` or `ReadOnly`.
- budget amount must be greater than zero.

Do not over-validate Azure region names unless the repo has a maintained region allowlist.

## Tags

The module should apply `var.tags` directly to the resource group.

Rules:

- Do not hard-code tenant-specific tags.
- Do not require enterprise tags in the primitive module unless explicitly requested.
- Let stack modules or policy enforce mandatory enterprise tags.
- If default tags are introduced later, document merge precedence.

Recommended default behavior:

```hcl
tags = var.tags
```

## Optional Lock

A resource group lock is acceptable in this module because it is directly scoped to the resource group.

Rules:

- Lock creation must be optional.
- Lock level must be explicit.
- Do not create a lock by default.
- Document operational impact in the complete example.

Recommended resource:

```hcl
resource "azurerm_management_lock" "this" {
  count = var.lock == null ? 0 : 1

  name       = coalesce(var.lock.name, "${local.resource_group_name}-lock")
  scope      = azurerm_resource_group.this.id
  lock_level = var.lock.level
  notes      = try(var.lock.notes, null)
}
```

## Optional RBAC

Resource group-scoped role assignments may be included when explicitly enabled by input.

Rules:

- Use a map for stable `for_each`.
- Accept principal IDs from the caller.
- Do not look up users or groups by display name.
- Do not hard-code tenant principals.
- Do not create broad roles by default.
- Output assignment IDs as a map.

The caller or stack module should decide which principals receive access.

## Optional Budget

A resource group budget is acceptable when this module is intended to support cost governance at the resource group boundary.

Rules:

- Budget creation must be optional.
- Budget notification contacts must be supplied by the caller.
- Do not hard-code email addresses.
- Keep budget examples realistic but non-tenant-specific.

If budgets become complex, consider whether they belong in a separate cost-management module.

## Data Sources

The Resource Group module should not need data sources for its baseline behavior.

Avoid data sources that look up:

- subscription context
- tenant context
- naming conventions
- principals
- existing resource groups by generated name

If the module needs subscription or tenant data for a future optional feature, make that dependency explicit and document why.

## Outputs

Required outputs:

- `resource_group_name`
- `resource_group_id`
- `resource_group_location`
- `resource_group_tags`

Recommended future outputs when optional features are added:

- `lock_id`
- `role_assignment_ids`
- `budget_id`

Do not output the full `azurerm_resource_group.this` object.

## Examples

Required examples:

- `examples/basic`: explicit `name`, `location`, and simple tags
- `examples/context-minimal`: context without optional `org` and `instance`
- `examples/name-override`: proves `name` wins over `context`
- `examples/complete`: context-based naming and realistic enterprise tags
- `examples/multiple-resource-groups`: caller-side `for_each`

When optional features are added, update `examples/complete` first. Add dedicated examples only if the feature needs extra explanation.

## Testing Guidance

This module is apply-test friendly because resource groups are cheap and quick to create.

Recommended tests:

- explicit name creates expected name
- context generates expected name
- name overrides context
- missing name and missing context fails
- optional `org` and `instance` are omitted cleanly
- tags are applied
- location is normalized only if that behavior remains intentional
- multiple resource groups can be created through caller-side `for_each`

If optional features are added:

- lock test should verify lock ID exists
- RBAC test may be plan-only unless test principals are available
- budget test may be plan-only or isolated, depending on Azure test setup

## Review Checklist

Review a Resource Group module for:

- no provider block in the module root
- no backend block in the module root
- one primary `azurerm_resource_group` resource
- deterministic naming
- explicit `name` override behavior
- clear failure when name cannot be determined
- no hidden data-source lookups
- stable map keys for optional repeated resources
- direct, useful outputs
- runnable examples
- no tenant-specific tags, principals, emails, or subscription IDs

## Common Mistakes

Avoid:

- creating networks, identities, or application resources inside the Resource Group module
- making the module depend on subscription-specific naming rules
- hard-coding tags such as owner emails or cost centers
- requiring both `name` and `context`
- using random names by default
- outputting full provider resource objects
- adding locks by default
- assigning Owner or Contributor roles by default
- putting provider configuration in the reusable module root
