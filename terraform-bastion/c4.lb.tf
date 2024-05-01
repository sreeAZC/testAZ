#create a public ip 
resource "azurerm_public_ip" "web_lb_public_ip" {
  name                = "${local.resource_name_prefix}-lbpublicip"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  allocation_method   = "Static"
  sku                 = "Standard"
  tags                = local.common_tags
}

##we will create the lb 
resource "azurerm_lb" "web_lb" {
  name                = "${local.resource_name_prefix}-lb"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  sku                 = "Standard"
  #to attach the public ip with lb we will provide the publci ip configuration in 
  frontend_ip_configuration {
    name                 = "web-lb-publicip"
    public_ip_address_id = azurerm_public_ip.web_lb_public_ip.id
  }
}

#target group backend address pool 
resource "azurerm_lb_backend_address_pool" "web_lb_backend_address_pool" {
  name            = "web-backend"
  loadbalancer_id = azurerm_lb.web_lb.id
}

#healtch check 
resource "azurerm_lb_probe" "web_lb_probe" {
  name            = "tcp-probe"
  protocol        = "Tcp"
  port            = 80
  loadbalancer_id = azurerm_lb.web_lb.id
}

#load balancer rule 
resource "azurerm_lb_rule" "web_lb_rule_app1" {
  name                           = "web-app-rule1"
  protocol                       = "Tcp"
  frontend_port                  = 80
  backend_port                   = 80
  frontend_ip_configuration_name = azurerm_lb.web_lb.frontend_ip_configuration[0].name
  backend_address_pool_ids       = [azurerm_lb_backend_address_pool.web_lb_backend_address_pool.id]
  probe_id                       = azurerm_lb_probe.web_lb_probe.id
  loadbalancer_id                = azurerm_lb.web_lb.id
}

#finally associate the nic behiond your lb 
resource "azurerm_network_interface_backend_address_pool_association" "web_nic_lb_associate" {
  for_each                = var.web_linux_vm_instance_count
  network_interface_id    = azurerm_network_interface.web_linux_nic[each.key].id
  ip_configuration_name   = azurerm_network_interface.web_linux_nic[each.key].ip_configuration[0].name
  backend_address_pool_id = azurerm_lb_backend_address_pool.web_lb_backend_address_pool.id
}