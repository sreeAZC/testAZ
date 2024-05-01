resource "azurerm_resource_group" "rg" {
  name     = "${local.resource_name_prefix}-${var.resource_group_name}"
  location = var.resource_group_location #to call a varaible it start with var
  tags     = local.common_tags
}