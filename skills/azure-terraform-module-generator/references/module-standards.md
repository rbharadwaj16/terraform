# Module Standards

## Primitive resource modules
Manage one main Azure resource family. Keep dependencies explicit. Caller loops with module `for_each`.

## Pattern/stack modules
Compose primitive modules for app-team consumption. Accept business intent and existing IDs.

## Inputs
Use explicit names or agreed `context`; object inputs for optional features; maps for repeated children.

## Outputs
Output names, IDs, principal IDs, and maps. Avoid full provider resource objects.

## Examples
Provide basic and complete examples. Add multi-instance example when reusable at scale.