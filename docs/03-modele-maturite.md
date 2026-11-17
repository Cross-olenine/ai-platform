# Modèle de maturité

Le modèle repose sur trois axes indépendants :

- la **version de la plateforme** (V1 à V4) : ce que la plateforme sait faire ;
- la **classe du cas d'usage** (C1 à C6) : la complexité technique de ce qu'on veut faire ;
- le **niveau de maturité du cas d'usage** (N0 à N4) : jusqu'où on l'emmène, de l'idée à la production critique.

Chaque cas d'usage déclare, dès sa qualification, sa classe et son **niveau cible**. La version de la plateforme détermine le niveau maximal qu'il peut atteindre (`docs/03-modele-maturite.md`).

## Versions de la plateforme

| Version | Nom | Ce qu'elle apporte | Ordre de grandeur |
|---|---|---|---|
| **V1** | Socle minimal | Un accès gouverné aux modèles, un agent managé, un canal, le coût mesuré par appel | 1 à 3 cas d'usage, 1 société |
| **V2** | Plateforme réutilisable | Multi-sociétés, quotas et refacturation, agents « code », deuxième canal, portes d'évaluation, Software Factory | 3 à 15 cas d'usage, quelques sociétés |
| **V3** | Connaissance et outils | RAG avec respect des droits, registre d'outils et MCP, identité d'agent, exécution asynchrone, mémoire | 10 à 50 cas d'usage |
| **V4** | Échelle | Libre-service, multi-région et PRA, capacité réservée, multi-agents, automatisation complète par catalogue | Des centaines de cas d'usage |

Les ordres de grandeur sont indicatifs. Le passage d'une version à l'autre est décidé sur des **déclencheurs mesurés** (`docs/architecture/`), pas sur un calendrier.

## Classes de cas d'usage

| Classe | Description | Exemples |
|---|---|---|
| **C1** | Service de modèle : appel d'API sans état | Génération, résumé, classification, extraction, analyse de contenu |
| **C2** | Assistant conversationnel : sessions, instructions, sans données privées d'entreprise ni actions | Chatbot d'aide à la rédaction, assistant généraliste, questions sur un document fourni dans la conversation |
| **C3** | Agent documentaire : réponses fondées sur des sources d'entreprise (RAG) | Agent connecté à SharePoint, base de procédures |
| **C4** | Agent avec outils : lit ou agit dans des systèmes | Création de ticket, interrogation d'un référentiel, serveurs MCP |
| **C5** | Multi-agents et tâches longues | Orchestration de plusieurs agents, traitements de plusieurs minutes ou heures, validation humaine intermédiaire |
| **C6** | Assistant de développement (Software Factory) | OpenCode branché sur la passerelle |

C6 est techniquement simple (c'est un client de la passerelle) mais c'est la classe la plus consommatrice de tokens. Elle est ouverte en V1 avec des limites d'appels par application (MGW-03), sans limite de tokens (niveau Consumption, ADR-18). Les limites de tokens (MGW-20) et les quotas par utilisateur (MGW-04) arrivent en V2 et permettent d'ouvrir C6 largement.

## Niveaux de maturité d'un cas d'usage

| Niveau | Nom | Ce que cela signifie | Exigences pour l'atteindre |
|---|---|---|---|
| **N0** | Qualifié | La demande est comprise et orientée | Fiche de qualification remplie (`docs/gouvernance.md`), arbre de décision passé, classe et niveau cible déclarés, propriétaire métier nommé |
| **N1** | Expérimentation | Prototype en bac à sable | Environnement de développement, budget plafonné, pas de données réelles sensibles, date d'expiration, aucun engagement de service |
| **N2** | Pilote | Groupe restreint d'utilisateurs réels | Fiche d'agent versionnée, jeu d'évaluation initial, traces disponibles, budget et quotas, collecte du feedback, entrée au registre des cas d'usage IA |
| **N3** | Production | Ouvert aux utilisateurs cibles | Seuils d'évaluation atteints, tableau de bord, alertes, procédure d'investigation, retour arrière testé, documentation d'exploitation, objectifs de service standard |
| **N4** | Production critique | Service dont l'arrêt a un impact métier fort | Haute disponibilité et repli, PRA avec RTO et RPO, évaluation continue sur traces de production, coût par tâche réussie suivi, astreinte |

Un cas d'usage n'a pas vocation à atteindre N4. Le niveau cible se choisit selon la criticité métier : un outil interne peut rester durablement en N3.

## Niveau maximal atteignable par classe et par version

| Classe | V1 | V2 | V3 | V4 |
|---|---|---|---|---|
| C1 Service de modèle | N3 | N3 | N3 | N4 |
| C2 Assistant conversationnel | N3 | N3 | N3 | N4 |
| C6 Assistant de développement | N1 (étude) | N3 | N3 | N4 |
| C3 Agent documentaire | N1 (étude) | N1 (étude) | N3 | N4 |
| C4 Agent avec outils | — | N1 (étude) | N3 | N4 |
| C5 Multi-agents, tâches longues | — | — | N2 | N4 |

Lecture : en V2, un agent documentaire peut être prototypé en bac à sable (N1) pour préparer V3, mais ne peut pas être ouvert à des utilisateurs réels.
