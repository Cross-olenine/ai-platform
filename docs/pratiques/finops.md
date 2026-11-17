# FinOps par version

| Sujet | V1 | V2 | V3 | V4 |
|---|---|---|---|---|
| **Mesure** | Événement d'usage par requête, coût estimé | + réconciliation mensuelle avec le coût réel | + coûts d'indexation et d'embeddings | Idem |
| **Attribution** | Par utilisateur, application, modèle, agent | + par société, offre, projet ; répartition des coûts partagés | + par source et par outil | Refacturation automatisée |
| **Limitation** | Plafonds de tokens par application | + par société et par utilisateur ; politique de dépassement par offre | + par outil | + par session pour les usages à risque |
| **Budgets** | Par environnement | + par offre, société, modèle, agent | + par source | + par projet |
| **Optimisation** | Deux alias (un économique) ; plafonds de sortie | + traitement par lots ; repli ; suivi de l'usage du cache de prompts | + maîtrise de la taille du contexte récupéré | + capacité réservée, cache sémantique, routage par coût |
| **Gaspillages** | Tags, propriétaires, dates d'expiration | Requêtes planifiées, règle 30/60/90 jours | + index inutilisés | Détection et tickets automatiques |
| **Revues** | Mensuelle (coût, écarts, ressources inutiles) | + hebdomadaire opérationnelle, + trimestrielle d'architecture | Idem | Idem |
| **Coût fixe du socle** | Chiffré et suivi | Rechiffré avant passage | Rechiffré | Rechiffré |

**Règles par environnement :**

- **Développement :** capacités minimales, quotas faibles, rétention courte, budgets stricts, alertes précoces, suppression régulière des ressources temporaires.
- **Recette :** capacité activée à la demande, données de test maîtrisées, nettoyage après campagne, coût suivi par campagne. Pas de données réelles de production sans anonymisation et autorisation explicites.
- **Production :** capacité conforme aux engagements, haute disponibilité seulement si justifiée, budgets par offre, alertes techniques et financières.

**Questions à poser avant toute création ou évolution de composant :** Quelle valeur apporte-t-il ? Qui en est responsable ? Qui le consommera ? Comment mesurer sa consommation ? Comment attribuer son coût ? Quel budget ? Comment détecter un surdimensionnement ou une absence d'usage ? Quand le réduire, l'arrêter ou le supprimer ?
