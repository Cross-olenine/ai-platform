# Exigences — Secrets (KV)

Mode : **N** = natif Azure, **C** = configuration, **D** = développement spécifique. La version indique quand l'exigence devient obligatoire. Statut : `À faire`, `En cours`, `Fait`, `Abandonnée`.

| ID | Exigence | Version | Mode | Statut |
|---|---|---|---|---|
| KV-01 | Un Key Vault par environnement, accessible par identité managée. | V1 | C | À faire |
| KV-02 | Aucun secret dans Git, dans les variables de pipeline ou dans les policies. Un contrôle automatique le vérifie. | V1 | C | À faire |
| KV-03 | Aucun secret de la plateforme n'est transmis aux interfaces clientes. | V1 | C | À faire |
| KV-04 | Les accès sont journalisés ; les expirations déclenchent une alerte. | V2 | N | À faire |
| KV-05 | La rotation est automatisée. | V2 | C | À faire |
| KV-06 | Les credentials d'outils et de connecteurs sont gérés au vault, par société si nécessaire. | V3 | C | À faire |
