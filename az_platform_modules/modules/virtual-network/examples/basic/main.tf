locals {
  context = {
    org      = "contoso"
    app      = "aks"
    env      = "dev"
    region   = "eus"
    instance = "01"
  }

  tags = {
    environment = "dev"
    workload    = "aks"
    owner       = "platform"
  }
}

module "resource_group" {
  source = "../../../resource-group"

  context  = local.context
  location = "eastus"
  tags     = local.tags
}

module "network" {
  source = "../.."

  context             = local.context
  resource_group_name = module.resource_group.resource_group_name
  location            = module.resource_group.resource_group_location
  address_space       = ["10.40.0.0/16"]

  subnets = {
    aks_system = {
      name             = "snet-aks-system"
      address_prefixes = ["10.40.0.0/22"]
    }
  }

  tags = local.tags
}
