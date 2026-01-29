############################################
# Azure Key Vault
############################################

resource "azurerm_key_vault" "this" {
  name                        = var.name
  location                    = var.location
  resource_group_name         = var.rg_name
  tenant_id                   = var.tenant_id

  # Standard SKU is recommended for most workloads
  sku_name = "standard"

  # IMPORTANT:
  # We enable RBAC instead of access policies.
  # This is required for Workload Identity + CSI Driver.
  enable_rbac_authorization = true

  # Best practice: do not expose Key Vault publicly
  public_network_access_enabled = false

  tags = var.tags
}

############################################
# User Assigned Managed Identity
# 1️⃣ Backend Identity
############################################

resource "azurerm_user_assigned_identity" "backend" {
  # Azure-visible name of the identity
  name = "uami-backend-${var.name}"

  location            = var.location
  resource_group_name = var.rg_name
}

############################################
# User Assigned Managed Identity
# 2️⃣ MySQL Identity
############################################

resource "azurerm_user_assigned_identity" "mysql" {
  # Azure-visible name of the identity
  name = "uami-mysql-${var.name}"

  location            = var.location
  resource_group_name = var.rg_name
}

