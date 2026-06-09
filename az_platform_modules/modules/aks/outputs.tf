output "cluster_name" {
  description = "Name of the AKS cluster."
  value       = azurerm_kubernetes_cluster.this.name
}

output "cluster_id" {
  description = "ID of the AKS cluster."
  value       = azurerm_kubernetes_cluster.this.id
}

output "node_resource_group" {
  description = "AKS-managed node resource group."
  value       = azurerm_kubernetes_cluster.this.node_resource_group
}

output "fqdn" {
  description = "Public FQDN of the AKS API server, when available."
  value       = azurerm_kubernetes_cluster.this.fqdn
}

output "private_fqdn" {
  description = "Private FQDN of the AKS API server, when available."
  value       = azurerm_kubernetes_cluster.this.private_fqdn
}

output "oidc_issuer_url" {
  description = "OIDC issuer URL for workload identity."
  value       = azurerm_kubernetes_cluster.this.oidc_issuer_url
}

output "identity_principal_id" {
  description = "Principal ID of the cluster managed identity."
  value       = try(azurerm_kubernetes_cluster.this.identity[0].principal_id, null)
}

output "kubelet_identity" {
  description = "Kubelet identity values needed for downstream RBAC assignments."
  value = {
    client_id                 = try(azurerm_kubernetes_cluster.this.kubelet_identity[0].client_id, null)
    object_id                 = try(azurerm_kubernetes_cluster.this.kubelet_identity[0].object_id, null)
    user_assigned_identity_id = try(azurerm_kubernetes_cluster.this.kubelet_identity[0].user_assigned_identity_id, null)
  }
}

output "node_pool_ids" {
  description = "Additional node pool IDs keyed by input node pool key."
  value       = { for key, pool in azurerm_kubernetes_cluster_node_pool.this : key => pool.id }
}

output "diagnostic_setting_id" {
  description = "Diagnostic setting ID when diagnostics are enabled."
  value       = try(azurerm_monitor_diagnostic_setting.this[0].id, null)
}
