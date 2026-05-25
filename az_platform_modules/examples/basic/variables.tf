variable "context" {
  description = "Naming context used to compute the resource group name."

  type = object({
    org      = optional(string)
    app      = string
    env      = string
    region   = string
    instance = optional(string)
  })
}

variable "location" {
  description = "Azure region where the resource group will be created."
  type        = string
}

variable "tags" {
  description = "Tags to apply to the resource group."
  type        = map(string)
}