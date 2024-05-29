# __generated__ by Terraform
# Please review these resources and move them into your main configuration files.

# __generated__ by Terraform from "/subscriptions/${id}/resourceGroups/journey-rg"
resource "azurerm_resource_group" "rg" {
  location   = "southcentralus"
  managed_by = null
  name       = "journey-rg"
  tags       = {}
}

# __generated__ by Terraform
resource "azurerm_storage_account" "tfstate" {
  access_tier                       = "Hot"
  account_kind                      = "StorageV2"
  account_replication_type          = "LRS"
  account_tier                      = "Standard"
  allow_nested_items_to_be_public   = false
  allowed_copy_scope                = null
  cross_tenant_replication_enabled  = false
  default_to_oauth_authentication   = false
  dns_endpoint_type                 = "Standard"
  edge_zone                         = null
  enable_https_traffic_only         = true
  infrastructure_encryption_enabled = false
  is_hns_enabled                    = false
  large_file_share_enabled          = null
  local_user_enabled                = true
  location                          = "southcentralus"
  min_tls_version                   = "TLS1_0"
  name                              = "journeytfstate"
  nfsv3_enabled                     = false
  public_network_access_enabled     = true
  queue_encryption_key_type         = "Service"
  resource_group_name               = "journey-rg"
  sftp_enabled                      = false
  shared_access_key_enabled         = true
  table_encryption_key_type         = "Service"
  tags                              = {}
  blob_properties {
    change_feed_enabled           = false
    change_feed_retention_in_days = 0
    default_service_version       = null
    last_access_time_enabled      = false
    versioning_enabled            = false
  }
  network_rules {
    bypass                     = ["AzureServices"]
    default_action             = "Allow"
    ip_rules                   = []
    virtual_network_subnet_ids = []
  }
  queue_properties {
    hour_metrics {
      enabled               = true
      include_apis          = true
      retention_policy_days = 7
      version               = jsonencode(1)
    }
    logging {
      delete                = false
      read                  = false
      retention_policy_days = 0
      version               = jsonencode(1)
      write                 = false
    }
    minute_metrics {
      enabled               = false
      include_apis          = false
      retention_policy_days = 0
      version               = jsonencode(1)
    }
  }
  share_properties {
    retention_policy {
      days = 7
    }
  }
}
