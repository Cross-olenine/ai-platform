# ADR-19 — Embeddings exposés par le Model Gateway

| | |
|---|---|
| **Statut** | Acceptée |
| **Échéance** | V1 (avancée depuis la V3) |
| **Responsable** | Owner du projet |
| **Date de décision** | 24 novembre 2026 |
| **Exigences liées** | MGW-15, MGW-08, CAT-01, CAT-04 |

## Contexte

L'ADR-06 fixe l'API Responses comme seul protocole du Model Gateway et demande une nouvelle décision pour tout second protocole. Les embeddings (vectorisation de textes, base du RAG de la V3) utilisent une autre API, `/embeddings`, avec un autre format de requête et de réponse : pas de tokens de sortie, les tokens d'entrée sont dans `usage.prompt_tokens`.

Les embeddings sont prévus en V3 (MGW-15). L'owner du projet a décidé de les avancer en V1, en connaissance de la règle « ne rien construire au-delà de la version en cours » : le besoin est de disposer du bloc dès maintenant pour les premiers cas d'usage de recherche.

## Décision

1. Le Model Gateway expose une seconde opération, `POST /embeddings` (`operationId: createEmbedding`), sur la même API, derrière les mêmes fragments de policy (authentification, liste blanche, limites d'appels, événement d'usage).
2. Le catalogue des modèles porte un champ `kind` (`chat` par défaut, ou `embedding`). Un embedding utilise `protocol: embeddings`, n'a ni plafond de sortie ni tarif de sortie.
3. Un alias d'embedding n'est accepté que sur `/embeddings`, un alias de chat que sur `/responses` ; sinon la passerelle répond `400 model_not_allowed`.
4. Le premier alias est `embedding-default` (modèle `text-embedding-3-small`, choisi pour son rapport qualité/prix). Le déploiement reste en Data Zone Standard UE (ADR-03), sans modifier la règle Azure sur les types de déploiement.
5. L'API Chat Completions n'est pas ajoutée : l'ADR-06 reste valable pour les modèles de chat.

## Alternatives examinées

| Alternative | Pourquoi elle n'est pas retenue |
|---|---|
| Garder les embeddings en V3 | Le besoin est avancé par l'owner du projet. |
| Une seconde API (`/embeddings` sur un autre produit APIM) | Double l'authentification, les limites et les événements d'usage pour un gain nul. |
| Appel direct à Foundry pour les embeddings | Interdit : un seul point de passage vers les modèles (règle 6, MGW-07). |

## Conséquences

- Le schéma `model.schema.json`, le module `catalog`, le module `model-gateway`, trois fragments de policy, l'OpenAPI, les tests et le générateur OpenCode évoluent dans le même changement.
- La table de routage `model-routes` passe à six champs (ajout de `kind`).
- L'événement d'usage d'un embedding a `output_tokens = 0` et `input_tokens = usage.prompt_tokens`.
- La taille de la policy assemblée augmente (limite de 16 Kio, PO-16) : contrôlée par `terraform test`.
- Le modèle exact, sa disponibilité en Data Zone depuis France Central, son quota et son tarif restent à confirmer dans Foundry (PO-20). Si le modèle n'est pas disponible en Data Zone UE, c'est une condition de révision d'ADR-03 : on ne contourne pas la règle.
- Le traitement RAG (ingestion, index, filtrage par droits) reste en V3 (KNW-02).

## Condition de révision

Rouvrir si un client exige d'autres variantes d'embedding (par exemple multimodal), ou si `llm-emit-token-metric` ne compte pas correctement les tokens d'embedding (PO-12).
