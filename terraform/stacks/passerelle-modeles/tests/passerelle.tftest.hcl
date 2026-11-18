# Test hors ligne de l'état « passerelle et modèles » : providers simulés, catalogue fictif.
# Vérifie le rendu des policies depuis le catalogue (API-03), le routage par alias (MGW-01) et les limites (MGW-03).

mock_provider "azurerm" {
  mock_data "azurerm_key_vault" {
    defaults = {
      id = "/subscriptions/11111111-1111-1111-1111-111111111111/resourceGroups/rg/providers/Microsoft.KeyVault/vaults/kv"
    }
  }
  mock_data "azurerm_resource_group" {
    defaults = {
      id = "/subscriptions/11111111-1111-1111-1111-111111111111/resourceGroups/rg"
    }
  }
  mock_data "azurerm_log_analytics_workspace" {
    defaults = {
      id = "/subscriptions/11111111-1111-1111-1111-111111111111/resourceGroups/rg/providers/Microsoft.OperationalInsights/workspaces/log"
    }
  }
  mock_data "azurerm_application_insights" {
    defaults = {
      id                = "/subscriptions/11111111-1111-1111-1111-111111111111/resourceGroups/rg/providers/Microsoft.Insights/components/appi"
      connection_string = "InstrumentationKey=00000000-0000-0000-0000-000000000000"
    }
  }
  mock_resource "azurerm_api_management_logger" {
    defaults = {
      id = "/subscriptions/11111111-1111-1111-1111-111111111111/resourceGroups/rg/providers/Microsoft.ApiManagement/service/apim/loggers/appinsights"
    }
  }
  mock_resource "azurerm_api_management_product" {
    defaults = {
      id = "/subscriptions/11111111-1111-1111-1111-111111111111/resourceGroups/rg/providers/Microsoft.ApiManagement/service/apim/products/opencode"
    }
  }
  mock_resource "azurerm_api_management_api" {
    defaults = {
      id   = "/subscriptions/11111111-1111-1111-1111-111111111111/resourceGroups/rg/providers/Microsoft.ApiManagement/service/apim/apis/model-gateway"
      path = "model-gateway/v1"
    }
  }
  mock_resource "azurerm_monitor_action_group" {
    defaults = {
      id = "/subscriptions/11111111-1111-1111-1111-111111111111/resourceGroups/rg/providers/Microsoft.Insights/actionGroups/ag"
    }
  }
  mock_resource "azurerm_cognitive_account" {
    defaults = {
      id = "/subscriptions/11111111-1111-1111-1111-111111111111/resourceGroups/rg/providers/Microsoft.CognitiveServices/accounts/aif"
    }
  }
  mock_resource "azurerm_api_management" {
    defaults = {
      id          = "/subscriptions/11111111-1111-1111-1111-111111111111/resourceGroups/rg/providers/Microsoft.ApiManagement/service/apim"
      gateway_url = "https://apim.example.com"
    }
  }
}

mock_provider "random" {}

# L'identité managée de l'APIM est un bloc imbriqué : sa valeur est fixée ici.
override_resource {
  target = module.apim.azurerm_api_management.this
  values = {
    id          = "/subscriptions/11111111-1111-1111-1111-111111111111/resourceGroups/rg/providers/Microsoft.ApiManagement/service/apim"
    gateway_url = "https://apim.example.com"
    identity = {
      principal_id = "22222222-2222-2222-2222-222222222222"
      tenant_id    = "11111111-1111-1111-1111-111111111111"
    }
  }
}

variables {
  environment           = "dev"
  catalog_path          = "../../tests/fixtures/catalog"
  api_path              = "../../../api"
  gateway_api_client_id = "33333333-3333-3333-3333-333333333333"
}

run "rendu_depuis_catalogue" {
  command = apply

  assert {
    condition     = module.model_gateway.subscription_key_secret_names["opencode"] == "apim-subscription-key-opencode"
    error_message = "Un secret de clé d'abonnement doit exister par application (KV-02)."
  }

  assert {
    condition     = module.model_gateway.model_routes == "agent-fast|agent-fast-v1|4096|512|2026-01-01;agent-general|agent-general-v1|16384|512|2026-01-01"
    error_message = "La table de routage alias -> déploiement doit venir du catalogue (MGW-01)."
  }

  assert {
    condition     = strcontains(module.model_gateway.product_policy_xml["opencode"], "<rate-limit calls=\"30\" renewal-period=\"60\" />")
    error_message = "La limite d'appels de l'application doit venir du catalogue (MGW-03)."
  }

  assert {
    condition     = strcontains(module.model_gateway.api_policy_xml, "metriques-tokens") && !strcontains(module.model_gateway.api_policy_xml, "<!--")
    error_message = "Policy de l'API : fragment metriques-tokens attendu, commentaires retirés."
  }

  assert {
    condition     = module.model_gateway.assembled_policy_bytes < 16384
    error_message = "ADR-18 : policy assemblée trop grande."
  }
}

run "metriques_tokens_desactivables" {
  command = apply

  variables {
    token_metrics_enabled = false
  }

  assert {
    condition     = !strcontains(module.model_gateway.api_policy_xml, "metriques-tokens")
    error_message = "Le fragment metriques-tokens doit pouvoir être retiré (PO-12)."
  }
}
