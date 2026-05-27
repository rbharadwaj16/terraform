module "resource_group" {
  source = "../.."

  context  = var.context
  location = var.location
  tags     = var.tags
}
