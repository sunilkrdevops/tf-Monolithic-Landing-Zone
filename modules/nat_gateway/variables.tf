# ==============================================================================
# Module: NAT Gateway
# File: modules/nat_gateway/variables.tf
# ==============================================================================

variable "name" {
  description = "The name of the NAT Gateway."
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

variable "public_ip_id" {
  description = "The ID of the Public IP address to associate with the NAT Gateway."
  type        = string
}

variable "subnet_ids" {
  description = "List of Subnet IDs to associate with the NAT Gateway."
  type        = list(string)
  default     = []
}

variable "tags" {
  description = "A mapping of tags to assign to the resource."
  type        = map(string)
  default     = {}
}
