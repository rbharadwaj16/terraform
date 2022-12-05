#Common Vars

variable "owner" {
  type = string
  description = "Owner of the resource"
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

variable "subscription_id" {
    type = string
    description = "ID of Subscription in which resource is to be deployed"  
}

variable "client_id" {
    type = string
    description = "Client ID to authorise"
}

variable "client_secret" {
    type = string
    description = "Client secret to authorise" 
}

variable "tenant_id" {
    type = string
    description = "Tenant ID in which subscription resides"  
}
# Resource Group Module

variable "rg_name" {
    type = list(string)
    description = "List of RG's to be created"
}