output "azurerm_resource_group_id" {
  description = "id of the resource group"
  value       = azurerm_resource_group.rg.id
}



output "azurerm_resource_group_name" {
  description = "Name of the resource group"

  value = azurerm_resource_group.rg.name
}


output "azurerm_resource_group_location" {

  description = "location of the resource group"

  value = azurerm_resource_group.rg.location

}