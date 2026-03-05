output "cluster_name" {
  description = "Name of the AKS cluster"
  value       = module.aks.cluster_name
}

output "resource_group_name" {
  description = "Name of the resource group"
  value       = module.aks.resource_group_name
}

output "kube_config" {
  description = "Kubeconfig for the cluster"
  value       = module.aks.kube_config
  sensitive   = true
}

output "configure_kubectl" {
  description = "Command to configure kubectl"
  value       = "az aks get-credentials --resource-group ${module.aks.resource_group_name} --name ${module.aks.cluster_name}"
}

output "acr_login_server" {
  description = "ACR login server URL"
  value       = module.acr.login_server
}
