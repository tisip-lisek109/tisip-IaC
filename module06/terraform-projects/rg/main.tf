terraform {
  backend "azurerm" {}
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 4.40.0"
    }
  }
}

provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "fd-rg" {
  name     = var.rgname
  location = var.location

  tags = {
    environment = var.environment
  }
}

# Ny ressurs  – Storage Account
resource "azurerm_storage_account" "sa" {
  name                     = local.storage_account_name
  resource_group_name      = azurerm_resource_group.fd-rg.name
  location                 = azurerm_resource_group.fd-rg.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
}
