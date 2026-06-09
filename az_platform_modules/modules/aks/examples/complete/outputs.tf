output "cluster_id" {
  description = "ID of the AKS cluster."
  value       = module.aks.cluster_id
}

output "node_pool_ids" {
  description = "Additional node pool IDs keyed by node pool key."
  value       = module.aks.node_pool_ids
}

output "kubelet_identity" {
  description = "Kubelet identity values needed for downstream RBAC assignments."
  value       = module.aks.kubelet_identity
}
