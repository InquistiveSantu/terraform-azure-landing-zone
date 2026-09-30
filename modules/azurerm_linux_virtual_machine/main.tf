resource "azurerm_linux_virtual_machine" "vms" {

  for_each = var.vms

  name                = each.value.vm_name
  resource_group_name = each.value.resource_group_name
  location            = each.value.location
  size                = each.value.vm_size

  admin_username = each.value.admin_username

  network_interface_ids = [
    each.value.network_interface_id
  ]

  disable_password_authentication = false

  admin_password = each.value.admin_password

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts"
    version   = "latest"
  }
}