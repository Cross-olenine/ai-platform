# ADR-18 — Niveau d'API Management en V1 : Consumption

| | |
|---|---|
| **Statut** | Acceptée |
| **Échéance** | V1 |
| **Responsable** | Owner du projet |
| **Date de décision** | 17 novembre 2026 |
| **Remplace** | ADR-02 |
| **Exigences liées** | MGW-03, MGW-20, IAM-01, FIN-01, FIN-07, OBS-03 |

## Contexte

ADR-02 retenait Basic v2 en V1. Or le reste de la documentation (`docs/architecture/v1-socle-minimal.md`, MGW-03, MGW-20, `docs/03-modele-maturite.md`) avait été écrit pour le niveau Consumption, avec une cible de coût fixe proche de zéro. Ces deux positions ne sont pas compatibles. Un ADR accepté ne se modifie pas : il est remplacé par celui-ci.

Ce que la documentation Microsoft indique pour le niveau Consumption (vérifié en novembre 2026) :

| Fonction | Consumption |
|---|---|
| `rate-limit` et `quota` par abonnement | Disponibles |
| `rate-limit-by-key`, `quota-by-key` | Non disponibles |
| `llm-token-limit` | Non disponible |
| `llm-emit-token-metric` | Contradictoire entre la page de la policy et la table de référence : à prouver |
| Fragments de policy (`include-fragment`) | Disponibles. Une policy assemblée est limitée à 16 Kio. |
| Journaux de ressources vers Log Analytics | Non disponibles |
| Journaux de requêtes et policy `trace` vers Application Insights | Disponibles |
| Identité managée, `validate-azure-ad-token` | Disponibles |
| Intégration à un réseau privé | Non disponible (cohérent avec ADR-07) |

## Décision

API Management au niveau **Consumption** en V1, une instance par environnement (développement, production). En V2, un niveau payant de la gamme v2 est choisi et chiffré (PO-03), notamment pour MGW-20, MGW-04 et le réseau privé.

## Conséquences

- **Limites par application (MGW-03).** Elles reposent sur `rate-limit` et `quota` par abonnement API Management, avec un abonnement par application consommatrice. La clé d'abonnement identifie l'application ; elle n'authentifie personne. Le jeton Entra ID reste obligatoire sur chaque appel, et une clé seule ne donne accès à rien (IAM-01 est reformulée en ce sens, formulation validée le 19/11/2026).
- **Pas de limite de tokens en V1** (MGW-20 reste en V2). Les plafonds de sortie par alias (MGW-05) bornent le coût d'une requête.
- **Télémétrie.** Les événements d'usage sont écrits par la policy `trace` dans une ressource Application Insights adossée à l'espace Log Analytics de l'environnement. Ils arrivent donc bien dans une table de journaux Log Analytics, ce qui reste conforme à ADR-08.
- **Taille des policies.** Une policy assemblée ne doit pas dépasser 16 Kio. Un contrôle automatique le vérifie à chaque demande de changement.
- **Coût fixe.** Il est quasi nul : facturation à l'appel, avec une franchise mensuelle. Il est chiffré et suivi (FIN-07).
- **Bascule en V2.** Le passage d'une instance Consumption à un niveau v2 implique une nouvelle instance. Cela se fera par reconstruction depuis le code, de façon cohérente avec la bascule d'abonnement prévue par ADR-12.

## Alternatives examinées

| Alternative | Pourquoi elle n'est pas retenue |
|---|---|
| Basic v2 (ADR-02) | Apporte `rate-limit-by-key`, `llm-token-limit` et les journaux de ressources, mais impose un coût fixe mensuel par instance (deux instances) pour 1 à 2 cas d'usage. |
| Gamme classique | Mêmes raisons qu'ADR-02 : pas de migration vers la gamme v2. |

## Condition de révision

Rouvrir cette décision dans l'un de ces cas :

- si le prototype P-B (`docs/suivi/points-ouverts.md`, PO-12) montre que le nombre de tokens d'un appel en streaming ne peut pas être capturé de façon fiable en Consumption, car FIN-01 ne serait alors pas tenable ;
- si le prototype P-A (PO-11) montre que les limites par abonnement ne fonctionnent pas comme attendu.

La solution de repli est Basic v2.
