variable "resource_group_name" {
  description = "Name of the resource group"
  type        = string
}

variable "location" {
  description = "Azure region"
  type        = string
}

variable "environment" {
  description = "Environment name"
  type        = string
}

variable "subnet_id" {
  description = "ID of the subnet for the VM"
  type        = string
}

variable "vm_size" {
  description = "VM size"
  type        = string
  default     = "Standard_B1s"
}

variable "admin_public_key_path" {
  description = "Path to SSH public key file"
  type        = string
  default     = "~/.ssh/finserve_key.pub"
}

variable "common_tags" {
  description = "Common tags for all resources"
  type        = map(string)
  default     = {}
} 