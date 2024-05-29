terraform {
  required_version = "1.8.4"

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "3.104.0"
    }
  }
}
provider "azurerm" {
  features {}
}
#1 Define a Virtual Network

resource "azurerm_resource_group" "rg" {
  name     = "rg-divelement"
  location = "South Central US"
}

resource "azurerm_virtual_network" "vnet" {
  name                = "vnet"
  address_space       = ["10.9.0.0/16"]
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
}

#2 Define a Subnet
resource "azurerm_subnet" "AzureBastionSubnet" {
  name                 = "AzureBastionSubnet"
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = ["10.0.0.0/24"]
}

resource "azurerm_subnet" "app_subnet" {
  name                 = "app_subnet"
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = ["10.0.1.0/24"]
}

resource "azurerm_subnet" "db_subnet" {
  name                 = "db_subnet"
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = ["10.0.2.0/24"]
}

#3 Define Network Interfaces
resource "azurerm_network_interface" "app_vm_interface" {
  name                = "app_vm_interface"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  ip_configuration {
    name                          = "app_vm_interface"
    subnet_id                     = azurerm_subnet.app_subnet.id
    private_ip_address_allocation = "Dynamic"
  }
}

resource "azurerm_network_interface" "db_vm_interface" {
  name                = "db_vm_interface"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  ip_configuration {
    name                          = "db_vm_interface"
    subnet_id                     = azurerm_subnet.db_subnet.id
    private_ip_address_allocation = "Dynamic"
  }
}

#4 Define Linux Virtual Machines
resource "azurerm_virtual_machine" "app_vm" {
  name                  = "app-vm"
  location              = azurerm_resource_group.rg.location
  resource_group_name   = azurerm_resource_group.rg.name
  network_interface_ids = [azurerm_network_interface.app_vm_interface.id]
  vm_size               = "Standard_B2s"

  storage_os_disk {
    name              = "osdisk-app"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Standard_LRS"
  }

  storage_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "20_04-lts"
    version   = "latest"
  }

  os_profile {
    computer_name  = "app-vm"
    admin_username = "adminuser"
    admin_password = "adminPa$$word"
  }

  os_profile_linux_config {
    disable_password_authentication = false
  }
}

resource "azurerm_virtual_machine" "db_vm" {
  name                  = "db-vm"
  location              = azurerm_resource_group.rg.location
  resource_group_name   = azurerm_resource_group.rg.name
  network_interface_ids = [azurerm_network_interface.db_vm_interface.id]
  vm_size               = "Standard_B2s"

  storage_os_disk {
    name              = "osdisk-db"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Standard_LRS"
  }

  storage_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "20_04-lts"
    version   = "latest"
  }

  os_profile {
    computer_name  = "db-vm"
    admin_username = "adminuser"
    admin_password = "adminPa$$word"
  }

  os_profile_linux_config {
    disable_password_authentication = false
  }
}

#5 Define a Public IP Address
resource "azurerm_public_ip" "public_ip_bastion" {
  name                = "public_ip_bastion"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  allocation_method   = "Static"
  sku                 = "Standard"
}

resource "azurerm_public_ip" "public_ip_lb" {
  name                = "public_ip_lb"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  allocation_method   = "Static"
  sku                 = "Standard"
}

#6 Define Bastion Host
resource "azurerm_bastion_host" "bastion" {
  name                = "bastion"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  dns_name            = "bastionhost"

  ip_configuration {
    name                 = "bastion_config"
    subnet_id            = azurerm_subnet.AzureBastionSubnet.id
    public_ip_address_id = azurerm_public_ip.public_ip_bastion.id
  }

  sku = "Standard"
}
#7 Define Load Balancer
resource "azurerm_lb" "app_lb" {
  name                = "app_lb"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  sku                 = "Standard"

  frontend_ip_configuration {
    name                 = "app_lb_config"
    public_ip_address_id = azurerm_public_ip.public_ip_lb.id
  }
}

#8 Define Load Balancer Backend Pool
resource "azurerm_lb_backend_address_pool" "app_lb_backend_pool" {
  name                = "app_lb_backend_pool"
  loadbalancer_id     = azurerm_lb.app_lb.id
}

#9 Define Network Interface Backend Address Pool Association
resource "azurerm_network_interface_backend_address_pool_association" "app_lb_association" {
  network_interface_id    = azurerm_network_interface.app_vm_interface.id
  ip_configuration_name    = "app_vm_interface" # azurerm_network_interface.app_vm_interface.ip_configuration.0.name
  backend_address_pool_id = azurerm_lb_backend_address_pool.app_lb_backend_pool.id
}

#10 Define Load Balancer Rules
resource "azurerm_lb_rule" "app_tcp_80" {
  name                           = "app_tcp_80"
  loadbalancer_id                = azurerm_lb.app_lb.id
  protocol                       = "Tcp"
  frontend_port                  = 80
  backend_port                   = 80
  frontend_ip_configuration_name = "app_lb_config"
}

resource "azurerm_lb_rule" "app_tcp_443" {
  name                           = "app_tcp_443"
  loadbalancer_id                = azurerm_lb.app_lb.id
  protocol                       = "Tcp"
  frontend_port                  = 443
  backend_port                   = 443
  frontend_ip_configuration_name = "app_lb_config"
}

