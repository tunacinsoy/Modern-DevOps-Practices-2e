terraform {
  required_providers {
    azurerm = {
      source = "azurerm"
      # If we state the version like this '~>', terraform will use the latest version that is lower than 4.0 (Right now, it is 3.112.0)
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

resource "azurerm_resource_group" "rg" {
  name     = var.rg_name
  location = var.rg_location
}
