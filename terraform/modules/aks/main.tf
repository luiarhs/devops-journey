# terraform/modules/aks/main.tf

variable "resource_group_name" {
  description = "Name of the resource group where AKS will be deployed."
}

variable "cluster_name" {
  description = "Name of the AKS cluster."
}

variable "location" {
  description = "Azure region where the AKS cluster will be deployed."
}

variable "node_count" {
  description = "Number of nodes in the AKS cluster."
  default     = 3
}

variable "node_vm_size" {
  description = "Size of the VMs in the AKS cluster."
  default     = "Standard_DS2_v2"
}

variable "k8s_version" {
  type    = string
  default = "1.28.5"
}

provider "azurerm" {
  features {}
}

resource "azurerm_kubernetes_cluster" "aks_cluster" {
  name                = var.cluster_name
  location            = var.location
  resource_group_name = var.resource_group_name
  dns_prefix          = "${var.cluster_name}-dns"
#   dns_prefix          = "${var.name}-dns01"
  kubernetes_version = var.k8s_version

  network_profile {
    network_plugin = "azure"
    network_policy = "azure"
  }

  default_node_pool {
    name       = "default"
    node_count = var.node_count
    vm_size    = var.node_vm_size
    # vm_size    = "Standard_A2_v2"
  }

  identity {
    type = "SystemAssigned"
  }

  tags = {
    Environment = "Production"
  }
}
