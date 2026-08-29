output "id" {
  description = "The resource ID of the Azure Kubernetes Service cluster."
  value       = azurerm_kubernetes_cluster.this.id
}

output "name" {
  description = "The name of the Azure Kubernetes Service cluster."
  value       = azurerm_kubernetes_cluster.this.name
}

output "kubelet_identity_object_id" {
  description = "The object ID of the kubelet managed identity, used for downstream role assignments."
  value       = azurerm_kubernetes_cluster.this.kubelet_identity[0].object_id
}
