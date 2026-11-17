# Exigences — Connaissance — RAG (KNW)

Mode : **N** = natif Azure, **C** = configuration, **D** = développement spécifique. La version indique quand l'exigence devient obligatoire. Statut : `À faire`, `En cours`, `Fait`, `Abandonnée`.

Bloc livré en V3. Études autorisées en bac à sable avant.

| ID | Exigence | Version | Mode | Statut |
|---|---|---|---|---|
| KNW-01 | Un catalogue décrit chaque source : propriétaire, classification, sociétés autorisées, fréquence de rafraîchissement, rétention. | V3 | C | À faire |
| KNW-02 | Un pipeline d'ingestion standard (extraction, découpage, embeddings, indexation) est paramétrable et réutilisé d'une source à l'autre. | V3 | D | À faire |
| KNW-03 | La recherche est filtrée selon les droits de l'utilisateur, repris de la source. | V3 | C | À faire |
| KNW-04 | Les suppressions et modifications de la source sont propagées dans un délai défini. | V3 | C | À faire |
| KNW-05 | Les index sont isolés par société (ADR-09). | V3 | C | À faire |
| KNW-06 | Toute réponse documentaire cite ses sources. | V3 | C | À faire |
| KNW-07 | Une évaluation dédiée mesure la pertinence de la recherche et l'ancrage des réponses. | V3 | C | À faire |
| KNW-08 | Premier connecteur : SharePoint. | V3 | C | À faire |
| KNW-09 | D'autres connecteurs s'ajoutent sur le même modèle. | V4 | C | À faire |
| KNW-10 | Un index inutilisé est détecté puis supprimé. | V4 | C | À faire |
