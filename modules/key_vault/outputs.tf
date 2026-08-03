# ==============================================================================
# Module: Azure Key Vault
# File: modules/key_vault/outputs.tf
# ==============================================================================

output "id" {
  description = "The ID of the Key Vault."
  value       = azurerm_key_vault.kv.id
}

output "vault_uri" {
  description = "The URI of the Key Vault for performing operations on keys and secrets."
  value       = azurerm_key_vault.kv.vault_uri
}

output "name" {
  description = "The name of the Key Vault."
  value       = azurerm_key_vault.kv.name
}
