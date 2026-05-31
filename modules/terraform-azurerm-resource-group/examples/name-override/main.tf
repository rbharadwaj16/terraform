module "resource_group" {
  source = "../.."

  name     = "rg-shared-prod-eus-01"
  location = "eastus"

  context = {
    org      = "contoso"
    app      = "ignored"
    env      = "dev"
    region   = "wus"
    instance = "99"
  }

  tags = {
    workload    = "shared"
    environment = "prod"
  }
}
