# To-Do: Make the main.tf reusable as much as possible (get vars from vars.tf file for
# web and db nodes as well)
terraform {
  required_providers {
    azurerm = {
      source  = "azurerm"
      version = "~> 3.0"
    }
  }
}
# Specify the service principal credentials for terraform to do its operations
provider "azurerm" {
  # Run az account show
  subscription_id = var.subscription_id
  tenant_id       = var.tenant_id

  # These values are generated once we create the service principal
  client_id     = var.client_id
  client_secret = var.client_secret
  features {}
}


resource "azurerm_resource_group" "main" {
  name     = var.rg_name
  location = var.rg_location
}

resource "azurerm_virtual_network" "main" {
  name                = var.vnet_name
  address_space       = [var.address_space[0]]
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name
}

resource "azurerm_subnet" "internal" {
  name                 = var.subnet_name
  resource_group_name  = azurerm_resource_group.main.name
  virtual_network_name = azurerm_virtual_network.main.name
  address_prefixes     = [var.address_prefix[0]]
}

resource "azurerm_public_ip" "control_node_publicip" {
  name                = var.control_node_publicip_name
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name
  allocation_method   = var.ip_allocation_method
  tags                = var.control_node_tags
}

resource "azurerm_network_security_group" "control_node_nsg" {
  name                = var.control_node_nsg_name
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name

  security_rule {
    name                       = var.security_rule.name
    priority                   = var.security_rule.priority
    direction                  = var.security_rule.direction
    access                     = var.security_rule.access
    protocol                   = var.security_rule.protocol
    source_port_range          = var.security_rule.source_port_range
    destination_port_range     = var.security_rule.destination_port_range
    source_address_prefix      = var.security_rule.source_address_prefix
    destination_address_prefix = var.security_rule.destination_address_prefix
  }

  tags = var.control_node_tags
}

resource "azurerm_network_interface" "control_node" {
  name                = var.control_node_nic_name
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name

  ip_configuration {
    name                          = var.control_node_ip_config.name
    subnet_id                     = azurerm_subnet.internal.id
    private_ip_address_allocation = var.control_node_ip_config.private_ip_address_allocation
    public_ip_address_id          = azurerm_public_ip.control_node_publicip.id
  }
}

# Connect the security group to the network interface
resource "azurerm_network_interface_security_group_association" "control_node" {
  network_interface_id      = azurerm_network_interface.control_node.id
  network_security_group_id = azurerm_network_security_group.control_node_nsg.id
}

resource "azurerm_virtual_machine" "control_node" {
  name                  = var.control_node_name
  depends_on            = [azurerm_virtual_machine.web, azurerm_virtual_machine.db]
  location              = azurerm_resource_group.main.location
  resource_group_name   = azurerm_resource_group.main.name
  network_interface_ids = [azurerm_network_interface.control_node.id]
  vm_size               = var.vm_size

  delete_os_disk_on_termination = true

  storage_image_reference {
    publisher = var.control_node_storage_image_reference.publisher
    offer     = var.control_node_storage_image_reference.offer
    sku       = var.control_node_storage_image_reference.sku
    version   = var.control_node_storage_image_reference.version
  }

  storage_os_disk {
    name              = var.control_node_storage_os_disk.name
    caching           = var.control_node_storage_os_disk.caching
    create_option     = var.control_node_storage_os_disk.create_option
    managed_disk_type = var.control_node_storage_os_disk.managed_disk_type
  }
  os_profile {
    computer_name  = var.control_node_computer_name
    admin_username = var.admin_username
    admin_password = var.admin_password
    custom_data    = base64encode(data.template_file.control_node_init.rendered)
  }
  os_profile_linux_config {
    disable_password_authentication = false
  }

  tags = var.control_node_tags
}

resource "azurerm_public_ip" "web_publicip" {
  name                = "web-public-ip"
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name
  allocation_method   = "Dynamic"

  tags = {}
}

resource "azurerm_network_security_group" "web_nsg" {
  name                = "web-nsg"
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name

  security_rule {
    name                       = "SSH"
    priority                   = 1001
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  security_rule {
    name                       = "HTTP"
    priority                   = 1002
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "80"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }


  tags = {}
}

resource "azurerm_network_interface" "web" {
  name                = "web-nic"
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name

  ip_configuration {
    name                          = "app-ipconfiguration"
    subnet_id                     = azurerm_subnet.internal.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.web_publicip.id
  }
}

# Connect the security group to the network interface
resource "azurerm_network_interface_security_group_association" "web" {
  network_interface_id      = azurerm_network_interface.web.id
  network_security_group_id = azurerm_network_security_group.web_nsg.id
}

resource "azurerm_virtual_machine" "web" {
  name                  = "web"
  location              = azurerm_resource_group.main.location
  resource_group_name   = azurerm_resource_group.main.name
  network_interface_ids = [azurerm_network_interface.web.id]
  vm_size               = var.vm_size

  delete_os_disk_on_termination = true

  storage_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "18.04-LTS"
    version   = "latest"
  }
  storage_os_disk {
    name              = "web-osdisk"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Standard_LRS"
  }
  os_profile {
    computer_name  = "web"
    admin_username = var.admin_username
    admin_password = var.admin_password
    custom_data    = base64encode(data.template_file.managed_nodes_init.rendered)
  }
  os_profile_linux_config {
    disable_password_authentication = false
  }

  tags = {}
}

resource "azurerm_network_security_group" "db_nsg" {
  name                = "db-nsg"
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name

  security_rule {
    name                       = "SSH"
    priority                   = 1001
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  security_rule {
    name                       = "SQL"
    priority                   = 1002
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "3306"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  tags = {}
}


resource "azurerm_network_interface" "db" {
  name                = "db-nic"
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name

  ip_configuration {
    name                          = "app-ipconfiguration"
    subnet_id                     = azurerm_subnet.internal.id
    private_ip_address_allocation = "Dynamic"
  }
}

# Connect the security group to the network interface
resource "azurerm_network_interface_security_group_association" "db" {
  network_interface_id      = azurerm_network_interface.db.id
  network_security_group_id = azurerm_network_security_group.db_nsg.id
}

resource "azurerm_virtual_machine" "db" {
  name                  = "db"
  location              = azurerm_resource_group.main.location
  resource_group_name   = azurerm_resource_group.main.name
  network_interface_ids = [azurerm_network_interface.db.id]
  vm_size               = var.vm_size

  delete_os_disk_on_termination = true

  storage_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "18.04-LTS"
    version   = "latest"
  }
  storage_os_disk {
    name              = "db-osdisk"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Standard_LRS"
  }
  os_profile {
    computer_name  = "db"
    admin_username = var.admin_username
    admin_password = var.admin_password
    custom_data    = base64encode(data.template_file.managed_nodes_init.rendered)
  }
  os_profile_linux_config {
    disable_password_authentication = false
  }

  tags = {}
}

data "template_file" "managed_nodes_init" {
  template = file("managed-nodes-user-data.sh")
  vars = {
    admin_password = var.admin_password
  }
}

data "template_file" "control_node_init" {
  template = file("control-node-user-data.sh")
  vars = {
    admin_password = var.admin_password
  }
}

