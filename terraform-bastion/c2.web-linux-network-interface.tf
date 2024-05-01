resource "azurerm_network_interface" "web_linux_nic" {
  for_each            = var.web_linux_vm_instance_count
  name                = "${local.resource_name_prefix}-web-linux-nic-${each.key}"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  ip_configuration {
    name                          = "web-linuxip-1"
    subnet_id                     = azurerm_subnet.websubnet.id
    private_ip_address_allocation = "Dynamic"
  }
}