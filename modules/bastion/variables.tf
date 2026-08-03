# ==============================================================================
# Module: Azure Bastion
# File: modules/bastion/variables.tf
# ==============================================================================

variable "name" {
  description = "The name of the Azure Bastion host."
  type        = string
}

variable "resource_group_name" {
  description = "The name of the Resource Group."
  type        = string
}

variable "location" {
  description = "The Azure Region location."
  type        = string
}

variable "subnet_id" {
  description = "The ID of the AzureBastionSubnet."
  type        = string
}

variable "public_ip_id" {
  description = "The ID of the Public IP address attached to Bastion."
  type        = string
}

variable "sku" {
  description = "The SKU of the Bastion Host (Basic or Standard)."
  type        = string
  default     = "Standard"
}

variable "tags" {
  description = "A mapping of tags to assign to the resource."
  type        = map(string)
  default     = {}
}
