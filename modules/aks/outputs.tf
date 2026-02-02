output "cluster_name" {
  description = "AKS cluster name"
  value       = azurerm_kubernetes_cluster.this.name
}

output "kubeconfig" {
  description = "Raw kubeconfig"
  value       = azurerm_kubernetes_cluster.this.kube_config_raw
  sensitive   = true
}

output "oidc_issuer_url" {
  description = "OIDC issuer URL"
  value       = azurerm_kubernetes_cluster.this.oidc_issuer_url
}
output "aks_identity_principal_id" { value = azurerm_user_assigned_identity.aks.principal_id }
