# terraform/main.tf

# Define any global resources that are shared across all environments
// For example, you might define a storage account, virtual network, etc.
# Create Resource Group
resource "azurerm_resource_group" "DemoRG" {
  name     = var.resource_group_name
  location = var.location
}


# Create Azure Container Registry
resource "azurerm_container_registry" "scacontainerregistry" {
  name                = var.container_registry_name
  resource_group_name = var.resource_group_name
  location            = var.location
  sku                 = var.registry-sku
}


# Create Storage Account to house Azure File Share
resource "azurerm_storage_account" "storage" {
  name                     = var.storage_account_name
  resource_group_name      = var.resource_group_name
  location                 = var.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
  account_kind             = "StorageV2"
}


# Include configurations for dev environment
module "dev" {
  source = "./environments/dev"
}

# Include configurations for prod environment
module "prod_environment" {
  source = "./environments/prod"
}

# Other global configurations and resources can go here
