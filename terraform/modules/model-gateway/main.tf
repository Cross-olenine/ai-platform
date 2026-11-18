# Model Gateway (MGW-*, API-01 à API-04) : fragments, API Responses, produits et abonnements par application,
# accès à Foundry par identité managée uniquement (IAM-02). Terraform est la seule source de vérité (ADR-05).

variable "resource_group_name" {
  type = string
}
variable "api_management_id" {
  type = string
}
variable "api_management_name" {
  type = string
}
variable "api_management_principal_id" {
  type = string
}
variable "logger_id" {
  type = string
}
variable "named_value_dependencies" {
  type = list(string)
}
variable "policies_path" {
  description = "Chemin du dossier api/policies."
  type        = string
}
variable "specification_path" {
  description = "Chemin de la spécification OpenAPI de l'API."
  type        = string
}
variable "foundry_account_id" {
  type = string
}
variable "foundry_openai_endpoint" {
  type = string
}
variable "gateway_audience" {
  description = "Identifiant client de l'application Entra « API passerelle » (créée par le bootstrap)."
  type        = string
}
variable "models" {
  description = "Modèles actifs du catalogue (alias => entrée)."
  type        = any
}
variable "applications" {
  description = "Applications consommatrices du catalogue d'environnement."
  type        = any
}
variable "gateway_policy" {
  description = "Bloc gateway_policy de commun.yaml."
  type        = any
}
variable "token_metrics_enabled" {
  description = "Inclut le fragment metriques-tokens (llm-emit-token-metric). Désactivable si PO-12 montre qu'il est refusé en Consumption."
  type        = bool
  default     = true
}
variable "key_vault_id" {
  type = string
}
variable "tags" {
  type = map(string)
}

locals {
  fragments = {
    for f in fileset("${var.policies_path}/fragments", "*.xml") : trimsuffix(f, ".xml") => f
    if var.token_metrics_enabled || f != "metriques-tokens.xml"
  }

  # Les commentaires et l'indentation sont retirés : une policy assemblée est limitée à 16 Kio en Consumption (ADR-18).
  minify = { for k, f in local.fragments : k => replace(replace(file("${var.policies_path}/fragments/${f}"), "/<!--[\\s\\S]*?-->/", ""), "/\\n[\\t ]+/", "\n") }

  # alias|déploiement|max_output_tokens|max_request_kb|version (fragment liste-blanche-routage).
  model_routes = length(var.models) == 0 ? "none" : join(";", [
    for alias, m in var.models : join("|", [alias, m.deployment_name, tostring(m.max_output_tokens), tostring(m.max_request_kb), m.model_version])
  ])

  applications = { for a in var.applications : a.id => a }
}

resource "azurerm_api_management_named_value" "gateway" {
  for_each = {
    gateway-audience     = var.gateway_audience
    model-routes         = local.model_routes
    allowed-tool-types   = join(",", var.gateway_policy.allowed_tool_types)
    forbidden-parameters = length(var.gateway_policy.forbidden_parameters) == 0 ? "none" : join(",", var.gateway_policy.forbidden_parameters)
  }
  name                = each.key
  display_name        = each.key
  api_management_name = var.api_management_name
  resource_group_name = var.resource_group_name
  value               = each.value
}

# Les fragments référencent des named values créées par apim-core : elles doivent exister avant.
resource "terraform_data" "named_values" {
  input = var.named_value_dependencies
}

resource "azurerm_api_management_policy_fragment" "this" {
  for_each          = local.minify
  name              = each.key
  api_management_id = var.api_management_id
  format            = "xml"
  value             = each.value
  depends_on        = [azurerm_api_management_named_value.gateway, terraform_data.named_values]
}

# IAM-02 : seule l'identité de la passerelle peut appeler les modèles (PO-13).
resource "azurerm_role_assignment" "apim_to_foundry" {
  scope                = var.foundry_account_id
  role_definition_name = "Cognitive Services OpenAI User"
  principal_id         = var.api_management_principal_id
  principal_type       = "ServicePrincipal"
}

resource "azurerm_api_management_backend" "foundry" {
  name                = "foundry-openai"
  api_management_name = var.api_management_name
  resource_group_name = var.resource_group_name
  protocol            = "http"
  url                 = var.foundry_openai_endpoint
  description         = "Foundry, API OpenAI v1. Jamais exposé aux consommateurs (MGW-07)."
}

resource "azurerm_api_management_api" "model_gateway" {
  name                  = "model-gateway"
  api_management_name   = var.api_management_name
  resource_group_name   = var.resource_group_name
  revision              = "1"
  display_name          = "Model Gateway"
  path                  = "model-gateway/v1"
  protocols             = ["https"]
  subscription_required = true # ADR-18 : la clé identifie l'application (limites MGW-03)

  subscription_key_parameter_names {
    header = "Ocp-Apim-Subscription-Key"
    query  = "subscription-key"
  }

  import {
    content_format = "openapi"
    content_value  = file(var.specification_path)
  }
}

locals {
  api_policy = replace(templatefile("${var.policies_path}/model-gateway/api.xml.tftpl", {
    token_metrics_enabled   = var.token_metrics_enabled
    backend_audience        = "https://cognitiveservices.azure.com"
    backend_timeout_seconds = var.gateway_policy.backend_timeout_seconds
  }), "/<!--[\\s\\S]*?-->/", "")

  product_policies = {
    for k, a in local.applications : k => replace(templatefile("${var.policies_path}/model-gateway/produit.xml.tftpl", {
      application_id   = k
      channel          = a.channel
      allowed_models   = join(",", a.allowed_models)
      calls_per_minute = a.limits.calls_per_minute
      calls_per_period = a.limits.calls_per_period
      period_seconds   = a.limits.period_seconds
    }), "/<!--[\\s\\S]*?-->/", "")
  }

  # Estimation prudente de la policy assemblée : chaque inclusion d'un fragment compte (ADR-18 : 16 Kio).
  assembled_policy_bytes = length(local.api_policy) + max(concat([0], [for p in local.product_policies : length(p)])...) + sum(concat([0], [
    for k, xml in local.minify : length(xml) * length(regexall("fragment-id=\"${k}\"", local.api_policy))
  ]))
}

resource "azurerm_api_management_api_policy" "model_gateway" {
  api_name            = azurerm_api_management_api.model_gateway.name
  api_management_name = var.api_management_name
  resource_group_name = var.resource_group_name
  xml_content         = local.api_policy
  depends_on          = [azurerm_api_management_policy_fragment.this, azurerm_api_management_backend.foundry]

  lifecycle {
    precondition {
      condition     = local.assembled_policy_bytes < 16384
      error_message = "ADR-18 : la policy assemblée dépasserait 16 Kio (niveau Consumption). Réduire les fragments."
    }
  }
}

# OBS-03, OBS-05 : télémétrie de requêtes et traces vers Application Insights, sans corps de requête ni de réponse.
resource "azurerm_api_management_api_diagnostic" "model_gateway" {
  identifier                = "applicationinsights"
  api_name                  = azurerm_api_management_api.model_gateway.name
  api_management_name       = var.api_management_name
  resource_group_name       = var.resource_group_name
  api_management_logger_id  = var.logger_id
  sampling_percentage       = 100
  always_log_errors         = true
  log_client_ip             = false
  verbosity                 = "information"
  http_correlation_protocol = "W3C"
  metrics_enabled           = true

  frontend_request {
    body_bytes = 0
  }
  frontend_response {
    body_bytes = 0
  }
  backend_request {
    body_bytes = 0
  }
  backend_response {
    body_bytes = 0
  }
}

# MGW-03 : un produit et un abonnement par application ; limites dans la policy du produit.
resource "azurerm_api_management_product" "app" {
  for_each              = local.applications
  product_id            = each.key
  display_name          = each.value.display_name
  description           = "Application ${each.value.display_name} (propriétaire : ${each.value.owner})."
  api_management_name   = var.api_management_name
  resource_group_name   = var.resource_group_name
  subscription_required = true
  approval_required     = false
  published             = true
}

resource "azurerm_api_management_product_api" "app" {
  for_each            = local.applications
  product_id          = azurerm_api_management_product.app[each.key].product_id
  api_name            = azurerm_api_management_api.model_gateway.name
  api_management_name = var.api_management_name
  resource_group_name = var.resource_group_name
}

resource "azurerm_api_management_product_policy" "app" {
  for_each            = local.applications
  product_id          = azurerm_api_management_product.app[each.key].product_id
  api_management_name = var.api_management_name
  resource_group_name = var.resource_group_name
  xml_content         = local.product_policies[each.key]
}

resource "azurerm_api_management_subscription" "app" {
  for_each            = local.applications
  display_name        = each.value.display_name
  api_management_name = var.api_management_name
  resource_group_name = var.resource_group_name
  product_id          = azurerm_api_management_product.app[each.key].id
  state               = "active"
  allow_tracing       = false
}

# KV-02, KV-03 : la clé d'abonnement n'est ni dans Git ni dans les pipelines ; elle est lue dans le Key Vault.
resource "azurerm_key_vault_secret" "subscription_key" {
  for_each     = local.applications
  name         = "apim-subscription-key-${each.key}"
  key_vault_id = var.key_vault_id
  value        = azurerm_api_management_subscription.app[each.key].primary_key
  content_type = "Clé d'abonnement API Management (identifie l'application, n'authentifie pas)"
  tags         = merge(var.tags, { component = "model-gateway" })
}

resource "azurerm_role_assignment" "subscription_key_readers" {
  for_each = merge([
    for app_id, a in local.applications : { for oid in a.key_readers : "${app_id}|${oid}" => { app = app_id, principal = oid } }
  ]...)
  scope                = "${var.key_vault_id}/secrets/${azurerm_key_vault_secret.subscription_key[each.value.app].name}"
  role_definition_name = "Key Vault Secrets User"
  principal_id         = each.value.principal
}

output "api_base_url" {
  value = azurerm_api_management_api.model_gateway.path
}
output "subscription_key_secret_names" {
  value = { for k, s in azurerm_key_vault_secret.subscription_key : k => s.name }
}

output "api_policy_xml" {
  description = "Policy de l'API telle que déployée (tests)."
  value       = local.api_policy
}
output "product_policy_xml" {
  value = local.product_policies
}
output "model_routes" {
  value = local.model_routes
}
output "assembled_policy_bytes" {
  value = local.assembled_policy_bytes
}
