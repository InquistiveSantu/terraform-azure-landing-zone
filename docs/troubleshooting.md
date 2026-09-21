# Troubleshooting

Known issues and resolutions encountered during development of the Azure Landing Zone. This document is updated as issues arise.

---

## Terraform & Provider

### Issue: `azurerm_subnet` — subnet already exists on re-apply

**Symptom:**  
`Error: A resource with the ID ... already exists`

**Cause:**  
Subnet was manually created or partially applied before the state was consistent.

**Resolution:**  
Import the existing subnet into Terraform state:
```bash
terraform import 'module.subnet.azurerm_subnet.subnet_dev["subnet2"]' /subscriptions/<sub-id>/resourceGroups/rg-dev-landingzone-ci-01/providers/Microsoft.Network/virtualNetworks/vnet-dev-landingzone-ci-01/subnets/snet-dev-frontend-ci-01
```

---

### Issue: NIC module fails with `subnet_id` not found

**Symptom:**  
`Error: Invalid index` when accessing `module.subnet.subnetblock_id["subnet2"]`

**Cause:**  
The subnet module has not been applied yet, or the `for_each` key does not match what is defined in `terraform.tfvars`.

**Resolution:**  
1. Verify `SUBNETS` keys in `terraform.tfvars` match the keys referenced in `environments/dev/main.tf` (`subnet2`, `subnet3`).
2. Run `terraform apply` targeting the subnet module first:
   ```bash
   terraform apply -target=module.subnet -var-file="terraform.tfvars"
   ```
3. Then apply the full configuration:
   ```bash
   terraform apply -var-file="terraform.tfvars"
   ```

---

### Issue: `terraform init` fails — backend storage account not found

**Symptom:**  
`Error: Failed to get existing workspaces: ... storage account not found`

**Cause:**  
The remote state storage account (`state0files0stg0dev123`) does not exist in `rg-dev-Landing-Zone-project-1`.

**Resolution:**  
Create the storage account and blob container manually before running `terraform init`:
```bash
az group create --name rg-dev-Landing-Zone-project-1 --location centralindia
az storage account create --name state0files0stg0dev123 --resource-group rg-dev-Landing-Zone-project-1 --location centralindia --sku Standard_LRS
az storage container create --name devtfstate --account-name state0files0stg0dev123
```

---

### Issue: Provider version conflict

**Symptom:**  
`Error: Failed to query available provider packages`

**Cause:**  
The `.terraform.lock.hcl` is locked to `azurerm 5.0.1` but a different version is being resolved.

**Resolution:**  
Run:
```bash
terraform init -upgrade
```
Or restore the lock file from git if the version must remain at `5.0.1`.

---

### Issue: `for_each` map value contains sensitive string

**Symptom:**  
Terraform plan shows `(sensitive value)` for NIC `subnet_id`

**Cause:**  
The `subnet_id` from the subnet module output can be marked sensitive in some provider versions.

**Resolution:**  
This is cosmetic and does not affect deployment. The correct subnet ID is still passed through. No action required.

---

## Azure Authentication

### Issue: `az login` fails in headless / CI environment

**Symptom:**  
`ERROR: Please run 'az login' to setup account`

**Cause:**  
No active Azure CLI session or service principal not configured.

**Resolution:**  
For CI/CD, use a service principal with environment variables:
```bash
export ARM_CLIENT_ID="<sp-client-id>"
export ARM_CLIENT_SECRET="<sp-client-secret>"
export ARM_SUBSCRIPTION_ID="<subscription-id>"
export ARM_TENANT_ID="<tenant-id>"
```

---

## Network Interface

### Issue: NIC shows no private IP after `terraform apply`

**Symptom:**  
Azure portal shows NIC with no IP address assigned.

**Cause:**  
Private IP allocation is `Dynamic` — Azure assigns the IP only when the NIC is attached to a running VM.

**Resolution:**  
This is expected behaviour. The IP will be assigned when the Linux VM module is implemented and attached to the NIC. No action required at this stage.

---

### Issue: Attempting to attach Public IP to NIC

**Symptom:**  
Plan or code includes a `public_ip_address_id` reference in the NIC `ip_configuration` block.

**Cause:**  
Incorrect configuration — the frontend and backend NICs are **private only** by design.

**Resolution:**  
Do not set `public_ip_address_id` in the `ip_configuration` block for `nic-dev-frontend-ci-01` or `nic-dev-backend-ci-01`.  
Public IPs (`pip-bastion`, `pip-nat-gateway`) are reserved for Bastion and NAT Gateway only.

---

## Diagram & Documentation

### Issue: `.drawio` file opens corrupted

**Symptom:**  
`azure-landing-zone-architecture.drawio` appears blank or malformed.

**Cause:**  
The file may have been saved incorrectly or there is a backup (`.bkp`) being loaded instead.

**Resolution:**  
Open the file directly in [draw.io](https://app.diagrams.net). The `.bkp` file (`.$azure-landing-zone-architecture.drawio.bkp`) is a draw.io auto-backup and can be ignored.

---

*This document is updated as issues are encountered during development. Last updated: Sprint 2 — Networking Layer.*