module "keyvault" {
  source = "../.."

  keyvault_name       = "kv-ai-inference-dev-eus-01"
  resource_group_name = "rg-ai-inference-dev-eus-01"
  location            = "eastus"
  tenant_id          = "your-tenant-id"

  tags = {
    environment = "dev"
    workload    = "ai-inference"
  }
}
