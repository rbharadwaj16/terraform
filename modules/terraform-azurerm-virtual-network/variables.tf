variable "vnet_name" {
  description = "The name of the virtual network."
  type        = string
}

variable "resource_group_name" {
  description = "The name of the resource group in which to create the virtual network."
  type        = string

}

variable "location" {
  description = "The Azure region in which to create the virtual network."
  type        = string
}

variable "address_space" {
  description = "The address space that is used by the virtual network."
  type        = list(string)
}

variable "subnets" {
  description = "A map of subnets to create within the virtual network."
  type = map(object({
    name             = string
    address_prefixes = list(string)
  }))
}

variable "tags" {
  description = "A map of tags to assign to the virtual network."
  type        = map(string)
  default     = {}
}

variable "dns_servers" {
  description = "A list of DNS server IP addresses to use for the virtual network."
  type        = list(string)
  default     = []
}
