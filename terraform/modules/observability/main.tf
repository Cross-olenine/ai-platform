# Log Analytics + Application Insights (OBS-03, OBS-04, OBS-06), événements d'usage et coût estimé
# (FIN-01, FIN-02, ADR-08), tableau de bord FinOps (FIN-06).

variable "name_base" {
  type = string
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
variable "retention_days" {
  type = number
}
variable "daily_quota_gb" {
  type = number
}
variable "models" {
  description = "Modèles actifs du catalogue (alias => entrée), pour la table des tarifs."
  type        = any
}

locals {
  tags = merge(var.tags, { component = "observability" })

  # FIN-02 : tarifs issus du catalogue des modèles (EUR par million de tokens).
  pricing_rows = join(",\n  ", concat(
    [for alias, m in var.models : format("\"%s\", real(%.6f), real(%.6f), real(%.6f)", alias, m.pricing.input, m.pricing.cached_input, m.pricing.output)],
    ["\"\", real(0), real(0), real(0)"] # ligne neutre : la table n'est jamais vide
  ))
}

resource "azurerm_log_analytics_workspace" "this" {
  name                = "log-${var.name_base}"
  resource_group_name = var.resource_group_name
  location            = var.location
  sku                 = "PerGB2018"
  retention_in_days   = var.retention_days
  daily_quota_gb      = var.daily_quota_gb # OBS-06
  tags                = local.tags
}

resource "azurerm_application_insights" "this" {
  name                 = "appi-${var.name_base}"
  resource_group_name  = var.resource_group_name
  location             = var.location
  workspace_id         = azurerm_log_analytics_workspace.this.id
  application_type     = "other"
  retention_in_days    = var.retention_days
  sampling_percentage  = 100 # un événement d'usage par requête (FIN-01) : pas d'échantillonnage
  daily_data_cap_in_gb = var.daily_quota_gb
  ip_masking_enabled   = true
  tags                 = local.tags
}

# Fonctions KQL : le schéma des événements d'usage est défini une seule fois, ici.
resource "azurerm_log_analytics_saved_search" "usage_events" {
  name                       = "UsageEvents"
  log_analytics_workspace_id = azurerm_log_analytics_workspace.this.id
  category                   = "Plateforme IA"
  display_name               = "Événements d'usage (FIN-01)"
  function_alias             = "UsageEvents"
  query                      = file("${path.module}/queries/usage-events.kql")
}

resource "azurerm_log_analytics_saved_search" "model_pricing" {
  name                       = "ModelPricing"
  log_analytics_workspace_id = azurerm_log_analytics_workspace.this.id
  category                   = "Plateforme IA"
  display_name               = "Tarifs des modèles (FIN-02, généré depuis le catalogue)"
  function_alias             = "ModelPricing"
  query                      = templatefile("${path.module}/queries/model-pricing.kql.tftpl", { rows = local.pricing_rows })
}

resource "azurerm_log_analytics_saved_search" "usage_cost" {
  name                       = "UsageCost"
  log_analytics_workspace_id = azurerm_log_analytics_workspace.this.id
  category                   = "Plateforme IA"
  display_name               = "Événements d'usage avec coût estimé (FIN-02)"
  function_alias             = "UsageCost"
  query                      = file("${path.module}/queries/usage-cost.kql")
  depends_on                 = [azurerm_log_analytics_saved_search.usage_events, azurerm_log_analytics_saved_search.model_pricing]
}

resource "azurerm_log_analytics_saved_search" "token_usage" {
  name                       = "TokenUsage"
  log_analytics_workspace_id = azurerm_log_analytics_workspace.this.id
  category                   = "Plateforme IA"
  display_name               = "Tokens mesurés par la passerelle, y compris en streaming (PO-12)"
  function_alias             = "TokenUsage"
  query                      = file("${path.module}/queries/token-usage.kql")
}

resource "random_uuid" "workbook" {}

resource "azurerm_application_insights_workbook" "finops" {
  name                = random_uuid.workbook.result
  resource_group_name = var.resource_group_name
  location            = var.location
  display_name        = "Plateforme IA : usage et coût (${var.name_base})"
  source_id           = lower(azurerm_log_analytics_workspace.this.id)
  category            = "workbook"
  data_json           = templatefile("${path.module}/queries/workbook.json.tftpl", { workspace_id = azurerm_log_analytics_workspace.this.id })
  tags                = local.tags
  depends_on          = [azurerm_log_analytics_saved_search.usage_cost]
}

output "workspace_id" {
  value = azurerm_log_analytics_workspace.this.id
}
output "workspace_name" {
  value = azurerm_log_analytics_workspace.this.name
}
output "application_insights_id" {
  value = azurerm_application_insights.this.id
}
output "application_insights_name" {
  value = azurerm_application_insights.this.name
}
output "pricing_query" {
  description = "Requête KQL des tarifs générée depuis le catalogue (tests)."
  value       = azurerm_log_analytics_saved_search.model_pricing.query
}
