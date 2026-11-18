# À faire pour la V1

Les hypothèses sont dans `docs/suivi/hypotheses.md`, les points à vérifier dans `docs/suivi/points-ouverts.md`.

## Décisions attendues de Christophe

1. **Premier cas d'usage** : compléter les marqueurs « À COMPLÉTER » de `docs/cas-usage/opencode.md` (utilisateurs, données, signal de réussite, propriétaire, budget).
2. ~~Compatibilité avec ADR-16~~ : **réglé**. ADR-16 range explicitement l'assistant de développement (Software Factory) dans la colonne « Plateforme ».
3. ~~Premier adaptateur (CHN-02)~~ : **réglé**. OpenCode est l'adaptateur de la V1. Le bloc agents managés est construit plus tard dans la V1, quand un cas C1 ou C2 arrive.
4. ~~Deux alias de modèles~~ : **réglé le 18/11/2026**. `agent-general` = gpt-6-luna, `agent-fast` = gpt-4.1-nano (PO-04 vérifié). gpt-4.1-nano arrive en fin de support le 14/04/2027 : successeur à choisir avant.
5. ~~Éléments RGPD du premier cas~~ : **abandonné** le 18/11/2026, la plateforme ne suit pas le RGPD (CMP-03).
6. **Formulation d'IAM-01** : valider la reformulation imposée par ADR-18 (une clé d'abonnement identifie l'application mais n'authentifie pas).
8. **Environnement d'apprentissage** : supprimer `rg-foundry-learning-dev` avant le bootstrap. Les règles Azure de la plateforme portent sur tout l'abonnement, et ses déploiements GlobalStandard y seraient non conformes.
7. **Dépôt GitHub** : sur un compte personnel gratuit, les protections de branches et l'approbation de la production ne sont appliquées que sur un dépôt public. Choisir entre un dépôt public (aucun secret n'est dans Git) et un plan payant. Désigner un second compte approbateur pour la production (ADR-13).

## Plan de construction

Le plan validé est découpé en étapes. Chacune donne lieu à une branche `feature/*` fusionnée dans `develop`.

- **Étape 0 : documentation et décisions.** ADR-18, registre des points ouverts, mise en cohérence.
- **Étape 1 : dépôt, bootstrap Terraform, prototypes bloquants.**
  - PO-11 (P-A) : limites par abonnement en Consumption.
  - PO-12 (P-B) : tokens mesurés en streaming. C'est le risque n°1 ; en cas d'échec, ADR-18 est rouvert.
  - PO-13 (P-C) : Foundry refuse les appels directs.
  - PO-04 : modèles disponibles.
- **Étape 2 : catalogues et modules Terraform.** Trois états par environnement : `socle`, `observabilite`, `passerelle-modeles`.
- **Étape 3 : policies de la passerelle** (fragments).
- **Étape 4 : adaptateur OpenCode, pipelines GitHub Actions, tests de l'API.**
- **Phase agents (plus tard dans la V1)** : PO-01, module `agent-platform`, API d'agents, adaptateur de canal.

## Plus tard (V2 et au-delà)

- ADR en attente, dans `docs/decisions/plus-tard/` : ADR-04, 09, 10, 11, 14, 15, 17.
- **V2** : limites de tokens à la passerelle (MGW-20) et quotas par utilisateur (MGW-04), tous deux sur un niveau payant d'API Management. Choix du niveau à trancher et à chiffrer (PO-03).
- **V2** : environnements Azure de test et de préproduction, alignés sur les branches `test` et `preprod`.
- **V2** : statut des agents « code » (PO-02).
- **V2** : réseau privé généralisé (ADR-07).
- **V3** : RAG et MCP (H5). Licence de l'identité d'agent à vérifier (PO-05).
