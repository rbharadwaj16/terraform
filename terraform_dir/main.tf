module "rg" {
    source = "./modules/resourceGroup"
    owner = var.owner
    env  = var.env
    rg_name = var.rg_name
    location = var.location
    location_short = var.location_short
    purpose_tag = var.purpose_tag
}

module "network" {
    source = "./modules/network"
    vnet = var.vnet
    owner = var.owner
    env  = var.env
    rg_name = var.rg_name
    location = var.location
    location_short = var.location_short

}