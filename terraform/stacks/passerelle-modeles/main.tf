# État « passerelle et modèles » : Foundry, déploiements, API Management, Model Gateway, alertes.
# Les ressources des autres états sont retrouvées par leur nom (convention du module catalog).

variable "environment" {
  type = string
}
variable "catalog_path" {
  type = string
}
variable "api_path" {
  description = "Chemin du dossier api/ (policies et spécifications)."
  type        = string
}
variable "gateway_api_client_id" {
  description = "Identifiant client de l'application Entra « API passerelle » de l'environnement (sortie du bootstrap, variable GitHub GATEWAY_API_CLIENT_ID_<ENV>)."
  type        = string
}
variable "token_metrics_enabled" {
  description = "Fragment metriques-tokens (PO-12)."
  type        = bool
  default     = true
}

module "catalog" {
  source       = "../../modules/catalog"
  catalog_path = var.catalog_path
  environment  = var.environment
}

locals {
  name = module.catalog.name
}

data "azurerm_resource_group" "env" {
  name = local.name.resource_group
}

data "azurerm_key_vault" "env" {
  name                = "kv-${local.name.base}"
  resource_group_name = data.azurerm_resource_group.env.name
}

data "azurerm_log_analytics_workspace" "env" {
  name                = "log-${local.name.base}"
  resource_group_name = data.azurerm_resource_group.env.name
}

data "azurerm_application_insights" "env" {
  name                = "appi-${local.name.base}"
  resource_group_name = data.azurerm_resource_group.env.name
}

module "foundry" {
  source              = "../../modules/foundry-core"
  name_base           = local.name.base
  custom_subdomain    = "aif-${local.name.base}"
  resource_group_name = data.azurerm_resource_group.env.name
  location            = module.catalog.location
  tags                = module.catalog.tags
  content_filter      = module.catalog.commun.content_filter
}

module "models" {
  source               = "../../modules/model-deployment"
  cognitive_account_id = module.foundry.id
  rai_policy_name      = module.foundry.rai_policy_name
  models               = module.catalog.models
}

module "apim" {
  source                                 = "../../modules/apim-core"
  name_base                              = local.name.base
  resource_group_name                    = data.azurerm_resource_group.env.name
  location                               = module.catalog.location
  tags                                   = module.catalog.tags
  publisher_name                         = module.catalog.env.gateway.publisher_name
  publisher_email                        = module.catalog.env.gateway.publisher_email
  application_insights_id                = data.azurerm_application_insights.env.id
  application_insights_connection_string = data.azurerm_application_insights.env.connection_string
  named_values = {
    tenant-id          = module.catalog.tenant_id
    environment        = var.environment
    default-company-id = module.catalog.commun.platform.default_company_id
    offer-id           = module.catalog.commun.tags.offer
    metrics-namespace  = module.catalog.commun.platform.prefix
  }
}

module "model_gateway" {
  source                      = "../../modules/model-gateway"
  resource_group_name         = data.azurerm_resource_group.env.name
  api_management_id           = module.apim.id
  api_management_name         = module.apim.name
  api_management_principal_id = module.apim.principal_id
  logger_id                   = module.apim.logger_id
  named_value_dependencies    = module.apim.named_value_ids
  policies_path               = "${var.api_path}/policies"
  specification_path          = "${var.api_path}/specifications/model-gateway.openapi.yaml"
  foundry_account_id          = module.foundry.id
  foundry_openai_endpoint     = module.foundry.openai_endpoint
  gateway_audience            = var.gateway_api_client_id
  models                      = module.catalog.models
  applications                = module.catalog.env.applications
  gateway_policy              = module.catalog.commun.gateway_policy
  token_metrics_enabled       = var.token_metrics_enabled
  key_vault_id                = data.azurerm_key_vault.env.id
  tags                        = module.catalog.tags
  depends_on                  = [module.models]
}

module "alerting" {
  source              = "../../modules/alerting"
  name_base           = local.name.base
  resource_group_name = data.azurerm_resource_group.env.name
  location            = module.catalog.location
  tags                = module.catalog.tags
  workspace_id        = data.azurerm_log_analytics_workspace.env.id
  thresholds          = module.catalog.env.alerting
  ingestion_alert_gb  = module.catalog.env.observability.ingestion_alert_gb
  foundry_account_id  = module.foundry.id
  model_deployments   = module.models.capacities
}

output "gateway_base_url" {
  description = "URL de base à donner aux consommateurs (DEX-01)."
  value       = "${module.apim.gateway_url}/${module.model_gateway.api_base_url}"
}
output "foundry_name" {
  value = module.foundry.name
}
output "subscription_key_secrets" {
  value = module.model_gateway.subscription_key_secret_names
}
