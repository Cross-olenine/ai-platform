# Alertes de base (OBS-06, OBS-07, RES-03). Seuils issus du catalogue d'environnement.

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
variable "workspace_id" {
  description = "Espace Log Analytics qui reçoit la télémétrie de la passerelle (AppRequests, Usage)."
  type        = string
}
variable "thresholds" {
  description = "Bloc « alerting » du catalogue d'environnement."
  type = object({
    emails                   = list(string)
    notified_roles           = list(string)
    availability_percent_min = number
    error_rate_percent_max   = number
    throttled_calls_max      = number
    min_requests             = number
    latency_p95_ms_max       = number
  })
}
variable "ingestion_alert_gb" {
  description = "OBS-06 : volume quotidien ingéré au-delà duquel une alerte est levée."
  type        = number
}
variable "foundry_account_id" {
  type = string
}
variable "model_deployments" {
  description = "Déploiements (nom => capacité en milliers de tokens par minute), pour l'alerte à 80 % (RES-03)."
  type        = map(number)
}
variable "quota_alert_percent" {
  description = "RES-03 : seuil d'alerte de consommation du quota d'un déploiement."
  type        = number
  default     = 80
}

# Destinataires par rôle Azure (ex. Owner) : contrairement à une adresse courriel, un rôle n'exige pas
# de validation par code à usage unique à chaque (re)création du groupe d'actions.
data "azurerm_subscription" "current" {}

data "azurerm_role_definition" "notified" {
  for_each = toset(var.thresholds.notified_roles)
  name     = each.value
  scope    = data.azurerm_subscription.current.id
}

locals {
  tags = merge(var.tags, { component = "alerting" })

  # Requêtes sur la télémétrie de requêtes de la passerelle (Application Insights, ADR-18).
  log_alerts = {
    disponibilite = {
      description = "OBS-07 : taux de succès de la passerelle sous le seuil."
      severity    = 1
      query       = <<-KQL
        AppRequests
        | summarize total = count(), ok = countif(toint(ResultCode) < 500)
        | where total >= ${var.thresholds.min_requests}
        | extend availability = 100.0 * ok / total
        | where availability < ${var.thresholds.availability_percent_min}
      KQL
    }
    taux-erreur = {
      description = "OBS-07 : taux d'erreur (4xx hors 401/403/429, et 5xx) au-dessus du seuil."
      severity    = 2
      query       = <<-KQL
        AppRequests
        | summarize total = count(), errors = countif(toint(ResultCode) >= 500 or (toint(ResultCode) >= 400 and toint(ResultCode) !in (401, 403, 429)))
        | where total >= ${var.thresholds.min_requests}
        | extend error_rate = 100.0 * errors / total
        | where error_rate > ${var.thresholds.error_rate_percent_max}
      KQL
    }
    limites-429 = {
      description = "OBS-07 : nombre de réponses 429 au-dessus du seuil."
      severity    = 3
      query       = <<-KQL
        AppRequests
        | where ResultCode == "429"
        | summarize throttled = count()
        | where throttled > ${var.thresholds.throttled_calls_max}
      KQL
    }
    latence-p95 = {
      description = "OBS-07 : latence P95 au-dessus du seuil."
      severity    = 3
      query       = <<-KQL
        AppRequests
        | summarize p95 = percentile(DurationMs, 95), total = count()
        | where total > 10 and p95 > ${var.thresholds.latency_p95_ms_max}
      KQL
    }
  }
}

resource "azurerm_monitor_action_group" "this" {
  name                = "ag-${var.name_base}"
  resource_group_name = var.resource_group_name
  short_name          = substr(replace(var.name_base, "-", ""), 0, 12)
  tags                = local.tags

  dynamic "email_receiver" {
    for_each = var.thresholds.emails
    content {
      name                    = "email-${email_receiver.key}"
      email_address           = email_receiver.value
      use_common_alert_schema = true
    }
  }

  dynamic "arm_role_receiver" {
    for_each = data.azurerm_role_definition.notified
    content {
      name                    = "role-${arm_role_receiver.key}"
      role_id                 = arm_role_receiver.value.role_definition_id
      use_common_alert_schema = true
    }
  }
}

resource "azurerm_monitor_scheduled_query_rules_alert_v2" "gateway" {
  for_each             = local.log_alerts
  name                 = "alrt-${each.key}-${var.name_base}"
  resource_group_name  = var.resource_group_name
  location             = var.location
  description          = each.value.description
  severity             = each.value.severity
  scopes               = [var.workspace_id]
  evaluation_frequency = "PT5M"
  window_duration      = "PT15M"
  tags                 = local.tags
  # Alerte avec état : une notification au déclenchement, une à la résolution,
  # au lieu d'une à chaque évaluation tant que la fenêtre contient l'anomalie.
  auto_mitigation_enabled = true

  criteria {
    query                   = each.value.query
    time_aggregation_method = "Count"
    operator                = "GreaterThan"
    threshold               = 0
    failing_periods {
      minimum_failing_periods_to_trigger_alert = 1
      number_of_evaluation_periods             = 1
    }
  }

  action {
    action_groups = [azurerm_monitor_action_group.this.id]
  }
}

# OBS-06 : hausse anormale de l'ingestion de journaux (le plafond quotidien est posé sur l'espace).
resource "azurerm_monitor_scheduled_query_rules_alert_v2" "ingestion" {
  name                    = "alrt-ingestion-${var.name_base}"
  resource_group_name     = var.resource_group_name
  location                = var.location
  description             = "OBS-06 : volume ingéré sur 24 h au-dessus du seuil."
  severity                = 2
  scopes                  = [var.workspace_id]
  evaluation_frequency    = "PT1H"
  window_duration         = "P1D"
  tags                    = local.tags
  auto_mitigation_enabled = true

  criteria {
    query                   = <<-KQL
      Usage
      | where IsBillable
      | summarize gb = sum(Quantity) / 1024.0
      | where gb > ${var.ingestion_alert_gb}
    KQL
    time_aggregation_method = "Count"
    operator                = "GreaterThan"
    threshold               = 0
    failing_periods {
      minimum_failing_periods_to_trigger_alert = 1
      number_of_evaluation_periods             = 1
    }
  }

  action {
    action_groups = [azurerm_monitor_action_group.this.id]
  }
}

# RES-03 : consommation du quota de tokens d'un déploiement au-delà de 80 % de sa capacité.
# Métrique « TokenTransaction » de Foundry (à confirmer au premier déploiement, PO-04).
resource "azurerm_monitor_metric_alert" "model_quota" {
  for_each            = var.model_deployments
  name                = "alrt-quota-${each.key}-${var.name_base}"
  resource_group_name = var.resource_group_name
  scopes              = [var.foundry_account_id]
  description         = "RES-03 : tokens par minute du déploiement ${each.key} au-delà de ${var.quota_alert_percent} % de sa capacité."
  severity            = 2
  frequency           = "PT1M"
  window_size         = "PT5M"
  tags                = local.tags

  criteria {
    metric_namespace = "Microsoft.CognitiveServices/accounts"
    metric_name      = "TokenTransaction"
    aggregation      = "Total"
    operator         = "GreaterThan"
    # capacité en milliers de TPM x 1000 x 5 minutes x seuil
    threshold = each.value * 1000 * 5 * var.quota_alert_percent / 100

    dimension {
      name     = "ModelDeploymentName"
      operator = "Include"
      values   = [each.key]
    }
  }

  action {
    action_group_id = azurerm_monitor_action_group.this.id
  }
}

output "action_group_id" {
  value = azurerm_monitor_action_group.this.id
}
