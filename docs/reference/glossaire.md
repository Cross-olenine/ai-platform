# Glossaire

| Terme | Définition |
|---|---|
| **ADR** | Architecture Decision Record : note courte qui consigne une décision d'architecture, son contexte et ses alternatives. |
| **Alias** | Nom fonctionnel stable donné à un modèle (`coding-main`). Les clients appellent l'alias ; la plateforme décide quel déploiement réel répond. |
| **Cardinalité** | Nombre de valeurs distinctes d'une dimension. Une dimension « utilisateur » a une forte cardinalité. |
| **Capacité réservée** | Débit de modèle acheté à l'avance pour un prix fixe, intéressant quand le volume est stable et élevé. |
| **Dérive** | Écart entre ce que décrit le code et ce qui existe réellement dans Azure. |
| **Disjoncteur** | Mécanisme qui cesse d'envoyer du trafic à un backend en erreur, puis réessaie plus tard. |
| **Feature flag** | Interrupteur qui active une fonction pour un périmètre donné sans redéployer. |
| **Fragment de policy** | Morceau de règle API Management réutilisable dans plusieurs API. |
| **Identité managée** | Identité Azure attribuée à un service, sans mot de passe à gérer. |
| **Injection de prompt** | Attaque qui glisse des instructions dans une entrée. *Directe* : dans le message de l'utilisateur. *Indirecte* : dans un document ou un résultat d'outil lu par l'agent. |
| **MCP** | Model Context Protocol : standard pour exposer des outils et des données à un agent. |
| **P95** | Valeur sous laquelle se situent 95 % des mesures. Une latence P95 de 4 s signifie que 95 % des appels répondent en moins de 4 s. |
| **PRA** | Plan de reprise d'activité. |
| **RAG** | Retrieval-Augmented Generation : le modèle répond à partir de documents retrouvés par une recherche. |
| **Red teaming** | Campagne où l'on attaque volontairement le système pour trouver ses failles. |
| **RTO / RPO** | Durée maximale d'interruption acceptée / perte de données maximale acceptée. |
| **TPM** | Tokens par minute : unité de quota d'un déploiement de modèle. |
| **Voisin bruyant** | Consommateur qui, sur une ressource partagée, dégrade le service des autres. |
| **Zone de données** | Type de déploiement qui garantit un traitement dans un périmètre géographique (ici l'UE). |
