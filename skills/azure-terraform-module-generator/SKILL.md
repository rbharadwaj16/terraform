---
name: azure-terraform-module-generator
description: generate enterprise reusable azure terraform module files and repo scaffolding. use when the user asks to create, scaffold, or generate a terraform module for azure resources such as resource groups, virtual networks, key vault, storage, acr, aks, private endpoints, policies, budgets, rbac, diagnostics, or landing-zone and aks platform stacks. follow azure and terraform best practices, avm-inspired conventions, examples, tests, and github-ready structure. ask clarifying questions when module scope, naming, inputs, optional features, or test strategy are ambiguous.
---

# Azure Terraform Module Generator

## Role
Generate Azure Terraform module files for an enterprise platform team. The user may ask for an architect brief, a scaffold, or complete files. If unclear, ask which level they want.

## Default assumptions
- Terraform, not OpenTofu, unless requested.
- `azurerm` provider v4.x unless requested.
- GitHub repository layout.
- Central platform team publishes modules; app teams consume them.
- Modules must be reusable, secure by default, and deployable many times by caller-side `for_each`.
- AVM is a reference standard, not something to copy blindly.

## Generation modes
When asked to generate, first classify the request:
- `brief`: requirements and acceptance criteria only.
- `scaffold`: file/folder structure plus partial placeholders.
- `full`: complete runnable module files, examples, tests, and CI.
If the user does not specify, ask or default to `brief` for new design discussions and `full` for explicit "generate files" requests.

## Standard module repository layout
Use this layout unless the user requests otherwise:
```
terraform-azurerm-<module>/
  versions.tf
  variables.tf
  locals.tf
  main.tf
  outputs.tf
  README.md
  CHANGELOG.md
  .terraform-docs.yml
  .tflint.hcl
  examples/
    basic/
    complete/
  tests/
  .github/workflows/ci.yml
```

## Resource module standards
- Manage one main Azure resource family per module.
- Do not configure `provider "azurerm"` or backend in the module root.
- Put provider configuration only in examples or consuming stacks.
- Use `required_providers` in `versions.tf`.
- Accept final `name` where practical. If agreed, also support a `context` object for convention-based naming.
- Use object inputs for optional feature blocks: `lock`, `budget`, `role_assignments`, `diagnostic_settings`, `private_endpoints`.
- Use maps for repeated child resources and stable `for_each` keys.
- Use `count` only for single optional resources.
- Make weak/security-reducing behavior opt-in.
- Expose discrete outputs. For repeated resources, output maps keyed by caller keys.

## Reference files
- Read `references/shared-module-standards.md` when generating or reviewing reusable module structure and cross-module conventions.
- Read `references/resource-group-module.md` when generating, reviewing, or extending the Azure Resource Group module.
- Read `references/network-module.md` when generating, reviewing, or extending Azure virtual network modules.
- Read `references/aks-module.md` when generating, reviewing, or extending Azure Kubernetes Service modules.

## Naming guidance
For primitive resource modules, prefer explicit `name`. If the user wants convention-based naming, support `context` with a deterministic prefix and clear override rule: `name` wins, `context` fallback. Never use random names by default.

## Examples requirement
Every generated module must include explicit examples that show how app teams consume it. Include at least:
- `basic`: minimal successful usage.
- `complete`: optional features and realistic enterprise inputs.
For modules designed for multiple instances, include a caller-side `for_each` example.

## Testing requirement
Generated modules should include test strategy and files where practical:
- Static checks: `terraform fmt`, `terraform validate`, `tflint`, `checkov` or equivalent.
- Example plan/apply tests for cheap resources.
- Plan-only tests for expensive resources such as AKS, App Gateway, NAT Gateway, Private Endpoints, or ingestion-heavy diagnostics.
- Always destroy integration-test resources.

## Clarifying questions
Ask before generating if any of these are unclear:
- Is this a primitive resource module or a composed stack/pattern module?
- Which optional features belong in scope?
- Should naming be explicit-only or support `context`?
- Should the module create dependencies or accept existing resource IDs?
- What should be apply-tested versus plan-only?
- Should examples target GitHub Actions, Azure DevOps, or both?

## Output rules
- If creating files, provide a downloadable archive when possible.
- If writing in chat, organize by filename.
- Do not silently omit tests or examples; if not included, state why and list follow-up work.
