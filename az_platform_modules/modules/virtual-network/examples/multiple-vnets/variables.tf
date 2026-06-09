variable "networks" {
  description = "Virtual networks to create, keyed by stable caller-defined names."
  type = map(object({
    name                = string
    resource_group_name = string
    location            = string
    address_space       = list(string)
    subnets = map(object({
      name             = optional(string)
      address_prefixes = list(string)
    }))
    tags = optional(map(string), {})
  }))
}
