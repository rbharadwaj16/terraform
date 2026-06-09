resource "azurerm_kubernetes_cluster" "this" {
  name                                = local.cluster_name
  resource_group_name                 = var.resource_group_name
  location                            = local.location
  dns_prefix                          = local.dns_prefix
  kubernetes_version                  = var.kubernetes_version
  sku_tier                            = var.sku_tier
  node_resource_group                 = var.node_resource_group
  private_cluster_enabled             = try(var.private_cluster.enabled, false)
  private_dns_zone_id                 = try(var.private_cluster.private_dns_zone_id, null)
  private_cluster_public_fqdn_enabled = try(var.private_cluster.public_fqdn_enabled, false)
  role_based_access_control_enabled   = var.role_based_access_control_enabled
  local_account_disabled              = var.local_account_disabled
  oidc_issuer_enabled                 = var.oidc_issuer_enabled
  workload_identity_enabled           = var.workload_identity_enabled
  azure_policy_enabled                = var.azure_policy_enabled
  tags                                = var.tags

  default_node_pool {
    name                         = var.default_node_pool.name
    vm_size                      = var.default_node_pool.vm_size
    vnet_subnet_id               = var.default_node_pool.subnet_id
    node_count                   = var.default_node_pool.node_count
    auto_scaling_enabled         = var.default_node_pool.auto_scaling_enabled
    min_count                    = try(var.default_node_pool.min_count, null)
    max_count                    = try(var.default_node_pool.max_count, null)
    max_pods                     = try(var.default_node_pool.max_pods, null)
    os_disk_size_gb              = try(var.default_node_pool.os_disk_size_gb, null)
    os_disk_type                 = try(var.default_node_pool.os_disk_type, null)
    os_sku                       = try(var.default_node_pool.os_sku, null)
    zones                        = try(var.default_node_pool.zones, null)
    only_critical_addons_enabled = try(var.default_node_pool.only_critical_addons_enabled, false)
    temporary_name_for_rotation  = try(var.default_node_pool.temporary_name_for_rotation, null)
    node_labels                  = try(var.default_node_pool.node_labels, {})
    tags                         = merge(var.tags, try(var.default_node_pool.tags, {}))
  }

  identity {
    type         = var.identity.type
    identity_ids = var.identity.type == "UserAssigned" ? var.identity.identity_ids : null
  }

  network_profile {
    network_plugin      = var.network_profile.network_plugin
    network_plugin_mode = try(var.network_profile.network_plugin_mode, null)
    network_policy      = try(var.network_profile.network_policy, null)
    load_balancer_sku   = var.network_profile.load_balancer_sku
    outbound_type       = var.network_profile.outbound_type
    service_cidr        = var.network_profile.service_cidr
    dns_service_ip      = var.network_profile.dns_service_ip
    pod_cidr            = try(var.network_profile.pod_cidr, null)
  }

  dynamic "azure_active_directory_role_based_access_control" {
    for_each = var.azure_active_directory_role_based_access_control == null ? [] : [var.azure_active_directory_role_based_access_control]

    content {
      tenant_id              = try(azure_active_directory_role_based_access_control.value.tenant_id, null)
      admin_group_object_ids = try(azure_active_directory_role_based_access_control.value.admin_group_object_ids, [])
      azure_rbac_enabled     = try(azure_active_directory_role_based_access_control.value.azure_rbac_enabled, true)
    }
  }

  dynamic "oms_agent" {
    for_each = var.oms_agent == null ? [] : [var.oms_agent]

    content {
      log_analytics_workspace_id      = oms_agent.value.log_analytics_workspace_id
      msi_auth_for_monitoring_enabled = try(oms_agent.value.msi_auth_for_monitoring_enabled, true)
    }
  }

  dynamic "key_vault_secrets_provider" {
    for_each = var.key_vault_secrets_provider == null ? [] : [var.key_vault_secrets_provider]

    content {
      secret_rotation_enabled  = try(key_vault_secrets_provider.value.secret_rotation_enabled, true)
      secret_rotation_interval = try(key_vault_secrets_provider.value.secret_rotation_interval, "2m")
    }
  }

  lifecycle {
    precondition {
      condition     = local.cluster_name != null
      error_message = "AKS cluster name cannot be determined. Provide either name or context."
    }
  }
}

resource "azurerm_kubernetes_cluster_node_pool" "this" {
  for_each = local.node_pools

  name                  = each.value.name
  kubernetes_cluster_id = azurerm_kubernetes_cluster.this.id
  vm_size               = each.value.vm_size
  mode                  = each.value.mode
  vnet_subnet_id        = each.value.subnet_id
  node_count            = each.value.node_count
  auto_scaling_enabled  = each.value.auto_scaling_enabled
  min_count             = try(each.value.min_count, null)
  max_count             = try(each.value.max_count, null)
  max_pods              = try(each.value.max_pods, null)
  os_disk_size_gb       = try(each.value.os_disk_size_gb, null)
  os_disk_type          = try(each.value.os_disk_type, null)
  os_sku                = try(each.value.os_sku, null)
  zones                 = try(each.value.zones, null)
  node_labels           = try(each.value.node_labels, {})
  node_taints           = try(each.value.node_taints, [])
  tags                  = merge(var.tags, try(each.value.tags, {}))
}

resource "azurerm_monitor_diagnostic_setting" "this" {
  count = var.diagnostic_settings == null ? 0 : 1

  name                           = coalesce(try(var.diagnostic_settings.name, null), "${local.cluster_name}-diag")
  target_resource_id             = azurerm_kubernetes_cluster.this.id
  log_analytics_workspace_id     = try(var.diagnostic_settings.log_analytics_workspace_id, null)
  storage_account_id             = try(var.diagnostic_settings.storage_account_id, null)
  eventhub_authorization_rule_id = try(var.diagnostic_settings.eventhub_authorization_rule_id, null)
  eventhub_name                  = try(var.diagnostic_settings.eventhub_name, null)

  dynamic "enabled_log" {
    for_each = try(var.diagnostic_settings.log_categories, [])

    content {
      category = enabled_log.value
    }
  }

  dynamic "enabled_log" {
    for_each = try(var.diagnostic_settings.log_category_groups, [])

    content {
      category_group = enabled_log.value
    }
  }

  dynamic "enabled_metric" {
    for_each = try(var.diagnostic_settings.metric_categories, [])

    content {
      category = enabled_metric.value
    }
  }
}

resource "azurerm_role_assignment" "this" {
  for_each = var.role_assignments

  scope                            = coalesce(try(each.value.scope, null), azurerm_kubernetes_cluster.this.id)
  role_definition_id               = try(each.value.role_definition_id, null)
  role_definition_name             = try(each.value.role_definition_name, null)
  principal_id                     = each.value.principal_id
  principal_type                   = try(each.value.principal_type, null)
  skip_service_principal_aad_check = try(each.value.skip_service_principal_aad_check, false)
}
