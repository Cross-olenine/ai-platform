# Exigences — Agent Runtime (AGT)

Mode : **N** = natif Azure, **C** = configuration, **D** = développement spécifique. La version indique quand l'exigence devient obligatoire. Statut : `À faire`, `En cours`, `Fait`, `Abandonnée`.

| ID | Exigence | Version | Mode | Statut |
|---|---|---|---|---|
| AGT-01 | Un agent est défini par une fiche déclarative versionnée : identifiant, version, propriétaire, alias de modèle, instructions, quotas, sociétés autorisées, jeu d'évaluation et seuils. | V1 | C | À faire |
| AGT-02 | Le runtime managé est le choix par défaut. | V1 | N | À faire |
| AGT-03 | Tous les agents exposent le même contrat d'API, indépendant du canal : session, message avec streaming, historique, feedback. | V1 | C | À faire |
| AGT-04 | Tous les appels aux modèles émis par un agent passent par la passerelle et sont mesurés. | V1 | C | À faire |
| AGT-05 | Les erreurs sont normalisées. Une session a des limites de tokens. | V1 | C | À faire |
| AGT-06 | Le feedback utilisateur est collecté et rattaché à la trace. | V1 | C | À faire |
| AGT-07 | Une voie « code » existe pour les agents à orchestration spécifique : conteneurs respectant le même contrat, la même télémétrie et la même passerelle. | V2 | D | À faire |
| AGT-08 | Une session a aussi des limites d'itérations et de durée. | V2 | C | À faire |
| AGT-09 | Le cycle de vie est explicite : brouillon, évaluation, pilote, production, archivé. | V2 | C | À faire |
| AGT-10 | La promotion d'un agent exige : propriétaire identifié, évaluations réussies, coût acceptable, quotas configurés, traces disponibles, documentation complète, retour arrière testé. | V2 | C | À faire |
| AGT-11 | Chaque agent a une liste blanche d'outils et une liste blanche de sources. | V3 | C | À faire |
| AGT-12 | La mémoire longue suit une stratégie déclarée ; elle est isolée par utilisateur et par société, et effaçable. | V3 | C | À faire |
| AGT-13 | Les tâches longues s'exécutent de façon asynchrone : file, reprise après erreur, notification de fin. | V3 | D | À faire |
| AGT-14 | Toute action d'écriture ou irréversible demande une validation humaine. | V3 | C | À faire |
| AGT-15 | Plusieurs agents peuvent se déléguer des tâches, avec corrélation et attribution des coûts préservées. | V4 | C | À faire |
| AGT-16 | Le cycle de vie complet comporte 8 états : brouillon, développement, évaluation, recette, pilote, production, déprécié, archivé. | V4 | C | À faire |
