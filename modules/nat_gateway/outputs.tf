# ==============================================================================
# Module: NAT Gateway
# File: modules/nat_gateway/outputs.tf
# ==============================================================================

output "id" {
  description = "The ID of the NAT Gateway."
  value       = azurerm_nat_gateway.nat.id
}

output "name" {
  description = "The name of the NAT Gateway."
  value       = azurerm_nat_gateway.nat.name
}
