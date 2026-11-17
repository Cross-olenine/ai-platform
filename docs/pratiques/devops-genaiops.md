# DevOps et GenAIOps par version

## Règles valables dès V1

Aucune modification n'atteint la production sans avoir été :

1. décrite dans le code ou dans un catalogue versionné ;
2. validée automatiquement ;
3. relue ;
4. testée dans un environnement non productif ;
5. approuvée ;
6. déployée par un pipeline ;
7. contrôlée après déploiement ;
8. documentée.

**Git est la source de vérité** pour : modules Terraform, paramètres d'environnement non sensibles, catalogues, spécifications d'API, policies, fiches d'agents, prompts, jeux d'évaluation, scripts de test, tableaux de bord, alertes, documentation, décisions d'architecture.

**Intervention manuelle d'urgence.** Autorisée uniquement pour un incident critique. Elle est approuvée, horodatée, attribuée à une personne, enregistrée, reproduite dans le code, suivie d'un contrôle de dérive et close par une revue.

**Paramètres autorisés à varier entre environnements :** noms, région, capacité, quotas, budgets, URLs, configuration réseau, niveau de journalisation, rétention, identifiants de Key Vault, plans de service, règles d'approbation. Rien d'autre.

## Modèle de branches

Quatre branches longues, deux environnements Azure en V1 (dev, prod). Les environnements de test et de préproduction arrivent en V2 sans changer ce modèle.

| Branche | Reçoit | Effet en V1 |
|---|---|---|
| `feature/*` | Le travail en cours, en petits commits réguliers | Contrôles automatiques et `plan` à chaque demande de changement |
| `develop` | Les demandes de changement `feature/*` | Application automatique en développement, puis tests de l'API |
| `test` | Une demande de changement depuis `develop` | Pas de ressource Azure : tests de l'API et évaluations rejoués contre le développement |
| `preprod` | Une demande de changement depuis `test` | Pas de ressource Azure : `plan` de production publié pour la revue finale |
| `main` | Une demande de changement depuis `preprod` | Application en production après approbation (environnement GitHub `prod`) |

**Même code à chaque étape.** Les promotions se font par fusion avec commit de fusion. Le pipeline vérifie que l'arbre Git promu (`HEAD^{tree}`) est identique à celui de la branche source déjà validée. Aucune modification directe sur `test`, `preprod` ou `main`. Un correctif urgent suit le même chemin.

**Messages de commit.** Ils citent les identifiants d'exigences, par exemple `feat(model-gateway): routage par alias (MGW-01, MGW-02)`.

## Pratiques par version

| Pratique | V1 | V2 | V3 | V4 |
|---|---|---|---|---|
| **Environnements** | Développement, production | + recette | + environnements temporaires par demande de changement | + seconde région |
| **Isolation** | Groupes de ressources, états, identités, Key Vaults et budgets distincts | + abonnement distinct pour la production si possible | Idem | Idem |
| **Dépôt** | Dépôt unique modulaire | Idem | Idem | Extraction de blocs selon responsabilités et cycles de publication |
| **Branches** | `develop`, `test`, `preprod`, `main` protégées, 1 approbation, pas de push direct (voir « Modèle de branches ») | + approbation renforcée pour la production, matrice d'approbation (`docs/pratiques/devops-genaiops.md`) | Idem | Idem |
| **Contrôles automatiques** | Format et validation Terraform, plan publié, schémas des catalogues, absence de secrets, tags | + analyse de sécurité, contrôle des suppressions et remplacements, tests des policies, documentation obligatoire | + tests des schémas d'outils et des pipelines d'ingestion | + règles de conformité sous forme de code |
| **Déploiement** | Automatique en développement depuis `develop` ; production depuis `main` sur approbation, même arbre Git que celui validé | Promotion du même artefact : développement → recette → production | Idem | Exposition progressive par anneaux et pourcentages |
| **Évaluations IA** | Jeu de 30 à 50 cas, lancé avant tout changement de prompt ou de modèle | Porte bloquante dans le pipeline, seuils par offre (`docs/pratiques/devops-genaiops.md`) | + évaluations RAG et outils, red teaming | Évaluation continue sur traces de production |
| **Exposition progressive** | Non | Par société pilote, via feature flags | Par agent et par outil | Par pourcentage d'utilisateurs, avec critères de santé |
| **Retour arrière** | Redéploiement du commit précédent, bascule d'alias | + révisions d'API, feature flags, version précédente de prompt | + versions d'index et d'outils | Automatique sur critères de santé |
| **Dérive** | Plan sans application, lancé chaque mois | Planifié chaque semaine, avec rapport et propriétaire | Idem | Chaque jour, avec ticket automatique |
| **Identité des pipelines** | Fédération d'identité sans secret permanent ; identités distinctes par environnement | + séparation lecture/plan et déploiement | Idem | Idem |
| **Versionnement** | Git et étiquettes | Versionnement sémantique des blocs ; matrice de versions par produit (`docs/pratiques/devops-genaiops.md`) | Idem | Idem |
| **États Terraform** | 3 : socle, passerelle et modèles, observabilité | 6 : + réseau et sécurité, FinOps, plateforme d'agents | 8 : + connaissance, outils | 10 : découpage cible (`docs/pratiques/devops-genaiops.md`) |

*Pourquoi les pourcentages n'arrivent qu'en V4 : ouvrir à « 5 % des utilisateurs » n'a de sens statistique qu'avec beaucoup d'utilisateurs. Avant, une société pilote suffit.*

## Matrice de versions d'un produit IA (à partir de V2)

Chaque version d'un produit IA permet de retrouver :

| Élément | Exemple |
|---|---|
| Version du produit | 1.4.0 |
| Version du prompt | prompt-2.3.1 |
| Alias du modèle | coding-main |
| Déploiement réel et version du modèle | Nom et version du déploiement Foundry |
| Version des outils | tools-1.5.0 |
| Version du jeu d'évaluation | evalset-3.0 |
| Version des policies | apim-policy-2.1.0 |
| Commit Git | Identifiant du commit déployé |

Cette matrice sert à reproduire une anomalie et à comparer deux versions.

## Évaluation des modèles et agents

**Contenu d'un jeu d'évaluation :** cas nominaux, cas limites, cas interdits, erreurs d'outils, demandes ambiguës, attaques par injection, données absentes, demandes dépassant les droits, scénarios à coût élevé.

**Quand évaluer :** changement de prompt, de modèle ou de version ; ajout d'un outil ; modification de la recherche documentaire ; avant toute promotion en production ; périodiquement sur les traces de production (V4).

**Seuils initiaux, à calibrer par offre (à partir de V2) :**

| Critère | Seuil initial |
|---|---|
| Réussite des scénarios critiques | 100 %, sur 3 exécutions |
| Réussite globale du jeu | Au moins 90 %, en moyenne sur 3 exécutions |
| Régression par rapport à la version courante | Moins de 2 points |
| Violation de sécurité critique | 0 |
| Fuite de données | 0 |
| Hausse du coût par tâche réussie | Moins de 15 % sans justification |
| Hausse de la latence P95 | Moins de 20 % sans justification |

*Pourquoi plusieurs exécutions : un modèle ne répond pas deux fois exactement pareil. Un seuil mesuré sur une seule exécution rendrait le pipeline instable.*

## Matrice d'approbation (à partir de V2)

| Changement | Approbation minimale |
|---|---|
| Documentation | Un pair |
| Module Terraform | Équipe plateforme |
| Policy API Management | Plateforme, et sécurité selon l'impact |
| Modèle | Plateforme, FinOps, propriétaire de l'offre |
| Agent | Propriétaire métier et plateforme |
| Réseau ou identité | Plateforme et sécurité |
| Production | Responsable habilité, distinct de l'auteur |
| Budget | FinOps et propriétaire de l'offre |

En V1, avec une équipe de 2 à 3 personnes, la règle minimale est : l'auteur d'un changement de production n'est pas celui qui l'approuve.

## Découpage cible des états Terraform (V4)

| État | Contenu |
|---|---|
| platform-core | Groupes de ressources, conventions, identités communes |
| network-security | Réseau, points d'accès privés, DNS, règles de sécurité |
| secrets | Key Vault et droits d'accès |
| foundry-models | Ressources Foundry et déploiements de modèles |
| apim-gateway | Instance API Management et socle commun |
| apim-products | API, opérations, policies, produits |
| observability | Application Insights, Log Analytics, diagnostics |
| finops | Budgets, alertes, exports, reporting |
| agent-platform | Runtimes et composants agentiques |
| software-factory | Composants propres au développement logiciel |

Les états sont séparés selon le cycle de vie, la criticité, la fréquence de changement et le rayon d'impact. Aucun état local pour un environnement partagé.

## Changements soumis à revue renforcée

Suppression d'une ressource ; remplacement d'une ressource à état ; modification du réseau, de Key Vault, des rôles ou d'une identité ; toute modification de production ; augmentation de capacité ; ajout d'une région ; changement de backend ou de rétention.
