# ==============================================================================
# Module: Resource Group
# File: modules/resource_group/variables.tf
# ==============================================================================

variable "name" {
  description = "The name of the Resource Group following Azure CAF naming conventions."
  type        = string
}

variable "location" {
  description = "The Azure Region where the Resource Group should exist."
  type        = string
}

variable "tags" {
  description = "A mapping of tags to assign to the resource."
  type        = map(string)
  default     = {}
}
