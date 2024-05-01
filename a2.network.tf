##3create a vnet
resource "azurerm_virtual_network" "myvnet" {
  name                = "${var.business_unit}-${var.environment}-${var.virtual_network_name}"
  location            = azurerm_resource_group.myrg1.location
  resource_group_name = azurerm_resource_group.myrg1.name
  address_space       = [var.virtual_network_address_space[0]]
  #address_space       = var.virtual_network_address_space
  # dns_servers         = ["10.0.0.4", "10.0.0.5"]
 lifecycle {
   ignore_changes = [ tags, ]
 }
  tags = {
    environment = "Production"
  }
  ##3lifecycle policy
  /*lifecycle {
    create_before_destroy = true 
  }*/
}
#create subnet
resource "azurerm_subnet" "mysubnet" {
  name                = "${azurerm_virtual_network.myvnet.name}-${var.subnet_name}"
  resource_group_name = azurerm_resource_group.myrg1.name
  ###the subnet need to be inside vnet
  virtual_network_name = azurerm_virtual_network.myvnet.name
  address_prefixes     = ["10.0.1.0/24"] #@i can attach 256 host. 

}
##create public ip
resource "azurerm_public_ip" "mypublicip" {
  ###add an explicit dependency to have this resource created only after vnet and subnet resource are created
  ##terraform have an metqa argument called as dependson
  ###in depends on the format will be resource and resource ref
  ##3count is an meta argument
  ###count need to do iteration
  for_each            = toset(["vm1"])
  depends_on          = [azurerm_virtual_network.myvnet, azurerm_subnet.mysubnet]
  name                = "mypublicip-1-${each.key}"
  resource_group_name = azurerm_resource_group.myrg1.name
  location            = azurerm_resource_group.myrg1.location
  allocation_method   = "Static" ##dynamic
  domain_name_label   = "app1-vm-${each.key}-${random_string.random.id}"

  tags = {
    environment = "Production"
  }
}
##create network interface
resource "azurerm_network_interface" "example" {
  for_each            = toset(["vm1"])
  name                = "example-nic-${each.key}"
  location            = azurerm_resource_group.myrg1.location
  resource_group_name = azurerm_resource_group.myrg1.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.mysubnet.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.mypublicip[each.key].id
    ##nic card will also have an public ip
  }
}