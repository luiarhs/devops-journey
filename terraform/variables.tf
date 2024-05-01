variable "name" {
  type    = string
  default = "aks-cluster-dev"
}
variable "container_registry_name" {
  type    = string
  default = "devops-acr"
  
}
variable "registry-sku" {
  type    = string
  default = "Basic"
}

variable "storage_account_name" {
  type    = string
  default = "devopssadev"
  
}

variable "resource_group_name" {}
variable "location" {}

variable "node_count" {
  type    = string
  default = 3
}

# variable "k8s_version" {
#   type    = string
#   default = "1.28.5"
# }
