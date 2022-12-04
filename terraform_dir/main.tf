module "rg" {
    source = "./modules/resourceGroup"
    owner = var.owner
    env  = var.env
    rg_name = var.rg_name
    location = var.location
    location_short = var.location_short  
}