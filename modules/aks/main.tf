
resource "azurerm_kubernetes_cluster" "this" {
  name                = var.aks_name
  location            = var.location
  resource_group_name = var.rg_name
  dns_prefix          = var.aks_name

  identity {
    type         = "UserAssigned"
    identity_ids = [azurerm_user_assigned_identity.aks.id]
  }

  azure_active_directory_role_based_access_control {
    managed                = true
    admin_group_object_ids = [var.admin_group_object_id]
  }

  network_profile {
    network_plugin = "azure"
    network_policy = "azure"
  }

  default_node_pool {
  name                = "system"
  vm_size             = "Standard_D2s_v3"
  enable_auto_scaling = true
  min_count           = 2
  max_count           = 3
  vnet_subnet_id      = var.system_subnet_id
}

  oms_agent {
    log_analytics_workspace_id = var.log_analytics_id
  }
}
