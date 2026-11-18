# Gouvernance et organisation

## Rôles

| Rôle | Responsabilités principales |
|---|---|
| Équipe plateforme | Socle Azure, passerelle, sécurité, catalogues, observabilité, FinOps |
| Équipe produit IA | Configuration des agents, règles métier, évaluations, expérience fonctionnelle |
| Équipe canal | Adaptateurs et interfaces |
| Équipe sécurité | Identités, réseau, secrets, audit, conformité |
| Équipe FinOps | Tarifs, budgets, réconciliation, reporting |
| Société consommatrice | Utilisateurs, projets, budget, validation métier, usage conforme |
| Exploitation | Supervision, incidents, capacité, changements, continuité |

En V1, ces rôles sont cumulés par 2 à 3 personnes. Ils se séparent à mesure que les versions avancent ; en V4, chacun est tenu par une équipe distincte.

## Qualification d'une demande

Toute demande remplit une fiche courte avant d'entrer sur la plateforme. Modèle : `docs/cas-usage/modele-fiche.md` ; registre des cas d'usage : `docs/cas-usage/README.md`.

| Champ | Contenu |
|---|---|
| Besoin | Problème métier, utilisateurs, valeur attendue |
| Résultat de l'arbre de décision (`docs/01-objet-perimetre.md`) | Produit sur étagère, configuration, adaptateur, nouvel agent ou nouveau composant |
| Classe (`docs/03-modele-maturite.md`) | C1 à C6 |
| Niveau cible (`docs/03-modele-maturite.md`) | N1 à N4, avec justification |
| Données | Nature, sensibilité, données personnelles |
| Signal de réussite | Comment on sait qu'une tâche est réussie |
| Propriétaire et budget | Personne responsable, enveloppe, centre de coût |
| Compatibilité | La version actuelle de la plateforme permet-elle ce niveau pour cette classe (`docs/03-modele-maturite.md`) ? |

Si la plateforme ne permet pas encore le niveau demandé, la demande alimente les déclencheurs de la version suivante.

## Instances

| Instance | Fréquence | Objet | À partir de |
|---|---|---|---|
| Revue de qualification | À la demande | Orienter les nouvelles demandes | V1 |
| Revue FinOps de service | Mensuelle | Coûts, écarts, ressources inutiles | V1 |
| Revue opérationnelle | Hebdomadaire | Anomalies, sessions coûteuses, erreurs répétées, dépassements | V2 |
| Revue d'architecture | Trimestrielle | Modèles, dimensionnement, tarifs, retraits, décision de passage de version | V2 |
