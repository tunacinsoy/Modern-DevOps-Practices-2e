terraform {
  required_providers {
    azurerm = {
      source  = "azurerm"
       # Following line allows Terraform to use any version >= 3.0 but < 4.0. It means Terraform can update to versions like 3.0.1, 3.0.2, 3.1.0 etc., but it will not use 4.0 or higher.
      version = "~> 3.0"
    }
  }
}
provider "azurerm" {
  subscription_id = var.subscription_id
  client_id       = var.app_id
  client_secret   = var.password
  tenant_id       = var.tenant
  features {}
}

resource "azurerm_resource_group" "main" {
  name     = "${var.rg_prefix}-${terraform.workspace}"
  location = var.rg_location
}

resource "azurerm_virtual_network" "main" {
  name                = "${var.net_prefix}-network"
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name
}

resource "azurerm_subnet" "internal" {
  name                 = "internal"
  resource_group_name  = azurerm_resource_group.main.name
  virtual_network_name = azurerm_virtual_network.main.name
  address_prefixes     = ["10.0.2.0/24"]
}

resource "azurerm_network_interface" "main" {
  name                = "${var.net_prefix}-nic"
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name

  ip_configuration {
    name                          = "${var.net_prefix}-ipconfiguration"
    subnet_id                     = azurerm_subnet.internal.id
    private_ip_address_allocation = "Dynamic"
  }
}

resource "azurerm_virtual_machine" "main" {
  name                  = var.vm_name
  location              = azurerm_resource_group.main.location
  resource_group_name   = azurerm_resource_group.main.name
  network_interface_ids = [azurerm_network_interface.main.id]
  vm_size               = var.vm_size

  delete_os_disk_on_termination = true

  storage_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "16.04-LTS"
    version   = "latest"
  }
  storage_os_disk {
    name              = "${var.vm_name}-osdisk"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Standard_LRS"
  }
  os_profile {
    computer_name  = var.vm_name
    admin_username = var.admin_username
    admin_password = var.admin_password
  }
  os_profile_linux_config {
    disable_password_authentication = false
  }
  tags = {}
}
