output "cluster_id" {
  description = "ID of the AKS cluster."
  value       = module.aks.cluster_id
}

output "oidc_issuer_url" {
  description = "OIDC issuer URL for workload identity."
  value       = module.aks.oidc_issuer_url
}
