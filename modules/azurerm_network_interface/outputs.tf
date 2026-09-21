output "nic_card_dev" {

  description = "Map of network interface card"
  value = {

    for key, nic in azurerm_network_interface.dev-nic :
    key => nic.id
  }

}