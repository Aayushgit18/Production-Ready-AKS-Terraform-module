resource "azurerm_log_analytics_workspace" "this" {
  name                = "aks-law"
  location            = var.location
  resource_group_name = var.rg_name
  sku                 = "PerGB2018"
}
