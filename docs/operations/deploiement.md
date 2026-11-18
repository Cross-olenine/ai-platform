# Déployer un changement

Tout changement passe par Git et par les pipelines (P8). Le modèle de branches est décrit dans `docs/pratiques/devops-genaiops.md`.

1. **Préparer le changement.**
   - Créer une branche `feature/<sujet>` depuis `develop`.
   - Faire de petits commits qui citent les exigences, par exemple `feat(model-gateway): ... (MGW-05)`.
   - Mettre à jour dans le même changement la documentation et le statut des exigences (règle 7).
2. **Ouvrir une demande de changement vers `develop`.**
   - Le job `controles` vérifie : format et validation Terraform, `tflint`, tests Terraform hors ligne, schémas des catalogues, absence de secrets, tags, policies et configuration OpenCode.
   - Le job `plan-dev` publie le plan dans la demande de changement.
3. **Fusionner (squash)** : `deploy-dev.yml` applique en développement, puis lance les tests de l'API (`api/tests`).
4. **Promouvoir.**
   - Ouvrir une demande de changement `develop` → `test`, puis `test` → `preprod`, puis `preprod` → `main`, en fusionnant avec un commit de fusion.
   - Chaque promotion vérifie que l'arbre promu est identique à celui de la branche source.
5. **Mettre en production.**
   - La fusion dans `main` lance `deploy-prod.yml`. Le job `plan` (environnement `prod-plan`) publie le plan dans le résumé de l'exécution.
   - L'approbateur, distinct de l'auteur, relit ce plan, puis approuve le job `apply` (environnement `prod`).
   - Les tests de contrôle s'exécutent après le déploiement.

## Changer le modèle derrière un alias (critère de sortie V1)

Modifier `model`, `model_version` et `deployment_name` dans `catalog/models/<alias>.yaml`, puis dérouler le chemin ci-dessus. Les clients continuent d'appeler le même alias (MGW-01). Le nouveau `deployment_name` crée le nouveau déploiement avant de supprimer l'ancien.

## Retour arrière

Annuler le commit fautif (`git revert`) et dérouler le même chemin. Ne jamais corriger dans le portail : toute modification manuelle est une dérive, détectée chaque mois par `drift.yml`.

## Intervention manuelle d'urgence

Elle suit la procédure de `docs/pratiques/devops-genaiops.md` : approuvée, horodatée, attribuée, reproduite dans le code, puis suivie d'un contrôle de dérive.
