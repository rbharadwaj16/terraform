variable "aks_name" {
  description = "The name of the Azure Kubernetes Service cluster."
  type        = string

  validation {
    condition     = trimspace(var.aks_name) != ""
    error_message = "aks_name cannot be empty."
  }
}

variable "resource_group_name" {
  description = "The name of the resource group in which to create the Azure Kubernetes Service cluster."
  type        = string

  validation {
    condition     = trimspace(var.resource_group_name) != ""
    error_message = "resource_group_name cannot be empty."
  }
}

variable "location" {
  description = "The Azure region in which to create the Azure Kubernetes Service cluster."
  type        = string

  validation {
    condition     = trimspace(var.location) != ""
    error_message = "location cannot be empty."
  }
}

variable "dns_prefix" {
  description = "The DNS prefix for the Azure Kubernetes Service cluster."
  type        = string

  validation {
    condition     = can(regex("^[A-Za-z0-9]([A-Za-z0-9-]{0,52}[A-Za-z0-9])?$", var.dns_prefix))
    error_message = "dns_prefix must be 1-54 characters, begin and end with a letter or number, and contain only letters, numbers, and hyphens."
  }
}

variable "default_node_pool" {
  description = "Configuration for the required default node pool."
  type = object({
    name           = string
    vm_size        = string
    node_count     = number
    vnet_subnet_id = string
  })

  validation {
    condition = alltrue([
      can(regex("^[a-z][a-z0-9]{0,11}$", var.default_node_pool.name)),
      trimspace(var.default_node_pool.vm_size) != "",
      var.default_node_pool.node_count > 0,
      trimspace(var.default_node_pool.vnet_subnet_id) != ""
    ])
    error_message = "default_node_pool.name must be 1-12 lowercase letters or numbers and start with a letter; vm_size and vnet_subnet_id cannot be empty; node_count must be greater than zero."
  }
}

variable "tags" {
  description = "A map of tags to assign to the Azure Kubernetes Service cluster."
  type        = map(string)
  default     = {}
}
