resource "null_resource" "null_copy_ssh" {
  depends_on = [ azurerm_linux_virtual_machine.bastion_linuxvm ]
  connection {
    type = "ssh" 
    host = azurerm_linux_virtual_machine.bastion_linuxvm.public_ip_address
    user = azurerm_linux_virtual_machine.bastion_linuxvm.admin_username
    private_key = file("${path.module}/ssh-key/terraform-azure.pem")
  }

  ##once i make connection to my server i need to upload the ssh key 
  provisioner "file" {
    source =  "ssh-key/terraform-azure.pem"
    destination = "/tmp/terraform-azure.pem"
  }
  provisioner "remote-exec" {
    inline = [ 
        "sudo chmod 400 /tmp/terraform-azure.pem"
     ]
  }
}