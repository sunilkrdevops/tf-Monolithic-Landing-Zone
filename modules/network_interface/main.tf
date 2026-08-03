# ==============================================================================
# Module: Network Interface
# File: modules/network_interface/main.tf
# ==============================================================================

resource "azurerm_network_interface" "nic" {
  name                = var.name
  location            = var.location
  resource_group_name = var.resource_group_name
  tags                = var.tags

  ip_configuration {
    name                          = "internal"
    subnet_id                     = var.subnet_id
    private_ip_address_allocation = var.private_ip_address_allocation
    private_ip_address            = var.private_ip_address
  }
}

resource "azurerm_network_interface_security_group_association" "nic_nsg" {
  count                     = var.nsg_id != null ? 1 : 0
  network_interface_id      = azurerm_network_interface.nic.id
  network_security_group_id = var.nsg_id
}
