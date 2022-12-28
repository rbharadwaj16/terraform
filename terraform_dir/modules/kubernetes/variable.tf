variable "owner" {
  type        = string
  description = "Owner of the resource"
}

variable "env" {
  type        = string
  description = "Environment to be deployed in"
}

variable "purpose" {
  type = string
  description = "Purpose of Kube cluster"
}

variable "location_short" {
  type        = string
  description = "Short name for location"
}

variable "location" {
  type        = string
  description = "Location in which resource group needs to be created"
}

variable "aks_rg_name" {
  type = string
  description = "Name of RG in which Kube cluster should be deployed"
}

variable "default_pool_subnet_id" {
  type = string
  description = "Subnet ID in which default node pool should be deployed"
}

variable "node_pool_subnet_id" {
  type = string
  description = "Subnet ID in which app node pools should be deployed"
}

variable "dns_service_ip" {
  type = string
  description = "IP of Kube DNS"
}

variable "docker_bridge_cidr" {
  type = string
  description = "Overlay Network"
}