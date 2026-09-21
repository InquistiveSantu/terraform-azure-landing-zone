output "subnet_id" {

  description = "subnet id created in dev enviourment"

  value = module.subnet.subnetblock_id

}


output "azurerm_public_ip" {
  description = "map of public ip for resource_id"

  value = module.public_ip_address_id.azurerm_public_ip


}






# output "nic_card" {

#     description = "nic id display"
#     value = module.nic_card.nic_card_dev

# }

