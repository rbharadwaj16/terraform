# Azure Role Assignment Terraform Module

This module creates one Azure RBAC role assignment at a caller-provided scope.

## Usage

```hcl
module "acr_pull" {
  source = "../../"

  scope                = module.container_registry.container_registry_id
  principal_id         = module.aks.kubelet_identity_object_id
  role_definition_name = "AcrPull"
}
```

## Inputs

| Name | Description | Type | Required |
| --- | --- | --- | --- |
| `scope` | Azure resource ID at which to assign the role. | `string` | yes |
| `principal_id` | Microsoft Entra object ID of the principal receiving the role. | `string` | yes |
| `role_definition_name` | Built-in Azure role name to assign. | `string` | yes |

## Outputs

| Name | Description |
| --- | --- |
| `id` | Resource ID of the role assignment. |

## Design Notes

- This initial version creates one assignment per module call.
- It supports built-in roles by name. Custom role-definition IDs and optional role-assignment settings are deferred to a later enhancement.
- The module creates no identities or target resources; callers pass both the principal ID and scope explicitly.
