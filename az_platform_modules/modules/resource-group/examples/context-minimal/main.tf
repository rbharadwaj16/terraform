module "resource_group" {
  source = "../.."

  # org and instance are optional, so the computed name becomes rg-catalog-test-wus2.
  context = {
    app    = "catalog"
    env    = "test"
    region = "wus2"
  }

  location = "westus2"

  tags = {
    environment = "test"
    owner       = "catalog-team"
    workload    = "catalog"
  }
}
