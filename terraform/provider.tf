terraform {
  required_version = ">=1.0"

  backend "azurerm" {
    resource_group_name  = "devops-rg"
    storage_account_name = "devopstfstate"
    container_name       = "tfstate"
    key                  = "terraform.tfstate"
    use_oidc             = true
  }

  required_providers {
    azurerm = {
      source = "hashicorp/azurerm"
      version = "~>3.0"
    }
  }
}

provider "azurerm" {
  features {}
  use_oidc = true
}

# terraform {
#   required_version = ">=1.0"

#   required_providers {
#     azapi = {
#       source  = "azure/azapi"
#       version = "~>1.5"
#     }
#     azurerm = {
#       source  = "hashicorp/azurerm"
#       version = "~>3.0"
#     }
#     random = {
#       source  = "hashicorp/random"
#       version = "~>3.0"
#     }
#     time = {
#       source  = "hashicorp/time"
#       version = "0.9.1"
#     }
#   }
# }

# provider "azurerm" {
#   features {}
# }