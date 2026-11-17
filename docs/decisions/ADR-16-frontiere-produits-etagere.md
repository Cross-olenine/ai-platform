# ADR-16 — Frontière avec les produits sur étagère

| | |
|---|---|
| **Statut** | Acceptée |
| **Échéance** | V1 |
| **Responsable** | Owner du projet |
| **Date de décision** | 16 novembre 2026 |
| **Exigences liées** | — |

## Contexte

La société dispose de licences Microsoft 365 Copilot. Une partie des besoins d'assistance IA est donc déjà couverte par un produit sur étagère. Construire la même chose sur la plateforme contredirait le mot d'ordre « coûts réduits ».

## Décision

Microsoft 365 Copilot est la réponse par défaut pour l'assistance bureautique individuelle. La plateforme n'accueille que les cas d'usage qu'il ne couvre pas.

| Besoin | Réponse |
|---|---|
| Assistance individuelle dans les outils Microsoft 365 : rédaction, résumé de réunion, questions sur ses propres documents, courriels et conversations | Microsoft 365 Copilot |
| Assistant ou service IA intégré à une application ou à un processus métier (application sur site, Power Platform, web, API) | Plateforme |
| Besoin de maîtriser le modèle, les instructions, l'évaluation, les quotas ou la refacturation par société | Plateforme |
| Utilisateurs sans licence Microsoft 365 Copilot | Plateforme |
| Assistant de développement (Software Factory) | Plateforme |

## Alternatives examinées

| Alternative | Pourquoi elle n'est pas retenue |
|---|---|
| Tout construire sur la plateforme | Double un produit déjà payé. |
| Tout confier à Microsoft 365 Copilot | Ne couvre ni l'intégration dans les applications métier, ni la refacturation par société, ni la maîtrise du modèle et de l'évaluation. |

## Conséquences

- La première question de l'arbre de décision (`docs/01-objet-perimetre.md`) a une réponse concrète : « Microsoft 365 Copilot le fait-il déjà ? ».
- Le premier cas d'usage de la V1 ne doit pas être un assistant généraliste : il ferait doublon. Il faut un cas intégré à une application ou à un processus (voir H4 dans `docs/suivi/hypotheses.md`).
- Les questions sur les documents SharePoint d'un utilisateur sont déjà couvertes pour les détenteurs de licence. Le RAG de la V3 vise les corpus intégrés à une application, les corpus sélectionnés par un métier et les utilisateurs sans licence.
- Le périmètre exact des licences reste à préciser (PO-10).

## Condition de révision

Rouvrir si le périmètre des licences change fortement, ou si la place de Copilot Studio doit être précisée.
