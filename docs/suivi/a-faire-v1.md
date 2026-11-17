# À faire pour la V1

Les hypothèses sont dans `docs/suivi/hypotheses.md`, les points à vérifier dans `docs/suivi/points-ouverts.md`.

## Décisions attendues de Christophe

1. **Premier cas d'usage** : remplir la fiche de qualification (`docs/gouvernance.md`) pour OpenCode, nommer le propriétaire métier et le budget (déclencheur de `docs/architecture/v1-socle-minimal.md`).
2. ~~Compatibilité avec ADR-16~~ : **réglé**. ADR-16 range explicitement l'assistant de développement (Software Factory) dans la colonne « Plateforme ».
3. ~~Premier adaptateur (CHN-02)~~ : **réglé**. OpenCode est l'adaptateur de la V1. Le bloc agents managés est construit plus tard dans la V1, quand un cas C1 ou C2 arrive.
4. **Deux alias de modèles** (un généraliste, un rapide et économique) : à choisir parmi les modèles disponibles en Data Zone Standard EU depuis France Central (PO-04).
5. **Éléments RGPD du premier cas** (CMP-03) : finalité, base légale, durées de conservation. Ce sont des informations que seul le propriétaire peut fournir.
6. **Formulation d'IAM-01** : valider la reformulation imposée par ADR-18 (une clé d'abonnement identifie l'application mais n'authentifie pas).
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
