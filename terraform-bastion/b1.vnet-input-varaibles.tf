#virtual network
variable "vnet_name" {
  type    = string
  default = "vnet-default"
}

variable "vnet_address_space" {
  type    = list(string)
  default = ["10.0.0.0/16"]
}

#websubnet 
variable "web_subnet_name" {
  type    = string
  default = "websubnet"
}
variable "web_subnet_address" {
  type    = list(string)
  default = ["10.0.1.0/24"]
}

##
variable "bastion_subnet_name" {
  type    = string
  default = "bastionsubnet"
}

variable "bastion_subnet_address" {
  type    = list(string)
  default = ["10.0.100.0/24"]
}
