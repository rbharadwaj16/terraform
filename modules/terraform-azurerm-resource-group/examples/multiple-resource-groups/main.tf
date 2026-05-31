locals {
  resource_groups = {
    orders = {
      context = {
        org      = "contoso"
        app      = "orders"
        env      = "prod"
        region   = "eus"
        instance = "01"
      }
      tags = {
        workload    = "orders"
        environment = "prod"
      }
    }
    payments = {
      context = {
        org      = "contoso"
        app      = "payments"
        env      = "prod"
        region   = "eus"
        instance = "01"
      }
      tags = {
        workload    = "payments"
        environment = "prod"
      }
    }
  }
}

module "resource_group" {
  source = "../.."

  for_each = local.resource_groups

  location = "eastus"
  context  = each.value.context
  tags     = each.value.tags
}
