module "resource_groups" {
  source = "../.."

  for_each = var.resource_groups

  name     = each.value.name
  context  = each.value.context
  location = each.value.location
  tags     = each.value.tags
}
