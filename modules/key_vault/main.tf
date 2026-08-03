# ==============================================================================
# Module: Azure Key Vault
# File: modules/key_vault/main.tf
# ==============================================================================

resource "azurerm_key_vault" "kv" {
  name                        = var.name
  location                    = var.location
  resource_group_name         = var.resource_group_name
  enabled_for_disk_encryption = true
  tenant_id                   = var.tenant_id
  soft_delete_retention_days  = 7
  purge_protection_enabled    = false
  sku_name                    = var.sku_name
  enable_rbac_authorization   = true
  tags                        = var.tags
}
