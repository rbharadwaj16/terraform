# Shared Azure Terraform Module Standards

## Purpose

Use these standards for all reusable Azure Terraform modules in this repository.

These modules are intended for enterprise platform engineering, where a central platform team builds reusable Terraform modules that can be consumed by application teams directly or through higher-level stack modules.

The goal is to produce modules that are:

- reusable
- predictable
- secure by default where practical
- flexible enough for repeated deployments
- easy to consume
- easy to test
- suitable for GitHub portfolio quality

## Design Mental Model

Treat each module as a product contract, not just a Terraform folder.

Application teams should be able to consume a module without knowing the internal implementation details, while platform engineers should be able to evolve the implementation without breaking stable inputs and outputs.

Good modules make the common path easy, keep escape hatches explicit, and avoid hidden assumptions.

When deciding whether something belongs in a module, ask:

- Is this part of the lifecycle of the resource family?
- Would most consumers expect this capability here?
- Can the behavior be expressed through clear inputs?
- Can the module be tested without requiring a full enterprise environment?
- Will this make future changes safer or harder?

If the answer is unclear, prefer a smaller primitive module and compose it from a stack module.

## Module Types

Use two levels of reusable modules.

### Primitive Resource Modules

Primitive modules manage one Azure resource family and directly related child or extension resources.

Examples:

- `terraform-azurerm-resource-group`
- `terraform-azurerm-virtual-network`
- `terraform-azurerm-key-vault`
- `terraform-azurerm-storage-account`
- `terraform-azurerm-container-registry`
- `terraform-azurerm-aks`

Primitive modules should stay focused. They should not become landing-zone or application-stack modules.

### Stack Modules

Stack modules compose multiple primitive modules into an opinionated platform or application pattern.

Examples:

- `terraform-azurerm-stack-landing-zone`
- `terraform-azurerm-stack-aks-platform`
- `terraform-azurerm-stack-secure-app`

Stack modules may encode more opinionated architecture, but they should still expose clear inputs and avoid hard-coded tenant-specific assumptions.

## Module Scope

Each primitive module must be single-purpose.

A primitive module may manage:

- one primary Azure resource type or resource family
- child resources that share the same lifecycle as the primary resource
- extension resources when explicitly enabled
- optional Azure platform integrations that are directly attached to the primary resource

A primitive module must not create unrelated infrastructure.

Examples:

- A Resource Group module may manage the resource group, optional lock, optional budget, optional RG-scoped RBAC assignments, and optional diagnostic settings if applicable.
- A Virtual Network module may manage the VNet, subnets, NSGs, route tables, delegations, peerings, private DNS links, and associations if designed as part of the network resource lifecycle.
- A Key Vault module may manage the vault, access model, diagnostic settings, private endpoint, RBAC assignments, keys, secrets, and certificates only when those child resources are intentionally in scope.
- An AKS module may manage the cluster, node pools, identities, network profile, private cluster settings, addons, diagnostic settings, and related role assignments.
- A Storage Account module may manage the account, containers, queues, tables, file shares, network rules, private endpoints, diagnostic settings, lifecycle policy, encryption settings, and RBAC assignments.

Avoid mega-modules that create a resource group, network, identity, compute, monitoring, and policy all at once. That composition belongs in a stack module.

## Repository Layout

Use a consistent module layout.

Recommended module structure:

```text
modules/
  terraform-azurerm-<resource-name>/
    versions.tf
    variables.tf
    locals.tf
    main.tf
    outputs.tf
    README.md
    examples/
      basic/
      complete/
      multiple-<resources>/
    tests/
      *.tftest.hcl
```

Small modules may omit files that are not needed, but keep the standard file names when the concepts exist.

Use these file responsibilities:

- `versions.tf`: Terraform and provider constraints only.
- `variables.tf`: input variables, descriptions, types, defaults, and validations.
- `locals.tf`: derived values such as names, normalized tags, merged maps, and feature flags.
- `main.tf`: primary resources and data sources.
- `outputs.tf`: stable output contract.
- `README.md`: consumer-facing usage, input/output tables, examples, and design notes.
- `examples/`: runnable consumer examples.
- `tests/`: Terraform native tests where practical.

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
```

Not allowed in a reusable module root:

```hcl
provider "azurerm" {
  features {}
}
```

Provider configuration belongs in root deployments, examples, test fixtures, or stack entry points.

Use provider aliases only when the module genuinely needs multiple provider contexts, such as cross-subscription private DNS or hub-spoke networking. If aliases are required, document them clearly and provide an example.

Do not configure Terraform backends inside reusable modules.

## Version Constraints

Set conservative version constraints.

Recommended default:

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
```

Use a higher Terraform version only when the module depends on features from that version.

Avoid overly narrow provider pinning in reusable modules. Let root deployments control exact provider lock versions through `.terraform.lock.hcl`.

## Naming Strategy

Modules should support predictable naming.

Use one of these patterns:

- explicit `name`
- structured `context`
- map keys for repeated child resources

For simple modules, support both:

- `name`: caller-provided exact resource name
- `context`: business context used to compute a name when `name` is not supplied

Recommended context shape:

```hcl
object({
  org      = optional(string)
  app      = string
  env      = string
  region   = string
  instance = optional(string)
})
```

Naming rules:

- Prefer explicit names when Azure naming rules are strict or organization-specific.
- Use computed names only when the naming convention is clear and stable.
- Do not use random suffixes by default.
- Do not make names depend on non-identity inputs such as tags, SKU, or diagnostics.
- Normalize names only when safe for the Azure resource type.
- Validate name length and allowed characters where practical.

If a generated name may exceed Azure limits, fail with a helpful validation error instead of silently truncating unless truncation is an explicit design choice.

## Inputs

Inputs are the consumer contract. Make them explicit, typed, and stable.

General input rules:

- Every variable must have a clear description.
- Prefer precise object types over `any`.
- Prefer maps for repeated resources.
- Prefer nullable objects for optional feature blocks.
- Use booleans for simple enablement only when no configuration is needed.
- Provide safe defaults where practical.
- Use `null` to mean "not configured" or "let provider default apply."
- Avoid empty strings as sentinel values.
- Avoid asking consumers for values that can be derived safely inside the module.

Good optional feature pattern:

```hcl
variable "diagnostic_settings" {
  description = "Diagnostic settings configuration. Set to null to disable diagnostic settings."
  type = object({
    workspace_resource_id = string
    logs                  = optional(set(string), [])
    metrics               = optional(set(string), ["AllMetrics"])
  })
  default = null
}
```

Avoid many loosely related booleans:

```hcl
variable "enable_diagnostics" {}
variable "enable_logs" {}
variable "enable_metrics" {}
variable "enable_archive" {}
```

Use validations for:

- required naming rules
- allowed SKUs
- allowed environments
- CIDR shape where simple validation is enough
- mutually exclusive inputs
- "at least one of these inputs" rules

Do not over-validate values already strongly validated by Azure unless the validation improves the consumer experience.

## Object Inputs

Use object inputs for structured feature configuration.

Object inputs should:

- group related settings together
- use optional attributes for reasonable defaults
- avoid deeply nested structures unless the Azure resource is naturally nested
- keep required attributes meaningful
- stay readable in examples

Prefer:

```hcl
variable "network_rules" {
  description = "Network access rules. Set to null to use provider defaults."
  type = object({
    default_action             = optional(string, "Deny")
    bypass                     = optional(set(string), ["AzureServices"])
    ip_rules                   = optional(set(string), [])
    virtual_network_subnet_ids = optional(set(string), [])
  })
  default = null
}
```

Avoid a flat variable list that forces consumers to understand internal resource structure.

## Repeated Resources

Use maps for repeated resources.

Repeated child resources should usually be modeled as:

```hcl
variable "subnets" {
  description = "Subnets to create, keyed by stable caller-defined names."
  type = map(object({
    name             = optional(string)
    address_prefixes = list(string)
  }))
  default = {}
}
```

Rules:

- Use caller-defined map keys for stable Terraform addresses.
- Do not use list indexes for resources that may be added, removed, or reordered.
- Allow each item to override its Azure name when useful.
- Keep the map key stable even if the Azure name changes.
- Output repeated resources as maps keyed by the same caller-defined keys.

## Locals

Use `locals` to centralize derived values.

Good uses of locals:

- computed names
- normalized location
- merged tags
- maps transformed for `for_each`
- feature enablement flags
- derived IDs or lookup maps

Keep locals readable. Avoid dense expressions that make review difficult.

When a transformation is complex, break it into multiple named locals.

## Tags

Every taggable Azure resource should support tags unless the Azure resource type does not allow them.

Recommended input:

```hcl
variable "tags" {
  description = "Tags to apply to taggable resources."
  type        = map(string)
  default     = {}
}
```

Tagging rules:

- Apply tags consistently to all taggable resources created by the module.
- Allow consumers to pass enterprise tags.
- Do not hard-code tenant-specific tag values.
- Do not silently overwrite consumer tags unless the module contract explicitly says so.
- If default tags are supported, merge them predictably and document precedence.

Recommended precedence:

1. mandatory module tags, if any
2. default tags
3. consumer-provided tags

Consumer-provided tags should usually win unless a tag is mandatory for governance.

## Data Sources

Use data sources carefully.

Data sources are acceptable when:

- the caller provides an explicit name or ID to look up
- the lookup is optional and clearly documented
- the data source avoids duplicating complex caller logic

Avoid data sources that:

- assume organization-specific naming conventions
- search broad Azure scope without explicit filters
- hide dependencies that should be explicit inputs
- make tests require real enterprise resources

Prefer resource IDs as inputs for existing infrastructure.

Example:

- Prefer `subnet_id` over `vnet_name`, `subnet_name`, and `resource_group_name` unless lookup by name is a deliberate module feature.

## Dependencies

Make dependencies explicit through inputs and outputs.

Do not create hidden dependencies through naming assumptions.

Prefer this:

```hcl
variable "subnet_id" {
  description = "Subnet resource ID used by the resource."
  type        = string
}
```

Over this:

```hcl
data "azurerm_subnet" "this" {
  name                 = "${var.app}-${var.env}-subnet"
  virtual_network_name = "${var.app}-${var.env}-vnet"
  resource_group_name  = "${var.app}-${var.env}-rg"
}
```

Use `depends_on` rarely. If explicit `depends_on` is needed, explain why in a concise comment.

## Security Defaults

Prefer secure defaults where practical, without making the module unusable.

Examples of secure defaults:

- disable public network access where the Azure service supports it and private access is expected
- require TLS 1.2 or newer where applicable
- use managed identities instead of secrets where possible
- enable purge protection for production-grade key vault usage where appropriate
- avoid broad role assignments by default
- avoid public IP creation unless explicitly requested
- avoid admin credentials unless the resource requires them

Security settings should be configurable when legitimate use cases differ between environments.

Do not encode enterprise policy enforcement into every primitive module if Azure Policy is the better control plane.

## Identity And RBAC

Prefer managed identity over credentials.

Identity rules:

- Support system-assigned identity when commonly needed.
- Support user-assigned identity when enterprise deployments need lifecycle control.
- Output principal IDs needed by downstream RBAC assignments.
- Avoid creating broad role assignments by default.

RBAC rules:

- Optional RBAC assignments may be included when they are directly attached to the resource lifecycle.
- Role assignments should use stable map keys.
- Inputs should accept principal IDs and role definition IDs or names.
- Avoid tenant-specific principals in reusable modules.
- Document whether RBAC propagation delay can affect examples or tests.

## Networking And Private Access

For resources that commonly support private access, model network controls intentionally.

Common patterns:

- `public_network_access_enabled`
- `network_rules`
- `private_endpoints`
- `private_dns_zone_resource_ids`
- `subnet_resource_id`

Private endpoint support should usually be optional and map-based.

Do not assume a private DNS zone name or hub subscription unless supplied by the caller or stack module.

## Diagnostics And Monitoring

Support diagnostic settings for resources where monitoring is expected in enterprise use.

Diagnostic settings should be optional and explicit.

Inputs should usually accept:

- Log Analytics workspace resource ID
- enabled log categories or category groups
- enabled metric categories
- optional storage account ID or event hub authorization rule ID when needed

Avoid enabling diagnostics by default unless the destination is supplied and behavior is clear.

Output diagnostic setting IDs when created.

## Locks

Resource locks may be supported when they are directly related to the module resource.

Rules:

- Locks must be optional.
- Lock level must be configurable.
- Lock names should be predictable.
- Document operational impact, especially for `CanNotDelete` and `ReadOnly`.

Do not add locks silently.

## Azure Policy And Governance

Do not over-govern primitive modules.

Governance often belongs in:

- Azure Policy
- landing-zone stack modules
- management group deployments
- platform CI checks

Primitive modules may expose inputs that make policy compliance easy, but they should not hide broad governance decisions inside a small resource module.

## Outputs

Outputs are part of the module contract.

Output rules:

- Output resource names.
- Output resource IDs.
- Output principal IDs.
- Output maps for repeated resources.
- Output key integration values needed by downstream modules.
- Avoid outputting full provider resource objects.
- Mark sensitive outputs as `sensitive = true`.

For repeated resources, preserve caller map keys:

```hcl
output "subnets" {
  description = "Subnets created by this module, keyed by input subnet key."
  value = {
    for key, subnet in azurerm_subnet.this : key => {
      name = subnet.name
      id   = subnet.id
    }
  }
}
```

## Examples

Every reusable module should include examples.

Required examples:

- `examples/basic`: smallest practical working example
- `examples/complete`: demonstrates common optional features

Add when useful:

- `examples/multiple-*`: demonstrates caller-owned `for_each`
- `examples/private-endpoint`: demonstrates private access
- `examples/customer-managed-key`: demonstrates encryption integration
- `examples/existing-network`: demonstrates explicit dependency inputs

Example rules:

- Examples must include provider configuration because examples are root modules.
- Examples should be runnable.
- Examples should avoid real tenant-specific values.
- Examples should use realistic names and tags.
- Examples should show consumer ergonomics, not every internal option.

## Testing

Prefer Terraform native tests where practical.

Minimum useful validation:

- `terraform fmt -check -recursive`
- `terraform validate`
- at least one example validation
- tests for naming logic when the module computes names
- tests for optional feature enablement where the module uses dynamic blocks or `for_each`

Use apply tests sparingly for expensive Azure resources.

For costly resources such as AKS, prefer:

- static validation
- plan-focused tests
- small apply-safe examples only when cost and cleanup are acceptable

Tests should prove module contracts, not Azure itself.

## Documentation

Each module should include consumer-facing documentation.

Documentation should explain:

- what the module creates
- what the module intentionally does not create
- basic usage
- complete usage
- important design decisions
- provider requirements
- input contract
- output contract
- known limitations

Keep documentation practical. Avoid long theory sections in module READMEs; put deeper standards in shared references like this file.

## CI Expectations

Recommended CI checks:

- Terraform formatting
- Terraform validation
- Terraform test where present
- linting with a Terraform-aware tool if configured
- documentation generation check if docs are generated
- security scanning where useful

CI should catch broken examples and invalid module syntax before review.

## Style

General style rules:

- Use `snake_case` for variables, locals, outputs, and resource names.
- Use `this` for the main resource when there is only one primary resource.
- Use descriptive names for child resources.
- Keep resource names stable.
- Keep expressions readable.
- Prefer explicit types.
- Avoid clever one-liners when a few locals are clearer.
- Add comments only when they explain non-obvious intent or provider behavior.

Formatting:

- Run `terraform fmt -recursive`.
- Keep files focused by responsibility.
- Avoid large unrelated changes in the same module revision.

## Review Checklist

Before considering a module ready, verify:

- The module has a clear resource-family boundary.
- The module root does not configure providers or backends.
- Inputs are typed, documented, and stable.
- Optional features use nullable objects or maps instead of many unrelated booleans.
- Repeated resources use stable map keys.
- Names are predictable and validated where practical.
- Dependencies are explicit through IDs or clear inputs.
- Security defaults are reasonable.
- Tags are applied consistently.
- Outputs expose IDs and integration values needed downstream.
- Examples are runnable and realistic.
- Tests or validation paths exist for important behavior.
- The module avoids tenant-specific assumptions.

## Blocking Issues

Treat these as blocking in review:

- Provider configuration inside a reusable module root.
- Backend configuration inside a reusable module root.
- Hidden dependencies based on hard-coded naming conventions.
- Repeated resources addressed by unstable list indexes.
- Missing outputs needed by downstream modules.
- Examples that cannot run.
- Required tenant-specific values hard-coded into the module.
- Broad role assignments created by default.
- Public exposure enabled by default without a clear reason for resource types where private access is expected.

## Design Risks

Treat these as design risks that may need discussion:

- Primitive module contains stack-level orchestration.
- Module has too many unrelated feature flags.
- Naming changes when non-identity inputs change.
- Data sources perform implicit lookups instead of accepting IDs.
- Optional features are difficult to test.
- Outputs expose too much implementation detail.
- The complete example is so large that consumers cannot understand the module contract.
