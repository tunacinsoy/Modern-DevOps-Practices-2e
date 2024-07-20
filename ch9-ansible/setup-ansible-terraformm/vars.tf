# Required for the provider "azurerm"
variable "subscription_id" {
  type        = string
  description = "The azure subscription id"
}

# Required for the provider "azurerm"
variable "client_id" {
  type        = string
  description = "The azure service principal appId"
}

# Required for the provider "azurerm"
variable "client_secret" {
  type        = string
  description = "The azure service principal password"
  sensitive   = true
}

# Required for the provider "azurerm"
variable "tenant_id" {
  type        = string
  description = "The azure tenant id"
}

# Required for the resource "azurerm_resource_group.main"
variable "rg_name" {
  type        = string
  description = "The resource group name"
}

# Required for the resource "azurerm_resource_group.main"
variable "rg_location" {
  type        = string
  description = "The resource group location"
}

# Required for the resource "azurerm_virtual_network.main"
variable "vnet_name" {
  type        = string
  description = "Virtual Network Name"
}

# Required for the resource "azurerm_virtual_network.main"
variable "address_space" {
  type        = list(string)
  description = "Address space for the virtual network"
}

# Required for the resource "azurerm_subnet.internal"
variable "subnet_name" {
  type        = string
  description = "Subnet name"
}

# Required for the resource "azurerm_subnet.internal"
variable "address_prefix" {
  type        = list(string)
  description = "subnet of resources"
}

# Required for the resource "azurerm_public_ip.control_node_publicip"
variable "control_node_publicip_name" {
  type        = string
  description = "public ip name of control node"
}

# Required for the resource "azurerm_public_ip.control_node_publicip"
variable "ip_allocation_method" {
  type        = string
  description = "allocation method of ip"
}

# Required for the resource "azurerm_network_security_group.control_node_nsg"
variable "control_node_nsg_name" {
  type        = string
  description = "nsg name of control node"
}
# Required for the resource "azurerm_network_security_group.control_node_nsg"
variable "security_rule" {
  type = object({
    name                       = string
    priority                   = number
    direction                  = string
    access                     = string
    protocol                   = string
    source_port_range          = string
    destination_port_range     = string
    source_address_prefix      = string
    destination_address_prefix = string
  })
  description = "Security rule configuration"
}
# Required for the resource "azurerm_network_interface.control_node"
variable "control_node_nic_name" {
  type        = string
  description = "nic name of control node"
}

# Required for the resource "azurerm_network_interface.control_node"
variable "control_node_ip_config" {
  type = object({
    name                          = string
    private_ip_address_allocation = string
  })
  description = "NIC's IP configuration of control node"
}

variable "control_node_name" {
  type        = string
  description = "Name of the control node"
}
# Required for the resource "azurerm_virtual_machine.control_node"
variable "vm_size" {
  type        = string
  description = "The size of the VM"
  default     = "Standard_DS1_v2"
}

# Required for the resource "azurerm_virtual_machine.control_node"
variable "control_node_storage_image_reference" {
  type = object({
    publisher = string
    offer     = string
    sku       = string
    version   = string
  })
  description = "Image configuration of control node VM"
}

# Required for the resource "azurerm_virtual_machine.control_node"
variable "control_node_storage_os_disk" {
  type = object({
    name              = string
    caching           = string
    create_option     = string
    managed_disk_type = string
  })
  description = "Storage disk configuration of control node VM"
}

# Required for the resource "azurerm_virtual_machine.control_node"
variable "control_node_tags" {
  type        = map(string)
  description = "Tags for the control node"
}

# Required for the resource "azurerm_virtual_machine.control_node"
variable "control_node_computer_name" {
  type        = string
  description = "OS profile of control node, computer name"
}

# Required for the resource "azurerm_virtual_machine.control_node"
variable "admin_username" {
  type        = string
  description = "The Linux admin username that you want to configure"
}

# Required for the resource "azurerm_virtual_machine.control_node"
variable "admin_password" {
  type        = string
  description = "The Linux admin password that you want to configure"
  sensitive   = "true"
}
