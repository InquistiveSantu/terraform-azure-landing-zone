resource "azurerm_virtual_network" "vnet" {
  name                = var.VNET
  location            = var.location
  resource_group_name = var.RG
  address_space       = var.address_space
  tags                = var.tags

}