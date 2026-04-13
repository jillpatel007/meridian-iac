# Meridian Azure IaC — hardened baseline
terraform {
  required_version = ">= 1.6"
  required_providers {
    azurerm = { source = "hashicorp/azurerm", version = "~> 3.100" }
    random  = { source = "hashicorp/random", version = "~> 3.6" }
  }
}

provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "range" {
  name     = "rg-meridian-range"
  location = "centralindia"
  tags = {
    project             = "meridian"
    environment         = "range"
    data_classification = "training-only"
  }
}

resource "random_string" "sa_suffix" {
  length  = 6
  upper   = false
  special = false
}

resource "azurerm_storage_account" "fundamentals" {
  name                            = "stmeridian${random_string.sa_suffix.result}"
  resource_group_name             = azurerm_resource_group.range.name
  location                        = azurerm_resource_group.range.location
  account_tier                    = "Standard"
  account_replication_type        = "LRS"
  min_tls_version                 = "TLS1_2"
  allow_nested_items_to_be_public = false
  public_network_access_enabled   = true   # Day 4 will flip to false + add Private Endpoint
  shared_access_key_enabled       = true   # Day 2 attacks need this; Day 4 disables
}
