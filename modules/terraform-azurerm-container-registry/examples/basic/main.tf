module "container_registry" {
  source = "../.."

  container_registry_name = "acrainferencedeveus01"
  resource_group_name     = "rg-ai-inference-dev-eus-01"
  location                = "eastus"

  tags = {
    environment = "dev"
    workload    = "ai-inference"
  }
}
