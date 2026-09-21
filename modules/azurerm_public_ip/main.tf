resource "azurerm_public_ip" "dev-environment" {
  for_each            = var.dev_pip
  name                = each.value.name
  resource_group_name = each.value.resource_group_name
  location            = each.value.location
  allocation_method   = each.value.allocation_method
  tags = {
    Environment = "Development"
    ManagedBy   = "Terraform"
  }
}
