# Bootstrap de la plateforme

Opération unique, faite à la main par un administrateur. Ensuite, plus personne n'applique Terraform à la main : les pipelines le font, par fédération OIDC, sans secret (ADR-13).

## Ce que crée `terraform/bootstrap`

| Élément | Exigences |
|---|---|
| Stockage des états Terraform : accès Entra uniquement, versioning, suppression réversible ; un conteneur par environnement | devops-genaiops.md |
| Un groupe de ressources par environnement | ADR-12 |
| Identité de pipeline par environnement : application Entra et fédération GitHub, sans secret. Droits limités à son groupe de ressources et à son état. Rôles attribuables limités à `governance.delegable_roles` | ADR-13 |
| Application Entra « API passerelle » par environnement, avec les rôles `utilisateur`, `admin-offre` et `exploitation` | IAM-01, IAM-03 |
| Azure Policy : régions autorisées et types de déploiement de modèles autorisés sur l'abonnement ; tags obligatoires sur les groupes de la plateforme (définition intégrée « Require a tag on resources », une affectation par tag, en évaluation seule tant que `tag_policy_effect` vaut `Audit`) | CMP-01, ADR-03, FIN-05 |
| Dépôt GitHub, règles de branches, environnements `dev`, `prod-plan` et `prod`, variables des pipelines | ADR-13 |

## Prérequis

1. **Connexions**, à lancer dans le terminal (ou dans Claude Code avec `! commande`) :
   - `az login --use-device-code`, puis `az account set --subscription <id>`.
     - Rôles requis sur l'abonnement : **Owner** (ou Contributor + User Access Administrator).
     - Rôle requis dans Entra ID : **Application Administrator** (ou Cloud Application Administrator).
   - `gh auth login`, avec les scopes `repo` et `workflow`, puis `export GITHUB_TOKEN=$(gh auth token)`.
2. **Catalogue** (`catalog/environments/`) : remplacer toutes les valeurs `A_RENSEIGNER` et les GUID nuls.
   - `commun.yaml` : `tenant_id`, `github.owner`, `tags.cost-center`, `tags.service-id`.
   - `dev.yaml` et `prod.yaml` : `subscription_id`, `gateway.publisher_email`, `budget.contact_emails`, `alerting.emails`.

   Terraform refuse de s'exécuter tant que des valeurs manquent (préconditions).
3. **Décision sur la visibilité du dépôt** (`github.visibility`) : voir `docs/suivi/a-faire-v1.md`, point 7.

## Déroulé

```bash
cd terraform/bootstrap

# 1. Premier passage avec un état local (fichier ignoré par Git).
cat > backend_local_override.tf <<'HCL'
terraform {
  backend "local" {}
}
HCL
terraform init
terraform apply                     # crée Azure, Entra ID et le dépôt GitHub (sans les règles de branches)

# 2. Migration de l'état vers le compte de stockage créé.
rm backend_local_override.tf
terraform init -migrate-state \
  -backend-config="resource_group_name=$(terraform output -raw tfstate_resource_group)" \
  -backend-config="storage_account_name=$(terraform output -raw tfstate_storage_account)" \
  -backend-config="container_name=bootstrap"
rm -f terraform.tfstate terraform.tfstate.backup

# 3. Pousser les quatre branches longues.
cd ../..
git remote add origin "$(terraform -chdir=terraform/bootstrap output -raw repository_clone_url)"
git push -u origin main
git push origin main:refs/heads/test main:refs/heads/preprod
git push -u origin develop          # déclenche le premier déploiement de dev

# 4. Second passage : branche par défaut, règles de branches, environnements.
terraform -chdir=terraform/bootstrap apply -var github_branches_pushed=true
```

L'ordre du point 3 compte : `main`, `test` et `preprod` partent du commit initial (sans pipeline), et seul le push de `develop` déclenche un déploiement. Ensuite, `test`, `preprod` et `main` rattrapent `develop` par le chemin normal des demandes de changement.

## Après le bootstrap

- La première fusion dans `develop` déploie l'environnement de développement (`deploy-dev.yml`).
- Pour donner accès à un utilisateur, ajouter son identifiant d'objet Entra dans `access.utilisateur` et dans `applications[].key_readers` du catalogue de l'environnement, puis appliquer à nouveau le bootstrap. Cela passe par une demande de changement, comme le reste.
- Le bootstrap n'est relancé que pour les éléments qu'il porte : identités, rôles applicatifs, policies, configuration GitHub.
