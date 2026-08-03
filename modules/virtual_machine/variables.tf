# ==============================================================================
# Module: Virtual Machine
# File: modules/virtual_machine/variables.tf
# ==============================================================================

variable "name" {
  description = "The name of the Virtual Machine."
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

variable "size" {
  description = "The SKU size of the Virtual Machine."
  type        = string
  default     = "Standard_B2s"
}

variable "admin_username" {
  description = "The admin username for the VM."
  type        = string
  default     = "azureuser"
}

variable "admin_password" {
  description = "The admin password for the VM. Required if password auth is enabled."
  type        = string
  sensitive   = true
  default     = null
}

variable "disable_password_authentication" {
  description = "Should password authentication be disabled?"
  type        = bool
  default     = false
}

variable "admin_ssh_public_key" {
  description = "The SSH Public Key for authentication."
  type        = string
  default     = null
}

variable "network_interface_ids" {
  description = "A list of Network Interface IDs to attach to the VM."
  type        = list(string)
}

variable "custom_data" {
  description = "Base64 encoded cloud-init / custom data script."
  type        = string
  default     = null
}

variable "os_disk_caching" {
  description = "Caching requirements for OS Disk."
  type        = string
  default     = "ReadWrite"
}

variable "os_disk_storage_account_type" {
  description = "Storage account type for OS Disk."
  type        = string
  default     = "Premium_LRS"
}

variable "os_publisher" {
  description = "Publisher of the OS image."
  type        = string
  default     = "Canonical"
}

variable "os_offer" {
  description = "Offer of the OS image."
  type        = string
  default     = "0001-com-ubuntu-server-jammy"
}

variable "os_sku" {
  description = "SKU of the OS image."
  type        = string
  default     = "22_04-lts-gen2"
}

variable "os_version" {
  description = "Version of the OS image."
  type        = string
  default     = "latest"
}

variable "tags" {
  description = "A mapping of tags to assign to the resource."
  type        = map(string)
  default     = {}
}
