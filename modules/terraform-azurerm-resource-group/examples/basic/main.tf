module "resource_group" {
  source = "../.."

  name     = "rg-orders-dev-eus-01"
  location = "eastus"

  tags = {
    workload    = "orders"
    environment = "dev"
  }
}
