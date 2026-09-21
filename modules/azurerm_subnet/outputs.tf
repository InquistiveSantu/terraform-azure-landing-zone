output "subnetblock_id" {

  description = "Here I give output block"
  value = {

    for key, subnet in azurerm_subnet.subnet_dev :
    key => subnet.id
  }
}