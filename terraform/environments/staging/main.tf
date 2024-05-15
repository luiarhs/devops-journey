# Define virtual network named vnet0 with address space 10.9.0.0/16
resource "azurerm_virtual_network" "vnet0" {
  name                = "vnet0"
  address_space       = ["10.9.0.0/16"]
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name
}

