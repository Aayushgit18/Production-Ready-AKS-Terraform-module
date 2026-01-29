output "id" {
  value = azurerm_key_vault.this.id
}

output "name" {
  value = azurerm_key_vault.this.name
}

output "backend_identity_id" {
  value = azurerm_user_assigned_identity.backend.id
}

output "backend_identity_principal_id" {
  value = azurerm_user_assigned_identity.backend.principal_id
}

output "mysql_identity_id" {
  value = azurerm_user_assigned_identity.mysql.id
}

output "mysql_identity_principal_id" {
  value = azurerm_user_assigned_identity.mysql.principal_id
}

