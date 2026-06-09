module "resource_group" {
  source = "../../../resource-group"

  context = {
    org      = "contoso"
    app      = "aks"
    env      = "prod"
    region   = "eus"
    instance = "01"
  }

  location = "eastus"

  tags = {
    environment = "prod"
    workload    = "aks"
    owner       = "platform"
  }
}

module "network" {
  source = "../.."

  context = {
    org      = "contoso"
    app      = "aks"
    env      = "prod"
    region   = "eus"
    instance = "01"
  }

  resource_group_name = module.resource_group.resource_group_name
  location            = module.resource_group.resource_group_location
  address_space       = ["10.50.0.0/16"]

  subnets = {
    aks_system = {
      name             = "snet-aks-system"
      address_prefixes = ["10.50.0.0/22"]
      nsg_key          = "aks"
      route_table_key  = "aks"
      service_endpoints = [
        "Microsoft.ContainerRegistry",
        "Microsoft.KeyVault"
      ]
    }

    private_endpoints = {
      name                              = "snet-private-endpoints"
      address_prefixes                  = ["10.50.8.0/24"]
      private_endpoint_network_policies = "Disabled"
      nsg_key                           = "private_endpoints"
    }
  }

  network_security_groups = {
    aks = {
      name = "nsg-aks-system"
      security_rules = {
        allow_https_from_corp = {
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

    private_endpoints = {
      name = "nsg-private-endpoints"
    }
  }

  route_tables = {
    aks = {
      name = "rt-aks-system"
      routes = {
        default_to_firewall = {
          address_prefix         = "0.0.0.0/0"
          next_hop_type          = "VirtualAppliance"
          next_hop_in_ip_address = "10.50.255.4"
        }
      }
    }
  }

  tags = {
    environment = "prod"
    workload    = "aks"
    owner       = "platform"
  }
}
