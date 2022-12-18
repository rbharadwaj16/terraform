variable "owner" {
  type        = string
  description = "Owner of the resource"
}

variable "network_rg" {
  type        = list(string)
  description = "RG in which VNET is to be created"
}

variable "location" {
  type        = string
  description = "Location in which resource group needs to be created"
}

variable "env" {
  type        = string
  description = "Environment to be deployed in"
}
variable "location_short" {
  type        = string
  description = "Short name for location"
}
variable "vnet" {
  type = map
  description = "Map of VNET attributes"
}
variable "purpose_tag" {
  type        = string
  description = "Purpose Tag"
}

variable "owner_tag" {
  type        = string
  description = "Owner tag"
}

variable "client_tag" {
  type        = string
  description = "Client tag"
}


variable "subnets" {
  type = map
  description = "Map of Subnet attributes"
}

