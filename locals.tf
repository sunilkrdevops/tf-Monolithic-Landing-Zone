# ==============================================================================
# Parent Module: Local Values & Azure CAF Naming Standards
# File: locals.tf
# ==============================================================================

locals {
  # Regional Abbrev Mapping for CAF standard naming
  region_code_map = {
    "centralindia"   = "cin"
    "eastus"         = "eus"
    "eastus2"        = "eus2"
    "westus"         = "wus"
    "westus2"        = "wus2"
    "westeurope"     = "weu"
    "northeurope"    = "neu"
    "centralus"      = "cus"
    "southcentralus" = "scus"
    "southeastasia"  = "sea"
  }

  region_code = lookup(local.region_code_map, lower(var.location), "gen")

  # Standard CAF Resource Names
  resource_group_name = "rg-${var.prefix}-${var.environment}-${local.region_code}"
  vnet_name           = "vnet-${var.prefix}-${var.environment}-${local.region_code}"
  bastion_name        = "bas-${var.prefix}-${var.environment}-${local.region_code}"
  nat_gateway_name    = "ng-${var.prefix}-${var.environment}-${local.region_code}"

  # Common Tags
  common_tags = merge(
    var.tags,
    {
      Environment = var.environment
      ManagedBy   = "Terraform"
      Project     = var.prefix
      DeployedAt  = timestamp()
    }
  )

  # Cloud-Init Script Base64
  cloud_init_base64 = base64encode(file("${path.module}/scripts/cloud-init.yaml"))
}
