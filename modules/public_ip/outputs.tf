# ==============================================================================
# Module: Public IP
# File: modules/public_ip/outputs.tf
# ==============================================================================

output "id" {
  description = "The ID of the Public IP."
  value       = azurerm_public_ip.pip.id
}

output "ip_address" {
  description = "The IP address value."
  value       = azurerm_public_ip.pip.ip_address
}

output "name" {
  description = "The name of the Public IP."
  value       = azurerm_public_ip.pip.name
}
