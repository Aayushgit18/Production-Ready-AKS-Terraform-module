terraform {
  backend "azurerm" {
    resource_group_name  = "tfstate-rg"
    storage_account_name = "foraks"
    container_name       = "tfstate"
    key                  = "dev/aks.tfstate"
  }
}
