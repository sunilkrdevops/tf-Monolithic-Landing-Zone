# ==============================================================================
# Module: Azure Key Vault
# File: modules/key_vault/variables.tf
# ==============================================================================

variable "name" {
  description = "The name of the Key Vault."
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

variable "tenant_id" {
  description = "The Azure Active Directory tenant ID."
  type        = string
}

variable "sku_name" {
  description = "The SKU Name of the Key Vault (standard or premium)."
  type        = string
  default     = "standard"
}

variable "tags" {
  description = "A mapping of tags to assign to the resource."
  type        = map(string)
  default     = {}
}
