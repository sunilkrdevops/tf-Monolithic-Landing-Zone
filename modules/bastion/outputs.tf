# ==============================================================================
# Module: Azure Bastion
# File: modules/bastion/outputs.tf
# ==============================================================================

output "id" {
  description = "The ID of the Azure Bastion host."
  value       = azurerm_bastion_host.bastion.id
}

output "dns_name" {
  description = "The FQDN of the Azure Bastion host."
  value       = azurerm_bastion_host.bastion.dns_name
}
