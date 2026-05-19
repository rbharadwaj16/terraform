variable "name" {
    description = "A static name of resource group provided by consumer."
    type = string
}


variable "context" {
    description = "context to consider if the name of rg is not provided"
    type = map(string)
}

variable "location" {
    description = "Azure region where the resource group will be created."
    type = string
}

variable "tags" {
    description = "A map of tags to assign to the resource group."
    type = map(string)
}