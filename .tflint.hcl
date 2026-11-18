plugin "terraform" {
  enabled = true
  preset  = "recommended"
}

# prevent_destroy est posé là où une suppression serait irréversible (stockage des états, bootstrap).
# La règle n'est pas appliquée aux modules : dev doit pouvoir être reconstruit depuis le code (critère de sortie V1),
# la production est protégée par l'approbation (ADR-13) et la protection contre la purge.
rule "azurerm_resources_missing_prevent_destroy" {
  enabled = false
}

plugin "azurerm" {
  enabled = true
  version = "0.33.0"
  source  = "github.com/terraform-linters/tflint-ruleset-azurerm"
}
