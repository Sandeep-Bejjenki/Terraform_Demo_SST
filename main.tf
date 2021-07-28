provider "azurerm" {
  features {}
}

terraform {
  backend "azurerm" {
    resource_group_name  = "rg01"
    storage_account_name = "test78sa"
    container_name       = "tfstate"
    key                  = "dev.terraform.tfstate"
  }
}

# Create a resource group
resource "azurerm_resource_group" "rg1" {
  name     = var.azurerm_resource_group
  location = var.azure_rg_location
}

# Create a virtual network within the resource group
resource "azurerm_virtual_network" "vnet1" {
  name                = var.azurerm_virtual_network
  resource_group_name = azurerm_resource_group.rg1.name
  location            = azurerm_resource_group.rg1.location
  address_space       = ["10.0.0.0/16"]
tags = var.tags
}
#Creating subnet
resource "azurerm_subnet" "snet1" {
  name                 = var.azurerm_subnet
  resource_group_name  = azurerm_resource_group.rg1.name
  virtual_network_name = azurerm_virtual_network.vnet1.name
  address_prefixes     = ["10.0.0.0/24"]
}

