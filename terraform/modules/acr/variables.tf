variable "registry_name" {
  description = "Name of the container registry (must be globally unique, alphanumeric only)"
  type        = string
}

variable "resource_group_name" {
  description = "Name of the resource group"
  type        = string
}

variable "location" {
  description = "Azure region"
  type        = string
}

variable "sku" {
  description = "ACR SKU tier"
  type        = string
  default     = "Basic"
}

variable "kubelet_identity_id" {
  description = "Object ID of the AKS kubelet managed identity for AcrPull role assignment"
  type        = string
}

variable "tags" {
  description = "Resource tags"
  type        = map(string)
  default     = {}
}
