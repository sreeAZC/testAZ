resource "azurerm_linux_virtual_machine" "web_linuxvm" {
  for_each              = var.web_linux_vm_instance_count
  name                  = "${local.resource_name_prefix}-web-linux-${each.key}"
  resource_group_name   = azurerm_resource_group.rg.name
  location              = azurerm_resource_group.rg.location
  size                  = "Standard_DS1_v2"
  admin_username        = "azureuser"
  network_interface_ids = [azurerm_network_interface.web_linux_nic[each.key].id]
  admin_ssh_key {
    username   = "azureuser"
    public_key = file("${path.module}/ssh-key/terraform-azure.pub")
  }
  os_disk {
    name                 = "disk-${each.key}"
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }
  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts"
    version   = "latest"
  }
  custom_data = filebase64("${path.module}/app/app.sh")
}