variable "business_unit" {
  description = "Business Unit Name"
  type=string #mnumeric string(list)
  default = "hr"
}
variable "environment" {
  description = "environment name"
  type=string #mnumeric string(list)
  default = "dev"
}

variable "resource_group_name" {
  description = "resource group name"
  type=string #mnumeric string(list)
  default = "myrgg"
}

variable "resource_group_location" {
  type = string
  default = "eastus"
}

variable "virtual_network_name" {
  type = string 
  default = "myvnet"
}
variable "subnet_name" {
  description = "virtual network subnet name"
  type = string
  default = "mysubnet"
}
variable "virtual_network_address_space" {
  description = "we will create multiple vnet together"
  type = list(string)
  default = [ "10.0.0.0/16" ]
}

variable "instance_size" {
  description = "Azure instance type"
  type = map(string)
  default = {
    "eastus" = "Standard_D2s_v3",
    "eastus2" = "Standard_D4s_v3"
  }
}