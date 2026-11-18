# Structure du dépôt

Structure cible. En V1, seuls les dossiers marqués `[V1]` existent.

```text
ai-platform/
├── README.md                     [V1]
├── AGENTS.md                     [V1]
├── CLAUDE.md                     [V1]
├── docs/
│   ├── architecture/             [V1]
│   ├── exigences/                [V1]
│   ├── pratiques/                [V1]
│   ├── decisions/                [V1]
│   ├── suivi/                    [V1]
│   ├── reference/                [V1]
│   ├── operations/               [V1]
│   ├── onboarding/               [V2]
│   └── troubleshooting/          [V2]
├── terraform/
│   ├── bootstrap/                [V1]
│   ├── environments/
│   │   ├── dev/                  [V1]
│   │   ├── test/                 [V2]
│   │   └── prod/                 [V1]  (une racine par état : socle, observabilite, passerelle-modeles)
│   ├── stacks/                   [V1]  (composition d'un état, partagée par tous les environnements)
│   ├── tests/fixtures/           [V1]  (catalogue fictif des tests « terraform test »)
│   └── modules/
│       ├── foundry-core/         [V1]
│       ├── model-deployment/     [V1]
│       ├── apim-core/            [V1]
│       ├── model-gateway/        [V1]
│       ├── agent-platform/       [V1]
│       ├── key-vault/            [V1]
│       ├── observability/        [V1]
│       ├── alerting/             [V1]
│       ├── catalog/              [V1]  (lecture et contrôle des catalogues)
│       ├── finops/               [V2]
│       ├── networking/           [V2]
│       ├── customer-onboarding/  [V2]
│       ├── software-factory/     [V2]
│       ├── knowledge/            [V3]
│       └── tools/                [V3]
├── api/
│   ├── specifications/           [V1]
│   ├── policies/
│   │   ├── fragments/            [V1]
│   │   ├── model-gateway/        [V1]
│   │   ├── agent-platform/       [V1]
│   │   └── software-factory/     [V2]
│   └── tests/                    [V1]
├── catalog/
│   ├── schemas/                  [V1]  (JSON Schema, CAT-01)
│   ├── models/                   [V1]
│   ├── agents/                   [V1]
│   ├── environments/             [V1]
│   ├── customers/                [V2]
│   ├── offers/                   [V2]
│   ├── service-plans/            [V2]
│   ├── sources/                  [V3]
│   └── tools/                    [V3]
├── evaluations/
│   ├── datasets/                 [V1]
│   ├── evaluators/               [V2]
│   ├── baselines/                [V2]
│   └── reports/                  [V2]
├── adapters/                     [V1 : un seul, opencode/]
├── templates/                    [V2]
├── scripts/                      [V1]  (ci/, opencode/)
├── .github/workflows/            [V1]  (pipelines GitHub Actions, ADR-13)
└── tests/                        [V1]
```

**Écarts assumés en V1.**
- Pas de module `identity` : l'identité managée de la passerelle est portée par `apim-core`, et les identités de pipeline par le bootstrap.
- `pipelines/` est remplacé par `.github/workflows/` (ADR-13).
