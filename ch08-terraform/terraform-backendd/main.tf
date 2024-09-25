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

module "rg" {
  source   = "./modules/resource_group"
  name     = var.rg_name
  location = var.rg_location
}
