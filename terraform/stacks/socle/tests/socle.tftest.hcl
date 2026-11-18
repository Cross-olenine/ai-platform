# Key Vault et budget de l'environnement depuis le catalogue (KV-01, FIN-03).

mock_provider "azurerm" {
  mock_data "azurerm_resource_group" {
    defaults = {
      id = "/subscriptions/11111111-1111-1111-1111-111111111111/resourceGroups/rg"
    }
  }
  mock_data "azurerm_client_config" {
    defaults = {
      object_id = "44444444-4444-4444-4444-444444444444"
    }
  }
  mock_resource "azurerm_key_vault" {
    defaults = {
      id = "/subscriptions/11111111-1111-1111-1111-111111111111/resourceGroups/rg/providers/Microsoft.KeyVault/vaults/kv"
    }
  }
}

variables {
  environment  = "dev"
  catalog_path = "../../tests/fixtures/catalog"
}

run "budget_et_key_vault" {
  command = apply
  assert {
    condition     = azurerm_consumption_budget_resource_group.env.amount == 50 && length(azurerm_consumption_budget_resource_group.env.notification) == 3
    error_message = "Budget et seuils attendus depuis le catalogue (FIN-03)."
  }
  assert {
    condition     = output.key_vault_name == "kv-aiplat-dev-frc-01"
    error_message = "Nom du Key Vault selon la convention."
  }
}
