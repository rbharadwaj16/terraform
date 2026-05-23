variable "name" {
    description = "A static name of resource group provided by consumer."
    type = string
    default = null
}


variable "context" {
    description = "context to consider if the name of rg is not provided"
    type = object({
        org = optional(string)
        app = string
        env = string
        region = string
        instance = optional(string)
    })
    default = null

}

variable "location" {
    description = "Azure region where the resource group will be created."
    type = string
}

variable "tags" {
    description = "A map of tags to assign to the resource group."
    type = map(string)
    default = {}

}