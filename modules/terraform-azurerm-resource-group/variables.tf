variable "name" {
  description = "Exact resource group name. When set, this overrides context-based naming."
  type        = string
  default     = null

  validation {
    condition     = var.name == null || trimspace(var.name) != ""
    error_message = "name cannot be empty when provided."
  }

  validation {
    condition     = var.name == null || can(regex("^[A-Za-z0-9_.()\\-]{1,90}$", var.name))
    error_message = "name must be 1-90 characters and may contain letters, numbers, underscores, periods, parentheses, and hyphens."
  }

  validation {
    condition     = var.name == null || !endswith(var.name, ".")
    error_message = "name cannot end with a period."
  }
}

variable "context" {
  description = "Business context used to compute the resource group name when name is not provided."
  type = object({
    org      = optional(string)
    app      = string
    env      = string
    region   = string
    instance = optional(string)
  })
  default = null

  validation {
    condition = var.context == null || alltrue([
      trimspace(var.context.app) != "",
      trimspace(var.context.env) != "",
      trimspace(var.context.region) != ""
    ])
    error_message = "context.app, context.env, and context.region cannot be empty when context is provided."
  }

  validation {
    condition = var.context == null || alltrue([
      var.context.org == null || trimspace(var.context.org) != "",
      var.context.instance == null || trimspace(var.context.instance) != ""
    ])
    error_message = "context.org and context.instance cannot be empty when provided."
  }
}

variable "location" {
  description = "Azure region where the resource group will be created."
  type        = string

  validation {
    condition     = trimspace(var.location) != ""
    error_message = "location cannot be empty."
  }
}

variable "tags" {
  description = "Tags to apply to the resource group."
  type        = map(string)
  default     = {}
}
