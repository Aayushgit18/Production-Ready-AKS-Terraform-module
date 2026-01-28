
resource "azurerm_kubernetes_cluster_node_pool" "user" {
  name                  = "usernp"
  kubernetes_cluster_id = azurerm_kubernetes_cluster.this.id
  user_vm_size = "Standard_DS2_v2"
  min_count             = 1
  max_count             = 5
  enable_auto_scaling   = true
  vnet_subnet_id        = var.user_subnet_id
}
