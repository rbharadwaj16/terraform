resource "azurerm_kubernetes_cluster" "this" {
  name                = var.aks_name
  location            = var.location
  resource_group_name = var.resource_group_name
  dns_prefix          = var.dns_prefix

  default_node_pool {
    name           = var.default_node_pool.name
    vm_size        = var.default_node_pool.vm_size
    node_count     = var.default_node_pool.node_count
    vnet_subnet_id = var.default_node_pool.vnet_subnet_id
  }

  node_provisioning_profile {
    mode = "Manual"
  }

  identity {
    type = "SystemAssigned"
  }

  tags = var.tags
}
