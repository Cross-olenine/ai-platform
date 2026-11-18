# Plateforme de services IA

Blocs partagés pour les cas d'usage IA de la société : accès gouverné aux modèles, identité, quotas, observabilité, FinOps. Infrastructure entièrement décrite en Terraform à partir de catalogues YAML.

**Version en cours : V1 — Socle minimal** (`docs/architecture/v1-socle-minimal.md`). Premier cas d'usage : OpenCode (C6) derrière la passerelle API Management.

| Dossier | Contenu |
|---|---|
| `catalog/` | Catalogues versionnés : environnements, modèles, agents (et leurs schémas) |
| `terraform/bootstrap/` | Socle hors pipelines : états, identités OIDC, Entra ID, Azure Policy, GitHub |
| `terraform/environments/<env>/<état>/` | Racines appliquées par les pipelines (socle, observabilite, passerelle-modeles) |
| `terraform/stacks/`, `terraform/modules/` | Composition des états et modules réutilisables |
| `api/` | Spécification OpenAPI, fragments de policy, tests de la passerelle |
| `adapters/opencode/` | Configuration centrale d'OpenCode, générée depuis les catalogues |
| `scripts/` | Scripts de CI et de poste développeur |
| `.github/workflows/` | Pipelines GitHub Actions |
| `docs/` | Documentation de référence (commencer par `docs/README.md` et `AGENTS.md`) |

**Démarrer :**
- bootstrap : `docs/operations/bootstrap.md` ;
- déployer un changement : `docs/operations/deploiement.md` ;
- utiliser OpenCode : `adapters/opencode/README.md`.
