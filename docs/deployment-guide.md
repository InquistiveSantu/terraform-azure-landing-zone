# Deployment Guide

This guide documents how to deploy the current implementation of the Azure Landing Zone using Terraform. All steps reflect what is **currently implemented** in the repository.

---

## Prerequisites

Before deploying, ensure the following are in place:

| Requirement | Details |
|---|---|
| Terraform | Version `>= 1.x` |
| Azure CLI | Authenticated via `az login` |
| Azure Subscription | With Contributor or Owner role |
| Remote State Storage | `state0files0stg0dev123` (must already exist in Azure) |

---

## Remote State Backend

Terraform state is stored remotely in Azure Blob Storage. This must be pre-created before running `terraform init`.

```hcl
# environments/dev/backend.tf
backend "azurerm" {
  resource_group_name  = "rg-dev-Landing-Zone-project-1"
  storage_account_name = "state0files0stg0dev123"
  container_name       = "devtfstate"
  key                  = "dev.tfstate"
}
```

> **Note:** The state storage account (`rg-dev-Landing-Zone-project-1`) is separate from the landing zone resource group (`rg-dev-landingzone-ci-01`).

---

## Deployment Steps — Dev Environment

### 1. Clone the Repository

```bash
git clone <repository-url>
cd terraform-azure-landing-zone/environments/dev
```

### 2. Authenticate to Azure

```bash
az login
az account set --subscription "<your-subscription-id>"
```

### 3. Initialise Terraform

```bash
terraform init
```

This connects to the remote state backend in Azure Blob Storage.

### 4. Review the Plan

```bash
terraform plan -var-file="terraform.tfvars"
```

Review the plan output carefully. The plan will provision the following resources:

| Resource Type | Name |
|---|---|
| `azurerm_resource_group` | `rg-dev-landingzone-ci-01` |
| `azurerm_virtual_network` | `vnet-dev-landingzone-ci-01` |
| `azurerm_subnet` (×3) | `AzureBastionSubnet`, `snet-dev-frontend-ci-01`, `snet-dev-backend-ci-01` |
| `azurerm_public_ip` (×2) | `pip-bastion`, `pip-nat-gateway` |
| `azurerm_network_interface` (×2) | `nic-dev-frontend-ci-01`, `nic-dev-backend-ci-01` |

### 5. Apply

```bash
terraform apply -var-file="terraform.tfvars"
```

Type `yes` when prompted to confirm.

### 6. Verify Outputs

After apply, verify the subnet IDs and public IP outputs:

```bash
terraform output subnet_id
terraform output azurerm_public_ip
```

> **Note:** The NIC output (`nic_card`) is currently commented out in `outputs.tf` and is not displayed after apply.

---

## What Gets Deployed

### Resource Group

```
rg-dev-landingzone-ci-01 | Central India
```

### Virtual Network

```
vnet-dev-landingzone-ci-01 | 10.10.0.0/16
```

### Subnets

```
AzureBastionSubnet       10.10.4.0/26   (Reserved — Bastion not yet deployed)
snet-dev-frontend-ci-01  10.10.1.0/24   (Frontend)
snet-dev-backend-ci-01   10.10.2.0/24   (Backend)
```

### Network Interfaces

```
nic-dev-frontend-ci-01
  IP Config : internal
  Subnet    : snet-dev-frontend-ci-01
  Private IP: Dynamic
  Public IP : None

nic-dev-backend-ci-01
  IP Config : internal
  Subnet    : snet-dev-backend-ci-01
  Private IP: Dynamic
  Public IP : None
```

### Public IPs (Reserved — Not Yet Attached)

```
pip-bastion      | Static | (Reserved for Azure Bastion)
pip-nat-gateway  | Static | (Reserved for NAT Gateway)
```

---

## Module Dependency Flow

```
terraform.tfvars
      │
      ▼
environments/dev/main.tf
      │
      ├──► module.resource_group
      │         azurerm_resource_group.rg
      │
      ├──► module.Virtual_Network          (depends_on: resource_group)
      │         azurerm_virtual_network.vnet
      │
      ├──► module.subnet                   (depends_on: Virtual_Network)
      │         azurerm_subnet.subnet_dev  (for_each)
      │         output: subnetblock_id
      │
      ├──► module.public_ip_address_id     (depends_on: resource_group)
      │         azurerm_public_ip.dev-environment (for_each)
      │
      └──► module.nic_card                 (depends_on: subnet)
                azurerm_network_interface.dev-nic (for_each)
                frontend subnet_id ◄── module.subnet.subnetblock_id["subnet2"]
                backend  subnet_id ◄── module.subnet.subnetblock_id["subnet3"]
```

---

## Destroy

To tear down all resources:

```bash
terraform destroy -var-file="terraform.tfvars"
```

> ⚠️ This will remove all resources. Ensure you have reviewed and confirmed before running in any environment.

---

## What Is NOT Yet Deployed

The following are planned but not yet implemented in Terraform code:

- Linux Virtual Machines (Frontend and Backend)
- Azure Bastion (will use `pip-bastion` once deployed)
- NAT Gateway (will use `pip-nat-gateway` once deployed)
- Network Security Groups
- Azure Key Vault
- Storage Account
- Log Analytics Workspace
- Azure Monitor
- Azure Database for PostgreSQL Flexible Server

---

## Tags Applied to All Resources

```hcl
tags = {
  Environment = "Development"
  Project     = "Azure Landing Zone"
  ManagedBy   = "Terraform"
  Owner       = "Santu Paira"
}
```