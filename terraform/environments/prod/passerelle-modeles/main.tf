# Racine Terraform : environnement « prod », état « passerelle-modeles ».
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
    container_name   = "prod"
    key              = "passerelle-modeles.tfstate"
  }
}

locals {
  environment  = "prod"
  catalog_path = "${path.root}/../../../../catalog"
  env_catalog  = yamldecode(file("${local.catalog_path}/environments/${local.environment}.yaml"))
}

provider "azurerm" {
  features {}
  subscription_id     = local.env_catalog.subscription_id # ADR-12 : paramètre d'environnement
  storage_use_azuread = true
}

variable "gateway_api_client_id" {
  description = "Variable GitHub GATEWAY_API_CLIENT_ID_<ENV> (sortie du bootstrap), passée par TF_VAR_gateway_api_client_id."
  type        = string
}

variable "token_metrics_enabled" {
  type    = bool
  default = true
}

module "stack" {
  source                = "../../../stacks/passerelle-modeles"
  environment           = local.environment
  catalog_path          = local.catalog_path
  api_path              = "${path.root}/../../../../api"
  gateway_api_client_id = var.gateway_api_client_id
  token_metrics_enabled = var.token_metrics_enabled
}

output "stack" {
  value = module.stack
}
