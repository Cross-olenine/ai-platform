# Lit les catalogues YAML (CAT-02, CAT-03) et expose une configuration fusionnée pour un environnement.
# Aucun effet de bord : ce module ne crée aucune ressource Azure.

terraform {
  required_version = ">= 1.9"
}

variable "catalog_path" {
  description = "Chemin du dossier catalog/."
  type        = string
}

variable "environment" {
  description = "Nom de l'environnement (fichier catalog/environments/<environment>.yaml)."
  type        = string
}

locals {
  commun = yamldecode(file("${var.catalog_path}/environments/commun.yaml"))
  env    = yamldecode(file("${var.catalog_path}/environments/${var.environment}.yaml"))

  all_models = {
    for f in fileset("${var.catalog_path}/models", "*.yaml") :
    trimsuffix(f, ".yaml") => yamldecode(file("${var.catalog_path}/models/${f}"))
  }

  # Seuls les modèles actifs sont déployés et routés (MGW-02 : liste blanche).
  # La capacité est résolue pour l'environnement demandé (quota partagé entre environnements).
  active_models = {
    # Valeurs par défaut : kind = chat (ADR-19) ; tokens de sortie et tarifs absents d'un embedding = 0.
    for k, m in local.all_models : m.alias => merge(m, {
      kind              = try(m.kind, "chat")
      max_output_tokens = try(m.max_output_tokens, 0)
      pricing           = merge({ cached_input = 0, output = 0 }, m.pricing)
      limits            = merge(m.limits, { capacity_thousand_tpm = try(m.limits.capacity_thousand_tpm[var.environment], 0) })
    }) if m.status == "active"
  }

  prefix    = local.commun.platform.prefix
  loc_short = local.commun.platform.location_short

  # Convention de nommage : <type>-<prefix>-<env>-<région>-<suffixe>.
  name = {
    resource_group = "rg-${local.prefix}-${var.environment}-${local.loc_short}-${local.env.name_suffix}"
    base           = "${local.prefix}-${var.environment}-${local.loc_short}-${local.env.name_suffix}"
    compact        = "${local.prefix}${var.environment}${local.loc_short}${local.env.name_suffix}"
  }

  tags = merge(local.commun.tags, {
    environment = var.environment
    criticality = local.env.criticality
  })

  null_guid = "00000000-0000-0000-0000-000000000000"
}

# CAT-04 : refus des entrées incomplètes (doublé par les schémas JSON en CI).
resource "terraform_data" "checks" {
  lifecycle {
    precondition {
      condition     = local.env.name == var.environment
      error_message = "Le champ name de catalog/environments/${var.environment}.yaml ne correspond pas à l'environnement."
    }
    precondition {
      condition     = local.env.subscription_id != local.null_guid && local.commun.platform.tenant_id != local.null_guid
      error_message = "Renseigner tenant_id (commun.yaml) et subscription_id (${var.environment}.yaml)."
    }
    precondition {
      condition     = !strcontains(jsonencode([local.commun.tags, local.env.gateway, local.env.budget, local.env.alerting]), "A_RENSEIGNER")
      error_message = "Des valeurs « A_RENSEIGNER » restent dans catalog/environments/ (tags, gateway, budget, alerting)."
    }
    precondition {
      condition = alltrue([
        # Un embedding (ADR-19) n'a pas de tokens de sortie : seul le tarif d'entrée est exigé.
        for m in local.active_models : m.model != "A_CHOISIR" && m.owner != "" && m.pricing.input > 0 && (m.kind == "embedding" || m.pricing.output > 0) && m.limits.capacity_thousand_tpm > 0
      ])
      error_message = "CAT-04 : un modèle actif doit avoir un modèle choisi, un propriétaire, un tarif et une limite."
    }
    precondition {
      condition = alltrue([
        for m in local.active_models : m.kind == "embedding" ? m.protocol == "embeddings" : (m.protocol == "responses" && try(m.max_output_tokens, 0) > 0)
      ])
      error_message = "ADR-06, ADR-19 : un chat utilise le protocole responses avec un plafond de sortie, un embedding le protocole embeddings."
    }
    precondition {
      condition     = alltrue([for m in local.active_models : contains(local.commun.governance.allowed_model_deployment_types, m.deployment_type)])
      error_message = "ADR-03 : type de déploiement de modèle non autorisé."
    }
    precondition {
      condition = alltrue(flatten([
        for a in local.env.applications : [for alias in a.allowed_models : contains(keys(local.all_models), alias)]
      ]))
      error_message = "Une application référence un alias absent du catalogue des modèles."
    }
  }
}

output "commun" {
  value = local.commun
}

output "env" {
  value = local.env
}

output "models" {
  description = "Modèles actifs, indexés par alias."
  value       = local.active_models
}

output "name" {
  value = local.name
}

output "tags" {
  description = "Tags obligatoires communs (FIN-05) ; chaque module ajoute « component »."
  value       = local.tags
}

output "location" {
  value = local.commun.platform.location
}

output "tenant_id" {
  value = local.commun.platform.tenant_id
}
