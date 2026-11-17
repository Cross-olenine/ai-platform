# Dépôt GitHub, branches protégées, environnements et variables des pipelines (ADR-13).
# Deux passages : 1) création du dépôt ; 2) après le push des branches, -var github_branches_pushed=true.

locals {
  gh           = local.commun.github
  all_branches = concat([local.gh.branches.integration], local.gh.branches.promotion, [local.gh.branches.production])
  github_envs = {
    dev       = { azure_env = "dev", branch = local.environments["dev"].github.deploy_branch, reviewers = false }
    prod-plan = { azure_env = "prod", branch = local.environments["prod"].github.deploy_branch, reviewers = false }
    prod      = { azure_env = "prod", branch = local.environments["prod"].github.deploy_branch, reviewers = true }
  }
}

resource "github_repository" "platform" {
  name                   = local.gh.repository
  description            = "Plateforme de services IA : infrastructure as code (Terraform), catalogues, policies."
  visibility             = local.gh.visibility
  has_issues             = true
  has_wiki               = false
  has_projects           = false
  allow_merge_commit     = true # promotions develop -> test -> preprod -> main (même arbre)
  allow_squash_merge     = true # feature/* -> develop
  allow_rebase_merge     = false
  delete_branch_on_merge = true
  auto_init              = false
}

resource "github_repository_vulnerability_alerts" "platform" {
  repository = github_repository.platform.name
  enabled    = true
}

resource "github_branch_default" "platform" {
  count      = var.github_branches_pushed ? 1 : 0
  repository = github_repository.platform.name
  branch     = local.gh.branches.integration
}

resource "github_repository_ruleset" "branches" {
  count       = var.github_branches_pushed ? 1 : 0
  name        = "branches-longues"
  repository  = github_repository.platform.name
  target      = "branch"
  enforcement = "active"

  conditions {
    ref_name {
      include = [for b in local.all_branches : "refs/heads/${b}"]
      exclude = []
    }
  }

  rules {
    deletion         = true
    non_fast_forward = true

    pull_request {
      required_approving_review_count   = local.gh.required_approvals
      dismiss_stale_reviews_on_push     = true
      required_review_thread_resolution = true
    }

    required_status_checks {
      strict_required_status_checks_policy = false
      required_check {
        context = local.gh.required_status_check
      }
    }
  }
}

data "github_user" "prod_reviewer" {
  for_each = toset(local.gh.prod_reviewers)
  username = each.value
}

resource "github_repository_environment" "env" {
  for_each            = local.github_envs
  repository          = github_repository.platform.name
  environment         = each.key
  can_admins_bypass   = false
  prevent_self_review = each.value.reviewers

  dynamic "reviewers" {
    for_each = each.value.reviewers && length(local.gh.prod_reviewers) > 0 ? [1] : []
    content {
      users = [for u in data.github_user.prod_reviewer : tonumber(u.id)]
    }
  }

  deployment_branch_policy {
    protected_branches     = false
    custom_branch_policies = true
  }
}

resource "github_repository_environment_deployment_policy" "env" {
  for_each       = local.github_envs
  repository     = github_repository.platform.name
  environment    = github_repository_environment.env[each.key].environment
  branch_pattern = each.value.branch
}

# Variables des pipelines : identifiants non secrets (fédération OIDC, aucun secret stocké).
locals {
  repo_variables = merge(
    {
      AZURE_TENANT_ID         = local.commun.platform.tenant_id
      AZURE_SUBSCRIPTION_ID   = local.subscription_id
      TFSTATE_RESOURCE_GROUP  = azurerm_resource_group.tfstate.name
      TFSTATE_STORAGE_ACCOUNT = azurerm_storage_account.tfstate.name
    },
    merge([
      for k in keys(local.environments) : {
        "AZURE_CLIENT_ID_${upper(k)}"       = azuread_application.pipeline[k].client_id
        "GATEWAY_API_CLIENT_ID_${upper(k)}" = azuread_application.gateway_api[k].client_id
        "RESOURCE_GROUP_${upper(k)}"        = azurerm_resource_group.env[k].name
      }
    ]...)
  )
}

resource "github_actions_variable" "platform" {
  for_each      = local.repo_variables
  repository    = github_repository.platform.name
  variable_name = each.key
  value         = each.value
}
