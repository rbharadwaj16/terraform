provider "azurerm" {
  features {}
}

run "complete_plan" {
  command = plan

  variables {
    context = {
      org      = "contoso"
      app      = "aks"
      env      = "prod"
      region   = "eus"
      instance = "01"
    }

    resource_group_name = "rg-contoso-aks-prod-eus-01"
    location            = "eastus"
    address_space       = ["10.50.0.0/16"]

    subnets = {
      aks_system = {
        name             = "snet-aks-system"
        address_prefixes = ["10.50.0.0/22"]
        nsg_key          = "aks"
        route_table_key  = "aks"
      }
    }

    network_security_groups = {
      aks = {
        security_rules = {
          allow_https = {
            priority                   = 100
            direction                  = "Inbound"
            access                     = "Allow"
            protocol                   = "Tcp"
            source_port_range          = "*"
            destination_port_range     = "443"
            source_address_prefix      = "10.0.0.0/8"
            destination_address_prefix = "*"
          }
        }
      }
    }

    route_tables = {
      aks = {
        routes = {
          default = {
            address_prefix         = "0.0.0.0/0"
            next_hop_type          = "VirtualAppliance"
            next_hop_in_ip_address = "10.50.255.4"
          }
        }
      }
    }
  }

  assert {
    condition     = azurerm_virtual_network.this.name == "vnet-contoso-aks-prod-eus-01"
    error_message = "Context should compute the expected VNet name."
  }

  assert {
    condition     = length(azurerm_network_security_group.this) == 1
    error_message = "One network security group should be planned."
  }

  assert {
    condition     = length(azurerm_subnet_route_table_association.this) == 1
    error_message = "One subnet route table association should be planned."
  }
}
