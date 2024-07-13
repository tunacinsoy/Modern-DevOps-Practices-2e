terraform {
  backend "azurerm" {
    resource_group_name  = "tfstate"
    storage_account_name = "tfstate61yxs47c"
    container_name       = "tfstate"
    key                  = "terraform_workspaces_exercise.tfstate"
  }
}