# Application Entra « API passerelle », une par environnement (IAM-01, IAM-03).
# Les consommateurs demandent un jeton pour cette API ; la passerelle vérifie audience et rôles.

locals {
  app_roles = {
    utilisateur  = { display = "Utilisateur", description = "Appeler les offres de la plateforme." }
    admin-offre  = { display = "Administrateur d'offre", description = "Administrer une offre de la plateforme." }
    exploitation = { display = "Exploitation", description = "Opérations d'exploitation de la plateforme." }
  }

  role_assignments = merge([
    for env, e in local.environments : merge([
      for role in keys(local.app_roles) : {
        for oid in try(e.access[role], []) : "${env}|${role}|${oid}" => { env = env, role = role, principal = oid }
      }
    ]...)
  ]...)
}

resource "random_uuid" "app_role" {
  for_each = local.app_roles
}

resource "random_uuid" "scope_user_impersonation" {}

resource "azuread_application" "gateway_api" {
  for_each         = local.environments
  display_name     = "${local.prefix}-${each.key}-gateway-api"
  owners           = [data.azurerm_client_config.current.object_id]
  sign_in_audience = "AzureADMyOrg" # un seul tenant en V1 (ADR-04 en V2)
  notes            = "Audience des jetons de la passerelle ${each.key}. Gérée par terraform/bootstrap."

  api {
    requested_access_token_version = 2

    oauth2_permission_scope {
      id                         = random_uuid.scope_user_impersonation.result
      value                      = "user_impersonation"
      type                       = "User"
      enabled                    = true
      admin_consent_display_name = "Appeler la plateforme IA"
      admin_consent_description  = "Permet à l'application d'appeler la passerelle de la plateforme IA au nom de l'utilisateur."
      user_consent_display_name  = "Appeler la plateforme IA"
      user_consent_description   = "Permet à l'application d'appeler la passerelle de la plateforme IA en votre nom."
    }
  }

  dynamic "app_role" {
    for_each = local.app_roles
    content {
      id                   = random_uuid.app_role[app_role.key].result
      value                = app_role.key
      display_name         = app_role.value.display
      description          = app_role.value.description
      allowed_member_types = ["User", "Application"]
      enabled              = true
    }
  }

  lifecycle {
    ignore_changes = [identifier_uris] # géré par azuread_application_identifier_uri
  }
}

resource "azuread_application_identifier_uri" "gateway_api" {
  for_each       = local.environments
  application_id = azuread_application.gateway_api[each.key].id
  identifier_uri = "api://${azuread_application.gateway_api[each.key].client_id}"
}

resource "azuread_service_principal" "gateway_api" {
  for_each                     = local.environments
  client_id                    = azuread_application.gateway_api[each.key].client_id
  app_role_assignment_required = false # le contrôle des rôles est fait à la passerelle (IAM-03)
  owners                       = [data.azurerm_client_config.current.object_id]
}

resource "azuread_application_pre_authorized" "gateway_api" {
  for_each = {
    for pair in setproduct(keys(local.environments), local.commun.gateway_api.preauthorized_client_ids) :
    "${pair[0]}|${pair[1]}" => { env = pair[0], client = pair[1] }
  }
  application_id       = azuread_application.gateway_api[each.value.env].id
  authorized_client_id = each.value.client
  permission_ids       = [random_uuid.scope_user_impersonation.result]
}

resource "azuread_app_role_assignment" "gateway_api" {
  for_each            = local.role_assignments
  app_role_id         = random_uuid.app_role[each.value.role].result
  principal_object_id = each.value.principal
  resource_object_id  = azuread_service_principal.gateway_api[each.value.env].object_id
}
