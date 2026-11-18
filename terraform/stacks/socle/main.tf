# État « socle » (devops-genaiops.md, 3 états en V1) : Key Vault et budget de l'environnement.
# Le groupe de ressources est créé par terraform/bootstrap (droits du pipeline limités à ce groupe).

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

data "azurerm_client_config" "current" {}

data "azurerm_resource_group" "env" {
  name = module.catalog.name.resource_group
}

module "key_vault" {
  source                        = "../../modules/key-vault"
  name                          = "kv-${module.catalog.name.base}"
  resource_group_name           = data.azurerm_resource_group.env.name
  location                      = module.catalog.location
  tenant_id                     = module.catalog.tenant_id
  tags                          = module.catalog.tags
  purge_protection_enabled      = module.catalog.env.key_vault.purge_protection
  secrets_officer_principal_ids = [data.azurerm_client_config.current.object_id]
}

# FIN-03 : budget par environnement. Notification seulement ; aucun blocage (FIN-04).
resource "azurerm_consumption_budget_resource_group" "env" {
  name              = "budget-${module.catalog.name.base}"
  resource_group_id = data.azurerm_resource_group.env.id
  amount            = module.catalog.env.budget.monthly_amount_eur
  time_grain        = "Monthly"

  time_period {
    start_date = formatdate("YYYY-MM-01'T'00:00:00Z", plantimestamp())
  }

  dynamic "notification" {
    for_each = toset(module.catalog.env.budget.thresholds_percent)
    content {
      enabled        = true
      threshold      = notification.value
      operator       = "GreaterThanOrEqualTo"
      threshold_type = "Actual"
      contact_emails = module.catalog.env.budget.contact_emails
      contact_roles  = ["Owner"]
    }
  }

  lifecycle {
    ignore_changes = [time_period]
  }
}

output "key_vault_name" {
  value = module.key_vault.name
}
