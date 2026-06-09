provider "azurerm" {
  features {}
}

run "basic_plan" {
  command = plan

  variables {
    name                = "aks-contoso-aks-dev-eus-01"
    resource_group_name = "rg-contoso-aks-dev-eus-01"
    location            = "eastus"

    default_node_pool = {
      vm_size   = "Standard_D2s_v5"
      subnet_id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-network/providers/Microsoft.Network/virtualNetworks/vnet-aks/subnets/snet-aks-system"
    }
  }

  assert {
    condition     = azurerm_kubernetes_cluster.this.name == "aks-contoso-aks-dev-eus-01"
    error_message = "AKS cluster should use the explicit name."
  }

  assert {
    condition     = azurerm_kubernetes_cluster.this.default_node_pool[0].vnet_subnet_id == var.default_node_pool.subnet_id
    error_message = "Default node pool should use the supplied subnet ID."
  }
}
