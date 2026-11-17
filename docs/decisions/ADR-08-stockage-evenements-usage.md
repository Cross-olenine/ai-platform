# ADR-08 — Stockage des événements d'usage

| | |
|---|---|
| **Statut** | Acceptée |
| **Échéance** | V1 |
| **Responsable** | Owner du projet |
| **Date de décision** | 16 novembre 2026 |
| **Exigences liées** | — |

## Contexte

Chaque requête produit un événement d'usage (FIN-01). Le détail par utilisateur et par session ne doit pas être porté par des dimensions de métriques (OBS-04).

## Décision

Stocker les événements d'usage dans une table de journaux Log Analytics, alimentée par la passerelle.

## Alternatives examinées

| Alternative | Pourquoi elle n'est pas retenue |
|---|---|
| Flux d'événements + entrepôt analytique | Plus adapté aux gros volumes et à la refacturation à grande échelle. Coût et complexité injustifiés en V1. |
| Base de données dédiée | Composant supplémentaire à développer et à exploiter. |

## Conséquences

- Les tableaux de bord et contrôles s'écrivent en requêtes sur les journaux.
- Le coût d'ingestion est à surveiller (OBS-06).
- À réévaluer au passage en V2 (refacturation par société) ou si le volume le justifie.
