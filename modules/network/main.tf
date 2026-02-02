resource "azurerm_virtual_network" "this" {
  name                = var.vnet_name
  location            = var.location
  resource_group_name = var.rg_name
  address_space       = var.address_space
  tags                = var.tags
}

resource "azurerm_subnet" "system" {
  name                 = "aks-system-subnet"
  resource_group_name  = var.rg_name
  virtual_network_name = azurerm_virtual_network.this.name
  address_prefixes     = [var.system_subnet_cidr]
}

resource "azurerm_subnet" "user" {
  name                 = "aks-user-subnet"
  resource_group_name  = var.rg_name
  virtual_network_name = azurerm_virtual_network.this.name
  address_prefixes     = [var.user_subnet_cidr]
}

resource "azurerm_network_security_group" "aks" {
  name                = "${var.vnet_name}-nsg"
  location            = var.location
  resource_group_name = var.rg_name
}

resource "azurerm_subnet_network_security_group_association" "system" {
  subnet_id                 = azurerm_subnet.system.id
  network_security_group_id = azurerm_network_security_group.aks.id
}

resource "azurerm_subnet_network_security_group_association" "user" {
  subnet_id                 = azurerm_subnet.user.id
  network_security_group_id = azurerm_network_security_group.aks.id
}
