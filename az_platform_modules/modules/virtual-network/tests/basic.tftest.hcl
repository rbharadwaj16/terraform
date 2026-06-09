provider "azurerm" {
  features {}
}

run "basic_plan" {
  command = plan

  variables {
    name                = "vnet-contoso-aks-dev-eus-01"
    resource_group_name = "rg-contoso-aks-dev-eus-01"
    location            = "eastus"
    address_space       = ["10.40.0.0/16"]

    subnets = {
      aks_system = {
        name             = "snet-aks-system"
        address_prefixes = ["10.40.0.0/22"]
      }
    }
  }

  assert {
    condition     = azurerm_virtual_network.this.name == "vnet-contoso-aks-dev-eus-01"
    error_message = "Virtual network should use the explicit name."
  }

  assert {
    condition     = azurerm_subnet.this["aks_system"].name == "snet-aks-system"
    error_message = "Subnet should preserve the caller-defined map key and Azure name."
  }
}
