environment = "prod"
location    = "uksouth"

admin_public_key_path = "~/.ssh/finserve_key.pub"

aks_node_count = 2
aks_node_size  = "Standard_D2s_v3"
vm_size        = "Standard_B1ms"

common_tags = {
  Project     = "FinServe-DevSecOps"
  Environment = "prod"
  ManagedBy   = "Terraform"
} 