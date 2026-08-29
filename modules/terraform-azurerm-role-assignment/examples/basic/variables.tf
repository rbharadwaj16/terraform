variable "subscription_id" {
  description = "The Azure subscription ID in which to create the example role assignment."
  type        = string
}

variable "scope" {
  description = "The Azure resource ID at which to assign the role."
  type        = string
}

variable "principal_id" {
  description = "The Microsoft Entra object ID of the principal that receives the role assignment."
  type        = string
}

variable "role_definition_name" {
  description = "The built-in Azure role name to assign."
  type        = string
}
