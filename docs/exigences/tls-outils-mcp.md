# Exigences — Outils et MCP (TLS)

Mode : **N** = natif Azure, **C** = configuration, **D** = développement spécifique. La version indique quand l'exigence devient obligatoire. Statut : `À faire`, `En cours`, `Fait`, `Abandonnée`.

Bloc livré en V3. Études autorisées en bac à sable à partir de V2.

| ID | Exigence | Version | Mode | Statut |
|---|---|---|---|---|
| TLS-01 | Un registre décrit chaque outil : propriétaire, schéma versionné, nature (lecture, écriture, irréversible), classification, sociétés autorisées. | V3 | C | À faire |
| TLS-02 | Les serveurs MCP ne sont joignables que par la passerelle. Aucun serveur non enregistré n'est utilisable. | V3 | C | À faire |
| TLS-03 | L'autorisation se fait par outil et par utilisateur ; l'outil s'exécute au nom de l'utilisateur. | V3 | C | À faire |
| TLS-04 | Les outils d'écriture et irréversibles demandent une validation humaine. | V3 | C | À faire |
| TLS-05 | Chaque appel d'outil est tracé : identifiant de trace, durée, statut, sans contenu sensible. | V3 | C | À faire |
| TLS-06 | Chaque outil a un quota et un délai maximal. | V3 | C | À faire |
| TLS-07 | Les schémas d'outils sont testés automatiquement. | V3 | C | À faire |
| TLS-08 | Les outils sont réutilisables entre agents par un catalogue en libre-service. | V4 | C | À faire |
