resource "azurerm_resource_group" "rg" {
 name     = var.RG
  location = var.location
  tags     = var.tags
  
}

