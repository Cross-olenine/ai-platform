# Exigences — FinOps (FIN)

Mode : **N** = natif Azure, **C** = configuration, **D** = développement spécifique. La version indique quand l'exigence devient obligatoire. Statut : `À faire`, `En cours`, `Fait`, `Abandonnée`.

| ID | Exigence | Version | Mode | Statut |
|---|---|---|---|---|
| FIN-01 | Chaque requête produit un événement d'usage au format unique (`docs/reference/evenement-usage.md`), identique quel que soit le canal. | V1 | C | À faire |
| FIN-02 | Le coût estimé est calculé à partir des tarifs du catalogue des modèles. | V1 | C | À faire |
| FIN-03 | Des budgets Azure avec alertes existent par environnement. | V1 | N | À faire |
| FIN-04 | Tout blocage repose sur un compteur temps réel à la passerelle, jamais sur les budgets Azure (ils sont évalués une fois par jour et ne font que notifier). | V1 | N | À faire |
| FIN-05 | Toutes les ressources portent les tags obligatoires (`docs/reference/tags.md`), contrôlés automatiquement. | V1 | C | À faire |
| FIN-06 | Un tableau de bord montre usage et coût par modèle, agent et application. | V1 | C | À faire |
| FIN-07 | Le coût fixe du socle est chiffré avant chaque version, puis suivi chaque mois. | V1 | C | À faire |
| FIN-08 | La consommation est restituée par société, offre et projet. La règle de répartition des coûts partagés est documentée (ADR-11). | V2 | C | À faire |
| FIN-09 | Le coût estimé est rapproché chaque mois du coût Azure réel ; l'écart toléré est défini. | V2 | C | À faire |
| FIN-10 | Les seuils budgétaires (`docs/reference/seuils-budgetaires.md`) et la politique de dépassement sont définis par offre. | V2 | C | À faire |
| FIN-11 | Chaque composant a une fiche FinOps (`docs/reference/fiche-finops.md`) avant sa mise en production. | V2 | C | À faire |
| FIN-12 | Les gaspillages sont détectés par requêtes planifiées : modèle jamais appelé, agent inutilisé, ressource sans propriétaire ou sans date de fin, journaux excessifs, taux anormal de nouvelles tentatives, sorties systématiquement tronquées, faible usage du cache. | V2 | C | À faire |
| FIN-13 | Un agent inutilisé suit une règle paramétrable : notification à 30 jours, statut « à confirmer » à 60, désactivation proposée à 90. | V2 | C | À faire |
| FIN-14 | Une campagne d'évaluation a un plafond de coût et une alerte. | V2 | C | À faire |
| FIN-15 | Le coût par tâche réussie est suivi pour chaque agent disposant d'un signal de réussite défini dans sa fiche. | V3 | C | À faire |
| FIN-16 | Les coûts d'indexation, de stockage et d'embeddings sont attribués par source et par société. | V3 | C | À faire |
| FIN-17 | Chaque anomalie produit automatiquement : constat, estimation du coût, recommandation, propriétaire, date cible, statut. | V4 | D | À faire |

*Pourquoi le coût par tâche réussie : un modèle peu cher par token devient coûteux s'il demande plus de tentatives, de corrections ou d'appels d'outils. L'indicateur n'a de sens que si chaque agent définit ce qu'est une « tâche réussie ».*
