module "rg" {
  source         = "./modules/resourceGroup"
  owner          = var.owner
  env            = var.env
  rg_name        = var.rg_name
  location       = var.location
  location_short = var.location_short
  purpose_tag    = var.purpose_tag
  owner_tag      = var.owner_tag
  client_tag     = var.client_tag
}

module "network" {
  source         = "./modules/network"
  network_rg     = var.network_rg
  vnet           = var.vnet
  owner          = var.owner
  env            = var.env
  location       = var.location
  location_short = var.location_short
  purpose_tag    = var.purpose_tag
  owner_tag      = var.owner_tag
  client_tag     = var.client_tag
  subnets        = var.subnets
}

module "kubernetes" {
  source                 = "./modules/kubernetes"
  owner                  = var.owner
  env                    = var.env
  location               = var.location
  location_short         = var.location_short
  purpose                = var.purpose
  aks_rg_name            = var.aks_rg_name
  node_pool_subnet_id    = var.node_pool_subnet_id
  service_cidr           = var.service_cidr
  dns_service_ip         = var.dns_service_ip
  docker_bridge_cidr     = var.docker_bridge_cidr

}
