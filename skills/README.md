# Terraform AI Skills

This folder contains four ChatGPT Skills for building an enterprise Azure Terraform module portfolio.

## Skills

1. `azure-terraform-coach` - teaches Terraform concepts step by step using your current module work.
2. `azure-terraform-module-reviewer` - reviews module code like a platform-infra PR reviewer.
3. `azure-terraform-module-generator` - generates reusable Azure Terraform module files, examples, tests, and CI scaffolding.
4. `azure-terraform-module-tester` - designs tests, plan assertions, and CI for Azure Terraform modules.

## Where to keep these files

Recommended repo layout:

```text
platform-infra/
  skills/
    azure-terraform-coach/
    azure-terraform-module-reviewer/
    azure-terraform-module-generator/
    azure-terraform-module-tester/
  modules/
    terraform-azurerm-resource-group/
    terraform-azurerm-virtual-network/
  stacks/
    aks-platform/
```

Keep Skills separate from Terraform modules. Skills are guidance/automation assets, not Terraform source.

## How to use in ChatGPT

Upload each skill folder as a Skill package if your ChatGPT workspace supports custom Skills, or keep these files in your repo and paste/load the relevant `SKILL.md` behavior into the session when working manually.

Typical usage:

```text
Use azure-terraform-coach to explain this locals.tf.
Use azure-terraform-module-reviewer to review my RG module.
Use azure-terraform-module-generator to scaffold a VNet module.
Use azure-terraform-module-tester to create tests for my RG module.
```

## How to use with Codex-style coding workflows

For Codex/AI coding agents, keep the relevant Skill instructions in the repo under `skills/` and reference the file in the task prompt. Example:

```text
Follow skills/azure-terraform-module-reviewer/SKILL.md. Review modules/terraform-azurerm-resource-group and produce a PR-style review.
```

For generation:

```text
Follow skills/azure-terraform-module-generator/SKILL.md. Generate the next checkpoint for modules/terraform-azurerm-resource-group. Do not change scope beyond the requested checkpoint.
```

For coaching:

```text
Follow skills/azure-terraform-coach/SKILL.md. Teach me why this locals.tf expression works before suggesting code changes.
```

## Packaging

Each skill directory is valid as an individual Skill. Package or upload them one at a time. Do not upload the whole `skills/` folder as one Skill.
