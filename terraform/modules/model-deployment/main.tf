# Un déploiement par alias actif du catalogue (MGW-01, CAT-03), en Data Zone EU (ADR-03, CMP-01).

variable "cognitive_account_id" {
  type = string
}
variable "rai_policy_name" {
  type = string
}
variable "models" {
  description = "Modèles actifs du catalogue (alias => entrée)."
  type        = any
}

resource "azurerm_cognitive_deployment" "this" {
  for_each               = var.models
  name                   = each.value.deployment_name
  cognitive_account_id   = var.cognitive_account_id
  rai_policy_name        = var.rai_policy_name # GRD-01, GRD-02
  version_upgrade_option = "NoAutoUpgrade"     # un changement de version passe par le catalogue

  model {
    format  = each.value.model_format
    name    = each.value.model
    version = each.value.model_version
  }

  sku {
    name     = each.value.deployment_type
    capacity = each.value.limits.capacity_thousand_tpm
  }

  # Changement de modèle derrière un alias : le nouveau déploiement existe avant la suppression de l'ancien.
  lifecycle {
    create_before_destroy = true
  }
}

output "deployments" {
  description = "alias => nom du déploiement"
  value       = { for alias, d in azurerm_cognitive_deployment.this : alias => d.name }
}

output "capacities" {
  description = "nom du déploiement => capacité (milliers de tokens par minute)"
  value       = { for alias, m in var.models : m.deployment_name => m.limits.capacity_thousand_tpm }
}
