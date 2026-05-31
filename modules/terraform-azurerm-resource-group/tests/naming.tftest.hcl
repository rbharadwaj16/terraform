mock_provider "azurerm" {
  mock_resource "azurerm_resource_group" {
    defaults = {
      id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/mock"
    }
  }
}

variables {
  location = "EastUS"
}

run "explicit_name_creates_expected_name" {
  command = plan

  variables {
    name = "rg-orders-dev-eus-01"
    tags = {
      workload    = "orders"
      environment = "dev"
    }
  }

  assert {
    condition     = output.resource_group_name == "rg-orders-dev-eus-01"
    error_message = "Explicit name should be used as the resource group name."
  }

  assert {
    condition     = output.resource_group_location == "eastus"
    error_message = "Location should be lowercased."
  }

  assert {
    condition     = output.resource_group_tags.environment == "dev"
    error_message = "Tags should be applied to the resource group."
  }
}

run "context_generates_expected_name" {
  command = plan

  variables {
    context = {
      org      = "contoso"
      app      = "orders"
      env      = "prod"
      region   = "eus"
      instance = "01"
    }
  }

  assert {
    condition     = output.resource_group_name == "rg-contoso-orders-prod-eus-01"
    error_message = "Context should generate the expected resource group name."
  }
}

run "name_overrides_context" {
  command = plan

  variables {
    name = "rg-shared-prod-eus-01"
    context = {
      org      = "contoso"
      app      = "ignored"
      env      = "dev"
      region   = "wus"
      instance = "99"
    }
  }

  assert {
    condition     = output.resource_group_name == "rg-shared-prod-eus-01"
    error_message = "Explicit name should override context-based naming."
  }
}

run "optional_context_parts_are_omitted" {
  command = plan

  variables {
    context = {
      app    = "payments"
      env    = "test"
      region = "eus"
    }
  }

  assert {
    condition     = output.resource_group_name == "rg-payments-test-eus"
    error_message = "Optional org and instance should be omitted cleanly."
  }
}

run "missing_name_and_context_fails" {
  command = plan

  expect_failures = [
    azurerm_resource_group.this
  ]
}
