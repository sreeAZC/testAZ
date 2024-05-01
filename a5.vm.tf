resource "azurerm_linux_virtual_machine" "mylinuxvm" {

  for_each            = toset(["vm1"])
  name                = "mylinuxvm-1-${each.key}"
  resource_group_name = "${var.business_unit}-${var.environment}-${var.resource_group_name}"
  location            = var.resource_group_location
  #size                = "Standard_DS1_v2"
  size                = lookup(var.instance_size, var.resource_group_location)
  admin_username      = "azureuser"
  ###splat operator using element
  ##count index is the length function 
  network_interface_ids = [azurerm_network_interface.example[each.key].id]
  admin_ssh_key {
    username = "azureuser"
    ##3root of the user directory
    public_key = file("${path.module}/ssh-key/terraform-azure.pub")
  }
  os_disk {
    name                 = "osdisk-${each.key}"
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }
  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts-gen2"
    version   = "latest"
  }
  custom_data = filebase64("${path.module}/app/app.sh")
  
}