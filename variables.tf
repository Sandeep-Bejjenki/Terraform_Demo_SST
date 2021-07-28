variable "azurerm_resource_group" {
  description = "Name resource group"
  default     = "sst02rg"
}
variable "azure_rg_location" {
  description = "Resource group location"
  default     = "East US"
}
variable "azurerm_virtual_network" {
  description = "Name of Virtual Network"
  default     = "sst01vnet"
}
variable "azurerm_subnet" {
  description = "Name of subnet"
  default     = "subnet1"
}
variable "tags" {
  description = "Tags for resources"
  default     = {
      CreatedBy = "Sandeep"
      Env = "Dev"
      Dept = "IT"
  }
}



