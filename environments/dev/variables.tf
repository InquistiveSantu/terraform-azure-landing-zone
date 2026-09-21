variable "RG" {


  description = "Name of the variable resource group"
  type        = string


}

variable "VNET" {

  description = "Craeting One Vnet for LandingZone"
  type        = string

}


variable "address_space" {

  description = "Creating CIDR Range for our all azure resources"
  type        = list(string)
}




variable "location" {


  description = "This is my Azure region Where all resources are created"
  type        = string


}


variable "tags" {
  description = "Common tags applied to all Azure resources."
  type        = map(string)
  default     = {}
}


variable "SUBNETS" {
  
description = "map of subnet configurations"
type = map(object({
  subnet_name = string
  resource_group_name = string
  virtual_network_name = string
  address_prefixes = list(string)
}))


}


variable "NICCARDS" {
  

  description = "Created nic card for frontend,backend and database VM"
  type = map(object({
     nic_name  = string
     location = string
     resource_group_name = string
     subnet_id = string

  }))
}



variable "dev_pip" {

    description = "dev_pip"
  type = map(object({
    name = string
    location = string
    resource_group_name = string
    allocation_method = string
  }))

  
}