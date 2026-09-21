output "azurerm_public_ip" {
  description = "map of public ip for resource_id"

  value = {


    for key, pip in azurerm_public_ip.dev-environment :
    key => pip.id
  }

}