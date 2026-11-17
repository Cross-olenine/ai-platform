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

# FIN-05 : tags obligatoires, sur les groupes de ressources de la plateforme.
resource "azurerm_policy_definition" "required_tags" {
  name         = "${local.prefix}-required-tags"
  display_name = "Plateforme IA : tags obligatoires (FIN-05)"
  policy_type  = "Custom"
  mode         = "Indexed"
  description  = "Signale (ou refuse) toute ressource à laquelle il manque un tag obligatoire."
  policy_rule  = file("${path.module}/policies/tags-obligatoires.json")
  parameters = jsonencode({
    requiredTags = {
      type     = "Array"
      metadata = { displayName = "Tags obligatoires" }
    }
    effect = {
      type          = "String"
      allowedValues = ["Audit", "Deny", "Disabled"]
      metadata      = { displayName = "Effet" }
    }
  })
}

resource "azurerm_resource_group_policy_assignment" "required_tags" {
  for_each             = local.environments
  name                 = "${local.prefix}-${each.key}-required-tags"
  display_name         = "Plateforme IA ${each.key} : tags obligatoires (FIN-05)"
  resource_group_id    = azurerm_resource_group.env[each.key].id
  policy_definition_id = azurerm_policy_definition.required_tags.id
  parameters = jsonencode({
    requiredTags = { value = local.commun.governance.required_tags }
    effect       = { value = local.commun.governance.tag_policy_effect }
  })
}
