variable "context" {
  description = "Business context used by the module to compute the resource group name."
  type = object({
    org      = optional(string)
    app      = string
    env      = string
    region   = string
    instance = optional(string)
  })

  default = {
    org      = "contoso"
    app      = "orders"
    env      = "prod"
    region   = "eus"
    instance = "01"
  }
}

variable "location" {
  description = "Azure region where the resource group will be created."
  type        = string
  default     = "eastus"
}

variable "tags" {
  description = "Enterprise tags assigned to the resource group."
  type        = map(string)

  default = {
    business_unit = "retail"
    cost_center   = "cc-1001"
    criticality   = "high"
    data_class    = "internal"
    environment   = "prod"
    managed_by    = "terraform"
    owner         = "platform"
    workload      = "orders"
  }
}
