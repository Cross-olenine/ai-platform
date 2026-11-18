# Fiche de qualification : OpenCode (Software Factory)

Premier cas d'usage de la V1. Fiche établie à partir de `docs/cas-usage/modele-fiche.md`.

| | |
|---|---|
| **Identifiant** | `opencode` |
| **Statut** | Expérimentation (N1) : opérationnel en développement depuis le 18/11/2026 |
| **Date de qualification** | 18/11/2026 |

## Qualification

| Champ | Contenu |
|---|---|
| Besoin | Assistant de code pour les développeurs : écriture, explication et revue de code depuis le terminal. Environ **50 développeurs**. Valeur attendue : un assistant de code équivalent aux offres des grands fournisseurs (Claude Code, Codex), sur des modèles gouvernés, hébergés dans l'UE, à coût maîtrisé. |
| Résultat de l'arbre de décision (`docs/01-objet-perimetre.md`) | Adaptateur sur la plateforme. Microsoft 365 Copilot ne couvre pas ce besoin ; ADR-16 range l'assistant de développement dans la colonne « Plateforme ». |
| Classe (`docs/03-modele-maturite.md`) | C6 : assistant de développement |
| Niveau cible (`docs/03-modele-maturite.md`) | **N2 (pilote) en V1**, sur l'environnement de développement avec des utilisateurs réels. **N3 (production) en V2** : la production n'est pas ouverte en V1 (décision du 18/11/2026). |
| Données | Code **open source**. Les prompts peuvent néanmoins contenir des fichiers de configuration ou des données de test : les développeurs n'y placent ni secret ni donnée personnelle. Le contenu des prompts n'est pas journalisé par la plateforme (OBS-05). |
| Signal de réussite | OpenCode, sur les modèles de la plateforme, rend fonctionnellement le même service que les assistants des grands fournisseurs (Claude Code, Codex). Indicateurs : utilisateurs actifs par semaine, sessions menées à terme sans abandon, retours des développeurs. |
| Propriétaire et budget | Propriétaire : administrateur Azure de la plateforme. Centre de coût : `CC-PERSO`. Budgets Azure confirmés : 50 €/mois en dev, 300 €/mois en prod (`catalog/environments/*.yaml`, `budget.monthly_amount_eur`) ; le budget de prod ne sert qu'à partir de la V2. |
| Compatibilité | Oui : la V1 ouvre C6 avec des limites d'appels par application (MGW-03). Les limites de tokens (MGW-20) et les quotas par utilisateur (MGW-04) arrivent en V2, avec la production. |

## Registre IA (CMP-02)

| Champ | Contenu |
|---|---|
| Classification de risque (règlement européen sur l'IA) | Risque minimal : outil interne d'aide à la programmation, sans décision sur des personnes. |
| Information des utilisateurs (CMP-04) | Nature d'IA explicite dans l'outil et rappelée dans `adapters/opencode/README.md`. |

## Mise en œuvre sur la plateforme

| Élément | Valeur |
|---|---|
| Application consommatrice | `opencode` dans `catalog/environments/dev.yaml` et `prod.yaml` |
| Alias de modèles autorisés | `agent-general` (gpt-6-luna), `agent-fast` (gpt-4.1-nano) |
| Limites d'appels (MGW-03) | Dev : 30 appels/min, 5 000/jour. Prod : 60 appels/min, 20 000/jour. À revoir avant d'ouvrir le pilote aux 50 développeurs. |
| Canal | Adaptateur OpenCode (`adapters/opencode/`), configuration générée depuis le catalogue (CHN-07) |
