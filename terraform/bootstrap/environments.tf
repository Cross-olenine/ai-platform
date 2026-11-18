# Un groupe de ressources par environnement (ADR-12). Il est créé ici, et non dans l'état
# « socle », pour que l'identité de pipeline n'ait de droits que sur son propre groupe.

resource "azurerm_resource_group" "env" {
  for_each = local.environments
  name     = "rg-${local.prefix}-${each.key}-${local.loc_short}-${each.value.name_suffix}"
  location = local.commun.platform.location
  tags     = local.env_tags[each.key]
}

# --- Identités des pipelines : une application Entra par environnement, fédération OIDC, aucun secret.

resource "azuread_application" "pipeline" {
  for_each     = local.environments
  display_name = "${local.prefix}-${each.key}-pipeline"
  owners       = [data.azurerm_client_config.current.object_id]
  notes        = "Identité GitHub Actions de l'environnement ${each.key} (ADR-13). Gérée par terraform/bootstrap."
}

resource "azuread_service_principal" "pipeline" {
  for_each  = local.environments
  client_id = azuread_application.pipeline[each.key].client_id
  owners    = [data.azurerm_client_config.current.object_id]
}

# GitHub émet un sujet immuable pour les nouveaux dépôts : repo:<compte>@<id>/<dépôt>@<id>:<suite>.
# Il résiste au renommage ou à la recréation du compte et du dépôt.
data "github_user" "owner" {
  username = local.commun.github.owner
}

locals {
  oidc_subject_prefix = "repo:${local.commun.github.owner}@${data.github_user.owner.id}/${github_repository.platform.name}@${github_repository.platform.repo_id}"
}

resource "azuread_application_federated_identity_credential" "pipeline" {
  for_each       = local.oidc_credentials
  application_id = azuread_application.pipeline[each.value.env].id
  display_name   = "github-${replace(replace(each.value.claim, "/[^A-Za-z0-9-]/", "-"), "/-+/", "-")}"
  description    = "GitHub OIDC : ${local.oidc_subject_prefix}:${each.value.claim}"
  audiences      = ["api://AzureADTokenExchange"]
  issuer         = "https://token.actions.githubusercontent.com"
  subject        = "${local.oidc_subject_prefix}:${each.value.claim}"
}

# Droits de l'identité de pipeline, limités à son groupe de ressources.
resource "azurerm_role_assignment" "pipeline_contributor" {
  for_each             = local.environments
  scope                = azurerm_resource_group.env[each.key].id
  role_definition_name = "Contributor"
  principal_id         = azuread_service_principal.pipeline[each.key].object_id
  principal_type       = "ServicePrincipal"
}

# Attribution de rôles limitée aux rôles listés dans governance.delegable_roles.
data "azurerm_role_definition" "delegable" {
  for_each = toset(local.commun.governance.delegable_roles)
  name     = each.value
}

locals {
  delegable_role_guids = join(", ", [for r in data.azurerm_role_definition.delegable : basename(r.id)])
  rbac_condition       = <<-EOT
    (
     (
      !(ActionMatches{'Microsoft.Authorization/roleAssignments/write'})
     )
     OR
     (
      @Request[Microsoft.Authorization/roleAssignments:RoleDefinitionId] ForAnyOfAnyValues:GuidEquals {${local.delegable_role_guids}}
     )
    )
    AND
    (
     (
      !(ActionMatches{'Microsoft.Authorization/roleAssignments/delete'})
     )
     OR
     (
      @Resource[Microsoft.Authorization/roleAssignments:RoleDefinitionId] ForAnyOfAnyValues:GuidEquals {${local.delegable_role_guids}}
     )
    )
  EOT
}

resource "azurerm_role_assignment" "pipeline_rbac_admin" {
  for_each             = local.environments
  scope                = azurerm_resource_group.env[each.key].id
  role_definition_name = "Role Based Access Control Administrator"
  principal_id         = azuread_service_principal.pipeline[each.key].object_id
  principal_type       = "ServicePrincipal"
  condition_version    = "2.0"
  condition            = local.rbac_condition
}

# Accès à l'état Terraform de son environnement uniquement.
resource "azurerm_role_assignment" "pipeline_state" {
  for_each             = local.environments
  scope                = azurerm_storage_container.env[each.key].id
  role_definition_name = "Storage Blob Data Contributor"
  principal_id         = azuread_service_principal.pipeline[each.key].object_id
  principal_type       = "ServicePrincipal"
}

# Lecture du compte de stockage (nécessaire à l'initialisation du backend).
resource "azurerm_role_assignment" "pipeline_state_reader" {
  for_each             = local.environments
  scope                = azurerm_storage_account.tfstate.id
  role_definition_name = "Reader"
  principal_id         = azuread_service_principal.pipeline[each.key].object_id
  principal_type       = "ServicePrincipal"
}
