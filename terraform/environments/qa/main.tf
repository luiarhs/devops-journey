
resource "azurerm_resource_group" "rg" {
  location   = "southcentralus"
  managed_by = null
  name       = "journey-rg"
  tags       = {}
}