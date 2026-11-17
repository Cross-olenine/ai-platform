# Principes directeurs

| # | Principe | Conséquence concrète |
|---|---|---|
| P1 | **Séparer plateforme, produits IA et canaux** | La couche haute peut changer sans toucher aux couches basses. Seul l'adaptateur change d'un canal à l'autre. |
| P2 | **Natif d'abord** | Avant de développer un bloc, vérifier ce que Foundry, API Management et Entra fournissent déjà. Tout développement spécifique est justifié par écrit. |
| P3 | **Un bloc devient « réutilisable » à son deuxième usage** | On n'écrit pas de module générique pour un besoin unique. On généralise quand un deuxième cas d'usage le demande. |
| P4 | **Configuration plutôt que développement** | Ajouter une société, un modèle ou un agent est une modification déclarative d'un catalogue versionné. |
| P5 | **Aucune valeur en dur** | Ni nom de modèle, ni identifiant de société, ni limite, ni URL dans une policy ou un module : tout vient d'un catalogue ou d'un paramètre. |
| P6 | **Les dimensions dès V1, la mécanique ensuite** | Les champs société, offre, projet existent dans les événements d'usage dès V1, même avec une seule société. On évite ainsi de reprendre les données plus tard. |
| P7 | **FinOps et observabilité dès la conception** | Aucun composant en production sans propriétaire, finalité, budget, métriques, seuils d'alerte et règle de suppression. |
| P8 | **Aucun changement manuel en production** | Tout changement vient de Git et passe par un pipeline. Une intervention d'urgence est tracée puis reproduite dans le code. |
| P9 | **Petits changements réversibles** | Une demande de changement ne touche pas en même temps le réseau, les identités, la passerelle et plusieurs agents. Le retour arrière est défini avant le déploiement. |
| P10 | **Le même artefact est promu** | Le code, les modules et les policies sont identiques entre environnements. Seuls les paramètres varient. |
| P11 | **L'agent ne voit jamais plus que l'utilisateur** | Tout accès à des données ou à des outils se fait avec les droits de l'utilisateur, pas avec ceux de l'agent. |
| P12 | **Un seul point de passage vers les modèles** | Aucun appel direct à Foundry. Tout passe par la passerelle, y compris les appels émis par les agents. |
| P13 | **Mesurer avant de dimensionner** | Une montée de capacité se justifie par une saturation mesurée, pas par anticipation. |
| P14 | **La documentation évolue avec le code** | Même demande de changement, même revue. Une partie est générée depuis les catalogues. |

> **Règle FinOps.** Toute capacité créée doit être observable, mesurable, attribuable, budgétée et supprimable.
