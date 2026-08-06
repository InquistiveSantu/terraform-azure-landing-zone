variable "VNET" {

  description = "Craeting One Vnet for LandingZone"
  type        = string

}


variable "location" {


  description = "This is my Azure region Where all resources are created"
  type        = string


}

variable "RG" {
  description = "Resource Group Name"
  type        = string
}




variable "address_space" {

  description = "Creating CIDR Range for our all azure resources"
  type        = list(string)
}


variable "tags" {
  description = "Common tags applied to all Azure resources."
  type        = map(string)
  default     = {}
}