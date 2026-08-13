# Azure Terraform Modules

This repository is a learning-oriented portfolio of reusable Azure Terraform modules for enterprise platform engineering.

## Current Module Catalog

- `terraform-azurerm-resource-group`: creates an Azure resource group with explicit or context-based naming.

The Resource Group module is the current foundation checkpoint. Virtual Network, AKS, and supporting modules will be designed and implemented incrementally by the developer, with architectural guidance and review.

## Intended Consumers

The reusable modules in this repository will be consumed by root stacks in the sibling `ai-inference-platform` repository.
