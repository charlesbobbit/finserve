environment = "staging"
location    = "uksouth"

# SSH Key for VM access
# Local development: uses file path
admin_public_key_path = "~/.ssh/finserve_key.pub"
# CI/CD: admin_public_key will be set via GitHub Secrets

# Minimal sizing for staging
aks_node_count = 1
aks_node_size  = "Standard_B2s"
vm_size        = "Standard_B1s"

common_tags = {
  Project     = "FinServe-DevSecOps"
  Environment = "staging"
  ManagedBy   = "Terraform"
} 