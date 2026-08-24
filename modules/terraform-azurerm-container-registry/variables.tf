variable "container_registry_name" {
  description = "The name of the Azure Container Registry."
  type        = string
}

variable "resource_group_name" {
  description = "The name of the resource group in which to create the Azure Container Registry."
  type        = string
}

variable "location" {
  description = "The Azure region in which to create the Azure Container Registry."
  type        = string
}

variable "sku" {
  description = "The SKU of the Azure Container Registry."
  type        = string
  default     = "Standard"
}

variable "admin_enabled" {
  description = "Whether to enable the admin user for the Azure Container Registry."
  type        = bool
  default     = false
}

variable "tags" {
  description = "A map of tags to assign to the Azure Container Registry."
  type        = map(string)
  default     = {}
}
