module "resource_group" {
  source = "../.."

  name     = "rg-contoso-payments-dev-eus-01"
  location = "eastus"

  tags = {
    environment = "dev"
    workload    = "payments"
    owner       = "platform"
  }
}
