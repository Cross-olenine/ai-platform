# Exigences — Model Gateway (MGW)

Mode : **N** = natif Azure, **C** = configuration, **D** = développement spécifique. La version indique quand l'exigence devient obligatoire. Statut : `À faire`, `En cours`, `Fait`, `Abandonnée`.

| ID | Exigence | Version | Mode | Statut |
|---|---|---|---|---|
| MGW-01 | Les consommateurs n'appellent que des alias fonctionnels stables. La correspondance alias → déploiement vit dans le catalogue des modèles. | V1 | C | À faire |
| MGW-02 | Tout modèle absent du catalogue est refusé (liste blanche). | V1 | C | À faire |
| MGW-03 | Une limite d'appels par minute et un quota d'appels par période sont appliqués à la passerelle, par abonnement (une application). Les limites de tokens sont reportées à MGW-20 (niveau Consumption : pas de limite de tokens, ADR-18). | V1 | N | À faire |
| MGW-04 | La limite et le quota s'appliquent aussi par société et par utilisateur. | V2 | N | À faire |
| MGW-05 | Chaque alias a un plafond de tokens de sortie et une taille maximale de requête. | V1 | C | À faire |
| MGW-06 | Le streaming fonctionne de bout en bout, sans mise en tampon à la passerelle. | V1 | C | À faire |
| MGW-07 | Les endpoints directs, clés, noms techniques et versions internes ne sont jamais visibles des consommateurs. | V1 | C | À faire |
| MGW-08 | Le protocole exposé est fixé par ADR-06. | V1 | C | À faire |
| MGW-09 | Le trafic est réparti sur plusieurs backends avec disjoncteur ; la bascule est automatique sur erreur 429 ou 5xx. | V2 | N | À faire |
| MGW-10 | Chaque alias déclare un modèle de repli (dégradation contrôlée). | V2 | C | À faire |
| MGW-11 | Un changement de modèle derrière un alias est traité comme un changement à risque : alias temporaire ou feature flag, campagne d'évaluation, bascule progressive. | V2 | C | À faire |
| MGW-12 | Les traitements non interactifs utilisent le mode par lots. | V2 | N | À faire |
| MGW-13 | Les dates de fin de support des modèles sont suivies ; une alerte précède chaque retrait. | V2 | C | À faire |
| MGW-14 | L'ajout d'un modèle se fait par une seule demande de changement sur le catalogue et prépare : déploiement, alias, route, liste blanche, limites, métriques, règles FinOps, tests, documentation. | V2 | C | À faire |
| MGW-15 | Les embeddings sont exposés par alias. | V3 | C | À faire |
| MGW-16 | Un cache sémantique est proposé aux offres éligibles, isolé par société, exclu en présence de données personnelles. | V4 | N | À faire |
| MGW-17 | Les alias à volume stable utilisent de la capacité réservée, avec débordement vers le paiement à l'usage. | V4 | C | À faire |
| MGW-18 | Un routage par coût dirige les requêtes simples vers un petit modèle et n'escalade que si nécessaire. | V4 | D | À faire |
| MGW-19 | Des modèles de fournisseurs tiers peuvent être exposés derrière la même passerelle et les mêmes règles. | V4 | C | À faire |
| MGW-20 | Une limite de tokens par minute et un quota de tokens par période sont appliqués à la passerelle, par application. Nécessite un niveau payant d'API Management (non disponible en Consumption). | V2 | N | À faire |
