# Objet et périmètre

## Objectif

Construire une plateforme de services IA **industrialisée, modulaire, réutilisable, sécurisée et pilotée par la consommation**, capable d'accueillir la plupart des cas d'usage IA de la société sans reconstruire les composants techniques à chaque nouveau besoin.

Lorsqu'un nouveau besoin apparaît (chatbot dans Power Platform, assistant dans une application sur site, agent documentaire, assistant de développement, API de génération, nouveau modèle pour plusieurs sociétés), l'équipe ne développe que ce qui est propre au besoin :

- l'interface utilisateur ;
- le connecteur avec l'application consommatrice ;
- les règles métier du cas d'usage ;
- les outils ou sources de données spécifiques ;
- la configuration fonctionnelle de l'agent.

Tout le reste (identité, accès aux modèles, quotas, sécurité, journalisation, FinOps, déploiement, documentation) est fourni par la plateforme.

> **Principe directeur.** Un nouveau service IA ne reconstruit pas une plateforme. Il assemble des capacités existantes et ne développe que la dernière couche, propre au canal, à l'interface ou au métier.

La plateforme doit pouvoir être reprise, comprise, exploitée et enrichie par une autre équipe, sans dépendre de la connaissance implicite de ses premiers constructeurs.

## Traduction des trois mots d'ordre

| Mot d'ordre | Ce que cela impose | Comment on le mesure |
|---|---|---|
| **Automatisation et réutilisation** | Tout changement récurrent est déclaratif (catalogue + pipeline). Un bloc n'est écrit qu'une fois. | Délai de mise en service d'un cas d'usage standard ; part des changements sans intervention manuelle ; nombre de canaux par agent |
| **Coûts réduits** | Natif Azure avant développement. Coût fixe du socle chiffré par version. Chaque appel est attribuable. Tout composant est supprimable. | Coût fixe mensuel du socle ; coût par tâche réussie ; part des ressources sans propriétaire (cible : 0) |
| **Solidité** | Rien en production sans tests, évaluation, supervision et retour arrière. Reconstruction possible depuis le code. | Taux de changements en échec ; temps moyen de restauration ; disponibilité et latence P95 par offre |

## Périmètre

**Dans le périmètre :**

- l'accès gouverné aux modèles (Model Gateway) ;
- l'exécution et le cycle de vie des agents (Agent Platform) ;
- l'assistant de développement logiciel (Software Factory) ;
- les services transverses : identité, sociétés, secrets, garde-fous, observabilité, FinOps, catalogues ;
- les contrats et modèles d'adaptateurs de canaux ;
- l'outillage DevOps et GenAIOps ;
- à partir de V3 : la couche de connaissance (RAG) et le registre d'outils (MCP).

**Hors périmètre :**

- les interfaces utilisateur finales (à la charge des équipes canal) ;
- les règles métier d'un cas d'usage (à la charge de l'équipe produit IA) ;
- l'entraînement ou l'ajustement fin de modèles ;
- l'hébergement de modèles sur une infrastructure propre ;
- les usages couverts par un produit sur étagère (voir `docs/01-objet-perimetre.md`).

## Arbre de décision amont

La plateforme n'est pas la réponse à toute demande. Chaque demande passe par ces questions, dans l'ordre :

1. **Un produit sur étagère couvre-t-il le besoin ?** (Microsoft 365 Copilot, Copilot Studio, fonction IA native d'un logiciel déjà en place.) Si oui, on l'utilise ; la plateforme n'intervient pas.
2. **Le besoin se résume-t-il à configurer un agent existant ou un alias de modèle ?** Si oui : configuration seule, pas de développement.
3. **Faut-il un nouveau canal pour un agent existant ?** Si oui : développement du seul adaptateur.
4. **Faut-il un nouvel agent ?** Si oui : fiche d'agent, jeu d'évaluation, et les blocs existants.
5. **Manque-t-il une capacité générique, utile à au moins deux cas d'usage ?** C'est le seul cas qui justifie un nouveau composant de plateforme.

> **Règle de conception principale.** Cette demande nécessite-t-elle réellement un nouveau composant de plateforme, ou seulement la configuration et l'assemblage de blocs existants ?
