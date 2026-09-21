resource "azurerm_network_interface" "dev-nic" {
  for_each            = var.NICCARDS
  name                = each.value.nic_name
  location            = var.location
  resource_group_name = var.RG


  ip_configuration {
    name                          = "internal"
    subnet_id                     = each.value.subnet_id
    private_ip_address_allocation = "Dynamic"
  }

}