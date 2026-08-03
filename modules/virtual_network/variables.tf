# ==============================================================================
# Module: Virtual Network
# File: modules/virtual_network/variables.tf
# ==============================================================================

variable "name" {
  description = "The name of the Virtual Network."
  type        = string
}

variable "resource_group_name" {
  description = "The name of the Resource Group in which to create the Virtual Network."
  type        = string
}

variable "location" {
  description = "The location/region where the Virtual Network is created."
  type        = string
}

variable "address_space" {
  description = "The address space that is used by the Virtual Network."
  type        = list(string)
  default     = ["10.0.0.0/16"]
}

variable "dns_servers" {
  description = "List of IP addresses of DNS servers."
  type        = list(string)
  default     = []
}

variable "tags" {
  description = "A mapping of tags to assign to the resource."
  type        = map(string)
  default     = {}
}
