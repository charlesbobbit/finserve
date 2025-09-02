terraform {
  required_version = ">= 1.0"
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "~> 3.0"
    }
  }
  # Local backend: couldn't get remote storage configured for this assessment, will use workspace specific state file
  backend "local" {}
}

provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "main" {
  name     = "rg-finserve-${var.environment}"
  location = var.location
  tags     = var.common_tags
}

module "network" {
  source = "./modules/network"
  
  resource_group_name = azurerm_resource_group.main.name
  location           = azurerm_resource_group.main.location
  environment        = var.environment
  common_tags        = var.common_tags
}

module "aks" {
  source = "./modules/aks"
  
  resource_group_name = azurerm_resource_group.main.name
  location           = azurerm_resource_group.main.location
  environment        = var.environment
  subnet_id          = module.network.aks_subnet_id
  node_count         = var.aks_node_count
  node_size          = var.aks_node_size
  common_tags        = var.common_tags
}

module "vm" {
  source = "./modules/vm"
  
  resource_group_name    = azurerm_resource_group.main.name
  location              = azurerm_resource_group.main.location
  environment           = var.environment
  subnet_id             = module.network.vm_subnet_id
  vm_size               = var.vm_size
  admin_public_key_path = var.admin_public_key_path
  common_tags           = var.common_tags
} 