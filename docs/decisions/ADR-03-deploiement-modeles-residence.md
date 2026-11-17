# ADR-03 — Type de déploiement des modèles et résidence

| | |
|---|---|
| **Statut** | Acceptée |
| **Échéance** | V1 |
| **Responsable** | Owner du projet |
| **Date de décision** | 16 novembre 2026 |
| **Exigences liées** | CMP-01 |

## Contexte

L'hypothèse H2 pose que les données doivent être traitées dans l'Union européenne. Les déploiements de type « Global » peuvent traiter les requêtes dans n'importe quelle région Azure.

## Décision

Déployer les modèles en zone de données UE (type Data Zone Standard), dans une région de l'UE. Une règle Azure interdit les types de déploiement « Global ».

## Alternatives examinées

| Alternative | Pourquoi elle n'est pas retenue |
|---|---|
| Global Standard | Accès aux nouveaux modèles en premier et quotas plus élevés, mais traitement possible hors UE. |
| Régional | Traitement dans une seule région. Catalogue de modèles et quotas plus restreints. |

## Conséquences

- Certains modèles sont indisponibles en zone de données UE, ou y arrivent plus tard (PO-04).
- Le champ `deployment_type` du catalogue des modèles est contrôlé par le pipeline.
- Le traitement par lots de la V2 utilisera le type par lots de la même zone.

## Condition de révision

Rouvrir si H2 est infirmée, ou si un modèle indispensable au premier cas d'usage n'existe pas en zone de données UE.
