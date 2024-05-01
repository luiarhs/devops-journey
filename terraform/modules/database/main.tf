# terraform/modules/sql_database/main.tf

variable "resource_group_name" {
  description = "Name of the resource group where SQL Database will be deployed."
}

variable "location" {
  description = "Azure region where the SQL Database will be deployed."
}

variable "database_name" {
  description = "Name of the SQL Database."
}

variable "storage_name" {
  description = "Name of the Storage Account."
}

variable "server_name" {
  description = "Name of the SQL Server."
}

variable "administrator_login" {
  description = "Administrator login for the SQL Server."
}

variable "administrator_password" {
  description = "Administrator password for the SQL Server."
}

provider "azurerm" {
  features {}
}

resource "azurerm_mysql_flexible_server" "mysql_server" {
  name                = var.server_name
  location            = var.location
  resource_group_name = var.resource_group_name

  administrator_login    = "mysqladminun"
  administrator_password = "H@Sh1CoR3!"
  sku_name               = "B_Standard_B1s"

  tags = {
    Environment = "dev"
  }
}

resource "azurerm_mysql_flexible_database" "mysql_database" {
  name                = var.database_name
  resource_group_name = var.resource_group_name
  server_name         = var.server_name
  charset             = "utf8"
  collation           = "utf8_unicode_ci"
  

  # prevent the possibility of accidental data loss
  lifecycle {
    prevent_destroy = true
  }
}