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
      public_ip_id = module.public_ip_address_id.azurerm_public_ip[
        var.NICCARDS["frontend"].public_ip_key
      ]




    }


    backend = {

      nic_name            = var.NICCARDS["backend"].nic_name
      location            = var.NICCARDS["backend"].location
      resource_group_name = var.NICCARDS["backend"].resource_group_name
      subnet_id           = module.subnet.subnetblock_id["subnet3"]
      public_ip_id = module.public_ip_address_id.azurerm_public_ip[
        var.NICCARDS["backend"].public_ip_key
      ]
    }
  }



}












module "nsg" {
  depends_on = [module.resource_group]

  source = "../../modules/azurerm_network_security_group"

  NSGS = var.NSGS

 NIC_NSG_ASSOCIATIONS = {
  frontend = {
    network_interface_id = module.nic_card.nic_card_dev["frontend"]
    nsg_key              = "frontend"
  }

  backend = {
    network_interface_id = module.nic_card.nic_card_dev["backend"]
    nsg_key              = "backend"
  }
}
}




module "vms" {
  depends_on = [module.subnet, module.public_ip_address_id]
  source     = "../../modules/azurerm_linux_virtual_machine"

  vms = {

    vm1 = {
      vm_name             = var.vms["vm1"].vm_name
      resource_group_name = var.vms["vm1"].resource_group_name
      location            = var.vms["vm1"].location
      vm_size             = var.vms["vm1"].vm_size
      admin_username      = var.vms["vm1"].admin_username
      admin_password      = var.vms["vm1"].admin_password

      network_interface_id = module.nic_card.nic_card_dev["frontend"]
    }

    vm2 = {
      vm_name             = var.vms["vm2"].vm_name
      resource_group_name = var.vms["vm2"].resource_group_name
      location            = var.vms["vm2"].location
      vm_size             = var.vms["vm2"].vm_size
      admin_username      = var.vms["vm2"].admin_username
      admin_password      = var.vms["vm2"].admin_password

      network_interface_id = module.nic_card.nic_card_dev["backend"]
    }
  }
}


module "postgressql" {
  depends_on         =[module.resource_group,module.subnet]
  source             = "../../modules/azurerm_postgres_flexible_server"
  postgresql_servers = var.postgresql_servers
}
















