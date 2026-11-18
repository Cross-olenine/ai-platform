# Reconstruire l'environnement de développement depuis le code

C'est un critère de sortie de la V1. La reconstruction prouve que rien n'existe hors du code.

1. **Supprimer**, dans l'ordre inverse des états, depuis une session locale :
   - se connecter avec un compte qui a les mêmes droits que l'identité de dev ;
   - exporter les variables `TFSTATE_*` et `TF_VAR_gateway_api_client_id` (voir les variables du dépôt GitHub) ;
   - lancer `terraform destroy` sur `passerelle-modeles`, puis `observabilite`, puis `socle`.
2. **Purger** les ressources supprimées de façon réversible :
   - Foundry : `az cognitiveservices account purge` ;
   - API Management : `az apim deletedservice purge`.

   Le Key Vault de dev n'a pas de protection contre la purge (`key_vault.purge_protection: false`), ce qui permet de recréer le même nom.
3. **Relancer** `deploy-dev.yml` (bouton *Run workflow* sur `develop`). Le pipeline recrée les trois états.
4. **Vérifier.** Les tests de l'API passent. OpenCode fonctionne après `source scripts/opencode/aiplat-env.sh dev`, car la clé d'abonnement a changé.

Le groupe de ressources, les identités et les états sont portés par le bootstrap : ils ne sont pas supprimés.
