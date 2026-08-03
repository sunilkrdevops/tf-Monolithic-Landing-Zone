# ==============================================================================
# Module: Subnet
# File: modules/subnet/outputs.tf
# ==============================================================================

output "subnets" {
  description = "Map of created subnet objects."
  value       = azurerm_subnet.subnet
}

output "subnet_ids" {
  description = "Map of subnet names to subnet IDs."
  value       = { for k, v in azurerm_subnet.subnet : k => v.id }
}
