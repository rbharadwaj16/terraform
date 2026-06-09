variable "tenant_id" {
  description = "Tenant ID used for Azure AD RBAC integration."
  type        = string
  default     = null
}

variable "admin_group_object_ids" {
  description = "Azure AD group object IDs that should be AKS cluster admins."
  type        = set(string)
  default     = []
}

variable "log_analytics_workspace_id" {
  description = "Optional Log Analytics workspace resource ID for AKS monitoring and diagnostics."
  type        = string
  default     = null
}
