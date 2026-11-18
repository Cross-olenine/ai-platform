# API Management, niveau Consumption (ADR-18), identité managée système (IAM-02),
# journalisation vers Application Insights (seule option en Consumption) et named values communes (API-03).

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
variable "publisher_name" {
  type = string
}
variable "publisher_email" {
  type = string
}
variable "application_insights_id" {
  type = string
}
variable "application_insights_connection_string" {
  type      = string
  sensitive = true
}
variable "named_values" {
  description = "Named values non secrètes communes à toutes les API (nom => valeur)."
  type        = map(string)
}

resource "azurerm_api_management" "this" {
  name                = "apim-${var.name_base}"
  resource_group_name = var.resource_group_name
  location            = var.location
  publisher_name      = var.publisher_name
  publisher_email     = var.publisher_email
  sku_name            = "Consumption_0" # ADR-18
  tags                = merge(var.tags, { component = "apim" })

  identity {
    type = "SystemAssigned"
  }
}

resource "azurerm_api_management_logger" "appinsights" {
  name                = "appinsights"
  api_management_name = azurerm_api_management.this.name
  resource_group_name = var.resource_group_name
  resource_id         = var.application_insights_id

  application_insights {
    connection_string = var.application_insights_connection_string
  }
}

# Sel de pseudonymisation des utilisateurs (FIN-01) : secret généré, jamais dans Git (KV-02).
resource "random_password" "user_hash_salt" {
  length  = 32
  special = false
}

resource "azurerm_api_management_named_value" "secret_salt" {
  name                = "user-hash-salt"
  display_name        = "user-hash-salt"
  api_management_name = azurerm_api_management.this.name
  resource_group_name = var.resource_group_name
  value               = random_password.user_hash_salt.result
  secret              = true
}

resource "azurerm_api_management_named_value" "this" {
  for_each            = var.named_values
  name                = each.key
  display_name        = each.key
  api_management_name = azurerm_api_management.this.name
  resource_group_name = var.resource_group_name
  value               = each.value
}

output "id" {
  value = azurerm_api_management.this.id
}
output "name" {
  value = azurerm_api_management.this.name
}
output "gateway_url" {
  value = azurerm_api_management.this.gateway_url
}
output "principal_id" {
  value = azurerm_api_management.this.identity[0].principal_id
}
output "logger_id" {
  value = azurerm_api_management_logger.appinsights.id
}
output "named_value_ids" {
  description = "Dépendances à poser avant les fragments qui référencent ces named values."
  value       = concat([for nv in azurerm_api_management_named_value.this : nv.id], [azurerm_api_management_named_value.secret_salt.id])
}
