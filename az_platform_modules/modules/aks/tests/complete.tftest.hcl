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
    sku_tier            = "Standard"

    private_cluster = {
      enabled             = true
      private_dns_zone_id = "System"
    }

    default_node_pool = {
      vm_size              = "Standard_D4s_v5"
      subnet_id            = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-network/providers/Microsoft.Network/virtualNetworks/vnet-aks/subnets/snet-aks-system"
      auto_scaling_enabled = true
      min_count            = 2
      max_count            = 5
    }

    node_pools = {
      user = {
        vm_size              = "Standard_D4s_v5"
        subnet_id            = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-network/providers/Microsoft.Network/virtualNetworks/vnet-aks/subnets/snet-aks-user"
        auto_scaling_enabled = true
        min_count            = 1
        max_count            = 4
      }
    }

    diagnostic_settings = {
      log_analytics_workspace_id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-monitoring/providers/Microsoft.OperationalInsights/workspaces/law-platform"
    }
  }

  assert {
    condition     = azurerm_kubernetes_cluster.this.name == "aks-contoso-aks-prod-eus-01"
    error_message = "Context should compute the expected AKS cluster name."
  }

  assert {
    condition     = azurerm_kubernetes_cluster.this.private_cluster_enabled == true
    error_message = "Private cluster should be enabled in the complete plan."
  }

  assert {
    condition     = length(azurerm_kubernetes_cluster_node_pool.this) == 1
    error_message = "One additional node pool should be planned."
  }

  assert {
    condition     = length(azurerm_monitor_diagnostic_setting.this) == 1
    error_message = "One diagnostic setting should be planned."
  }
}
