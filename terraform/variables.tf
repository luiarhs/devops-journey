variable "name" {
  type    = string
  default = "aks-cluster-dev"
}
variable "container_registry_name" {
  type    = string
  default = "journeyacr"

}
variable "registry-sku" {
  type    = string
  default = "Basic"
}

variable "storage_account_name" {
  type    = string
  default = "journeysadev"

}

variable "resource_group_name" {}
variable "location" {}

variable "node_count" {
  type    = string
  default = 3
}

variable "business_division" {
  description = "The business division"
  type        = string
}
variable "rg_location" {
  description = "The business division"
  type        = string
}
# variable "k8s_version" {
#   type    = string
#   default = "1.28.5"
# }
