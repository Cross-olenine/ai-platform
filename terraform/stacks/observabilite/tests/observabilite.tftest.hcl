# Les tarifs de la fonction KQL ModelPricing viennent du catalogue des modèles (FIN-02).

mock_provider "azurerm" {
  mock_data "azurerm_resource_group" {
    defaults = {
      id = "/subscriptions/11111111-1111-1111-1111-111111111111/resourceGroups/rg"
    }
  }
  mock_resource "azurerm_log_analytics_workspace" {
    defaults = {
      id = "/subscriptions/11111111-1111-1111-1111-111111111111/resourceGroups/rg/providers/Microsoft.OperationalInsights/workspaces/log"
    }
  }
}


variables {
  environment  = "dev"
  catalog_path = "../../tests/fixtures/catalog"
}

run "tarifs_depuis_catalogue" {
  command = apply
  assert {
    condition     = strcontains(module.observability.pricing_query, "\"agent-general\", real(1.500000), real(0.000000), real(6.000000)")
    error_message = "La table des tarifs doit être générée depuis le catalogue."
  }
  assert {
    condition     = strcontains(module.observability.pricing_query, "\"embedding-default\", real(0.020000), real(0.000000), real(0.000000)")
    error_message = "ADR-19 : un embedding est tarifé à l'entrée seulement (sortie et cache à 0)."
  }
}
