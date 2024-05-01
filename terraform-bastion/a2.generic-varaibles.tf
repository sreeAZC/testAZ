#generic input varabiles
variable "business_division" {
  description = "business devision in large organization"
  type        = string #list of string #map
  default     = "sap"
}

variable "environment" {
  description = "environment for test"
  type        = string #list of string #map
  default     = "dev"
}

variable "resource_group_name" {
  type    = string
  default = "rg-default"
  #sap-dev-rg-default
}

variable "resource_group_location" {
  description = "resource group location"
  type        = string
  default     = "eastus"
}