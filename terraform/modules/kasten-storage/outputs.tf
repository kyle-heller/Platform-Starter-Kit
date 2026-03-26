output "storage_account_name" {
  description = "Name of the storage account"
  value       = azurerm_storage_account.this.name
}

output "storage_account_id" {
  description = "Resource ID of the storage account"
  value       = azurerm_storage_account.this.id
}

output "container_name" {
  description = "Name of the blob container for K10 exports"
  value       = azurerm_storage_container.k10_backups.name
}

output "primary_blob_endpoint" {
  description = "Primary blob endpoint URL"
  value       = azurerm_storage_account.this.primary_blob_endpoint
}
