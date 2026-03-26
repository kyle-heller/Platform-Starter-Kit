variable "storage_account_name" {
  description = "Storage account name"
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

variable "replication_type" {
  description = "Storage replication type (LRS, GRS, ZRS, GZRS)"
  type        = string
  default     = "LRS"
}

variable "soft_delete_retention_days" {
  description = "Days to retain soft-deleted blobs and containers"
  type        = number
  default     = 14
}

variable "kubelet_identity_id" {
  description = "Object ID of the AKS kubelet managed identity for Storage Blob Data Contributor role"
  type        = string
}

variable "tags" {
  description = "Resource tags"
  type        = map(string)
  default     = {}
}
