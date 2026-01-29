resource "azurerm_key_vault" "this" {
  name                          = var.name
  location                      = var.location
  resource_group_name           = var.rg_name
  tenant_id                     = var.tenant_id
  sku_name                      = "standard"
  enable_rbac_authorization     = true
  public_network_access_enabled = false
  tags                          = var.tags
}

resource "azurerm_user_assigned_identity" "backend" {
  name                = "uami-backend-${var.name}"
  location            = var.location
  resource_group_name = var.rg_name
}

resource "azurerm_user_assigned_identity" "mysql" {
  name                = "uami-mysql-${var.name}"
  location            = var.location
  resource_group_name = var.rg_name
}

resource "azurerm_role_assignment" "backend_kv_secrets_user" {
  scope                = azurerm_key_vault.this.id
  role_definition_name = "Key Vault Secrets User"
  principal_id         = azurerm_user_assigned_identity.backend.principal_id
}

resource "azurerm_role_assignment" "mysql_kv_secrets_user" {
  scope                = azurerm_key_vault.this.id
  role_definition_name = "Key Vault Secrets User"
  principal_id         = azurerm_user_assigned_identity.mysql.principal_id
}

