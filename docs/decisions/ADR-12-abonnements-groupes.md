# ADR-12 — Organisation des abonnements et groupes de ressources

| | |
|---|---|
| **Statut** | Acceptée |
| **Échéance** | V1 |
| **Responsable** | Owner du projet |
| **Date de décision** | 16 novembre 2026 |
| **Exigences liées** | — |

## Contexte

La séparation par abonnement est la plus forte isolation entre environnements. La société fournira un abonnement dédié à la production à partir de V2.

## Décision

En V1 : un seul abonnement, avec des groupes de ressources, états Terraform, identités, Key Vaults et budgets distincts par environnement. En V2 : la production est placée dans un abonnement séparé.

## Alternatives examinées

| Alternative | Pourquoi elle n'est pas retenue |
|---|---|
| Abonnement de production séparé dès V1 | Non disponible avant V2. |
| Un seul abonnement durablement | Isolation insuffisante pour la production multi-sociétés. |

## Conséquences

- L'identifiant d'abonnement est un paramètre d'environnement dès V1, jamais une valeur en dur (P5).
- Le passage en V2 se fait en reconstruisant la production depuis le code dans le nouvel abonnement, puis en basculant. On ne déplace pas les ressources. Cela sert de test de reconstruction (RES-06).
- Les données à migrer ou à laisser expirer (historiques de sessions, journaux) sont à décider avant la bascule (PO-09).
- Les noms globalement uniques doivent permettre la coexistence temporaire de deux productions.
