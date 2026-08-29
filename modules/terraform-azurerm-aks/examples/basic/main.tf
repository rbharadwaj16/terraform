module "aks" {
  source = "../.."

  aks_name            = "aks-ai-inference-dev-eus-01"
  resource_group_name = var.resource_group_name
  location            = var.location
  dns_prefix          = "aks-ai-inference-dev-eus-01"

  default_node_pool = {
    name           = "system"
    vm_size        = "Standard_D4s_v5"
    node_count     = 1
    vnet_subnet_id = var.aks_subnet_id
  }

  tags = {
    environment = "dev"
    workload    = "ai-inference"
  }
}
