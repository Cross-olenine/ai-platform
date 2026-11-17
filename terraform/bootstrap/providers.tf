provider "azurerm" {
  features {}
  subscription_id     = local.subscription_id
  tenant_id           = local.commun.platform.tenant_id
  storage_use_azuread = true
}

provider "azuread" {
  tenant_id = local.commun.platform.tenant_id
}

# Jeton lu dans GITHUB_TOKEN (export GITHUB_TOKEN=$(gh auth token)), jamais écrit dans un fichier.
provider "github" {
  owner = local.commun.github.owner
}
