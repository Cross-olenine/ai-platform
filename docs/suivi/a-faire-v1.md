# À faire pour la V1

**Hypothèses levées**

| Hypothèse | Statut |
|---|---|
| H1 : équipe plateforme de 2 à 3 personnes | Confirmée |
| H2 : données traitées dans l'Union européenne | Confirmée |
| H3 : une société en V1, plusieurs à partir de V2 | Confirmée |
| H4 : premier cas d'usage conversationnel ou de génération, sans données privées | **Infirmée** : le premier cas est un assistant de code (C6), via OpenCode |
| H5 : RAG et MCP livrés en V3 | Confirmée |
| H6 : Entra ID et Git avec pipelines déjà en place (GitHub) | Confirmée |
| Un seul abonnement en V1 | Confirmée (ADR-12) |
| Réseau privé en V2 | Confirmée (ADR-07) |
| Licences Microsoft 365 Copilot | Levée |

## Décisions attendues de Christophe

1. **Premier cas d'usage** : remplir la fiche de qualification (`docs/gouvernance.md`), nommer le propriétaire métier et le budget (déclencheur de `docs/architecture/v1-socle-minimal.md`).
2. **Compatibilité avec ADR-16** : cet ADR accepté dit que le premier cas de la V1 ne doit pas être un assistant généraliste et doit être intégré à une application ou un processus. Confirmer que l'assistant de code OpenCode (C6) respecte cette règle. Si ce n'est pas le cas, un nouvel ADR est nécessaire, car un ADR accepté ne se modifie pas.
3. **Premier adaptateur (CHN-02)** : confirmer si OpenCode est l'adaptateur de la V1, ou si un autre canal est visé.
4. **Deux alias de modèles** (un généraliste, un rapide et économique) : à choisir parmi les modèles disponibles en zone UE (voir étape 2 ci-dessous).
5. **Éléments RGPD du premier cas** (CMP-03) : finalité, base légale, durées de conservation. Ce sont des informations que seul le propriétaire peut fournir.

## Vérifications à faire en construisant

Les étapes ci-dessous sont proposées pour regrouper les vérifications ; elles ne figurent pas encore dans un plan validé.

- **Étape 1 : socle Azure (passerelle, environnements)**
  - PO-09 : les politiques de limite d'appels par abonnement (`rate-limit`, `quota`) fonctionnent sur le niveau Consumption. MGW-03 en dépend. Test à faire sur une souscription de test.
  - PO-10 : Foundry n'accepte d'appels que depuis la passerelle, sans réseau privé. Test de non-contournement, à passer avant toute mise en production (ADR-07).
- **Étape 2 : modèles**
  - PO-04 : disponibilité en zone UE de chaque modèle visé, puis choix des deux alias.
- **Étape 3 : agent managé**
  - PO-01 : les appels d'un agent managé passent par la passerelle et produisent les mêmes événements d'usage. Conditionne AGT-04 et le FinOps des agents.
- **Étape 4 : FinOps**
  - PO-07 : chiffrer le coût fixe de la V1 (FIN-07) avant de démarrer. La contrainte de 0 € (ADR-02, ADR-07) reste à vérifier pour Log Analytics, Key Vault et les pipelines.

## Plus tard (V2 et au-delà)

- ADR en attente, dans `docs/decisions/plus-tard/` : ADR-04, 09, 10, 11, 14, 15, 17.
- **V2** : limites de tokens à la passerelle (MGW-20) et quotas par utilisateur (MGW-04), tous deux sur un niveau payant d'API Management. Choix du niveau à trancher et à chiffrer (PO-03).
- **V2** : statut des agents « code » (PO-02).
- **V2** : réseau privé généralisé (ADR-07).
- **V3** : RAG et MCP (H5). Licence de l'identité d'agent à vérifier (PO-05).
