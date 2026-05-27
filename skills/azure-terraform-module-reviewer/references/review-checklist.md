# Review Checklist

## Blocking
- Provider configured in reusable module root.
- Module creates hidden dependencies without clear inputs.
- Repeated resources use unstable list indexes.
- Outputs are missing IDs needed by downstream modules.
- Examples cannot run.

## Design risks
- Primitive module contains governance that belongs in policy.
- Naming is random or changes when non-identity inputs change.
- Data sources assume org naming conventions.
- Optional features controlled by many booleans instead of nullable objects.
