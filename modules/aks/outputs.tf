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
