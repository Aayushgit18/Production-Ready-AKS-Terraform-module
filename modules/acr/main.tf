resource "azurerm_container_registry" "this" {
  name                          = var.name
  resource_group_name           = var.rg_name
  location                      = var.location
  sku                           = "Premium"
  admin_enabled                 = false
  public_network_access_enabled = false
  tags                          = var.tags
}
