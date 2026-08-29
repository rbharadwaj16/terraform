resource "azurerm_role_assignment" "this" {
  scope                = var.scope
  principal_id         = var.principal_id
  role_definition_name = var.role_definition_name
}
