resource "azurerm_kubernetes_cluster" "main" {
  name                = "aks-finserve-${var.environment}"
  location            = var.location
  resource_group_name = var.resource_group_name
  dns_prefix          = "aks-finserve-${var.environment}"

  default_node_pool {
    name           = "default"
    node_count     = var.node_count
    vm_size        = var.node_size
    vnet_subnet_id = var.subnet_id
  }

  identity {
    type = "SystemAssigned"
  }

  role_based_access_control_enabled = true

  network_profile {
    network_plugin = "azure"
    service_cidr   = "172.16.0.0/16" # Different from VNet CIDR to avoid overlap
    dns_service_ip = "172.16.0.10"
  }

  tags = var.common_tags
} 