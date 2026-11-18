# Exigences — Résilience et capacité (RES)

Mode : **N** = natif Azure, **C** = configuration, **D** = développement spécifique. La version indique quand l'exigence devient obligatoire. Statut : `À faire`, `En cours`, `Fait`, `Abandonnée`.

| ID | Exigence | Version | Mode | Statut |
|---|---|---|---|---|
| RES-01 | Disponibilité et latence P95 sont mesurées par offre. | V1 | C | En cours |
| RES-02 | Les nouvelles tentatives sur erreur 429 sont bornées et espacées, pour ne pas amplifier une saturation. | V1 | C | En cours |
| RES-03 | La consommation des quotas de modèles est suivie, avec alerte à 80 %. | V1 | C | En cours |
| RES-04 | Des objectifs de service sont engagés par offre. | V2 | C | À faire |
| RES-05 | Un mode dégradé est documenté par offre (modèle de repli, fonctions désactivées). | V2 | C | À faire |
| RES-06 | Un environnement est reconstruit depuis le code au moins une fois par version. États Terraform et catalogues sont sauvegardés. | V2 | C | À faire |
| RES-07 | Un test de charge précède chaque ouverture à un nouveau palier d'utilisateurs. | V2 | C | À faire |
| RES-08 | Un PRA définit RTO et RPO par offre et s'appuie sur une seconde région. | V4 | C | À faire |
