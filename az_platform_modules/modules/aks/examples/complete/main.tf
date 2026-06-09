locals {
  context = {
    org      = "contoso"
    app      = "aks"
    env      = "prod"
    region   = "eus"
    instance = "01"
  }

  tags = {
    environment = "prod"
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
  address_space       = ["10.50.0.0/16"]

  subnets = {
    aks_system = {
      name             = "snet-aks-system"
      address_prefixes = ["10.50.0.0/22"]
      nsg_key          = "aks"
    }

    aks_user = {
      name             = "snet-aks-user"
      address_prefixes = ["10.50.4.0/22"]
      nsg_key          = "aks"
    }
  }

  network_security_groups = {
    aks = {
      name = "nsg-aks"
    }
  }

  tags = local.tags
}

module "aks" {
  source = "../.."

  context             = local.context
  resource_group_name = module.resource_group.resource_group_name
  location            = module.resource_group.resource_group_location
  sku_tier            = "Standard"

  private_cluster = {
    enabled             = true
    private_dns_zone_id = "System"
  }

  default_node_pool = {
    name                 = "system"
    vm_size              = "Standard_D4s_v5"
    subnet_id            = module.network.subnet_ids["aks_system"]
    auto_scaling_enabled = true
    min_count            = 2
    max_count            = 5
    max_pods             = 50
    os_disk_size_gb      = 128
  }

  node_pools = {
    user = {
      name                 = "user"
      vm_size              = "Standard_D4s_v5"
      subnet_id            = module.network.subnet_ids["aks_user"]
      auto_scaling_enabled = true
      min_count            = 1
      max_count            = 4
      node_labels = {
        workload = "user"
      }
    }
  }

  network_profile = {
    network_plugin    = "azure"
    network_policy    = "azure"
    load_balancer_sku = "standard"
    outbound_type     = "loadBalancer"
    service_cidr      = "10.240.0.0/16"
    dns_service_ip    = "10.240.0.10"
  }

  azure_active_directory_role_based_access_control = {
    tenant_id              = var.tenant_id
    admin_group_object_ids = var.admin_group_object_ids
    azure_rbac_enabled     = true
  }

  oms_agent = var.log_analytics_workspace_id == null ? null : {
    log_analytics_workspace_id = var.log_analytics_workspace_id
  }

  diagnostic_settings = var.log_analytics_workspace_id == null ? null : {
    log_analytics_workspace_id = var.log_analytics_workspace_id
    log_category_groups        = ["allLogs"]
    metric_categories          = ["AllMetrics"]
  }

  azure_policy_enabled = true

  key_vault_secrets_provider = {
    secret_rotation_enabled = true
  }

  tags = local.tags
}
