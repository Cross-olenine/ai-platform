# ADR-01 — Runtime d'agents : service managé ou runtime maison

| | |
|---|---|
| **Statut** | Acceptée |
| **Échéance** | V1 |
| **Responsable** | Owner du projet |
| **Date de décision** | 16 novembre 2026 |
| **Exigences liées** | — |

## Contexte

L'Agent Runtime est le bloc le plus coûteux à développer et à maintenir. L'équipe compte 2 à 3 personnes en V1. Le principe P2 demande de privilégier le natif Azure.

## Décision

Utiliser Foundry Agent Service. En V1, uniquement des agents managés définis par configuration. À partir de V2, les agents « code » (conteneurs) s'exécutent sur le même service.

## Alternatives examinées

| Alternative | Pourquoi elle n'est pas retenue |
|---|---|
| Runtime maison (conteneurs + cadre d'agents open source) | Contrôle total, mais sessions, montée en charge, sécurité et exploitation sont à développer. Contredit P2 et le mot d'ordre « coûts réduits ». |
| Copilot Studio comme runtime unique | Adapté aux usages à faible code. Moins de maîtrise sur la passerelle et le registre d'usage. Sa place est traitée par ADR-16. |

## Conséquences

- Dépendance à Azure assumée. Le contrat d'API de plateforme (`docs/architecture/contrats.md`) limite l'impact d'un changement de runtime sur les canaux.
- Les sessions et l'historique sont gérés par le service (STA-01).
- Le FinOps des agents dépend du passage de leurs appels par la passerelle (AGT-04).

## Condition de révision

Rouvrir cette décision si le prototype PO-01 montre que les appels aux modèles émis par un agent managé ne passent pas par la passerelle ou ne produisent pas d'événement d'usage exploitable.
