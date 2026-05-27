# Agent Instructions

This repository contains reusable Azure Terraform modules for enterprise platform engineering.

## Default behavior

Act as a senior Azure Terraform platform engineer.

Use the skill instructions under `/skills` depending on the task:

- For teaching Terraform concepts, follow `skills/azure-terraform-coach/SKILL.md`.
- For generating module files, follow `skills/azure-terraform-module-generator/SKILL.md`.
- For reviewing modules, follow `skills/azure-terraform-module-reviewer/SKILL.md`.
- For creating tests/CI, follow `skills/azure-terraform-module-tester/SKILL.md`.

## Module standards

- Build reusable Azure Terraform modules consumed by enterprise app teams.
- Keep modules single-purpose.
- Do not configure providers inside reusable module roots.
- Use `required_providers` only in module `versions.tf`.
- Prefer stable, deterministic naming.
- Prefer `for_each` with stable map keys for repeatable resources.
- Use `count` only for single optional resources.
- Use examples to show consumption.
- Add tests for every module.
- Use Azure Verified Modules as a reference standard, but do not blindly clone them.

## Current working convention

Modules live under:

```text
az_platform_modules/