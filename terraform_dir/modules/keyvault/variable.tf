variable "owner" {
  type        = string
  description = "Owner of the resource"
}

variable "env" {
  type        = string
  description = "Environment to be deployed in"
}


variable "location_short" {
  type        = string
  description = "Short name for location"
}

variable "kv_mappings" {
  type        = map(any)
  description = "Map of RG and KVs"
}

variable "location" {
  type        = string
  description = "Location in which resource needs to be provisioned"
}
