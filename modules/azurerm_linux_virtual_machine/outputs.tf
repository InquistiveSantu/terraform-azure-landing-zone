output "vm_ids" {

  description = "Map of Linux virtual machine IDs"

  value = {
    for key, vm in azurerm_linux_virtual_machine.vms :
    key => vm.id
  }
}