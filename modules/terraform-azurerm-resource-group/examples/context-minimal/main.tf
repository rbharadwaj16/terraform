module "resource_group" {
  source = "../.."

  location = "eastus"

  context = {
    app    = "payments"
    env    = "test"
    region = "eus"
  }

  tags = {
    workload    = "payments"
    environment = "test"
  }
}
