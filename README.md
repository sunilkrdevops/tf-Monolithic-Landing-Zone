# Azure Enterprise Landing Zone (Terraform)

A production-ready, highly secure, modular Azure Landing Zone built with **Terraform**. This Landing Zone follows the **Microsoft Cloud Adoption Framework (CAF)** naming conventions and implements a modern multi-tier cloud topology.

---

## 📐 Architecture Overview

The architecture enforces strict network isolation and zero-trust principles:

```
                                  +---------------------------------------------------+
                                  |                 AZURE SUBSCRIPTION                |
                                  +---------------------------------------------------+
                                                           |
                                 +---------------------------------------------------+
                                 |         Resource Group: rg-alz-prod-cin           |
                                 +---------------------------------------------------+
                                                           |
                                 +---------------------------------------------------+
                                 |       Virtual Network: vnet-alz-prod-cin          |
                                 |                  (10.0.0.0/16)                    |
                                 +---------------------------------------------------+
                                           |               |               |
                    +----------------------+               |               +----------------------+
                    |                                      |                                      |
                    v                                      v                                      v
  +-----------------------------------+  +-----------------------------------+  +-----------------------------------+
  |    Subnet: AzureBastionSubnet     |  |       Subnet: snet-frontend       |  |        Subnet: snet-backend       |
  |           (10.0.3.0/27)           |  |           (10.0.1.0/24)           |  |           (10.0.2.0/24)           |
  +-----------------------------------+  +-----------------------------------+  +-----------------------------------+
  | • Azure Bastion Host (Standard)   |  | • NSG: nsg-frontend-prod          |  | • NSG: nsg-backend-prod           |
  | • Public IP: pip-bastion-prod     |  |   - Allow HTTP/HTTPS Inbound      |  |   - Allow HTTP from Frontend      |
  | • Enables secure SSH to workloads |  |   - Allow SSH ONLY from Bastion   |  |   - Allow SSH ONLY from Bastion   |
  +-----------------------------------+  |   - Deny Direct Internet SSH      |  |   - Deny All Direct Internet In    |
                                         | • Frontend VM (vm-frontend-prod)   |  | • Backend VM (vm-backend-prod)    |
                                         | • Cloud-Init Provisioned          |  | • Cloud-Init Provisioned          |
                                         +-----------------------------------+  +-----------------------------------+
                                                                                                  |
                                                                                                  v
                                                                                +-----------------------------------+
                                                                                |            NAT Gateway            |
                                                                                |         (ng-alz-prod-cin)         |
                                                                                +-----------------------------------+
                                                                                | • Public IP: pip-natgw-prod       |
                                                                                | • Secure Outbound Internet Egress |
                                                                                +-----------------------------------+

  +-----------------------------------------------------------------------------------------------------------------+
  | Optional Infrastructure: Azure Key Vault (kv-alz-prod-XXXXXX) with RBAC & Purge Protection                     |
  +-----------------------------------------------------------------------------------------------------------------+
```

### Key Highlights

- **CAF Naming Standards**: Standardized naming across all resources using regional location codes (e.g., `rg-alz-prod-cin` for Central India).
- **Multi-Tier Network Isolation**: Distinct Frontend and Backend subnets protected by granular Network Security Groups (NSGs).
- **Zero Public IP Exposure on Compute**: VMs have no public IP addresses assigned. Access is brokered exclusively through Azure Bastion.
- **Secure Internet Egress**: Backend workload egress is routed through an Azure NAT Gateway.
- **Automated VM Bootstrap**: Cloud-Init configuration (`scripts/cloud-init.yaml`) handles VM initialization upon deployment.
- **Secrets Management**: Integrated Azure Key Vault for central management of credentials and keys.

---

## 📁 Repository Structure

```
.
├── main.tf                  # Main Terraform orchestration file
├── variables.tf             # Global input variable definitions
├── outputs.tf               # Terraform output values
├── locals.tf                # CAF region mapping, standard names, and tags
├── provider.tf              # AzureRM provider & backend configuration
├── terraform.tfvars.example # Sample variable configurations
├── scripts/
│   └── cloud-init.yaml      # VM initialization script
└── modules/                 # Modular Terraform components
    ├── bastion/             # Azure Bastion module
    ├── key_vault/           # Azure Key Vault module
    ├── nat_gateway/         # Azure NAT Gateway module
    ├── network_interface/   # Network Interface Card (NIC) module
    ├── network_security_group/ # NSG and Security Rules module
    ├── public_ip/           # Public IP Address module
    ├── resource_group/      # Resource Group module
    ├── subnet/              # Subnet module (dynamic map support)
    ├── virtual_machine/     # Linux VM module
    └── virtual_network/     # Virtual Network (VNet) module
```

---

## ⚙️ Prerequisites

Before deploying this Landing Zone, make sure you have:

1. **Terraform CLI**: `v1.5.0` or higher ([Download](https://developer.hashicorp.com/terraform/downloads))
2. **Azure CLI**: `v2.40.0` or higher ([Install Guide](https://learn.microsoft.com/en-us/cli/azure/install-azure-cli))
3. **Active Azure Subscription** with `Contributor` or `Owner` privileges.

---

## 🚀 Quick Start

### 1. Authenticate to Azure

```bash
az login
az account set --subscription "YOUR_SUBSCRIPTION_ID"
```

### 2. Configure Environment Variables

Copy the example variable file and adjust parameters according to your environment:

```bash
cp terraform.tfvars.example terraform.tfvars
```

Update `terraform.tfvars` with your secure credentials and environment settings:

```hcl
prefix            = "alz"
environment       = "prod"
location          = "centralindia"
vm_admin_username = "azureadmin"
vm_admin_password = "YourSecurePassword123!#"
enable_key_vault  = true
```

### 3. Initialize Terraform

Download required provider plugins and initialize modules:

```bash
terraform init
```

### 4. Review Execution Plan

Inspect the resources that will be provisioned:

```bash
terraform plan
```

### 5. Deploy Infrastructure

Apply the plan to provision the Azure Landing Zone:

```bash
terraform apply -auto-approve
```

---

## 🎛️ Input Variables

| Variable Name | Type | Default | Description |
| :--- | :--- | :--- | :--- |
| `prefix` | `string` | `"alz"` | Project prefix used for resource naming conventions. |
| `environment` | `string` | `"prod"` | Target deployment environment (`dev`, `staging`, `prod`). |
| `location` | `string` | `"centralindia"` | Primary Azure Region for resource deployment. |
| `vnet_cidr` | `list(string)` | `["10.0.0.0/16"]` | Address space allocated to the Virtual Network. |
| `frontend_subnet_cidr` | `list(string)` | `["10.0.1.0/24"]` | Address prefix for the Frontend Subnet. |
| `backend_subnet_cidr` | `list(string)` | `["10.0.2.0/24"]` | Address prefix for the Backend Subnet. |
| `bastion_subnet_cidr` | `list(string)` | `["10.0.3.0/27"]` | Address prefix for `AzureBastionSubnet` (Min `/27`). |
| `vm_admin_username` | `string` | `"azureuser"` | Administrator username for Linux VMs. |
| `vm_admin_password` | `string` | `sensitive` | Administrator password for Linux VMs. |
| `vm_size` | `string` | `"Standard_B2s"` | SKU size for Linux Virtual Machines. |
| `ssh_public_key` | `string` | `null` | Optional SSH Public Key string for VM authentication. |
| `enable_key_vault` | `bool` | `true` | Controls whether Azure Key Vault is provisioned. |
| `tags` | `map(string)` | `{ Owner = "...", ... }` | Resource tags applied to all deployed resources. |

---

## 📤 Output Values

| Output Name | Description |
| :--- | :--- |
| `resource_group_name` | Name of the provisioned Azure Resource Group. |
| `resource_group_id` | Resource ID of the provisioned Resource Group. |
| `vnet_id` | Resource ID of the Virtual Network. |
| `vnet_name` | Name of the Virtual Network. |
| `subnet_ids` | Map of all created Subnet names to Subnet IDs. |
| `bastion_public_ip` | Public IP address assigned to Azure Bastion host. |
| `nat_gateway_public_ip` | Public IP address assigned to NAT Gateway for outbound egress. |
| `bastion_dns_name` | Fully Qualified Domain Name (FQDN) of Azure Bastion. |
| `frontend_vm_private_ip` | Private IP address of Frontend Virtual Machine. |
| `backend_vm_private_ip` | Private IP address of Backend Virtual Machine. |
| `key_vault_uri` | Vault URI of the created Azure Key Vault (if enabled). |

---

## 🔒 Security Best Practices Implemented

1. **No Public IPs on Workload VMs**: VMs are isolated in private subnets and accessed via Azure Bastion host using native SSH tunneling over TLS.
2. **Network Security Groups (NSGs)**:
   - Direct inbound SSH from the Internet is explicitly **denied**.
   - SSH access is allowed **strictly** from the `AzureBastionSubnet` CIDR block.
   - Backend workloads reject all inbound traffic from the public Internet.
3. **Azure Key Vault**: Configured with `purge_soft_delete_on_destroy` and unique naming for secrets safety.
4. **Sensitive Data Protection**: Passwords and keys are marked as `sensitive` in Terraform variable declarations to avoid exposure in console output.

---

## 🧹 Cleanup / Teardown

To destroy all provisioned infrastructure and release cloud resources:

```bash
terraform destroy -auto-approve
```

---

## 📝 License

This infrastructure code is maintained for enterprise cloud deployment standards and DevOps best practices.
