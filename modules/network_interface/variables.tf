# ==============================================================================
# Module: Network Interface
# File: modules/network_interface/variables.tf
# ==============================================================================

variable "name" {
  description = "The name of the Network Interface."
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
  description = "The ID of the Subnet to connect this NIC."
  type        = string
}

variable "private_ip_address_allocation" {
  description = "The allocation method for the Private IP Address (Dynamic or Static)."
  type        = string
  default     = "Dynamic"
}

variable "private_ip_address" {
  description = "Static private IP address if allocation method is Static."
  type        = string
  default     = null
}

variable "nsg_id" {
  description = "Optional Network Security Group ID to associate directly with this NIC."
  type        = string
  default     = null
}

variable "tags" {
  description = "A mapping of tags to assign to the resource."
  type        = map(string)
  default     = {}
}
