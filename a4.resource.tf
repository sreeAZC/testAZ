resource "azurerm_resource_group" "myrg1" {
  #azurerm_resource_group.myrg1.name
  #azurerm_resource_group.myrg1.location
  #name     = "myrg-1-gopal-1"
  #location = "East US"
  name = "${var.business_unit}-${var.environment}-${var.resource_group_name}"
  location = var.resource_group_location 
}