# Adaptateur OpenCode (Software Factory, C6)

Premier adaptateur de la V1 (CHN-02). OpenCode appelle uniquement la passerelle (règle 6), avec l'API Responses (ADR-06). L'adaptateur ne contient ni logique d'agent, ni clé Foundry, ni endpoint de modèle, ni tarif, ni quota (CHN-01).

## Contenu

| Fichier | Rôle |
|---|---|
| `<env>/opencode.json` | Configuration centrale (CHN-07) : fournisseur unique `aiplat`, URL de la passerelle, alias autorisés, plafonds de sortie, en-tête de la clé d'abonnement. **Générée** par `scripts/opencode/generer-config.py` depuis les catalogues : ne pas la modifier à la main. La CI vérifie qu'elle est à jour. |
| `scripts/opencode/aiplat-env.sh` | Obtient le jeton Entra ID de l'utilisateur et la clé d'abonnement de l'application (Key Vault). |

**Justification du code spécifique (mode D, P2).** OpenCode ne sait pas obtenir lui-même un jeton Entra ID. Le script se limite à deux appels Azure CLI. Rien n'est stocké sur le disque.

## Démarrage (DEX-01)

Prérequis :
- Azure CLI et `python3` avec `pyyaml` ;
- le rôle `utilisateur` sur l'API passerelle de l'environnement ;
- le droit de lire la clé d'abonnement.

Les deux derniers points sont accordés par une demande de changement sur `catalog/environments/<env>.yaml` : `access.utilisateur` et `applications[opencode].key_readers`.

```bash
az login
source scripts/opencode/aiplat-env.sh dev
mkdir -p ~/.config/opencode && cp adapters/opencode/dev/opencode.json ~/.config/opencode/opencode.json
opencode
```

Sur un poste géré, la configuration est déposée dans `/etc/opencode/opencode.json` (Linux), `/Library/Application Support/opencode/` (macOS) ou `%ProgramData%\opencode\` (Windows). Elle prend alors le pas sur celle de l'utilisateur.

## Exemple d'appel direct

```bash
curl -sS "https://apim-aiplat-dev-frc-01.azure-api.net/model-gateway/v1/responses" \
  -H "Authorization: Bearer $AIPLAT_TOKEN" \
  -H "Ocp-Apim-Subscription-Key: $AIPLAT_SUBSCRIPTION_KEY" \
  -H "Content-Type: application/json" \
  -d '{"model": "agent-fast", "input": "Bonjour"}'
```

| Réponse | Cause |
|---|---|
| `401 unauthorized` | Jeton expiré (environ 1 h) : relancer le script, puis OpenCode. |
| `429 rate_limited` | Limite d'appels de l'application atteinte (MGW-03). Attendre la durée indiquée par l'en-tête `Retry-After`. |
| `400 model_not_allowed` | Alias inconnu ou non autorisé pour l'application. |

Les utilisateurs savent qu'ils interagissent avec une IA (CMP-04) : c'est la nature même de l'outil, rappelée dans ce guide.

## Points à vérifier (PO-14)

Ces points sont à vérifier avec la version d'OpenCode déployée :
- le paquet `@opencode/ai/providers/openai-compatible/responses` envoie bien le jeton de `AIPLAT_TOKEN` en `Authorization: Bearer` ;
- la substitution `{env:...}` fonctionne dans `headers` ;
- les `policies` bloquent bien les autres fournisseurs.
