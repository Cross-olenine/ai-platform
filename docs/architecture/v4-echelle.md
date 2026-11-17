# V4 — Échelle (architecture cible)

**Objectif.** Tenir des centaines de cas d'usage sans que l'équipe plateforme devienne le goulot d'étranglement.

**Déclencheurs d'entrée** (au moins deux) :

- plus de 30 cas d'usage en production, ou plus de 5 équipes produit ;
- le délai de mise en service d'un cas d'usage standard dépasse la cible parce que l'équipe plateforme est saturée ;
- les quotas de modèles sont saturés de façon récurrente ;
- un cas d'usage exige le niveau N4 (engagement contractuel, PRA) ;
- une société exige une isolation dédiée.

Le schéma est celui de `docs/architecture/cible.md`.

**Ajouts par rapport à V3 :**

| Domaine | Ajout V4 |
|---|---|
| Libre-service | Portail au-dessus des catalogues. Une entrée de catalogue déclenche toute la chaîne (déploiement, routes, policies, diagnostics, alertes, tableaux de bord, documentation, tests). |
| Résilience | Seconde région, passerelles régionales, PRA avec RTO et RPO par offre. Niveau N4 ouvert. |
| Capacité et coûts | Capacité réservée pour les alias à volume stable, avec débordement à l'usage. Cache sémantique. Routage par coût (petit modèle par défaut, escalade). Modèles tiers derrière la même passerelle. |
| Agents | Multi-agents et délégation entre agents. Cycle de vie complet en 8 états. |
| Sociétés | Isolation « dédiée » (déploiements, index et stockage propres). |
| FinOps | Détection automatique des gaspillages avec constat, estimation, recommandation, propriétaire, échéance, statut. Refacturation automatisée. |
| DevOps | Exposition progressive par anneaux et par pourcentage. Retour arrière automatique sur critères de santé. Extraction de dépôts selon les responsabilités. Dérive contrôlée chaque jour. 10 états Terraform. |
| GenAIOps | Évaluation continue sur les traces de production. |
| Canaux | Teams et Microsoft 365. Catalogue d'adaptateurs. |
| Gouvernance | Rôles de `docs/gouvernance.md` tenus par des équipes distinctes. Registre complet des agents et outils. |

**Critères de sortie V4 :** les critères de réussite globaux de `docs/criteres-reussite.md`.
