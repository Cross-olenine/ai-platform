# Exigences — Garde-fous IA (GRD)

Mode : **N** = natif Azure, **C** = configuration, **D** = développement spécifique. La version indique quand l'exigence devient obligatoire. Statut : `À faire`, `En cours`, `Fait`, `Abandonnée`.

| ID | Exigence | Version | Mode | Statut |
|---|---|---|---|---|
| GRD-01 | Le filtrage de contenu en entrée et en sortie est actif sur tous les déploiements. | V1 | N | À faire |
| GRD-02 | Les tentatives d'injection directe sont détectées. | V1 | N | À faire |
| GRD-03 | La passerelle borne ou interdit les paramètres sensibles. | V1 | C | À faire |
| GRD-04 | Chaque jeu d'évaluation contient des cas adverses : injection, demande dépassant les droits, tentative de fuite. | V2 | C | À faire |
| GRD-05 | Les données personnelles sont masquées dans les journaux. | V2 | C | À faire |
| GRD-06 | Le contenu des documents et les résultats d'outils sont traités comme des données, jamais comme des instructions (protection contre l'injection indirecte). | V3 | C | À faire |
| GRD-07 | Un red teaming précède tout passage en N3 pour les classes C3 à C5. | V3 | C | À faire |
| GRD-08 | La politique de garde-fous est paramétrable par offre. | V4 | C | À faire |
