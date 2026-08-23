variable "keyvault_name" {
  description = "The name of the Key Vault."
  type        = string
}   

variable "resource_group_name" {
  description = "The name of the resource group in which to create the Key Vault."
  type        = string
}   

variable "location" {
  description = "The Azure region in which to create the Key Vault."
  type        = string
}

variable "sku_name" {
  description = "The SKU name of the Key Vault. Possible values are 'standard' and 'premium'."
  type        = string
  default     = "standard"
}

variable "tenant_id" {
  description = "The Azure Active Directory tenant ID that should be used for authenticating requests to the Key Vault."
  type        = string
}   

variable " tags" {
    description = "A mapping of tags to assign to the Key Vault."
    type        = map(string)
    default     = {}
}