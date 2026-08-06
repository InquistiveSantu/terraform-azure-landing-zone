module "resource_group" {

  source   = "../../modules/azurerm_resource_group"
  RG       = var.RG
  location = var.location
  tags     = var.tags

}


module "Virtual_Network" {
  source        = "../../modules/azurerm_virtual_network"
  RG  = module.resource_group.azurerm_resource_group_name
  VNET          = var.VNET
  location      = var.location
  address_space = var.address_space
  tags          = var.tags
}