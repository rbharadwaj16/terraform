module "virtual_network" {
  source = "../.."

  vnet_name           = "vnet-ai-inference-dev-eus-01"
  resource_group_name = "rg-ai-inference-dev-eus-01"
  location            = "eastus"
  address_space       = ["10.20.0.0/16"]

  subnets = {
    aks = {
      name             = "snet-aks"
      address_prefixes = ["10.20.1.0/24"]
    }

    private_endpoints = {
      name             = "snet-private-endpoints"
      address_prefixes = ["10.20.2.0/24"]
    }
  }

  tags = {
    environment = "dev"
    workload    = "ai-inference"
  }
}
