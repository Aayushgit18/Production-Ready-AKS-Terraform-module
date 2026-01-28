terraform {
  backend "azurerm" {
    resource_group_name  = "tfstate-rg"
    storage_account_name = "<REPLACE_STORAGE_ACCOUNT>"
    container_name       = "tfstate"
    key                  = "dev/aks.tfstate"
  }
}
