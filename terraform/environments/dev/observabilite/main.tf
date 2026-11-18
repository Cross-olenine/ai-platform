# Racine Terraform : environnement « dev », état « observabilite ».
# Identique d'un environnement à l'autre, à l'exception du nom d'environnement (contrôlé en CI).

terraform {
  required_version = ">= 1.9"

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 5.14"
    }
    random = {
      source  = "hashicorp/random"
      version = "~> 3.7"
    }
  }

  # resource_group_name et storage_account_name : -backend-config (variables GitHub TFSTATE_*).
  backend "azurerm" {
    use_azuread_auth = true
    container_name   = "dev"
    key              = "observabilite.tfstate"
  }
}

locals {
  environment  = "dev"
  catalog_path = "${path.root}/../../../../catalog"
  env_catalog  = yamldecode(file("${local.catalog_path}/environments/${local.environment}.yaml"))
}

provider "azurerm" {
  features {}
  subscription_id     = local.env_catalog.subscription_id # ADR-12 : paramètre d'environnement
  storage_use_azuread = true
}

module "stack" {
  source       = "../../../stacks/observabilite"
  environment  = local.environment
  catalog_path = local.catalog_path
}

output "stack" {
  value = module.stack
}
