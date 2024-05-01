##using terraform we will create a resource
##the block name is resource what resource i want to create
resource "azurerm_resource_group" "rg" {
  name     = "mynewrg"
  location = "eastus"
}

