# Terraform State Storage to Azure Storage Container (Values will be taken from Azure DevOps)
 backend "azurerm" {
    resource_group_name   = "rg-terraform-state"
    storage_account_name  = "stterraformstate"
    container_name        = "tfstate"
    key                   = "terraform.tfstate"
 } 