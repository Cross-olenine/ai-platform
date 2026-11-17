# Exigences — API Management (API)

Mode : **N** = natif Azure, **C** = configuration, **D** = développement spécifique. La version indique quand l'exigence devient obligatoire. Statut : `À faire`, `En cours`, `Fait`, `Abandonnée`.

| ID | Exigence | Version | Mode | Statut |
|---|---|---|---|---|
| API-01 | Les policies sont composées de fragments réutilisables. Aucune policy complète n'est copiée d'une API à l'autre. | V1 | C | À faire |
| API-02 | Fragments V1 : authentification, contexte, corrélation, liste blanche, limite de tokens, métriques de tokens, erreurs normalisées, routage par alias. | V1 | C | À faire |
| API-03 | Aucune valeur en dur dans une policy (P5). | V1 | C | À faire |
| API-04 | La configuration a une seule source de vérité (ADR-05). | V1 | C | À faire |
| API-05 | Tests automatisés de base : authentification, liste blanche, propagation des identifiants. | V1 | C | À faire |
| API-06 | Fragments V2 : autorisation par offre et rôle, contexte société, quotas, validation du corps et des paramètres, suppression des données sensibles, collecte FinOps. | V2 | C | À faire |
| API-07 | Tout changement non rétrocompatible passe par une révision ou une version d'API. | V2 | N | À faire |
| API-08 | Tests complets : quotas, paramètres interdits, format des erreurs, collecte FinOps. | V2 | C | À faire |
| API-09 | Une montée de capacité se justifie par : saturation mesurée, hausse durable du trafic, exigence de disponibilité ou engagement contractuel. | V2 | C | À faire |
| API-10 | Les serveurs MCP et les API d'agents sont exposés et gouvernés par la passerelle. | V3 | N | À faire |
| API-11 | Des passerelles régionales servent le multi-région. | V4 | N | À faire |
