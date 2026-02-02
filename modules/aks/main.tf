resource "azurerm_user_assigned_identity" "aks" {
  name                = "${var.name}-uami"
  location            = var.location
  resource_group_name = var.rg_name
}

resource "azurerm_kubernetes_cluster" "this" {
  name                = var.name
  location            = var.location
  resource_group_name = var.rg_name
  dns_prefix          = var.name

  oidc_issuer_enabled       = true
  workload_identity_enabled = true
  automatic_channel_upgrade = "stable"
  azure_policy_enabled      = true

  identity {
    type         = "UserAssigned"
    identity_ids = [azurerm_user_assigned_identity.aks.id]
  }

  role_based_access_control_enabled = true
  azure_active_directory_role_based_access_control {
    managed = true
  }

  oms_agent {
    log_analytics_workspace_id = var.law_id
  }

  default_node_pool {
    name                = "system"
    vm_size             = "Standard_D2s_v3"
    enable_auto_scaling = true
    min_count           = 1
    max_count           = 2
  }

  network_profile {
    network_plugin    = "azure"
    network_policy    = "azure"
    load_balancer_sku = "standard"
    service_cidr      = "172.16.0.0/16"
    dns_service_ip    = "172.16.0.10"
  }
}

resource "azurerm_kubernetes_cluster_node_pool" "user" {
  name                  = "user"
  kubernetes_cluster_id = azurerm_kubernetes_cluster.this.id
  vm_size               = "Standard_D2s_v3"
  enable_auto_scaling   = true
  min_count             = 1
  max_count             = 2
  mode                  = "User"

  node_labels = {
    workload = "apps"
  }
}

resource "azurerm_role_assignment" "acr_pull" {
  scope                = var.acr_id
  role_definition_name = "AcrPull"
  principal_id         = azurerm_kubernetes_cluster.this.kubelet_identity[0].object_id
}
