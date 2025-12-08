provider "azurerm" {
  features {}
  subscription_id = "7a3c6854-0fe1-42eb-b5b9-800af1e53d70" # Sett riktig subscription_id her eller via env var
  use_cli         = true
}

resource "azurerm_resource_group" "lab" {
  name     = "rg-lab-vnet-sample-tomlis1"
  location = "norwayeast"
}

resource "azurerm_virtual_network" "vnet" {
  name                = "vnet-sample-01"
  location            = azurerm_resource_group.lab.location
  resource_group_name = azurerm_resource_group.lab.name
  address_space       = ["10.42.0.0/16"]
}
