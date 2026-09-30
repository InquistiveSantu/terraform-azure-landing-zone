variable "NICCARDS" {


  description = "Created nic card for frontend,backend and database VM"
  type = map(object({
    nic_name            = string
    location            = string
    resource_group_name = string
    subnet_id           = string
    public_ip_id        = string


  }))
}

variable "RG" {


  description = "Name of the variable resource group"
  type        = string


}

variable "location" {


  description = "This is my Azure region Where all resources are created"
  type        = string


}
