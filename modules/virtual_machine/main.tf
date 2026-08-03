# ==============================================================================
# Module: Virtual Machine
# File: modules/virtual_machine/main.tf
# ==============================================================================

resource "azurerm_linux_virtual_machine" "vm" {
  name                            = var.name
  resource_group_name             = var.resource_group_name
  location                        = var.location
  size                            = var.size
  admin_username                  = var.admin_username
  admin_password                  = var.admin_password
  disable_password_authentication = var.disable_password_authentication
  network_interface_ids           = var.network_interface_ids
  custom_data                     = var.custom_data
  secure_boot_enabled             = true
  vtpm_enabled                    = true
  tags                            = var.tags

  os_disk {
    name                 = "osdisk-${var.name}"
    caching              = var.os_disk_caching
    storage_account_type = var.os_disk_storage_account_type
  }

  source_image_reference {
    publisher = var.os_publisher
    offer     = var.os_offer
    sku       = var.os_sku
    version   = var.os_version
  }

  dynamic "admin_ssh_key" {
    for_each = var.admin_ssh_public_key != null ? [var.admin_ssh_public_key] : []
    content {
      username   = var.admin_username
      public_key = admin_ssh_key.value
    }
  }

  identity {
    type = "SystemAssigned"
  }

  boot_diagnostics {
    storage_account_uri = null # Managed Storage Account
  }
}
