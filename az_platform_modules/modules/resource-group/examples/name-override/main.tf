module "resource_group" {
  source = "../.."

  # name wins over context, so this exact name is used.
  name = "rg-contoso-landingzone-prod-eus-001"

  context = {
    org      = "contoso"
    app      = "landingzone"
    env      = "prod"
    region   = "eus"
    instance = "99"
  }

  location = "eastus"

  tags = {
    environment = "prod"
    owner       = "platform"
    workload    = "landingzone"
  }
}
