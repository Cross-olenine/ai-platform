# ADR-02 — Niveau de service d'API Management

| | |
|---|---|
| **Statut** | Remplacée par ADR-18 |
| **Échéance** | V1 |
| **Responsable** | Owner du projet |
| **Date de décision** | 16 novembre 2026 |
| **Exigences liées** | — |

## Contexte

Le niveau d'API Management détermine une grande part du coût fixe du socle et les options réseau. Une instance de la gamme classique ne peut pas être migrée vers la gamme v2 : le choix de gamme se fait à la création. Le réseau privé n'est requis qu'à partir de V2 (ADR-07).

## Décision

Gamme v2. En V1 : Basic v2 en développement et en production. En V2 : Standard v2 pour la production, créée dans le nouvel abonnement (ADR-12), afin de disposer du réseau privé.

## Alternatives examinées

| Alternative | Pourquoi elle n'est pas retenue |
|---|---|
| Gamme classique (Developer, Standard, Premium) | Developer n'a pas d'engagement de service ; Premium a un coût fixe élevé ; aucune migration possible vers v2 ensuite. |
| Standard v2 dès V1 | Apporte le réseau privé, qui n'est pas requis en V1. Coût fixe supérieur sans bénéfice immédiat. |
| Premium v2 | Isolation réseau complète de la passerelle. Non requise à ce stade ; à réexaminer si la sécurité l'exige en V2. |
| Niveau dédié à l'IA (« AI Gateway ») | En préversion : exclu du chemin critique de production. |

## Conséquences

- Basic v2 n'offre pas d'intégration au réseau privé : cohérent avec ADR-07 pour la V1.
- Le passage de Basic v2 à Standard v2 est possible sans recréer l'instance, si la bascule d'abonnement n'a pas lieu au même moment.
- Le coût mensuel reste à chiffrer (PO-07).

## Condition de révision

Microsoft présente Basic v2 comme destiné au développement et aux tests, bien qu'il ait un engagement de service. Acceptable pour 1 à 2 cas d'usage au niveau N3. À revoir si un engagement de service fort est pris avant V2.
