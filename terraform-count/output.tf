output "public_ip_address" {
  description = "this is the public ip of your instance"
  value       = azurerm_linux_virtual_machine.mylinuxvm[*].public_ip_addresses
}