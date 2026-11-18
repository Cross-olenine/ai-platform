# Plateforme de services IA — instructions pour les agents de code

Ce fichier est chargé à chaque session. Il reste court : le détail est dans `docs/`, à lire selon la tâche (voir la carte plus bas).

## Le projet

Plateforme Azure qui fournit aux cas d'usage IA de la société des blocs partagés : accès gouverné aux modèles, exécution d'agents, identité, quotas, observabilité, FinOps. Un nouveau cas d'usage assemble ces blocs et ne développe que sa dernière couche (interface, adaptateur de canal, règles métier).

Trois mots d'ordre guident tout arbitrage : **automatisation et réutilisation**, **coûts réduits**, **solidité**.

## État actuel

- **Version en cours : V1 — Socle minimal.** Périmètre : `docs/architecture/v1-socle-minimal.md`.
- Mettre cette ligne à jour à chaque passage de version.

## Règles impératives

1. **Ne rien construire au-delà de la version en cours.** Les exigences marquées V2, V3 ou V4 et `docs/architecture/cible.md` sont une référence pour ne fermer aucune porte, pas une liste de tâches.
2. **Ne jamais trancher seul une décision ouverte.** Si la tâche dépend d'un ADR au statut `Ouverte` dans `docs/decisions/`, exposer les options et demander.
3. **Natif Azure avant développement.** Tout code spécifique à maintenir se justifie par écrit.
4. **Aucune valeur en dur** dans une policy ou un module : ni nom de modèle, ni société, ni limite, ni URL. Tout vient d'un catalogue ou d'un paramètre.
5. **Aucun secret dans Git**, dans une variable de pipeline ou dans une policy.
6. **Un seul point de passage vers les modèles :** la passerelle. Aucun appel direct à Foundry.
7. **Documentation dans le même changement que le code.** Mettre à jour le statut des exigences traitées dans `docs/exigences/`.
8. **Citer les identifiants d'exigences** (par exemple `MGW-03`) dans les messages de commit et les demandes de changement.
9. **Ne jamais renuméroter une exigence ou un ADR.** Une nouvelle entrée prend le numéro suivant.
10. **Vérifier la documentation Azure à jour** avant d'affirmer qu'une fonction existe ou est disponible. Les produits concernés évoluent vite ; voir `docs/suivi/a-faire-v1.md`.

## Carte de la documentation

| Pour… | Lire… |
|---|---|
| Comprendre le but et ce qui est hors périmètre | `docs/01-objet-perimetre.md` |
| Arbitrer un choix de conception | `docs/02-principes.md` |
| Savoir ce qu'une version autorise pour un cas d'usage | `docs/03-modele-maturite.md` |
| Savoir quoi construire maintenant | `docs/architecture/v1-socle-minimal.md` |
| Vérifier qu'un choix reste compatible avec la suite | `docs/architecture/cible.md`, `docs/architecture/matrice-couverture.md` |
| Toucher à une API, un alias, un événement d'usage, une fiche d'agent | `docs/architecture/contrats.md` |
| Travailler sur un bloc précis | Le fichier du bloc dans `docs/exigences/` (index : `docs/exigences/README.md`) |
| Écrire un pipeline, un test, une évaluation | `docs/pratiques/devops-genaiops.md` |
| Toucher aux coûts, quotas, budgets, tags | `docs/pratiques/finops.md`, `docs/reference/tags.md` |
| Évaluer un risque de sécurité | `docs/pratiques/securite.md` |
| Prendre ou consulter une décision | `docs/decisions/README.md` |
| Écrire une entrée de catalogue | `docs/reference/schemas-catalogues.md` |
| Créer un dossier ou un module | `docs/reference/structure-depot.md` |
| Comprendre un terme | `docs/reference/glossaire.md` |
| Connaître les hypothèses et points non vérifiés | `docs/suivi/` |

## Conventions

- Langue de la documentation : français.
- Versions de la plateforme : V1 à V4. Classes de cas d'usage : C1 à C6. Niveaux de maturité : N0 à N4.
- Mode de réalisation d'une exigence : N (natif Azure), C (configuration), D (développement).
- Lister les exigences d'une version : `grep -rh "| V1 |" docs/exigences/`.

## Commandes

```bash
terraform fmt -recursive terraform                                    # formatage
for d in terraform/environments/*/*; do terraform -chdir=$d init -backend=false && terraform -chdir=$d validate; done
for d in terraform/modules/catalog terraform/stacks/*; do terraform -chdir=$d init -backend=false && terraform -chdir=$d test; done   # tests hors ligne (providers simulés)
check-jsonschema --schemafile catalog/schemas/model.schema.json catalog/models/*.yaml               # schémas des catalogues
python3 scripts/opencode/generer-config.py                            # configuration OpenCode depuis le catalogue
scripts/ci/verifier-racines.sh                                        # racines dev et prod identiques
AIPLAT_ENV=dev pytest -v api/tests                                    # tests de la passerelle déployée (az login requis)
```

Le déploiement passe uniquement par les pipelines (`docs/operations/deploiement.md`). Bootstrap : `docs/operations/bootstrap.md`.

- Les évaluations (30 à 50 cas par agent) arrivent avec la phase agents.
- Après une modification du catalogue des modèles, régénérer la configuration OpenCode.
- Après une modification d'une policy, relancer `terraform test` (contrôle des 16 Kio).
