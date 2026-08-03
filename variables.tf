# ==============================================================================
# Parent Module: Variable Definitions
# File: variables.tf
# ==============================================================================

variable "prefix" {
  description = "Project prefix for resource naming."
  type        = string
  default     = "alz"
}

variable "environment" {
  description = "Deployment environment (e.g. dev, staging, prod)."
  type        = string
  default     = "prod"
}

variable "location" {
  description = "Primary Azure Region for resource deployment."
  type        = string
  default     = "centralindia"
}

variable "vnet_cidr" {
  description = "Address space for the Virtual Network."
  type        = list(string)
  default     = ["10.0.0.0/16"]
}

variable "frontend_subnet_cidr" {
  description = "Address prefixes for the Frontend Subnet."
  type        = list(string)
  default     = ["10.0.1.0/24"]
}

variable "backend_subnet_cidr" {
  description = "Address prefixes for the Backend Subnet."
  type        = list(string)
  default     = ["10.0.2.0/24"]
}

variable "bastion_subnet_cidr" {
  description = "Address prefixes for AzureBastionSubnet (Must be at least /27 or /26)."
  type        = list(string)
  default     = ["10.0.3.0/27"]
}

variable "vm_admin_username" {
  description = "Administrator username for Linux VMs."
  type        = string
  default     = "azureuser"
}

variable "vm_admin_password" {
  description = "Administrator password for Linux VMs. Must meet complexity requirements."
  type        = string
  sensitive   = true
}

variable "vm_size" {
  description = "VM SKU size for Linux Virtual Machines."
  type        = string
  default     = "Standard_B2s"
}

variable "ssh_public_key" {
  description = "Optional SSH Public Key for VM authentication."
  type        = string
  default     = null
}

variable "enable_key_vault" {
  description = "Whether to provision an Azure Key Vault for secrets management."
  type        = bool
  default     = true
}

variable "tags" {
  description = "Tags to apply to all resources."
  type        = map(string)
  default = {
    Owner      = "DevOps-Team"
    CostCenter = "Infrastructure-101"
  }
}
