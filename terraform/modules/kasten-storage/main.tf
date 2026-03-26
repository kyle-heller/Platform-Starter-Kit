resource "azurerm_storage_account" "this" {
  name                     = var.storage_account_name
  resource_group_name      = var.resource_group_name
  location                 = var.location
  account_tier             = "Standard"
  account_replication_type = var.replication_type
  min_tls_version          = "TLS1_2"

  blob_properties {
    delete_retention_policy {
      days = var.soft_delete_retention_days
    }
    container_delete_retention_policy {
      days = var.soft_delete_retention_days
    }
  }

  tags = var.tags
}

resource "azurerm_storage_container" "k10_backups" {
  name                  = "k10-backups"
  storage_account_name  = azurerm_storage_account.this.name
  container_access_type = "private"
}

# Allow AKS kubelet identity to write backup exports to blob storage
resource "azurerm_role_assignment" "blob_contributor" {
  scope                = azurerm_storage_account.this.id
  role_definition_name = "Storage Blob Data Contributor"
  principal_id         = var.kubelet_identity_id
}
