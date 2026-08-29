variable "subscription_id" {
  description = "The Azure subscription ID in which to create the example resources."
  type        = string
}

variable "resource_group_name" {
  description = "The name of the existing resource group in which to create the AKS cluster."
  type        = string
}

variable "location" {
  description = "The Azure region of the existing resource group and AKS cluster."
  type        = string
}

variable "aks_subnet_id" {
  description = "The resource ID of an existing subnet for the AKS default node pool."
  type        = string
}
