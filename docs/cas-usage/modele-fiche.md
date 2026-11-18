# Fiche de qualification : <nom du cas d'usage>

Modèle de la fiche de `docs/gouvernance.md` (« Qualification d'une demande »). Copier ce fichier en `docs/cas-usage/<identifiant>.md`, le remplir, puis ajouter une ligne au registre (`docs/cas-usage/README.md`). Les marqueurs `À COMPLÉTER` signalent ce que seul le demandeur peut fournir.

| | |
|---|---|
| **Identifiant** | `<identifiant>` (le même que dans `catalog/environments/*.yaml`, `applications[].id`) |
| **Statut** | Qualifié (N0) / Expérimentation (N1) / Pilote (N2) / Production (N3) / Industrialisé (N4) |
| **Date de qualification** | AAAA-MM-JJ |

## Qualification

| Champ | Contenu |
|---|---|
| Besoin | À COMPLÉTER : problème métier, utilisateurs, valeur attendue |
| Résultat de l'arbre de décision (`docs/01-objet-perimetre.md`) | Produit sur étagère, configuration, adaptateur, nouvel agent ou nouveau composant |
| Classe (`docs/03-modele-maturite.md`) | C1 à C6 |
| Niveau cible (`docs/03-modele-maturite.md`) | N1 à N4, avec justification |
| Données | À COMPLÉTER : nature, sensibilité, données personnelles |
| Signal de réussite | À COMPLÉTER : comment on sait qu'une tâche est réussie |
| Propriétaire et budget | À COMPLÉTER : personne responsable, enveloppe mensuelle, centre de coût |
| Compatibilité | La version actuelle de la plateforme permet-elle ce niveau pour cette classe ? |

## Registre IA (CMP-02)

| Champ | Contenu |
|---|---|
| Classification de risque (règlement européen sur l'IA) | Minimal / limité / élevé, avec justification |
| Information des utilisateurs (CMP-04) | Comment les utilisateurs savent qu'ils interagissent avec une IA |

## Mise en œuvre sur la plateforme

| Élément | Valeur |
|---|---|
| Application consommatrice | `applications[]` dans `catalog/environments/<env>.yaml` |
| Alias de modèles autorisés | |
| Limites d'appels (MGW-03) | |
| Canal | |
