variable "environment" {
  description = "Environment name (staging, prod)"
  type        = string
  default     = "staging"
}

variable "location" {
  description = "Azure region"
  type        = string
  default     = "uksouth"
}

variable "admin_public_key_path" {
  description = "Path to SSH public key file (local development)"
  type        = string
  default     = ""
}

variable "admin_public_key" {
  description = "SSH public key content (CI/CD pipelines)"
  type        = string
  default     = ""
  sensitive   = true
}

variable "common_tags" {
  description = "Common tags for all resources"
  type        = map(string)
  default = {
    Project     = "FinServe-DevSecOps"
    ManagedBy   = "Terraform"
  }
}

# AKS Configuration
variable "aks_node_count" {
  description = "Number of nodes in AKS default pool"
  type        = number
  default     = 1
}

variable "aks_node_size" {
  description = "VM size for AKS nodes"
  type        = string
  default     = "Standard_D2s_v3"
}

# VM Configuration
variable "vm_size" {
  description = "VM size for Linux VM"
  type        = string
  default     = "Standard_B1s"
} 