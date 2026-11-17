# ADR-06 — Protocole exposé par le Model Gateway

| | |
|---|---|
| **Statut** | Acceptée |
| **Échéance** | V1 |
| **Responsable** | Owner du projet |
| **Date de décision** | 16 novembre 2026 |
| **Exigences liées** | MGW-08 |

## Contexte

Le Model Gateway peut exposer l'API Responses, l'API Chat Completions, ou les deux. Chaque protocole exposé double les policies et les tests.

## Décision

Exposer l'API Responses par défaut. Un second protocole n'est ajouté que sur besoin avéré.

## Alternatives examinées

| Alternative | Pourquoi elle n'est pas retenue |
|---|---|
| Chat Completions par défaut | Plus largement pris en charge par les outils tiers, mais ce n'est pas le protocole des agents Foundry. |
| Exposer les deux dès V1 | Double la surface à tester et à sécuriser sans besoin identifié. |

## Conséquences

- Cohérence avec l'API des agents, qui suit le même contrat.
- Si un client exige Chat Completions (par exemple l'assistant de développement en V2), l'ajout fait l'objet d'une nouvelle décision.
