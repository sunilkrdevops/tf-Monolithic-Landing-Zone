# ==============================================================================
# Module: Subnet
# File: modules/subnet/variables.tf
# ==============================================================================

variable "resource_group_name" {
  description = "The name of the resource group in which to create the subnet."
  type        = string
}

variable "virtual_network_name" {
  description = "The name of the virtual network to which the subnet belongs."
  type        = string
}

variable "subnets" {
  description = "Map of subnets to create with their CIDR prefixes and optional settings."
  type = map(object({
    address_prefixes                              = list(string)
    private_endpoint_network_policies             = optional(string, "Enabled")
    private_link_service_network_policies_enabled = optional(bool, true)
    service_endpoints                             = optional(list(string), [])
  }))
}
