# ==============================================================================
# Module: Network Interface
# File: modules/network_interface/outputs.tf
# ==============================================================================

output "id" {
  description = "The ID of the Network Interface."
  value       = azurerm_network_interface.nic.id
}

output "private_ip_address" {
  description = "The Private IP Address assigned to this Network Interface."
  value       = azurerm_network_interface.nic.private_ip_address
}

output "name" {
  description = "The name of the Network Interface."
  value       = azurerm_network_interface.nic.name
}
