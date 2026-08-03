# ==============================================================================
# Parent Module: Output Values
# File: outputs.tf
# ==============================================================================

output "resource_group_name" {
  description = "The name of the Resource Group created."
  value       = module.resource_group.name
}

output "resource_group_id" {
  description = "The ID of the Resource Group created."
  value       = module.resource_group.id
}

output "vnet_id" {
  description = "The ID of the Virtual Network."
  value       = module.virtual_network.id
}

output "vnet_name" {
  description = "The name of the Virtual Network."
  value       = module.virtual_network.name
}

output "subnet_ids" {
  description = "Map of all created Subnet IDs."
  value       = module.subnets.subnet_ids
}

output "bastion_public_ip" {
  description = "The Public IP address assigned to Azure Bastion."
  value       = module.public_ips["bastion"].ip_address
}

output "nat_gateway_public_ip" {
  description = "The Public IP address assigned to NAT Gateway."
  value       = module.public_ips["natgw"].ip_address
}

output "bastion_dns_name" {
  description = "The FQDN of the Azure Bastion host."
  value       = module.bastion.dns_name
}

output "frontend_vm_private_ip" {
  description = "Private IP address of Frontend Virtual Machine."
  value       = module.frontend_nic.private_ip_address
}

output "backend_vm_private_ip" {
  description = "Private IP address of Backend Virtual Machine."
  value       = module.backend_nic.private_ip_address
}

output "key_vault_uri" {
  description = "The URI of the created Azure Key Vault."
  value       = var.enable_key_vault ? module.key_vault[0].vault_uri : null
}
