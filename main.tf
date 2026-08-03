# ==============================================================================
# Parent Module: Main Orchestration Specification
# File: main.tf
# ==============================================================================

# ------------------------------------------------------------------------------
# Data Blocks: Retrieve Current Azure Client Context
# ------------------------------------------------------------------------------
data "azurerm_client_config" "current" {}

# ------------------------------------------------------------------------------
# Resource Group
# ------------------------------------------------------------------------------
module "resource_group" {
  source   = "./modules/resource_group"
  name     = local.resource_group_name
  location = var.location
  tags     = local.common_tags
}

# ------------------------------------------------------------------------------
# Virtual Network
# ------------------------------------------------------------------------------
module "virtual_network" {
  source              = "./modules/virtual_network"
  name                = local.vnet_name
  resource_group_name = module.resource_group.name
  location            = module.resource_group.location
  address_space       = var.vnet_cidr
  tags                = local.common_tags

  depends_on = [module.resource_group]
}

# ------------------------------------------------------------------------------
# Subnets (Frontend, Backend, AzureBastionSubnet) using for_each
# ------------------------------------------------------------------------------
module "subnets" {
  source               = "./modules/subnet"
  resource_group_name  = module.resource_group.name
  virtual_network_name = module.virtual_network.name

  subnets = {
    "snet-frontend" = {
      address_prefixes = var.frontend_subnet_cidr
    }
    "snet-backend" = {
      address_prefixes = var.backend_subnet_cidr
    }
    "AzureBastionSubnet" = {
      address_prefixes = var.bastion_subnet_cidr
    }
  }

  depends_on = [module.virtual_network]
}

# ------------------------------------------------------------------------------
# Network Security Groups (Frontend & Backend)
# ------------------------------------------------------------------------------
module "frontend_nsg" {
  source              = "./modules/network_security_group"
  name                = "nsg-frontend-${var.environment}"
  resource_group_name = module.resource_group.name
  location            = module.resource_group.location
  tags                = local.common_tags

  security_rules = [
    {
      name                       = "Allow-HTTP-Inbound"
      priority                   = 100
      direction                  = "Inbound"
      access                     = "Allow"
      protocol                   = "Tcp"
      source_port_range          = "*"
      destination_port_range     = "80"
      source_address_prefix      = "*"
      destination_address_prefix = "*"
      description                = "Allow HTTP web traffic from Internet"
    },
    {
      name                       = "Allow-HTTPS-Inbound"
      priority                   = 110
      direction                  = "Inbound"
      access                     = "Allow"
      protocol                   = "Tcp"
      source_port_range          = "*"
      destination_address_prefix = "*"
      destination_port_range     = "443"
      source_address_prefix      = "*"
      description                = "Allow HTTPS encrypted web traffic"
    },
    {
      name                       = "Allow-SSH-From-Bastion-Only"
      priority                   = 120
      direction                  = "Inbound"
      access                     = "Allow"
      protocol                   = "Tcp"
      source_port_range          = "*"
      destination_port_range     = "22"
      source_address_prefix      = var.bastion_subnet_cidr[0]
      destination_address_prefix = "*"
      description                = "Allow SSH management strictly from Azure Bastion subnet"
    },
    {
      name                       = "Deny-Direct-Internet-SSH"
      priority                   = 200
      direction                  = "Inbound"
      access                     = "Deny"
      protocol                   = "Tcp"
      source_port_range          = "*"
      destination_port_range     = "22"
      source_address_prefix      = "Internet"
      destination_address_prefix = "*"
      description                = "Block direct SSH exposure to the Internet"
    }
  ]
}

module "backend_nsg" {
  source              = "./modules/network_security_group"
  name                = "nsg-backend-${var.environment}"
  resource_group_name = module.resource_group.name
  location            = module.resource_group.location
  tags                = local.common_tags

  security_rules = [
    {
      name                       = "Allow-Internal-HTTP-From-Frontend"
      priority                   = 100
      direction                  = "Inbound"
      access                     = "Allow"
      protocol                   = "Tcp"
      source_port_range          = "*"
      destination_port_range     = "80"
      source_address_prefix      = var.frontend_subnet_cidr[0]
      destination_address_prefix = "*"
      description                = "Allow application traffic from Frontend subnet"
    },
    {
      name                       = "Allow-SSH-From-Bastion-Only"
      priority                   = 110
      direction                  = "Inbound"
      access                     = "Allow"
      protocol                   = "Tcp"
      source_port_range          = "*"
      destination_port_range     = "22"
      source_address_prefix      = var.bastion_subnet_cidr[0]
      destination_address_prefix = "*"
      description                = "Allow SSH strictly from Azure Bastion subnet"
    },
    {
      name                       = "Deny-All-Inbound-Internet"
      priority                   = 4000
      direction                  = "Inbound"
      access                     = "Deny"
      protocol                   = "*"
      source_port_range          = "*"
      destination_port_range     = "*"
      source_address_prefix      = "Internet"
      destination_address_prefix = "*"
      description                = "Strictly isolate backend from direct Internet access"
    }
  ]
}

# Subnet to NSG Associations
resource "azurerm_subnet_network_security_group_association" "frontend_assoc" {
  subnet_id                 = module.subnets.subnet_ids["snet-frontend"]
  network_security_group_id = module.frontend_nsg.id
}

resource "azurerm_subnet_network_security_group_association" "backend_assoc" {
  subnet_id                 = module.subnets.subnet_ids["snet-backend"]
  network_security_group_id = module.backend_nsg.id
}

# ------------------------------------------------------------------------------
# Public IPs (for Azure Bastion and NAT Gateway) using for_each
# ------------------------------------------------------------------------------
module "public_ips" {
  source              = "./modules/public_ip"
  for_each            = toset(["bastion", "natgw"])
  name                = "pip-${each.key}-${var.environment}"
  resource_group_name = module.resource_group.name
  location            = module.resource_group.location
  allocation_method   = "Static"
  sku                 = "Standard"
  tags                = local.common_tags
}

# ------------------------------------------------------------------------------
# NAT Gateway (Attached to Backend Subnet for secure outbound Internet access)
# ------------------------------------------------------------------------------
module "nat_gateway" {
  source              = "./modules/nat_gateway"
  name                = local.nat_gateway_name
  resource_group_name = module.resource_group.name
  location            = module.resource_group.location
  public_ip_id        = module.public_ips["natgw"].id
  subnet_ids          = [module.subnets.subnet_ids["snet-backend"]]
  tags                = local.common_tags
}

# ------------------------------------------------------------------------------
# Azure Bastion Host
# ------------------------------------------------------------------------------
module "bastion" {
  source              = "./modules/bastion"
  name                = local.bastion_name
  resource_group_name = module.resource_group.name
  location            = module.resource_group.location
  subnet_id           = module.subnets.subnet_ids["AzureBastionSubnet"]
  public_ip_id        = module.public_ips["bastion"].id
  sku                 = "Standard"
  tags                = local.common_tags
}

# ------------------------------------------------------------------------------
# Network Interfaces (Frontend & Backend NICs)
# ------------------------------------------------------------------------------
module "frontend_nic" {
  source              = "./modules/network_interface"
  name                = "nic-frontend-${var.environment}"
  resource_group_name = module.resource_group.name
  location            = module.resource_group.location
  subnet_id           = module.subnets.subnet_ids["snet-frontend"]
  tags                = local.common_tags
}

module "backend_nic" {
  source              = "./modules/network_interface"
  name                = "nic-backend-${var.environment}"
  resource_group_name = module.resource_group.name
  location            = module.resource_group.location
  subnet_id           = module.subnets.subnet_ids["snet-backend"]
  tags                = local.common_tags
}

# ------------------------------------------------------------------------------
# Linux Virtual Machines (Frontend & Backend VMs)
# ------------------------------------------------------------------------------
module "frontend_vm" {
  source                          = "./modules/virtual_machine"
  name                            = "vm-frontend-${var.environment}"
  resource_group_name             = module.resource_group.name
  location                        = module.resource_group.location
  size                            = var.vm_size
  admin_username                  = var.vm_admin_username
  admin_password                  = var.vm_admin_password
  disable_password_authentication = false
  admin_ssh_public_key            = var.ssh_public_key
  network_interface_ids           = [module.frontend_nic.id]
  custom_data                     = local.cloud_init_base64
  tags                            = local.common_tags
}

module "backend_vm" {
  source                          = "./modules/virtual_machine"
  name                            = "vm-backend-${var.environment}"
  resource_group_name             = module.resource_group.name
  location                        = module.resource_group.location
  size                            = var.vm_size
  admin_username                  = var.vm_admin_username
  admin_password                  = var.vm_admin_password
  disable_password_authentication = false
  admin_ssh_public_key            = var.ssh_public_key
  network_interface_ids           = [module.backend_nic.id]
  custom_data                     = local.cloud_init_base64
  tags                            = local.common_tags
}

# ------------------------------------------------------------------------------
# Optional Integration: Azure Key Vault for Secure Secrets Management
# ------------------------------------------------------------------------------
resource "random_string" "kv_suffix" {
  length  = 6
  special = false
  upper   = false
}

module "key_vault" {
  count               = var.enable_key_vault ? 1 : 0
  source              = "./modules/key_vault"
  name                = "kv-${var.prefix}-${var.environment}-${random_string.kv_suffix.result}"
  resource_group_name = module.resource_group.name
  location            = module.resource_group.location
  tenant_id           = data.azurerm_client_config.current.tenant_id
  sku_name            = "standard"
  tags                = local.common_tags
}
