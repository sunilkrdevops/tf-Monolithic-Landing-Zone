# ==============================================================================
# Module: Virtual Machine
# File: modules/virtual_machine/outputs.tf
# ==============================================================================

output "id" {
  description = "The ID of the Linux Virtual Machine."
  value       = azurerm_linux_virtual_machine.vm.id
}

output "name" {
  description = "The name of the Linux Virtual Machine."
  value       = azurerm_linux_virtual_machine.vm.name
}

output "principal_id" {
  description = "The Principal ID of the System Assigned Managed Identity."
  value       = azurerm_linux_virtual_machine.vm.identity[0].principal_id
}
