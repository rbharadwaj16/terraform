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
