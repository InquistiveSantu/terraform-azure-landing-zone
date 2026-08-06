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