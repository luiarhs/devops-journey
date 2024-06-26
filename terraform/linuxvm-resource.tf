# Resource: Azure Linux Virtual Machine
resource "azurerm_linux_virtual_machine" "web_linuxvm" {
 name = "${local.resource_name_prefix}-web-linuxvm"
 #computer_name = "web-linux-vm" # Hostname of the VM (Optional)
 resource_group_name = azurerm_resource_group.rg.name
 location = azurerm_resource_group.rg.location 
 size = var.web_linuxvm_size
 admin_username = var.web_linuxvm_admin_user
 network_interface_ids = [ azurerm_network_interface.web_linuxvm_nic.id ]
 admin_ssh_key {
 username = var.web_linuxvm_admin_user
 public_key = file("${path.module}/ssh-keys/terraform-azure.pub")
 }
 os_disk {
 caching = "ReadWrite"
 storage_account_type = "Standard_LRS"
 } 
 source_image_reference {
 publisher = "RedHat"
 offer = "RHEL"
 sku = "83-gen2"
 version = "latest"
 } 
 #custom_data = filebase64("${path.module}/app-scripts/redhat-webvm-script.sh")
 custom_data = base64encode(local.webvm_custom_data)
}

# Declare the local variable 'resource_name_prefix'
locals {
 resource_name_prefix = "my-resource-prefix"
 webvm_custom_data   = file("${path.module}/app-scripts/redhat-webvm-script.sh")
}