# ==============================================================================
# Module: Public IP
# File: modules/public_ip/variables.tf
# ==============================================================================

variable "name" {
  description = "The name of the Public IP."
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

variable "allocation_method" {
  description = "Defines the allocation method for this IP address (Static or Dynamic)."
  type        = string
  default     = "Static"
}

variable "sku" {
  description = "The SKU of the Public IP (Basic or Standard)."
  type        = string
  default     = "Standard"
}

variable "tags" {
  description = "A mapping of tags to assign to the resource."
  type        = map(string)
  default     = {}
}
