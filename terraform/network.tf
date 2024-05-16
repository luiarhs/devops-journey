
# resource "azurerm_virtual_network" "k8s" {
#   name                = var.virtual_network_name
#   location            = azurerm_resource_group.k8s.location
#   resource_group_name = azurerm_resource_group.k8s.name
#   address_space       = [var.virtual_network_address_prefix]
#   subnet {
#     name           = var.kubernetes_subnet_name
#     address_prefix = var.kubernetes_subnet_address_prefix
#   }
#   tags = var.tags
# }

# data "azurerm_subnet" "kubesubnet" {
#   name                 = var.kubernetes_subnet_name
#   virtual_network_name = azurerm_virtual_network.k8s.name
#   resource_group_name  = azurerm_resource_group.k8s.name
#  }

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
