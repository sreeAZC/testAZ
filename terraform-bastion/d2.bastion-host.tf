resource "azurerm_public_ip" "bastion_host_public_ip" {
  name                = "${local.resource_name_prefix}-bastion-publicip"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  allocation_method   = "Static"
  sku                 = "Standard" #specific to region
  #"stock keeping unit"
}
#bastion network interface
resource "azurerm_network_interface" "bastion_linux_nic" {
  name                = "${local.resource_name_prefix}-bastion-linux-nic"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  ip_configuration {
    name                          = "bastioninternal"
    subnet_id                     = azurerm_subnet.bastionsubnet.id
  private_ip_address_allocation  = "Dynamic"
    public_ip_address_id = azurerm_public_ip.bastion_host_public_ip.id 
  }
}

#bastion linux virtual machine 
resource "azurerm_linux_virtual_machine" "bastion_linuxvm" {
  
  name                  = "${local.resource_name_prefix}-bastion-linuxvm"
  resource_group_name   = azurerm_resource_group.rg.name
  location              = azurerm_resource_group.rg.location
  size                  = "Standard_DS1_v2"
  admin_username        = "azureuser"
  network_interface_ids = [azurerm_network_interface.bastion_linux_nic.id]
  admin_ssh_key {
    username   = "azureuser"
    public_key = file("${path.module}/ssh-key/terraform-azure.pub")
  }
  os_disk {
    name                 = "diskbas"
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }
  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts"
    version   = "latest"
  }
  #ustom_data = filebase64("${path.module}/app/app.sh")
}


