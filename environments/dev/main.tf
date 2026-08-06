module "resource_group" {

  source   = "../../modules/azurerm_resource_group"
  RG       = var.RG
  location = var.location
  tags     = var.tags

}