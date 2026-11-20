# Exigences — Observabilité (OBS)

Mode : **N** = natif Azure, **C** = configuration, **D** = développement spécifique. La version indique quand l'exigence devient obligatoire. Statut : `À faire`, `En cours`, `Fait`, `Abandonnée`.

| ID | Exigence | Version | Mode | Statut |
|---|---|---|---|---|
| OBS-01 | Un identifiant de corrélation au standard W3C Trace Context est propagé de l'interface au modèle. | V1 | C | En cours |
| OBS-02 | La télémétrie suit les conventions OpenTelemetry pour l'IA générative. | V1 | C | En cours |
| OBS-03 | Métriques minimales : appels, succès, erreurs, réponses 429 et 5xx, latence moyenne et P95, délai du premier token, tokens d'entrée, en cache, de sortie et de raisonnement. | V1 | N | En cours |
| OBS-04 | Les métriques restent à faible cardinalité. Le détail par utilisateur et par session vit dans les événements d'usage (table de journaux). | V1 | C | En cours |
| OBS-05 | Le contenu des prompts et des réponses n'est pas journalisé par défaut. | V1 | C | En cours |
| OBS-06 | Un plafond quotidien d'ingestion des journaux et une alerte sur hausse anormale sont en place. | V1 | N | En cours |
| OBS-07 | Alertes de base : disponibilité, taux d'erreur, 429, latence. Alertes avec état (une notification au déclenchement, une à la résolution) ; disponibilité et taux d'erreur évalués au-delà d'un volume minimal (`alerting.min_requests`). Notification par rôle Azure (`alerting.notified_roles`) : pas de code de validation à chaque recréation du groupe d'actions. | V1 | C | En cours |
| OBS-08 | La journalisation du contenu est activable par offre, avec masquage et rétention courte (ADR-10). | V2 | C | À faire |
| OBS-09 | Des tableaux de bord existent par offre, société et agent. | V2 | C | À faire |
| OBS-10 | On navigue de la société à l'utilisateur, à la session, à la requête, à l'appel de modèle. | V2 | C | À faire |
| OBS-11 | Chaque composant a une procédure d'investigation. | V2 | C | À faire |
| OBS-12 | La rétention est définie par type de donnée ; les journaux de niveau debug sont limités aux environnements non productifs ou aux périodes d'investigation. | V2 | C | À faire |
| OBS-13 | Les pipelines sont observés : fréquence des déploiements, délai entre commit et production, taux de changements en échec, temps moyen de restauration. | V2 | C | À faire |
| OBS-14 | La trace va jusqu'à l'appel d'outil et à la recherche documentaire. | V3 | C | À faire |
| OBS-15 | La qualité est évaluée en continu sur les traces de production. | V4 | C | À faire |

*Pourquoi OBS-04 : un coût par utilisateur et par session exige beaucoup de valeurs distinctes. Les mettre en dimensions de métriques ferait exploser le coût de la supervision. On les stocke donc comme lignes de journal.*
