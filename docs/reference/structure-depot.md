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
│   │   └── prod/                 [V1]
│   └── modules/
│       ├── foundry-core/         [V1]
│       ├── model-deployment/     [V1]
│       ├── apim-core/            [V1]
│       ├── model-gateway/        [V1]
│       ├── agent-platform/       [V1]
│       ├── identity/             [V1]
│       ├── key-vault/            [V1]
│       ├── observability/        [V1]
│       ├── alerting/             [V1]
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
├── adapters/                     [V1 : un seul]
├── templates/                    [V2]
├── scripts/                      [V1]
├── .github/workflows/            [V1]  (pipelines GitHub Actions, ADR-13)
└── tests/                        [V1]
```
