# ==============================================================================
# Module: Resource Group
# File: modules/resource_group/outputs.tf
# ==============================================================================

output "name" {
  description = "The name of the created Resource Group."
  value       = azurerm_resource_group.rg.name
}

output "id" {
  description = "The ID of the created Resource Group."
  value       = azurerm_resource_group.rg.id
}

output "location" {
  description = "The location of the created Resource Group."
  value       = azurerm_resource_group.rg.location
}
