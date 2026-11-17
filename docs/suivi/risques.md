# Risques

| Risque | Effet | Parade |
|---|---|---|
| Construire la plateforme avant les cas d'usage | Coût sans valeur, blocs inadaptés | Versions déclenchées par des signaux mesurés ; principe P3 |
| Coût fixe du socle supérieur à la valeur produite | Contredit « coûts réduits » | FIN-07 ; deux environnements en V1 |
| Contournement de la plateforme par les équipes | Sécurité et coûts non maîtrisés | Bloc expérience développeur ; DEX-05 |
| Dépendance à des fonctions en préversion | Instabilité, reprise | Liste des points à vérifier ; pas de préversion sur le chemin critique de production |
| Assistant de développement très consommateur | Dérive budgétaire rapide | Limites d'appels par application en V1 (MGW-03), sans limite de tokens ; limites de tokens en V2 (MGW-20), quotas par utilisateur (MGW-04) |
| Retrait d'un modèle imposé par le fournisseur | Régression subie | MGW-11, MGW-13 |
| Pipeline instable à cause du non-déterminisme | Perte de confiance dans les portes d'évaluation | Seuils sur plusieurs exécutions |
| Équipe trop petite pour le périmètre | Retard, dette | Périmètre V1 strict ; reports explicites |
| Forte dépendance à Azure | Réversibilité limitée | Contrats stables (`docs/architecture/contrats.md`) indépendants du fournisseur ; à assumer explicitement dans ADR-01 |
