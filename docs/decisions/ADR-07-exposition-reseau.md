# ADR-07 — Exposition réseau en V1

| | |
|---|---|
| **Statut** | Acceptée |
| **Échéance** | V1 |
| **Responsable** | Owner du projet |
| **Date de décision** | 16 novembre 2026 |
| **Exigences liées** | — |

## Contexte

Le réseau privé (points d'accès privés, intégration réseau de la passerelle) ajoute un coût fixe et de la complexité. La décision de la société est de l'exiger à partir de V2.

## Décision

En V1 : points d'accès publics, protégés par l'identité. En V2 : réseau privé généralisé.

## Alternatives examinées

| Alternative | Pourquoi elle n'est pas retenue |
|---|---|
| Réseau privé dès V1 | Coût fixe et complexité supérieurs, niveau d'API Management plus élevé, pour 1 à 2 cas d'usage. |
| Public sans restriction d'identité | Inacceptable : contournement possible de la passerelle. |

## Conséquences

- En V1, la protection repose sur : jeton Entra ID obligatoire à la passerelle (IAM-01), authentification par clé désactivée sur Foundry et rôle d'accès aux modèles attribué à la seule identité managée de la passerelle (IAM-02).
- Le test « un appel direct à Foundry est refusé » vérifie un refus d'identité, pas un blocage réseau.
- Les cas d'usage de la V1 sont choisis en conséquence : pas de données dont la sensibilité exige un réseau privé. À valider avec l'équipe sécurité.
- Une restriction par adresse IP de sortie de la passerelle est à étudier (PO-08).

## Condition de révision

Rouvrir si un cas d'usage de la V1 manipule des données que l'équipe sécurité refuse d'exposer sur un point d'accès public authentifié.
