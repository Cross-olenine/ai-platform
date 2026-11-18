# Fiche de qualification : OpenCode (Software Factory)

Premier cas d'usage de la V1. Fiche établie à partir de `docs/cas-usage/modele-fiche.md`.

| | |
|---|---|
| **Identifiant** | `opencode` |
| **Statut** | Expérimentation (N1) : opérationnel en développement depuis le 18/11/2026 ; production en attente d'un second approbateur GitHub (ADR-13) |
| **Date de qualification** | À COMPLÉTER |

## Qualification

| Champ | Contenu |
|---|---|
| Besoin | Assistant de code pour les développeurs : écriture, explication et revue de code depuis le terminal. **À COMPLÉTER** : utilisateurs visés (nombre, équipes) et valeur attendue. |
| Résultat de l'arbre de décision (`docs/01-objet-perimetre.md`) | Adaptateur sur la plateforme. Microsoft 365 Copilot ne couvre pas ce besoin ; ADR-16 range l'assistant de développement dans la colonne « Plateforme ». |
| Classe (`docs/03-modele-maturite.md`) | C6 : assistant de développement |
| Niveau cible (`docs/03-modele-maturite.md`) | N3 (production), niveau visé par le critère de sortie de la V1. **À CONFIRMER**. |
| Données | **À COMPLÉTER** : nature du code envoyé dans les prompts (interne, client, open source) ; présence possible de secrets ou de données personnelles (configuration, données de test). Le contenu des prompts n'est pas journalisé par la plateforme (OBS-05). |
| Signal de réussite | **À COMPLÉTER** : par exemple, adoption (utilisateurs actifs par semaine), sessions sans abandon, retours des développeurs. |
| Propriétaire et budget | Propriétaire : **À COMPLÉTER**. Centre de coût : `CC-PERSO`. Budgets Azure : 50 €/mois en dev et 300 €/mois en prod (`catalog/environments/*.yaml`, `budget.monthly_amount_eur`), **À CONFIRMER**. |
| Compatibilité | Oui : la V1 ouvre C6 jusqu'à N3 avec des limites d'appels par application (MGW-03). Les limites de tokens (MGW-20) et les quotas par utilisateur (MGW-04) arrivent en V2. |

## Registre IA (CMP-02)

| Champ | Contenu |
|---|---|
| Classification de risque (règlement européen sur l'IA) | Risque minimal pressenti : outil interne d'aide à la programmation, sans décision sur des personnes. **À CONFIRMER**. |
| Information des utilisateurs (CMP-04) | Nature d'IA explicite dans l'outil et rappelée dans `adapters/opencode/README.md`. |

## Mise en œuvre sur la plateforme

| Élément | Valeur |
|---|---|
| Application consommatrice | `opencode` dans `catalog/environments/dev.yaml` et `prod.yaml` |
| Alias de modèles autorisés | `agent-general` (gpt-6-luna), `agent-fast` (gpt-4.1-nano) |
| Limites d'appels (MGW-03) | Dev : 30 appels/min, 5 000/jour. Prod : 60 appels/min, 20 000/jour. |
| Canal | Adaptateur OpenCode (`adapters/opencode/`), configuration générée depuis le catalogue (CHN-07) |
