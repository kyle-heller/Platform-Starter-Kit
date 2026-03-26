module "aks" {
  source = "../../modules/aks-cluster"

  cluster_name        = "platform-prod"
  resource_group_name = "platform-prod-rg"
  location            = var.location
  kubernetes_version  = "1.29"

  vnet_address_space  = "10.2.0.0/16"
  nodes_subnet_prefix = "10.2.0.0/22"
  service_cidr        = "10.3.0.0/16"
  dns_service_ip      = "10.3.0.10"

  default_node_pool = {
    node_count          = 3
    vm_size             = "Standard_D2s_v3"
    enable_auto_scaling = true
    min_count           = 2
    max_count           = 5
  }

  workload_node_pool = {
    node_count          = 2
    vm_size             = "Standard_D4s_v3"
    enable_auto_scaling = true
    min_count           = 1
    max_count           = 10
  }

  # TODO: replace with actual AAD group object ID
  rbac_aad_admin_group_ids = ["00000000-0000-0000-0000-000000000000"]

  tags = {
    Environment = "prod"
    Project     = "platform-starter-kit"
    ManagedBy   = "terraform"
  }
}

module "acr" {
  source = "../../modules/acr"

  registry_name       = "platformprodacr"
  resource_group_name = module.aks.resource_group_name
  location            = var.location
  sku                 = "Standard"
  kubelet_identity_id = module.aks.kubelet_identity

  tags = {
    Environment = "prod"
    Project     = "platform-starter-kit"
    ManagedBy   = "terraform"
  }
}

module "kasten_storage" {
  source = "../../modules/kasten-storage"

  storage_account_name = "platformprodk10bak"
  resource_group_name  = module.aks.resource_group_name
  location             = var.location
  replication_type     = "GRS" # cross-region durability for backup exports
  kubelet_identity_id  = module.aks.kubelet_identity

  tags = {
    Environment = "prod"
    Project     = "platform-starter-kit"
    ManagedBy   = "terraform"
  }
}
