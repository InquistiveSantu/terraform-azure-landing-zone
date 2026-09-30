variable "vms" {

  description = "Linux Virtual Machine configuration"

  type = map(object({
    vm_name              = string
    resource_group_name  = string
    location             = string
    vm_size              = string
    admin_username       = string
    admin_password       = string
    network_interface_id = string
  }))
}










