# Project Overview

## Objective

Build a production-ready Azure Landing Zone using reusable Terraform modules following Infrastructure as Code (IaC) best practices. The landing zone provides a secure, scalable foundation for hosting cloud-native workloads on Microsoft Azure.

---

## Architecture Summary

The landing zone is built around a hub-and-spoke network topology. The current implementation covers the core networking layer — resource group, virtual network, subnets, and network interfaces for frontend and backend Linux VMs.

| Layer | Status |
|---|---|
| Resource Group | ✅ Implemented |
| Virtual Network | ✅ Implemented |
| Subnets | ✅ Implemented |
| Public IP (Bastion/NAT reserved) | ✅ Implemented |
| Network Interfaces | ✅ Implemented |
| Linux Virtual Machines | ⏳ Pending |
| Azure Bastion | ⏳ Pending |
| NAT Gateway | ⏳ Pending |
| NSG | ⏳ Pending |
| Load Balancer | ⏳ Pending |
| Database (PostgreSQL Flexible Server) | ⏳ Planned (replaces PostgreSQL VM) |
| Monitoring | ⏳ Pending |
| CI/CD Pipeline | ⏳ Pending |

---

## Current Implementation — Networking Layer

### Resource Group

- **Name:** `rg-dev-landingzone-ci-01`
- **Region:** Central India
- **Managed by:** Terraform module `azurerm_resource_group`

### Virtual Network

- **Name:** `vnet-dev-landingzone-ci-01`
- **CIDR:** `10.10.0.0/16`
- **Region:** Central India

### Subnets (provisioned via `for_each`)

| Subnet | Name | CIDR |
|---|---|---|
| `subnet1` | `AzureBastionSubnet` | `10.10.4.0/26` |
| `subnet2` | `snet-dev-frontend-ci-01` | `10.10.1.0/24` |
| `subnet3` | `snet-dev-backend-ci-01` | `10.10.2.0/24` |

### Network Interfaces

Two NICs are provisioned using the `azurerm_network_interface` module with `for_each`:

| NIC | Name | IP Config Name | IP Allocation | Public IP |
|---|---|---|---|---|
| Frontend | `nic-dev-frontend-ci-01` | `internal` | Dynamic | None |
| Backend | `nic-dev-backend-ci-01` | `internal` | Dynamic | None |

- The NIC module receives subnet IDs from the subnet module output (`subnetblock_id`)
- `frontend` NIC is attached to `subnet2` (`snet-dev-frontend-ci-01`)
- `backend` NIC is attached to `subnet3` (`snet-dev-backend-ci-01`)
- No public IP is attached to either NIC
- Private IP allocation is Dynamic (Azure assigns on deployment)

### Public IP Module

The Public IP module is provisioned and holds two PIPs reserved for future use:

| Name | Allocation | Purpose |
|---|---|---|
| `pip-bastion` | Static | Reserved for Azure Bastion (not yet attached) |
| `pip-nat-gateway` | Static | Reserved for NAT Gateway (not yet attached) |

These PIPs are **not attached** to any NIC or frontend/backend VM.

---

## Architecture Decision — Database Layer

PostgreSQL Linux VM has been **removed** from the architecture.  
The database layer will use **Azure Database for PostgreSQL Flexible Server** in a future sprint. This is a managed PaaS service that eliminates the need for a VM-based database.

---

## Sprint History

### Sprint 1 — Foundation
- Repository structure
- Initial architecture diagram
- Resource Group module

### Sprint 2 — Networking Layer (Current)
- Virtual Network module
- Subnet module (`for_each`)
- Public IP module (reserved for Bastion/NAT)
- Network Interface module (Frontend + Backend NICs, dynamic private IP, no public IP)

### Sprint 3 — Compute (Upcoming)
- Frontend Linux VM
- Backend Linux VM
- NSG rules for subnet security

### Sprint 4 — Access & Security (Upcoming)
- Azure Bastion (private VM access)
- NAT Gateway (outbound internet for private VMs)
- Azure Key Vault

### Sprint 5 — Observability & Pipeline (Upcoming)
- Log Analytics Workspace
- Azure Monitor
- Azure DevOps CI/CD Pipeline

---

## Terraform State

Remote state is stored in Azure Blob Storage:

| Property | Value |
|---|---|
| Storage Account | `state0files0stg0dev123` |
| Container | `devtfstate` |
| Key | `dev.tfstate` |
| Resource Group | `rg-dev-Landing-Zone-project-1` |

---

## Technology Stack

| Tool | Role |
|---|---|
| Terraform | Infrastructure as Code |
| AzureRM Provider `5.0.1` | Azure resource provisioning |
| Azure Blob Storage | Remote Terraform state backend |
| Azure CLI | Authentication |
| Azure DevOps | CI/CD (planned) |