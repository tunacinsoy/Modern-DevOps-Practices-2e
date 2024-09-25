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

# Needed for resource "azurerm_resource_group" "rg"
variable "rg_name" {
  type        = string
  description = "Resource Group Name for resource 'azurerm_resource_group.rg'"
}
# Needed for resource "azurerm_resource_group" "rg"
variable "rg_location" {
  type        = string
  description = "Resource Group Location for resource 'azurerm_resource_group.rg'"
  # In terms of latency, the minimum value is obtained from here.
  # Check https://www.azurespeed.com/Azure/Latency
  default = "Germany West Central"
}
