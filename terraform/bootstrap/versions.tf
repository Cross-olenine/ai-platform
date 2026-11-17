terraform {
  required_version = ">= 1.9"

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 5.14"
    }
    azuread = {
      source  = "hashicorp/azuread"
      version = "~> 3.10"
    }
    github = {
      source  = "integrations/github"
      version = "~> 6.13"
    }
    random = {
      source  = "hashicorp/random"
      version = "~> 3.7"
    }
  }

  # Premier passage : état local via backend_local_override.tf (ignoré par Git),
  # puis migration dans le compte de stockage créé ici. Voir docs/operations/bootstrap.md.
  backend "azurerm" {
    use_azuread_auth = true
    key              = "bootstrap.tfstate"
  }
}
