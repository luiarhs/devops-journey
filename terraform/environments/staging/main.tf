# 1. Define virtual network named vnet0 with address space 10.9.0.0/16
resource "azurerm_virtual_network" "vnet0" {
  name                = "vnet0"
  address_space       = ["10.9.0.0/16"]
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name
}

# 2. Define subnet for Azure bastion
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
