# Stockage des états Terraform : un conteneur par environnement, 3 états par conteneur
# (socle, observabilite, passerelle-modeles), plus un conteneur pour le bootstrap.

resource "azurerm_resource_group" "tfstate" {
  name     = "rg-${local.prefix}-tfstate-${local.loc_short}-${local.suffix}"
  location = local.commun.platform.location
  tags     = local.base_tags
}

resource "azurerm_storage_account" "tfstate" {
  name                             = "st${local.prefix}tfstate${local.loc_short}${local.suffix}"
  resource_group_name              = azurerm_resource_group.tfstate.name
  location                         = azurerm_resource_group.tfstate.location
  account_tier                     = "Standard"
  account_replication_type         = "ZRS"
  min_tls_version                  = "TLS1_2"
  https_traffic_only_enabled       = true
  shared_access_key_enabled        = false # accès Entra ID uniquement (aucun secret)
  default_to_oauth_authentication  = true
  allow_nested_items_to_be_public  = false
  cross_tenant_replication_enabled = false
  tags                             = local.base_tags

  blob_properties {
    versioning_enabled = true
    delete_retention_policy {
      days = 30
    }
    container_delete_retention_policy {
      days = 30
    }
  }
}

resource "azurerm_storage_container" "bootstrap" {
  name                  = "bootstrap"
  storage_account_id    = azurerm_storage_account.tfstate.id
  container_access_type = "private"
}

resource "azurerm_storage_container" "env" {
  for_each              = local.environments
  name                  = each.key
  storage_account_id    = azurerm_storage_account.tfstate.id
  container_access_type = "private"
}

# L'administrateur qui lance le bootstrap doit pouvoir lire et écrire l'état (accès Entra).
data "azurerm_client_config" "current" {}

resource "azurerm_role_assignment" "bootstrap_admin_state" {
  scope                = azurerm_storage_account.tfstate.id
  role_definition_name = "Storage Blob Data Owner"
  principal_id         = data.azurerm_client_config.current.object_id
}
