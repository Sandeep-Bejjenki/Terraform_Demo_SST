provider "azurerm" {
  features {}
}

# Create a resource group
resource "azurerm_resource_group" "rg1" {
  name     = "sst01rg"
  location = "West Europe"
}

# Create a virtual network within the resource group
resource "azurerm_virtual_network" "vnet1" {
  name                = "sst01vnet"
  resource_group_name = azurerm_resource_group.rg1.name
  location            = azurerm_resource_group.rg1.location
  address_space       = ["10.0.0.0/16"]
subnet {
    name = "snet1"
	address_prefix = "10.0.0.0/24"
}
}