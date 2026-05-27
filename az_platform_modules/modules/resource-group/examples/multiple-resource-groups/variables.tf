variable "resource_groups" {
  description = "Resource groups to create, keyed by stable caller-defined names."
  type = map(object({
    name = optional(string)
    context = optional(object({
      org      = optional(string)
      app      = string
      env      = string
      region   = string
      instance = optional(string)
    }))
    location = string
    tags     = optional(map(string), {})
  }))

  default = {
    app = {
      context = {
        org      = "contoso"
        app      = "orders"
        env      = "dev"
        region   = "eus"
        instance = "01"
      }
      location = "eastus"
      tags = {
        environment = "dev"
        owner       = "orders-team"
        workload    = "orders"
      }
    }

    shared = {
      name     = "rg-contoso-shared-dev-eus-01"
      location = "eastus"
      tags = {
        environment = "dev"
        owner       = "platform"
        workload    = "shared"
      }
    }
  }
}
