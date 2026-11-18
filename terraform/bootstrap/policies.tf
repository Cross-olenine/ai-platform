# Règles Azure appliquées à l'abonnement (P8 : tout vient du code).

locals {
  subscription_scope = "/subscriptions/${local.subscription_id}"
}

# CMP-01 : traitement dans l'UE. Régions autorisées pour les ressources et groupes de ressources.
data "azurerm_policy_definition" "allowed_locations" {
  display_name = "Allowed locations"
}

data "azurerm_policy_definition" "allowed_locations_rg" {
  display_name = "Allowed locations for resource groups"
}

resource "azurerm_subscription_policy_assignment" "allowed_locations" {
  name                 = "${local.prefix}-allowed-locations"
  display_name         = "Plateforme IA : régions autorisées (CMP-01)"
  subscription_id      = local.subscription_scope
  policy_definition_id = data.azurerm_policy_definition.allowed_locations.id
  parameters = jsonencode({
    listOfAllowedLocations = { value = local.commun.governance.allowed_locations }
  })
}

resource "azurerm_subscription_policy_assignment" "allowed_locations_rg" {
  name                 = "${local.prefix}-allowed-locations-rg"
  display_name         = "Plateforme IA : régions autorisées pour les groupes de ressources (CMP-01)"
  subscription_id      = local.subscription_scope
  policy_definition_id = data.azurerm_policy_definition.allowed_locations_rg.id
  parameters = jsonencode({
    listOfAllowedLocations = { value = local.commun.governance.allowed_locations }
  })
}

# CMP-01, ADR-03 : seuls les types de déploiement de modèles autorisés (Data Zone EU).
resource "azurerm_policy_definition" "model_deployment_types" {
  name         = "${local.prefix}-model-deployment-types"
  display_name = "Plateforme IA : types de déploiement de modèles autorisés (ADR-03)"
  policy_type  = "Custom"
  mode         = "All"
  description  = "Refuse tout déploiement de modèle Foundry dont le type n'est pas autorisé (par exemple Global)."
  policy_rule  = file("${path.module}/policies/types-deploiement-modeles.json")
  parameters = jsonencode({
    allowedDeploymentTypes = {
      type     = "Array"
      metadata = { displayName = "Types de déploiement autorisés" }
    }
  })
}

resource "azurerm_subscription_policy_assignment" "model_deployment_types" {
  name                 = "${local.prefix}-model-deployment-types"
  display_name         = azurerm_policy_definition.model_deployment_types.display_name
  subscription_id      = local.subscription_scope
  policy_definition_id = azurerm_policy_definition.model_deployment_types.id
  parameters = jsonencode({
    allowedDeploymentTypes = { value = local.commun.governance.allowed_model_deployment_types }
  })
}

# FIN-05 : tags obligatoires sur les groupes de ressources de la plateforme.
# Définition intégrée « Require a tag on resources », une affectation par tag et par environnement.
# tag_policy_effect = Audit : évaluation seule (DoNotEnforce), le contrôle bloquant est fait en CI.
data "azurerm_policy_definition" "require_tag" {
  display_name = "Require a tag on resources"
}

resource "azurerm_resource_group_policy_assignment" "required_tags" {
  for_each = {
    for pair in setproduct(keys(local.environments), local.commun.governance.required_tags) :
    "${pair[0]}|${pair[1]}" => { env = pair[0], tag = pair[1] }
  }
  name                 = "${local.prefix}-${each.value.env}-tag-${each.value.tag}"
  display_name         = "Plateforme IA ${each.value.env} : tag ${each.value.tag} obligatoire (FIN-05)"
  resource_group_id    = azurerm_resource_group.env[each.value.env].id
  policy_definition_id = data.azurerm_policy_definition.require_tag.id
  enforce              = local.commun.governance.tag_policy_effect == "Deny"
  parameters = jsonencode({
    tagName = { value = each.value.tag }
  })
}
