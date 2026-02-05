resource "azurerm_resource_group" "this" {
  name     = var.resource_group_name
  location = var.location

  tags = var.tags
}

resource "azurerm_virtual_network" "this" {
  name                = "${var.cluster_name}-vnet"
  location            = azurerm_resource_group.this.location
  resource_group_name = azurerm_resource_group.this.name
  address_space       = [var.vnet_address_space]

  tags = var.tags
}

resource "azurerm_subnet" "nodes" {
  name                 = "nodes"
  resource_group_name  = azurerm_resource_group.this.name
  virtual_network_name = azurerm_virtual_network.this.name
  address_prefixes     = [var.nodes_subnet_prefix]
}

resource "azurerm_kubernetes_cluster" "this" {
  name                = var.cluster_name
  location            = azurerm_resource_group.this.location
  resource_group_name = azurerm_resource_group.this.name
  dns_prefix          = var.cluster_name
  kubernetes_version  = var.kubernetes_version

  default_node_pool {
    name                = "default"
    node_count          = var.default_node_pool.node_count
    vm_size             = var.default_node_pool.vm_size
    vnet_subnet_id      = azurerm_subnet.nodes.id
    enable_auto_scaling = var.default_node_pool.enable_auto_scaling
    min_count           = var.default_node_pool.enable_auto_scaling ? var.default_node_pool.min_count : null
    max_count           = var.default_node_pool.enable_auto_scaling ? var.default_node_pool.max_count : null

    tags = var.tags
  }

  identity {
    type = "SystemAssigned"
  }

  azure_active_directory_role_based_access_control {
    azure_rbac_enabled     = true
    admin_group_object_ids = var.rbac_aad_admin_group_ids
  }

  # NOTE: azure CNI + calico for full network policy support
  network_profile {
    network_plugin    = "azure"
    network_policy    = "calico"
    load_balancer_sku = "standard"
    service_cidr      = var.service_cidr
    dns_service_ip    = var.dns_service_ip
  }

  tags = var.tags
}

# Additional node pool for workloads (optional)
resource "azurerm_kubernetes_cluster_node_pool" "workloads" {
  count = var.workload_node_pool != null ? 1 : 0

  name                  = "workloads"
  kubernetes_cluster_id = azurerm_kubernetes_cluster.this.id
  vm_size               = var.workload_node_pool.vm_size
  node_count            = var.workload_node_pool.node_count
  vnet_subnet_id        = azurerm_subnet.nodes.id
  enable_auto_scaling   = var.workload_node_pool.enable_auto_scaling
  min_count             = var.workload_node_pool.enable_auto_scaling ? var.workload_node_pool.min_count : null
  max_count             = var.workload_node_pool.enable_auto_scaling ? var.workload_node_pool.max_count : null

  node_labels = {
    "workload-type" = "general"
  }

  tags = var.tags
}
