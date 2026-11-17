# Sécurité : synthèse des menaces et réponses

| Menace | Réponse | Exigences |
|---|---|---|
| Contournement de la passerelle | Clés désactivées, identité managée, réseau restreint, règles Azure | IAM-02, AGT-04, DEX-05 |
| Fuite de documents par un agent | Accès au nom de l'utilisateur, recherche filtrée par droits | IAM-07, KNW-03 |
| Injection de prompt directe | Filtres natifs, tests adverses | GRD-02, GRD-04 |
| Injection indirecte par un document ou un outil | Contenu traité comme donnée, validation humaine des écritures | GRD-06, TLS-04 |
| Accès croisé entre sociétés | Contexte résolu depuis le jeton, partitionnement, tests | IAM-04, TEN-04, TEN-07 |
| Fuite de secrets | Key Vault, identités managées, contrôle automatique | KV-01 à KV-03 |
| Données personnelles dans les journaux | Contenu non journalisé par défaut, masquage | OBS-05, GRD-05 |
| Consommation incontrôlée | Compteurs temps réel, limites par session | MGW-03, FIN-04, AGT-08 |
| Changement non maîtrisé en production | Pipeline obligatoire, approbation distincte, dérive détectée | `docs/pratiques/devops-genaiops.md` |
