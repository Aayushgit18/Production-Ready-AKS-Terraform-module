# AKS Outputs

output "aks_cluster_name" {
  description = "AKS cluster name"
  value = module.aks.cluster_name
}

output "aks_resource_group" {
  description = "AKS resource group name"
  value       = module.rg.name
}

output "aks_kubeconfig" {
  description = "Raw kubeconfig for AKS cluster"
  value       = module.aks.kubeconfig
  sensitive   = true
}

output "aks_oidc_issuer_url" {
  description = "OIDC issuer URL for workload identity"
  value       = module.aks.oidc_issuer_url
}

# ACR Outputs

output "acr_id" {
  description = "Azure Container Registry ID"
  value       = module.acr.acr_id
}

output "acr_login_server" {
  description = "ACR login server URL"
  value       = module.acr.login_server
}

# Monitoring Outputs

output "log_analytics_workspace_id" {
  description = "Log Analytics Workspace ID"
  value       = module.monitoring.law_id
}

# Network Outputs


output "vnet_name" {
  description = "Virtual Network name"
  value       = var.vnet_name
}

output "system_subnet_id" {
  description = "AKS system node subnet ID"
  value       = module.network.system_subnet_id
}

output "user_subnet_id" {
  description = "AKS user node subnet ID"
  value       = module.network.user_subnet_id
}




