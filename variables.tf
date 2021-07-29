variable "client_secret" {
  description = "Secret value"
  default     = ""
}

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
variable "azurerm_public_ip" {
  description = "Public-IP Name"
  default     = "pub-ip"
}
variable "azurerm_network_interface" {
  description = "Name of NIC card"
  default     = "NIC1"
}
variable "azurerm_network_security_group" {
  description = "Name of NSG"
  default     = "NSG1"
}
variable "admin_ID" {
  description = "Admin user name"
  default     = "sandeep"
}
variable "admin_pwd" {
  description = "password for user"
  default     = ""
}
variable "virtual_machine_name" {
  description = "name of vm"
  default     = "win_vm_01"
}
variable "data_disk" {
  description = "Data disk name"
  default     = "datadisk1"
}







