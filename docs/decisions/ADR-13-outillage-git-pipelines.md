# ADR-13 — Outillage Git et pipelines

| | |
|---|---|
| **Statut** | Acceptée |
| **Échéance** | V1 |
| **Responsable** | Owner du projet |
| **Date de décision** | 16 novembre 2026 |
| **Exigences liées** | — |

## Contexte

Le principe P8 impose que tout changement vienne de Git et passe par un pipeline. La société utilise GitHub.

## Décision

GitHub pour le dépôt et GitHub Actions pour les pipelines.

## Alternatives examinées

| Alternative | Pourquoi elle n'est pas retenue |
|---|---|
| Azure DevOps | Non retenu : GitHub est le standard de la société. |

## Conséquences

- Les pipelines vivent dans `.github/workflows/`.
- L'authentification vers Azure se fait par fédération d'identité, sans secret stocké dans GitHub.
- Les environnements GitHub (développement, production) portent les règles d'approbation ; la production exige un approbateur distinct de l'auteur.
- La branche principale est protégée ; l'identité de production n'est utilisable que depuis elle.
