# ADR-05 — Source de vérité de la configuration API Management

| | |
|---|---|
| **Statut** | Acceptée |
| **Échéance** | V1 |
| **Responsable** | Owner du projet |
| **Date de décision** | 16 novembre 2026 |
| **Exigences liées** | API-04 |

## Contexte

La configuration d'API Management (API, opérations, policies, fragments) peut être gérée par Terraform, par l'outillage APIOps, ou par le portail. Deux sources concurrentes produisent de la dérive.

## Décision

Terraform est la seule source de vérité de la configuration API Management. Les policies sont des fichiers XML du dépôt, référencés par Terraform.

## Alternatives examinées

| Alternative | Pourquoi elle n'est pas retenue |
|---|---|
| APIOps (extraction et publication) | Pertinent pour de grandes équipes d'API. Ajoute un second outillage à maîtriser pour une équipe de 2 à 3 personnes. |
| Portail Azure | Interdit par le principe P8. |

## Conséquences

- Les fragments vivent dans `api/policies/fragments/`.
- Toute modification faite dans le portail est une dérive à corriger.
- À réévaluer en V2 si la gestion des policies par Terraform devient lourde. On ne fera jamais coexister deux sources.
