module "network" {
  source   = "../.."
  for_each = var.networks

  name                = each.value.name
  resource_group_name = each.value.resource_group_name
  location            = each.value.location
  address_space       = each.value.address_space
  subnets             = each.value.subnets
  tags                = try(each.value.tags, {})
}
