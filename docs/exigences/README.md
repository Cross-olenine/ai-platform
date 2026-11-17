# Exigences par bloc

Mode : **N** = natif Azure, **C** = configuration, **D** = développement spécifique. La version indique quand l'exigence devient obligatoire. Statut : `À faire`, `En cours`, `Fait`, `Abandonnée`.

Chaque exigence a un identifiant stable (`MGW-03`). On ne renumérote jamais : une nouvelle exigence prend le numéro suivant du bloc.

| Bloc | Fichier | V1 | V2 | V3 | V4 |
|---|---|---|---|---|---|
| Identité et accès (IAM) | `docs/exigences/iam-identite-acces.md` | 3 | 3 | 2 | 1 |
| Model Gateway (MGW) | `docs/exigences/mgw-model-gateway.md` | 7 | 7 | 1 | 4 |
| Agent Runtime (AGT) | `docs/exigences/agt-agent-runtime.md` | 6 | 4 | 4 | 2 |
| Sociétés (TEN) | `docs/exigences/ten-societes.md` | 1 | 5 | 1 | 1 |
| FinOps (FIN) | `docs/exigences/fin-finops.md` | 7 | 7 | 2 | 1 |
| Observabilité (OBS) | `docs/exigences/obs-observabilite.md` | 7 | 6 | 1 | 1 |
| Secrets (KV) | `docs/exigences/kv-secrets.md` | 3 | 2 | 1 | 0 |
| API Management (API) | `docs/exigences/api-api-management.md` | 5 | 4 | 1 | 1 |
| Garde-fous IA (GRD) | `docs/exigences/grd-garde-fous.md` | 3 | 2 | 2 | 1 |
| Connaissance — RAG (KNW) | `docs/exigences/knw-connaissance-rag.md` | 0 | 0 | 8 | 2 |
| Outils et MCP (TLS) | `docs/exigences/tls-outils-mcp.md` | 0 | 0 | 7 | 1 |
| État, sessions et mémoire (STA) | `docs/exigences/sta-etat-memoire.md` | 2 | 2 | 1 | 1 |
| Adaptateurs de canaux (CHN) | `docs/exigences/chn-adaptateurs-canaux.md` | 2 | 6 | 0 | 1 |
| Catalogues (CAT) | `docs/exigences/cat-catalogues.md` | 4 | 2 | 1 | 1 |
| Expérience développeur (DEX) | `docs/exigences/dex-experience-developpeur.md` | 2 | 4 | 0 | 1 |
| Résilience et capacité (RES) | `docs/exigences/res-resilience-capacite.md` | 3 | 4 | 0 | 1 |
| Conformité (CMP) | `docs/exigences/cmp-conformite.md` | 5 | 2 | 1 | 0 |
| **Total** | | **60** | **60** | **33** | **20** |

## Filtrer

Toutes les exigences d'une version :

```bash
grep -rh "| V1 |" docs/exigences/
```

Ce qui reste à faire pour la version en cours :

```bash
grep -rh "| V1 |" docs/exigences/ | grep "À faire"
```
