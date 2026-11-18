# Reconstruire l'environnement de développement depuis le code

C'est un critère de sortie de la V1. La reconstruction prouve que rien n'existe hors du code.

1. Dans GitHub, lancer le workflow **`reconstruire-dev`** sur la branche `develop` (*Run workflow*), en tapant `reconstruire-dev` dans le champ de confirmation.
2. Le workflow :
   - supprime les trois états dans l'ordre inverse : `passerelle-modeles`, `observabilite`, `socle` ;
   - purge Foundry, API Management et le Key Vault supprimés de façon réversible. Il utilise pour cela un rôle limité à ces purges, accordé par le bootstrap aux seuls environnements sans protection contre la purge (`key_vault.purge_protection: false`) ;
   - recrée les trois états depuis le code ;
   - lance les tests de la passerelle.
3. Après la reconstruction, la clé d'abonnement d'OpenCode a changé : relancer `source scripts/opencode/aiplat-env.sh dev`.

Durée indicative : 20 à 30 minutes. Dev est indisponible pendant ce temps.

Le groupe de ressources, les identités et les états sont portés par le bootstrap : ils ne sont pas supprimés. Le script refuse la suppression de la production.
