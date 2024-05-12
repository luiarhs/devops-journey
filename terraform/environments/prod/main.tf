# Define provider (Azure)
provider "azurerm" {
  features {}
}

# Define resource group
resource "azurerm_resource_group" "main" {
  name     = "my-resource-group"
  location = "East US" # Choose your desired region
}
# Define virtual network named vnet0 with address space 10.9.0.0/16
resource "azurerm_virtual_network" "vnet0" {
  name                = "vnet0"
  address_space       = ["10.9.0.0/16"]
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name
}

# Define subnet for Azure bastion
resource "azurerm_subnet" "azure_bastion_subnet" {
  name                 = "AzureBastionSubnet"
  resource_group_name  = azurerm_resource_group.main.name
  virtual_network_name = azurerm_virtual_network.vnet0.name
  address_prefixes     = ["10.9.0.0/24"]
}

# Define subnet for application
resource "azurerm_subnet" "app_subnet" {
  name                 = "app-subnet"
  resource_group_name  = azurerm_resource_group.main.name
  virtual_network_name = azurerm_virtual_network.vnet0.name
  address_prefixes     = ["10.9.1.0/24"]
}

# Define subnet for database
resource "azurerm_subnet" "db_subnet" {
  name                 = "db-subnet"
  resource_group_name  = azurerm_resource_group.main.name
  virtual_network_name = azurerm_virtual_network.vnet0.name
  address_prefixes     = ["10.9.2.0/24"]
}


# Define virtual network
resource "azurerm_virtual_network" "main" {
  name                = "my-vnet"
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name
}

# Define subnet for bastion host
resource "azurerm_subnet" "bastion_subnet" {
  name                 = "bastion-subnet"
  resource_group_name  = azurerm_resource_group.main.name
  virtual_network_name = azurerm_virtual_network.main.name
  address_prefixes     = ["10.0.1.0/24"]
}

# Define subnet for application and database
resource "azurerm_subnet" "app_db_subnet" {
  name                 = "app-db-subnet"
  resource_group_name  = azurerm_resource_group.main.name
  virtual_network_name = azurerm_virtual_network.main.name
  address_prefixes     = ["10.0.2.0/24"]
}

# Define public IP for bastion host
resource "azurerm_public_ip" "bastion_public_ip" {
  name                = "bastion-public-ip"
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name
  allocation_method   = "Static"
}

# Define network security group for bastion host
resource "azurerm_network_security_group" "bastion_nsg" {
  name                = "bastion-nsg"
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name

  security_rule {
    name                       = "SSH"
    priority                   = 1001
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
}

# Define network interface for bastion host
resource "azurerm_network_interface" "bastion_nic" {
  name                      = "bastion-nic"
  location                  = azurerm_resource_group.main.location
  resource_group_name       = azurerm_resource_group.main.name

  ip_configuration {
    name                          = "bastion-ip-config"
    subnet_id                     = azurerm_subnet.bastion_subnet.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.bastion_public_ip.id
  }
}

# Define virtual machine for bastion host
resource "azurerm_virtual_machine" "bastion_vm" {
  name                  = "bastion-vm"
  location              = azurerm_resource_group.main.location
  resource_group_name   = azurerm_resource_group.main.name
  network_interface_ids = [azurerm_network_interface.bastion_nic.id]
  vm_size               = "Standard_B1s" # Choose your desired VM size
  delete_os_disk_on_termination = true

  storage_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "18.04-LTS"
    version   = "latest"
  }

  storage_os_disk {
    name              = "bastion-os-disk"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Premium_LRS"
  }

  os_profile {
    computer_name  = "bastion-vm"
    admin_username = "azureuser" # Replace with your desired username
  }

  os_profile_linux_config {
    disable_password_authentication = true
    ssh_keys {
      path     = "/home/azureuser/.ssh/authorized_keys"
      key_data = "SSH_PUBLIC_KEY" # Replace with your SSH public key
    }
  }
}

# Define network security group for application and database
resource "azurerm_network_security_group" "app_db_nsg" {
  name                = "app-db-nsg"
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name

  # Define security rules for application
  security_rule {
    name                       = "HTTP"
    priority                   = 1001
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "80"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  # Define security rules for database
  security_rule {
    name                       = "Database"
    priority                   = 1002
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "3306" # Assuming MySQL database
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
}

# Define load balancer
resource "azurerm_lb" "main" {
  name                = "my-load-balancer"
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name
  sku                 = "Standard"
  frontend_ip_configuration {
    name                          = "PublicIPAddress"
    public_ip_address_id          = azurerm_public_ip.lb_public_ip.id
  }
}

# Define public IP for load balancer
resource "azurerm_public_ip" "lb_public_ip" {
  name                = "lb-public-ip"
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name
  allocation_method   = "Static"
}


# Define backend address pool for load balancer
resource "azurerm_lb_backend_address_pool" "main" {
  name                = "backendPool"
  resource_group_name = azurerm_resource_group.main.name
  loadbalancer_id     = azurerm_lb.main.id
}

# Define health probe for load balancer
resource "azurerm_lb_probe" "main" {
  name                = "httpProbe"
  resource_group_name = azurerm_resource_group.main.name
  loadbalancer_id     = azurerm_lb.main.id
  protocol            = "Http"
  port                = 80
  path                = "/"
}

# Define load balancer rule
resource "azurerm_lb_rule" "main" {
  name                  = "httpRule"
  resource_group_name   = azurerm_resource_group.main.name
  loadbalancer_id       = azurerm_lb.main
