# Exigences — Sociétés (TEN)

Mode : **N** = natif Azure, **C** = configuration, **D** = développement spécifique. La version indique quand l'exigence devient obligatoire. Statut : `À faire`, `En cours`, `Fait`, `Abandonnée`.

| ID | Exigence | Version | Mode | Statut |
|---|---|---|---|---|
| TEN-01 | Le champ société est présent dans tous les événements d'usage, même avec une seule société. | V1 | C | À faire |
| TEN-02 | Le référentiel des sociétés contient : identifiant interne, tenant Entra, entité contractuelle, centre de coût, offres souscrites, modèles et agents autorisés, quotas, budget, responsables à notifier, politique de dépassement, niveau d'isolation, période contractuelle. | V2 | C | À faire |
| TEN-03 | L'onboarding se fait par modification déclarative du catalogue, sans déploiement manuel de composants partagés. | V2 | C | À faire |
| TEN-04 | Le niveau d'isolation « mutualisé » sépare logiquement les données de sessions par société. Un test automatisé prouve l'absence d'accès croisé. | V2 | C | À faire |
| TEN-05 | Chaque société a une part garantie et un plafond sur chaque alias, pour qu'aucune ne sature le quota partagé. | V2 | C | À faire |
| TEN-06 | L'offboarding couvre : désactivation, export, suppression des données, clôture FinOps. | V2 | C | À faire |
| TEN-07 | Les index et la mémoire sont isolés par société. | V3 | C | À faire |
| TEN-08 | Le niveau d'isolation « dédié » fournit des déploiements de modèles, des index et un stockage propres à une société. | V4 | C | À faire |

Le référentiel doit permettre de répondre à la question : *à quelle société, quel contrat et quel centre de coût cet appel doit-il être attribué ?*
