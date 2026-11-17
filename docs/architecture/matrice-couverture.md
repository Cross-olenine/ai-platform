# Matrice de couverture bloc × version

| Bloc | V1 | V2 | V3 | V4 |
|---|---|---|---|---|
| Identité | Entra, 1 tenant, identité managée | Multi-tenant, contexte société, révocation | Au nom de l'utilisateur, identité d'agent | Accès conditionnel, revue des droits |
| Model Gateway | 2 alias, limites, streaming | Repli, lots, quotas par société | Embeddings | Capacité réservée, cache, routage, modèles tiers |
| Agent Runtime | Agents managés, sessions | Agents code, cycle de vie 5 états | Outils, sources, mémoire, asynchrone | Multi-agents, 8 états |
| Passerelle | 8 fragments de base | Fragments complets, révisions | Exposition MCP | Multi-région |
| Sociétés | Dimension présente dans les données | Référentiel, isolation mutualisée | Index et mémoire isolés | Isolation dédiée |
| FinOps | Événement d'usage, coût estimé, plafonds | Refacturation, réconciliation, revues | Coûts RAG, coût par tâche réussie | Gaspillages automatisés |
| Observabilité | Corrélation, métriques, alertes de base | Tableaux de bord, politique de contenu | Trace jusqu'à l'outil | Évaluation continue |
| Garde-fous | Filtres par défaut | Tests adverses, données personnelles | Injection indirecte, red teaming | Politique par offre |
| Catalogues | Modèles, agents, environnements | Sociétés, offres, plans | Sources, outils | Portail libre-service |
| Connaissance | — | Étude | Production | Multi-connecteurs |
| Outils et MCP | — | Étude | Production | Catalogue partagé |
| Canaux | 1 adaptateur | 2 canaux, SDK, OpenCode | Idem | Teams, catalogue d'adaptateurs |
| Résilience | Mesure des objectifs de service | Repli, test de reconstruction | Idem | Multi-région, PRA |
| Environnements | Dev, prod | Dev, recette, prod | + temporaires | + seconde région |
| États Terraform | 3 | 6 | 8 | 10 |
