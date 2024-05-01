
module "aks_cluster" {
  source  = "../../modules/aks"
  // Configuration for AKS module
  resource_group_name = "devops-rg"
  cluster_name        = "akscluster-dev"
  location            = "southcentralus"
  node_count          = 3
  node_vm_size        = "Standard_DS2_v2"
}

module "database" {
  source  = "../../modules/database"
  // Configuration for Azure SQL Database module
  resource_group_name   = "devops-rg"
  location              = "southcentralus"
  storage_name          = "mysqlstorage-dev"
  database_name         = "mysqldb-dev"
  server_name           = "mysqlserver-dev"
  administrator_login   = "mysqladminun"
  administrator_password = ""
}
