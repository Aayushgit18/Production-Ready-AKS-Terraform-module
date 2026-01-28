resource "azurerm_kubernetes_cluster" "this" {
  name                = var.name
  location            = var.location
  resource_group_name = var.rg_name
  dns_prefix          = var.name

  private_cluster_enabled = true

  oidc_issuer_enabled       = true
  workload_identity_enabled = true
  automatic_channel_upgrade = "stable"

  azure_policy_enabled = true

  identity {
    type = "SystemAssigned"
  }

  role_based_access_control_enabled = true
  azure_active_directory_role_based_access_control {
    managed = true
  }

  oms_agent {
    log_analytics_workspace_id = var.law_id
  }

  default_node_pool {
    name                         = "system"
    vm_size                      = "Standard_D4s_v5"
    vnet_subnet_id               = var.system_subnet_id
    enable_auto_scaling          = true
    min_count                    = 1
    max_count                    = 3
    zones                        = ["1", "2", "3"]
    only_critical_addons_enabled = true
  }

  network_profile {
    network_plugin    = "azure"
    network_policy    = "azure"
    load_balancer_sku = "standard"
    service_cidr      = "10.20.0.0/16"
    dns_service_ip    = "10.20.0.10"
  }
}

resource "azurerm_kubernetes_cluster_node_pool" "user" {
  name                  = "user"
  kubernetes_cluster_id = azurerm_kubernetes_cluster.this.id
  vm_size               = "Standard_D4s_v5"
  vnet_subnet_id        = var.user_subnet_id
  enable_auto_scaling   = true
  min_count             = 1
  max_count             = 5
  zones                 = ["1", "2", "3"]
  mode                  = "User"
}

resource "azurerm_role_assignment" "acr_pull" {
  scope                = var.acr_id
  role_definition_name = "AcrPull"
  principal_id         = azurerm_kubernetes_cluster.this.kubelet_identity[0].object_id
}
