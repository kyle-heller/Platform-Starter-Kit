variable "cluster_name" {
  description = "Name of the AKS cluster"
  type        = string
}

variable "resource_group_name" {
  description = "Name of the resource group"
  type        = string
}

variable "location" {
  description = "Azure region for resources"
  type        = string
  default     = "eastus2"
}

variable "kubernetes_version" {
  description = "Kubernetes version for the cluster"
  type        = string
  default     = "1.29"
}

variable "vnet_address_space" {
  description = "Address space for the virtual network"
  type        = string
  default     = "10.0.0.0/16"
}

variable "nodes_subnet_prefix" {
  description = "Address prefix for the nodes subnet"
  type        = string
  default     = "10.0.0.0/22"
}

variable "service_cidr" {
  description = "CIDR for Kubernetes services"
  type        = string
  default     = "10.1.0.0/16"
}

variable "dns_service_ip" {
  description = "IP address for Kubernetes DNS service"
  type        = string
  default     = "10.1.0.10"
}

variable "default_node_pool" {
  description = "Configuration for the default node pool"
  type = object({
    node_count          = number
    vm_size             = string
    enable_auto_scaling = bool
    min_count           = optional(number)
    max_count           = optional(number)
  })
  default = {
    node_count          = 2
    vm_size             = "Standard_B2s"
    enable_auto_scaling = false
    min_count           = null
    max_count           = null
  }
}

variable "workload_node_pool" {
  description = "Optional additional node pool for workloads"
  type = object({
    node_count          = number
    vm_size             = string
    enable_auto_scaling = bool
    min_count           = optional(number)
    max_count           = optional(number)
  })
  default = null
}

variable "rbac_aad_admin_group_ids" {
  description = "Azure AD group object IDs that will have admin access to the cluster"
  type        = list(string)
  default     = []
}

variable "tags" {
  description = "Tags to apply to all resources"
  type        = map(string)
  default     = {}
}
