# État « observabilite » : Log Analytics, Application Insights, fonctions KQL et tableau de bord FinOps.

variable "environment" {
  type = string
}
variable "catalog_path" {
  type = string
}

module "catalog" {
  source       = "../../modules/catalog"
  catalog_path = var.catalog_path
  environment  = var.environment
}

data "azurerm_resource_group" "env" {
  name = module.catalog.name.resource_group
}

module "observability" {
  source              = "../../modules/observability"
  name_base           = module.catalog.name.base
  resource_group_name = data.azurerm_resource_group.env.name
  location            = module.catalog.location
  tags                = module.catalog.tags
  retention_days      = module.catalog.env.observability.retention_days
  daily_quota_gb      = module.catalog.env.observability.daily_quota_gb
  models              = module.catalog.models
}

output "workspace_name" {
  value = module.observability.workspace_name
}
output "application_insights_name" {
  value = module.observability.application_insights_name
}
