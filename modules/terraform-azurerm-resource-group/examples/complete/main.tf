module "resource_group" {
  source = "../.."

  location = "eastus"

  context = {
    org      = "contoso"
    app      = "orders"
    env      = "prod"
    region   = "eus"
    instance = "01"
  }

  tags = {
    workload      = "orders"
    environment   = "prod"
    business_unit = "commerce"
    data_class    = "internal"
    managed_by    = "terraform"
    module        = "terraform-azurerm-resource-group"
  }
}
