provider "azurerm" {
  features {}
  subscription_id = "00342dc7-04f1-4515-8187-48d0df42d0e3"
  client_id       = "e79c5940-cc49-4abd-aca3-11377f15c951"
  client_secret   = var.client_secret
  tenant_id       = "785decce-c49a-4cf3-bfe9-8ff5b5b46ce5"
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
#Creating Public_IP
resource "azurerm_public_ip" "example" {
  name                = var.azurerm_public_ip
  resource_group_name = azurerm_resource_group.rg1.name
  location            = azurerm_resource_group.rg1.location
  allocation_method   = "Dynamic"

  tags = var.tags
}
#Creating NIC
resource "azurerm_network_interface" "nic" {
  name                = var.azurerm_network_interface
  location            = azurerm_resource_group.rg1.location
  resource_group_name = azurerm_resource_group.rg1.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.snet1.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.example.id
  }
}
resource "azurerm_network_interface_security_group_association" "nsgnic" {
    network_interface_id      = azurerm_network_interface.nic.id
    network_security_group_id = azurerm_network_security_group.nsg1.id
}
#Creation of NSG
resource "azurerm_network_security_group" "nsg1" {
  name                = var.azurerm_network_security_group
  location            = azurerm_resource_group.rg1.location
  resource_group_name = azurerm_resource_group.rg1.name

  security_rule {
    name                       = "test1"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "3389"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  tags = var.tags
}

#Creating Windows Server 2016 VM
resource "azurerm_windows_virtual_machine" "vm" {
  name       = var.virtual_machine_name
  resource_group_name = azurerm_resource_group.rg1.name
  location            = azurerm_resource_group.rg1.location
  size                = "Standard_D2S_v3"
  computer_name  = "hostname"
  admin_username      = var.admin_ID
  admin_password      = data.azurerm_key_vault_secret.keysecret1.value
  network_interface_ids = [
    azurerm_network_interface.nic.id,
  ]

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "MicrosoftWindowsServer"
    offer     = "WindowsServer"
    sku       = "2016-Datacenter"
    version   = "latest"
  }
}
#Attaching Data-Disk
resource "azurerm_managed_disk" "dd1" {
  name                 = var.data_disk
  location             = azurerm_resource_group.rg1.location
  resource_group_name  = azurerm_resource_group.rg1.name
  storage_account_type = "Standard_LRS"
  create_option        = "Empty"
  disk_size_gb         = 10
}

resource "azurerm_virtual_machine_data_disk_attachment" "datadisk1" {
  managed_disk_id    = azurerm_managed_disk.dd1.id
  virtual_machine_id = azurerm_windows_virtual_machine.vm.id
  lun                = "10"
  caching            = "ReadWrite"
}
#Configuring Key_Vault
data "azurerm_key_vault" "kv1" {
  name                = "keyvaultsst1"
  resource_group_name = var.azurerm_resource_group
}
#Configuring Key_Secret
data "azurerm_key_vault_secret" "keysecret1" {
  name         = "sstkey1"
  key_vault_id = data.azurerm_key_vault.kv1.id
}