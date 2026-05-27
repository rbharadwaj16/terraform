# Testing Standards

## Static
Run `terraform fmt`, `terraform validate`, `tflint`, and security scanning.

## Examples
Every example should init and plan. Cheap examples can apply/destroy. Expensive examples stay plan-only.

## Plan assertions
Assert presence and absence of resources, critical arguments, secure defaults, and stable map keys.

## Cleanup
Always destroy integration resources. Add unique prefixes/suffixes in examples if needed for parallel CI.
