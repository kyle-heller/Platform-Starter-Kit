module "aks" {
  source = "../../modules/aks-cluster"

  cluster_name        = "platform-dev"
  resource_group_name = "platform-dev-rg"
  location            = var.location
  kubernetes_version  = "1.29"

  vnet_address_space  = "10.0.0.0/16"
  nodes_subnet_prefix = "10.0.1.0/24"
  service_cidr        = "10.1.0.0/16"
  dns_service_ip      = "10.1.0.10"

  default_node_pool = {
    node_count          = 2
    vm_size             = "Standard_B2s"
    enable_auto_scaling = true
    min_count           = 1
    max_count           = 3
  }

  workload_node_pool = null # not worth the cost in dev

  rbac_aad_admin_group_ids = [] # dev doesn't need AAD groups

  tags = {
    Environment = "dev"
    Project     = "platform-starter-kit"
    ManagedBy   = "terraform"
  }
}
