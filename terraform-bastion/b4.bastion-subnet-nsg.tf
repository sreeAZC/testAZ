#create a webtier subnet 
resource "azurerm_subnet" "bastionsubnet" {
  name                 = "${azurerm_virtual_network.vnet.name}-${var.bastion_subnet_name}"
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = var.bastion_subnet_address
}

##we will create an nsg
resource "azurerm_network_security_group" "bastion_subnet_nsg" {
  name                = "${azurerm_virtual_network.vnet.name}-bastion"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
}
#subnet and nsg are two individual resource

#we need to associate nsg with subnet
#to map this two individual resource
resource "azurerm_subnet_network_security_group_association" "bastion_subnet_nsg_associate" {
  subnet_id                 = azurerm_subnet.bastionsubnet.id
  network_security_group_id = azurerm_network_security_group.bastion_subnet_nsg.id
}

##we need to create nsg rule 
locals {
  bastion_inbound_port_map = {
    "110" : "22",
    "120" : "3389"
  }
}

#when we create an nsg rule we need to provide two things one is priority and port number

resource "azurerm_network_security_rule" "bastion_nsg_rule_inbound" {
  for_each                    = local.bastion_inbound_port_map #toset
  name                        = "Rule-Port-${each.value}"      #rule-port-80
  priority                    = each.key                       #110
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = each.value #
  source_address_prefix       = "*"
  destination_address_prefix  = "*"
  resource_group_name         = azurerm_resource_group.rg.name
  network_security_group_name = azurerm_network_security_group.bastion_subnet_nsg.name
}