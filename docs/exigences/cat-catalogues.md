# Exigences — Catalogues (CAT)

Mode : **N** = natif Azure, **C** = configuration, **D** = développement spécifique. La version indique quand l'exigence devient obligatoire. Statut : `À faire`, `En cours`, `Fait`, `Abandonnée`.

| ID | Exigence | Version | Mode | Statut |
|---|---|---|---|---|
| CAT-01 | Les catalogues sont des fichiers YAML versionnés dans Git, validés par schéma à chaque demande de changement. | V1 | C | En cours |
| CAT-02 | Catalogues V1 : modèles, agents, environnements. | V1 | C | En cours |
| CAT-03 | Une entrée de catalogue produit l'infrastructure par une boucle Terraform. Pas d'outil de génération maison avant V4. | V1 | C | En cours |
| CAT-04 | Le pipeline refuse : un modèle sans propriétaire, tarif ou limite ; un agent sans propriétaire, modèle ou jeu d'évaluation ; une ressource temporaire sans date d'expiration. | V1 | C | En cours |
| CAT-05 | Catalogues V2 : sociétés, offres, plans de service. Refus d'une société sans tenant ou contrat, d'une offre sans quotas. | V2 | C | À faire |
| CAT-06 | Une partie de la documentation est générée depuis les catalogues : modèles, agents, offres, routes, quotas, versions. | V2 | C | À faire |
| CAT-07 | Catalogues V3 : sources de données, outils. | V3 | C | À faire |
| CAT-08 | Un portail libre-service s'appuie sur les catalogues. | V4 | D | À faire |

*Pourquoi CAT-03 : faire lire des fichiers YAML par une boucle Terraform donne l'essentiel du bénéfice (« j'ajoute une ligne, l'infrastructure suit ») sans écrire ni maintenir un générateur.*
