# Exigences — État, sessions et mémoire (STA)

Mode : **N** = natif Azure, **C** = configuration, **D** = développement spécifique. La version indique quand l'exigence devient obligatoire. Statut : `À faire`, `En cours`, `Fait`, `Abandonnée`.

| ID | Exigence | Version | Mode | Statut |
|---|---|---|---|---|
| STA-01 | Les sessions et l'historique sont gérés par le runtime managé. | V1 | N | À faire |
| STA-02 | La rétention des conversations est définie par offre ; la purge est automatique. | V1 | C | À faire |
| STA-03 | Les données sont partitionnées par société et par utilisateur. | V2 | C | À faire |
| STA-04 | Les données d'un utilisateur sont supprimables sur demande (droit à l'effacement). | V2 | C | À faire |
| STA-05 | La mémoire longue est disponible selon ADR-14. | V3 | C | À faire |
| STA-06 | Un stockage dédié par société est possible. | V4 | C | À faire |
