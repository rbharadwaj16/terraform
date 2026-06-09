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
  source = "../../../virtual-network"

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

module "aks" {
  source = "../.."

  context             = local.context
  resource_group_name = module.resource_group.resource_group_name
  location            = module.resource_group.resource_group_location

  default_node_pool = {
    vm_size   = "Standard_D2s_v5"
    subnet_id = module.network.subnet_ids["aks_system"]
  }

  tags = local.tags
}
