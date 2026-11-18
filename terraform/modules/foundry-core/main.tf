# Ressource Foundry (AI Services) et projet. Authentification par clé désactivée (IAM-02),
# filtrage de contenu et détection d'injection directe sur tous les déploiements (GRD-01, GRD-02).

variable "name_base" {
  type = string
}
variable "custom_subdomain" {
  description = "Sous-domaine globalement unique de la ressource Foundry."
  type        = string
}
variable "resource_group_name" {
  type = string
}
variable "location" {
  type = string
}
variable "tags" {
  type = map(string)
}
variable "content_filter" {
  description = "Bloc « content_filter » de catalog/environments/commun.yaml."
  type = object({
    base_policy        = string
    severity_threshold = string
    harm_categories    = list(string)
    prompt_shields     = bool
    protected_material = bool
  })
}

locals {
  tags = merge(var.tags, { component = "foundry" })

  harm_filters = flatten([
    for c in var.content_filter.harm_categories : [
      for source in ["Prompt", "Completion"] : {
        name = c, source = source, severity = var.content_filter.severity_threshold
      }
    ]
  ])
  shield_filters = var.content_filter.prompt_shields ? [{ name = "Jailbreak", source = "Prompt", severity = null }] : []
  material_filters = var.content_filter.protected_material ? [
    { name = "Protected Material Text", source = "Completion", severity = null },
    { name = "Protected Material Code", source = "Completion", severity = null },
  ] : []
  filters = concat(local.harm_filters, local.shield_filters, local.material_filters)
}

resource "azurerm_cognitive_account" "this" {
  name                          = "aif-${var.name_base}"
  resource_group_name           = var.resource_group_name
  location                      = var.location
  kind                          = "AIServices"
  sku_name                      = "S0"
  custom_subdomain_name         = var.custom_subdomain
  local_auth_enabled            = false # IAM-02 : aucune clé, identité Entra uniquement
  public_network_access_enabled = true  # ADR-07 : protégé par l'identité en V1, réseau privé en V2
  project_management_enabled    = true
  tags                          = local.tags

  identity {
    type = "SystemAssigned"
  }
}

# Projet Foundry : prépare la phase agents (ADR-01) sans rien y déployer en V1.
resource "azurerm_cognitive_account_project" "this" {
  name                 = "proj-${var.name_base}"
  cognitive_account_id = azurerm_cognitive_account.this.id
  location             = var.location
  display_name         = "Plateforme IA (${var.name_base})"
  description          = "Projet de la plateforme. Agents managés à partir de la phase agents de la V1."
  tags                 = local.tags

  identity {
    type = "SystemAssigned"
  }
}

resource "azurerm_cognitive_account_rai_policy" "default" {
  name                 = "plateforme-defaut"
  cognitive_account_id = azurerm_cognitive_account.this.id
  base_policy_name     = var.content_filter.base_policy
  mode                 = "Blocking"
  tags                 = local.tags

  dynamic "content_filter" {
    for_each = local.filters
    content {
      name               = content_filter.value.name
      source             = content_filter.value.source
      filter_enabled     = true
      block_enabled      = true
      severity_threshold = content_filter.value.severity
    }
  }
}

output "id" {
  value = azurerm_cognitive_account.this.id
}
output "name" {
  value = azurerm_cognitive_account.this.name
}
output "openai_endpoint" {
  description = "Point d'accès de l'API OpenAI v1 (utilisé uniquement par la passerelle, MGW-07)."
  value       = "https://${var.custom_subdomain}.openai.azure.com/openai/v1"
}
output "rai_policy_name" {
  value = azurerm_cognitive_account_rai_policy.default.name
}
output "project_id" {
  value = azurerm_cognitive_account_project.this.id
}
