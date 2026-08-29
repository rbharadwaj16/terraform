output "aks_id" {
  description = "The ID of the AKS cluster."
  value       = module.aks.id
}

output "kubelet_identity_object_id" {
  description = "The object ID used for downstream role assignments, such as ACR AcrPull."
  value       = module.aks.kubelet_identity_object_id
}
