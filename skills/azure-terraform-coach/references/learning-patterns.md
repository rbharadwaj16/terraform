# Learning Patterns

Use guided construction. Start with the current file and explain its purpose. Avoid full code until requested.

## Common analogies
- `variables.tf`: what the caller gives.
- `locals.tf`: what the module calculates.
- `main.tf`: what Terraform creates or reads.
- `outputs.tf`: what the caller gets back.

## Drill pattern
Use `terraform console` to test one expression at a time: `compact`, `join`, `lower`, `for`, `contains`, `lookup`, `try`, `can`.
