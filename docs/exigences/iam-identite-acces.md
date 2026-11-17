# Exigences — Identité et accès (IAM)

Mode : **N** = natif Azure, **C** = configuration, **D** = développement spécifique. La version indique quand l'exigence devient obligatoire. Statut : `À faire`, `En cours`, `Fait`, `Abandonnée`.

| ID | Exigence | Version | Mode | Statut |
|---|---|---|---|---|
| IAM-01 | Tout appel est authentifié par un jeton Microsoft Entra ID. Aucune clé d'API n'est distribuée aux consommateurs. | V1 | C | À faire |
| IAM-02 | La passerelle accède à Foundry par identité managée. L'authentification par clé est désactivée sur les ressources Foundry. | V1 | C | À faire |
| IAM-03 | Les rôles applicatifs (utilisateur, administrateur d'offre, exploitation) sont contrôlés à la passerelle. | V1 | C | À faire |
| IAM-04 | Le contexte (société, utilisateur, application, offre) est résolu à partir du jeton, jamais d'un en-tête déclaré par le client. | V2 | C | À faire |
| IAM-05 | Plusieurs tenants Entra sont pris en charge, selon le mode retenu par ADR-04. | V2 | C | À faire |
| IAM-06 | La révocation d'un utilisateur, d'une application ou d'une société prend effet dans un délai défini et testé. | V2 | C | À faire |
| IAM-07 | L'accès aux données et aux outils se fait au nom de l'utilisateur : l'agent ne voit jamais plus que lui. | V3 | C | À faire |
| IAM-08 | Chaque agent a sa propre identité, distincte de celle de l'utilisateur et de l'application hôte. | V3 | N | À faire |
| IAM-09 | Les identités d'agents et de pipelines font l'objet d'un accès conditionnel et d'une revue périodique des droits. | V4 | C | À faire |

*Pourquoi IAM-07 est structurant : un agent qui lit SharePoint avec sa propre identité peut remonter à n'importe qui un document confidentiel. C'est le premier risque de fuite des agents documentaires.*
