variable "name" {
  description = "Exact AKS cluster name. When set, this overrides context-based naming."
  type        = string
  default     = null

  validation {
    condition     = var.name == null || length(trimspace(var.name)) > 0
    error_message = "When provided, name must not be empty."
  }
}

variable "context" {
  description = "Business context used to compute the AKS cluster name when name is not provided."
  type = object({
    org      = optional(string)
    app      = string
    env      = string
    region   = string
    instance = optional(string)
  })
  default = null
}

variable "resource_group_name" {
  description = "Name of the resource group where the AKS cluster will be created."
  type        = string
}

variable "location" {
  description = "Azure region where the AKS cluster will be created."
  type        = string
}

variable "dns_prefix" {
  description = "DNS prefix for the AKS cluster. When null, a deterministic prefix is derived from the cluster name."
  type        = string
  default     = null
}

variable "kubernetes_version" {
  description = "AKS Kubernetes version. Set to null to use the provider or Azure default."
  type        = string
  default     = null
}

variable "sku_tier" {
  description = "AKS SKU tier."
  type        = string
  default     = "Free"
}

variable "node_resource_group" {
  description = "Optional name for the AKS-managed node resource group."
  type        = string
  default     = null
}

variable "default_node_pool" {
  description = "Default AKS node pool configuration."
  type = object({
    name                         = optional(string, "system")
    vm_size                      = string
    subnet_id                    = string
    node_count                   = optional(number, 2)
    auto_scaling_enabled         = optional(bool, false)
    min_count                    = optional(number)
    max_count                    = optional(number)
    max_pods                     = optional(number)
    os_disk_size_gb              = optional(number)
    os_disk_type                 = optional(string)
    os_sku                       = optional(string)
    zones                        = optional(set(string))
    only_critical_addons_enabled = optional(bool, false)
    temporary_name_for_rotation  = optional(string)
    node_labels                  = optional(map(string), {})
    tags                         = optional(map(string), {})
  })

  validation {
    condition     = length(var.default_node_pool.name) <= 12
    error_message = "default_node_pool.name must be 12 characters or fewer."
  }

  validation {
    condition = (
      var.default_node_pool.auto_scaling_enabled == false ||
      (try(var.default_node_pool.min_count, null) != null && try(var.default_node_pool.max_count, null) != null)
    )
    error_message = "When default node pool autoscaling is enabled, min_count and max_count are required."
  }
}

variable "node_pools" {
  description = "Additional AKS node pools, keyed by stable caller-defined names."
  type = map(object({
    name                 = optional(string)
    vm_size              = string
    mode                 = optional(string, "User")
    subnet_id            = optional(string)
    node_count           = optional(number, 1)
    auto_scaling_enabled = optional(bool, false)
    min_count            = optional(number)
    max_count            = optional(number)
    max_pods             = optional(number)
    os_disk_size_gb      = optional(number)
    os_disk_type         = optional(string)
    os_sku               = optional(string)
    zones                = optional(set(string))
    node_labels          = optional(map(string), {})
    node_taints          = optional(list(string), [])
    tags                 = optional(map(string), {})
  }))
  default = {}

  validation {
    condition = alltrue([
      for pool in values(var.node_pools) :
      pool.auto_scaling_enabled == false || (try(pool.min_count, null) != null && try(pool.max_count, null) != null)
    ])
    error_message = "When additional node pool autoscaling is enabled, min_count and max_count are required."
  }
}

variable "identity" {
  description = "Managed identity configuration for the AKS cluster."
  type = object({
    type         = optional(string, "SystemAssigned")
    identity_ids = optional(set(string), [])
  })
  default = {}

  validation {
    condition     = contains(["SystemAssigned", "UserAssigned"], var.identity.type)
    error_message = "identity.type must be either SystemAssigned or UserAssigned."
  }

  validation {
    condition     = var.identity.type != "UserAssigned" || length(var.identity.identity_ids) > 0
    error_message = "identity.identity_ids must contain at least one identity ID when identity.type is UserAssigned."
  }
}

variable "network_profile" {
  description = "AKS network profile."
  type = object({
    network_plugin      = optional(string, "azure")
    network_plugin_mode = optional(string)
    network_policy      = optional(string, "azure")
    load_balancer_sku   = optional(string, "standard")
    outbound_type       = optional(string, "loadBalancer")
    service_cidr        = optional(string, "10.240.0.0/16")
    dns_service_ip      = optional(string, "10.240.0.10")
    pod_cidr            = optional(string)
  })
  default = {}
}

variable "private_cluster" {
  description = "Private cluster configuration. Set enabled to true to deploy a private AKS API server."
  type = object({
    enabled             = optional(bool, false)
    private_dns_zone_id = optional(string)
    public_fqdn_enabled = optional(bool, false)
  })
  default = {}
}

variable "role_based_access_control_enabled" {
  description = "Whether Kubernetes role-based access control is enabled."
  type        = bool
  default     = true
}

variable "azure_active_directory_role_based_access_control" {
  description = "Azure AD and Azure RBAC integration. Set to null to skip the Azure AD RBAC block."
  type = object({
    tenant_id              = optional(string)
    admin_group_object_ids = optional(set(string), [])
    azure_rbac_enabled     = optional(bool, true)
  })
  default = null
}

variable "local_account_disabled" {
  description = "Whether local AKS cluster admin accounts are disabled."
  type        = bool
  default     = true
}

variable "oidc_issuer_enabled" {
  description = "Whether the OIDC issuer is enabled for workload identity."
  type        = bool
  default     = true
}

variable "workload_identity_enabled" {
  description = "Whether Azure Workload Identity is enabled."
  type        = bool
  default     = true
}

variable "azure_policy_enabled" {
  description = "Whether the Azure Policy add-on is enabled."
  type        = bool
  default     = false
}

variable "oms_agent" {
  description = "OMS agent add-on configuration. Set to null to disable."
  type = object({
    log_analytics_workspace_id      = string
    msi_auth_for_monitoring_enabled = optional(bool, true)
  })
  default = null
}

variable "key_vault_secrets_provider" {
  description = "Key Vault Secrets Provider add-on configuration. Set to null to disable."
  type = object({
    secret_rotation_enabled  = optional(bool, true)
    secret_rotation_interval = optional(string, "2m")
  })
  default = null
}

variable "diagnostic_settings" {
  description = "Diagnostic settings configuration. Set to null to disable diagnostic settings."
  type = object({
    name                           = optional(string)
    log_analytics_workspace_id     = optional(string)
    storage_account_id             = optional(string)
    eventhub_authorization_rule_id = optional(string)
    eventhub_name                  = optional(string)
    log_categories                 = optional(set(string), [])
    log_category_groups            = optional(set(string), ["allLogs"])
    metric_categories              = optional(set(string), ["AllMetrics"])
  })
  default = null
}

variable "role_assignments" {
  description = "Role assignments to create, keyed by stable caller-defined names. Scope defaults to the AKS cluster ID."
  type = map(object({
    principal_id                     = string
    role_definition_id               = optional(string)
    role_definition_name             = optional(string)
    principal_type                   = optional(string)
    scope                            = optional(string)
    skip_service_principal_aad_check = optional(bool, false)
  }))
  default = {}

  validation {
    condition = alltrue([
      for assignment in values(var.role_assignments) :
      (try(assignment.role_definition_id, null) != null) != (try(assignment.role_definition_name, null) != null)
    ])
    error_message = "Each role assignment must set exactly one of role_definition_id or role_definition_name."
  }
}

variable "tags" {
  description = "Tags to apply to taggable AKS resources."
  type        = map(string)
  default     = {}
}
