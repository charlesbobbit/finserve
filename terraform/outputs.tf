output "resource_group_name" {
  description = "Name of the resource group"
  value       = azurerm_resource_group.main.name
}

output "aks_cluster_name" {
  description = "Name of the AKS cluster"
  value       = module.aks.cluster_name
}

output "aks_kubeconfig" {
  description = "Kubeconfig for AKS cluster"
  value       = module.aks.kubeconfig
  sensitive   = true
}

output "vm_public_ip" {
  description = "Public IP of the Linux VM"
  value       = module.vm.public_ip
}

output "vm_ssh_command" {
  description = "SSH command to connect to VM"
  value       = module.vm.ssh_command
} 