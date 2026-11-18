locals {
  commun = yamldecode(file("${var.catalog_path}/environments/commun.yaml"))

  # Un fichier par environnement, hors commun.yaml (CAT-03 : la liste vient du catalogue).
  environments = {
    for f in fileset("${var.catalog_path}/environments", "*.yaml") :
    trimsuffix(f, ".yaml") => yamldecode(file("${var.catalog_path}/environments/${f}"))
    if f != "commun.yaml"
  }

  # V1 : un seul abonnement (ADR-12). Il est lu dans le catalogue, jamais écrit en dur.
  subscription_ids = distinct([for e in local.environments : e.subscription_id])
  subscription_id  = local.subscription_ids[0]

  prefix    = local.commun.platform.prefix
  loc_short = local.commun.platform.location_short
  suffix    = local.commun.bootstrap.name_suffix
  repo_full = "${local.commun.github.owner}/${local.commun.github.repository}"

  base_tags = merge(local.commun.tags, {
    component   = "bootstrap"
    environment = "shared"
    criticality = "high"
  })

  env_tags = {
    for k, e in local.environments : k => merge(local.commun.tags, {
      environment = k
      component   = "platform"
      criticality = e.criticality
    })
  }

  # Sujets OIDC GitHub autorisés par environnement (ADR-13).
  # dev  : déploiement depuis l'environnement GitHub « dev », plans des demandes de changement,
  #        et tests rejoués lors des promotions (branches test et preprod, sans ressource Azure en V1).
  # prod : plan et déploiement depuis les environnements GitHub « prod-plan » et « prod » (branche main uniquement).
  # Fin du sujet OIDC (après le préfixe du dépôt), connue dès le plan : sert de clé.
  oidc_subjects = {
    for k, e in local.environments : k => concat(
      ["environment:${k}"],
      k == "prod" ? ["environment:prod-plan"] : [],
      e.github.plan_on_pull_request ? ["pull_request"] : [],
      e.github.plan_on_pull_request ? [for b in local.commun.github.branches.promotion : "ref:refs/heads/${b}"] : []
    )
  }

  oidc_credentials = merge([
    for k, subjects in local.oidc_subjects : {
      for s in subjects : "${k}|${s}" => { env = k, claim = s }
    }
  ]...)

  null_guid = "00000000-0000-0000-0000-000000000000"
}

resource "terraform_data" "catalog_checks" {
  lifecycle {
    precondition {
      condition     = length(local.subscription_ids) == 1
      error_message = "V1 (ADR-12) : tous les environnements doivent utiliser le même abonnement."
    }
    precondition {
      condition     = local.subscription_id != local.null_guid && local.commun.platform.tenant_id != local.null_guid
      error_message = "Renseigner tenant_id (commun.yaml) et subscription_id (dev.yaml, prod.yaml)."
    }
    precondition {
      condition     = !contains([local.commun.github.owner, local.commun.tags["cost-center"], local.commun.tags["service-id"]], "A_RENSEIGNER")
      error_message = "Renseigner github.owner, tags.cost-center et tags.service-id dans catalog/environments/commun.yaml."
    }
  }
}
