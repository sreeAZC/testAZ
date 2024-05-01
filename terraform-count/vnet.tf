#vnet
resource "azurerm_virtual_network" "myvnet" {
  name          = "myvnet-1"
  address_space = ["10.0.0.0/16"] #cidr
  ##this vnet is part of your resource group
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
}
#subnet
resource "azurerm_subnet" "mysubnet" {
  name                 = "mysubnet-1"
  resource_group_name  = azurerm_resource_group.rg.name      #subnet created in the same resource group
  virtual_network_name = azurerm_virtual_network.myvnet.name #we will map the same in the vnet
  address_prefixes     = ["10.0.1.0/24"]
}

#public ip will be create but i need to attache this public ip with a nic
#when i execute it will create a single resouce means a single public ip
resource "azurerm_public_ip" "mypublicip" {
  count = 2                         #this will create two public ip
  name  = "mypublic-${count.index}" #index value start with 0
  #mypublic-0
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  allocation_method   = "Static"
}


resource "azurerm_network_interface" "myvmnic" {
  count               = 2
  name                = "vmnic-${count.index}"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.mysubnet.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = element(azurerm_public_ip.mypublicip[*].id, count.index)
  }
}