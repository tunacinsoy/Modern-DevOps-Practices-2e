# Needed for provider "azurerm"
variable "subscription_id" {
  type        = string
  description = "Azure Subscription ID"
}

# Needed for provider "azurerm"
variable "app_id" {
  type        = string
  description = "Azure Service Principal appId"
}

# Needed for provider "azurerm"
variable "password" {
  type        = string
  description = "Azure Service Principal Password"
  sensitive   = true
}

# Needed for provider "azurerm"
variable "tenant" {
  type        = string
  description = "Azure Tenant ID"
}

# Needed for module "rg"
variable "rg_name" {
  type        = string
  description = "Resource Group Name for resource 'azurerm_resource_group.rg'"
}

# Needed for module "rg"
variable "rg_location" {
  type        = string
  description = "Resource Group Location for resource 'azurerm_resource_group.rg'"
  # In terms of latency, the minimum value is obtained from here.
  # Check https://www.azurespeed.com/Azure/Latency
  default = "Germany West Central"
}

# Needed for module "storage"
variable "storage_name_prefix" {
  type        = string
  description = "Prefix of Storage Account Name, Suffix will be generated in main.tf"
}

# Needed for module "storage"
variable "account_tier" {
  type        = string
  description = "Type of Storage Account"
  default     = "Standard"
}

# Needed for module "storage"
variable "account_replication_type" {
  type        = string
  description = "Account Replication for Data Redundancy"
  default     = "LRS"
}

# Needed for module "storage"
resource "random_string" "suffix" {
  length  = 8
  # Storage account nme can only consist of lowercase letters and numbers,
  # and must be between 3 and 24 characters long
  special = false
  upper   = false
}

# Needed for module "container"
variable "container_name" {
  type        = string
  description = "Container Name"
}

# Needed for module "container"
variable "container_access_type" {
  type        = string
  description = "Container Access Type"
}
