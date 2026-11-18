# KV-01 : un Key Vault par environnement, en mode RBAC, accessible par identité managée.

variable "name" {
  type = string
}
variable "resource_group_name" {
  type = string
}
variable "location" {
  type = string
}
variable "tenant_id" {
  type = string
}
variable "tags" {
  type = map(string)
}
variable "secrets_officer_principal_ids" {
  description = "Identités autorisées à écrire des secrets (identité de pipeline)."
  type        = list(string)
  default     = []
}
variable "purge_protection_enabled" {
  description = "Protection contre la purge. Désactivable en développement pour permettre la reconstruction complète."
  type        = bool
}

resource "azurerm_key_vault" "this" {
  name                          = var.name
  resource_group_name           = var.resource_group_name
  location                      = var.location
  tenant_id                     = var.tenant_id
  sku_name                      = "standard"
  rbac_authorization_enabled    = true
  purge_protection_enabled      = var.purge_protection_enabled
  soft_delete_retention_days    = 7
  public_network_access_enabled = true # ADR-07 : réseau privé en V2
  tags                          = merge(var.tags, { component = "key-vault" })
}

resource "azurerm_role_assignment" "secrets_officer" {
  for_each             = toset(var.secrets_officer_principal_ids)
  scope                = azurerm_key_vault.this.id
  role_definition_name = "Key Vault Secrets Officer"
  principal_id         = each.value
}

output "id" {
  value = azurerm_key_vault.this.id
}
output "name" {
  value = azurerm_key_vault.this.name
}
output "uri" {
  value = azurerm_key_vault.this.vault_uri
}
