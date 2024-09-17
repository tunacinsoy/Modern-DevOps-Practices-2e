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

module "storage" {
  source = "./modules/storage_account"
  # Storage name has to be unique, so we need to add random suffix at the end
  name = "${var.storage_name_prefix}${random_string.suffix.result}"
  # We can get the values of following two parameters from the output of rg module
  resource_group_name      = module.rg.resource_group_name
  location                 = module.rg.resource_group_location
  account_tier             = var.account_tier
  account_replication_type = var.account_replication_type
}

module "container" {
  source = "./modules/storage_container"
  name   = var.container_name
  # We can get the value of following parameter from the output of storage module
  storage_account_name  = module.storage.storage_account_name
  container_access_type = var.container_access_type
}

