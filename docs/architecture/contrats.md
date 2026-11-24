# Contrats stables

Ces contrats sont fixés dès V1 et ne changent plus sans gestion de version. Ce sont eux qui rendent la réutilisation possible.

| Contrat | Contenu | Pourquoi il est stable |
|---|---|---|
| **API de plateforme pour les agents** | Créer une session ; envoyer un message (avec streaming) ; récupérer l'historique ; transmettre un feedback ; à partir de V3 : lancer et suivre une tâche asynchrone | Tous les canaux l'appellent. La changer, c'est modifier tous les adaptateurs. |
| **Alias de modèles** | Noms fonctionnels (`agent-general`, `coding-main`, `embedding-default`…). Un alias a une nature (`kind` : `chat` ou `embedding`) qui détermine la route (`/responses` ou `/embeddings`, ADR-06, ADR-19) | Les clients ne connaissent jamais le déploiement réel. On change de modèle sans toucher aux clients. |
| **Événement d'usage** | Une ligne par requête, au même format quel que soit le canal (`docs/reference/evenement-usage.md`) | Tout le FinOps en dépend. |
| **Contexte de trace** | Identifiant de corrélation au standard W3C Trace Context, propagé de l'interface à l'outil | Permet de suivre un appel de bout en bout. |
| **Fiche d'agent** | Schéma de la définition déclarative d'un agent (`docs/reference/schemas-catalogues.md`) | Un agent se décrit de la même façon, qu'il soit managé ou « code ». |
