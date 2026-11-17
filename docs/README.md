# Cahier des charges — Plateforme de services IA industrialisée (Azure)

| | |
|---|---|
| **Statut** | Projet v0.2, à valider |
| **Mots d'ordre** | Automatisation et réutilisation · Coûts réduits · Solidité |
| **Version en cours** | V1 — Socle minimal |

Le cahier des charges est découpé en fichiers courts. Chaque fichier traite un seul sujet et peut être lu seul.

## Ordre de lecture pour un nouvel arrivant

1. `01-objet-perimetre.md` : ce que la plateforme fait et ne fait pas.
2. `02-principes.md` : les règles qui guident tous les choix.
3. `03-modele-maturite.md` : versions (V1 à V4), classes de cas d'usage (C1 à C6), niveaux de maturité (N0 à N4).
4. `architecture/v1-socle-minimal.md` : ce qu'on construit maintenant.
5. `architecture/cible.md` : où l'on va.

## Contenu

| Dossier ou fichier | Contenu | Stabilité |
|---|---|---|
| `01-objet-perimetre.md` | Objectif, mots d'ordre, périmètre, arbre de décision amont | Stable |
| `02-principes.md` | 14 principes directeurs | Stable |
| `03-modele-maturite.md` | Versions, classes, niveaux, matrice classe × version | Stable |
| `architecture/` | Cible, contrats stables, un fichier par version, matrice de couverture | Évolue à chaque version |
| `exigences/` | Un fichier par bloc, 173 exigences avec version, mode et statut | Statuts mis à jour en continu |
| `pratiques/` | DevOps et GenAIOps, FinOps, sécurité | Stable |
| `gouvernance.md` | Rôles, qualification d'une demande, instances | Stable |
| `documentation.md` | Documents attendus et règle de mise à jour | Stable |
| `decisions/` | Un fichier par décision d'architecture | Évolue à chaque décision |
| `criteres-reussite.md` | Critères globaux et version où ils sont atteints | Stable |
| `suivi/` | Hypothèses, risques, points à vérifier | Volatile |
| `reference/` | Glossaire, structure du dépôt, schémas de catalogue, événement d'usage, tags, seuils, fiche FinOps | Référence |

## Règles de tenue

- Une information vit à un seul endroit. Les autres fichiers y renvoient par son chemin.
- Les identifiants d'exigences et d'ADR ne changent jamais.
- La documentation est modifiée dans le même changement que le composant concerné.
