# Points ouverts (PO)

Registre unique des points à vérifier. Un numéro n'est jamais réutilisé ni renuméroté. Statuts : `Ouvert`, `En test`, `Vérifié`, `Infirmé`.

> **Remise en ordre du 17 novembre 2026.** Les numéros PO-08, PO-09 et PO-10 avaient deux sens. Ceux des ADR acceptés sont conservés. Les points qui portaient ces numéros dans `docs/architecture/v1-socle-minimal.md` et `docs/suivi/a-faire-v1.md` ont été renumérotés PO-11 à PO-13.

| PO | Point à vérifier | Version | Cité par | Statut | Résultat |
|---|---|---|---|---|---|
| PO-01 | Les appels aux modèles d'un agent managé passent par la passerelle et produisent les mêmes événements d'usage. Piste : connexion « modèle via API Management » de Foundry Agent Service (préversion en novembre 2026). | V1 (phase agents) | ADR-01, AGT-04 | Ouvert | |
| PO-02 | Statut de disponibilité générale des agents « code » dans Foundry Agent Service. | V2 | ADR-01 | Ouvert | |
| PO-03 | Choix et chiffrage du niveau payant d'API Management de la V2. | V2 | ADR-18 | Ouvert | |
| PO-04 | Disponibilité, en déploiement Data Zone Standard EU depuis France Central, des modèles candidats aux deux alias. | V1 | ADR-03 | Ouvert | |
| PO-05 | Licence nécessaire à l'identité d'agent. | V3 | — | Ouvert | |
| PO-06 | Non attribué. | — | — | — | |
| PO-07 | Coût fixe mensuel du socle V1 : API Management Consumption, Log Analytics, Application Insights, Key Vault, stockage des états, minutes de pipelines. | V1 | FIN-07 | Ouvert | |
| PO-08 | Restriction par adresse IP de sortie de la passerelle vers Foundry. | V1 | ADR-07 | Ouvert | Les adresses de sortie du niveau Consumption ne sont pas fixes : à vérifier. |
| PO-09 | Données à migrer ou à laisser expirer lors de la bascule de la production vers son abonnement V2. | V2 | ADR-12 | Ouvert | |
| PO-10 | Périmètre exact des licences Microsoft 365 Copilot. | V1 | ADR-16 | Ouvert | |
| PO-11 | **Prototype P-A.** `rate-limit` et `quota` par abonnement fonctionnent en Consumption et renvoient un 429 exploitable. | V1 | MGW-03, ADR-18 | Ouvert | |
| PO-12 | **Prototype P-B.** Un appel en streaming sur l'API Responses traverse API Management Consumption sans mise en tampon, et son nombre de tokens est capturé dans l'événement d'usage. Pistes : `llm-emit-token-metric`, puis policy `trace` sur l'événement final. | V1 | FIN-01, MGW-06, ADR-18 | Ouvert | Échec : ADR-18 rouvert (repli Basic v2). |
| PO-13 | **Prototype P-C.** Foundry refuse tout appel direct (authentification par clé désactivée, rôle d'accès aux modèles accordé à la seule identité de la passerelle), sans réseau privé. | V1 | IAM-02, ADR-07 | Ouvert | |
| PO-14 | OpenCode parle l'API Responses (ADR-06) avec un fournisseur personnalisé, et accepte un jeton Entra ID renouvelé pendant une longue session. | V1 | CHN-02, CHN-07 | Ouvert | |
