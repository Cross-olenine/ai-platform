# Documentation et transférabilité

**Objectif.** Une personne qui n'a pas participé à la construction peut comprendre l'architecture, déployer un environnement, ajouter une société, un modèle ou un agent, intégrer un canal, diagnostiquer un incident, analyser une consommation, gérer un secret et revenir à une version précédente.

| Document | Contenu | À partir de |
|---|---|---|
| Architecture | Objectifs, principes, schémas, flux, responsabilités, risques, dépendances | V1 |
| Déploiement | Prérequis, versions d'outils, authentification, variables, commandes, pipelines, retour arrière | V1 |
| Exploitation | Supervision, alertes, journaux, incidents, quotas, budgets, rotation des secrets, urgences | V1 (base), V2 (complet) |
| Fiche de bloc | Objectif, périmètre, entrées, sorties, prérequis, paramètres, exemples, tests, limites, dépannage | V1 pour chaque bloc livré |
| Fiche d'offre | Utilisateurs cibles, fonctions, sécurité, quotas, engagements, tarification, onboarding | V2 |
| Décisions d'architecture | Contexte, décision, alternatives, conséquences, date, statut, responsable | V1 |
| Documentation générée | Catalogues, routes, quotas, variables et sorties Terraform, journal des changements | V2 |

**Règle.** La documentation est mise à jour dans la même demande de changement que le composant. Une évolution qui modifie une API, une policy, un modèle, un agent, un quota, une alerte ou une procédure sans mettre à jour sa documentation n'est pas terminée.
