# Exigences — Adaptateurs de canaux (CHN)

Mode : **N** = natif Azure, **C** = configuration, **D** = développement spécifique. La version indique quand l'exigence devient obligatoire. Statut : `À faire`, `En cours`, `Fait`, `Abandonnée`.

Un adaptateur prend en charge : l'authentification du canal, la transformation des formats d'entrée et de sortie, l'appel de l'API de plateforme, la propagation du contexte utilisateur, le streaming.

| ID | Exigence | Version | Mode | Statut |
|---|---|---|---|---|
| CHN-01 | Un adaptateur ne contient ni logique d'agent, ni clé Foundry, ni endpoint de modèle, ni tarif, ni quota, ni règle de sécurité propre au modèle. | V1 | C | À faire |
| CHN-02 | Un premier adaptateur est livré, choisi selon le premier cas d'usage. | V1 | D | À faire |
| CHN-03 | Un deuxième canal consomme un agent existant sans modification de l'agent ni de la plateforme. | V2 | D | À faire |
| CHN-04 | Power Platform : connecteur personnalisé sécurisé par Entra ID, sans logique d'agent. Un flux Power Automate seulement quand l'orchestration le justifie. | V2 | D | À faire |
| CHN-05 | Application sur site : obtention et renouvellement du jeton, proxy d'entreprise, délais, nouvelles tentatives bornées, streaming, corrélation. | V2 | D | À faire |
| CHN-06 | Web et mobile passent par un backend applicatif, pas directement par la passerelle. | V2 | D | À faire |
| CHN-07 | Software Factory : la configuration centrale d'OpenCode impose fournisseur d'entreprise, alias autorisés, endpoint de la passerelle, limites et en-têtes de contexte. | V1 | C | À faire |
| CHN-08 | Un modèle d'adaptateur et un SDK évitent de réécrire jeton, nouvelles tentatives et corrélation. | V2 | D | À faire |
| CHN-09 | Teams et Microsoft 365. | V4 | C | À faire |
