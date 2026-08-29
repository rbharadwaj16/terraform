variable "scope" {
  description = "The Azure resource ID at which to assign the role."
  type        = string

  validation {
    condition     = trimspace(var.scope) != ""
    error_message = "scope cannot be empty."
  }
}

variable "principal_id" {
  description = "The Microsoft Entra object ID of the principal that receives the role assignment."
  type        = string

  validation {
    condition     = trimspace(var.principal_id) != ""
    error_message = "principal_id cannot be empty."
  }
}

variable "role_definition_name" {
  description = "The built-in Azure role name to assign."
  type        = string

  validation {
    condition     = trimspace(var.role_definition_name) != ""
    error_message = "role_definition_name cannot be empty."
  }
}
