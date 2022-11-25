variable "owner" {
  type = string
  description = "Owner of the resource"
}

variable "rg_name" {
    type = list(string)
    description = "List of RG's to be created"
}

variable "location" {
    type = string
    description = "Location in which resource group needs to be created"  
}

variable "env" {
  type = string
  description = "Environment to be deployed in"
}
variable "location_short" {
    type = string
    description = "Short name for location"
}
