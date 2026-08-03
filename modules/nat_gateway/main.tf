# ==============================================================================
# Module: NAT Gateway
# File: modules/nat_gateway/main.tf
# ==============================================================================

resource "azurerm_nat_gateway" "nat" {
  name                    = var.name
  location                = var.location
  resource_group_name     = var.resource_group_name
  sku_name                = "Standard"
  idle_timeout_in_minutes = 4
  tags                    = var.tags
}

resource "azurerm_nat_gateway_public_ip_association" "nat_pip" {
  nat_gateway_id       = azurerm_nat_gateway.nat.id
  public_ip_address_id = var.public_ip_id
}

resource "azurerm_subnet_nat_gateway_association" "subnet_assoc" {
  count          = length(var.subnet_ids)
  subnet_id      = var.subnet_ids[count.index]
  nat_gateway_id = azurerm_nat_gateway.nat.id
}
