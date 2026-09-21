module "resource_group" {

  source   = "../../modules/azurerm_resource_group"
  RG       = var.RG
  location = var.location
  tags     = var.tags

}


module "Virtual_Network" {
  depends_on    = [module.resource_group]
  source        = "../../modules/azurerm_virtual_network"
  RG            = module.resource_group.azurerm_resource_group_name
  VNET          = var.VNET
  location      = var.location
  address_space = var.address_space
  tags          = var.tags
}


module "subnet" {
  depends_on = [module.Virtual_Network]

  source  = "../../modules/azurerm_subnet"
  SUBNETS = var.SUBNETS

}




module "public_ip_address_id" {

  depends_on = [module.resource_group]
  source     = "../../modules/azurerm_public_ip"
  dev_pip    = var.dev_pip

}

module "nic_card" {

  depends_on = [module.subnet]
  source     = "../../modules/azurerm_network_interface"
  RG         = var.RG
  location   = var.location
  NICCARDS = {
    frontend = {
      nic_name            = var.NICCARDS["frontend"].nic_name
      location            = var.NICCARDS["frontend"].location
      resource_group_name = var.NICCARDS["frontend"].resource_group_name
      subnet_id           = module.subnet.subnetblock_id["subnet2"]




    }


    backend = {

      nic_name            = var.NICCARDS["backend"].nic_name
      location            = var.NICCARDS["backend"].location
      resource_group_name = var.NICCARDS["backend"].resource_group_name
      subnet_id           = module.subnet.subnetblock_id["subnet3"]



    }


  }



}








