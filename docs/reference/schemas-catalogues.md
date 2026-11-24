# Exemples d'entrées de catalogue

Exemples illustratifs : la source de vérité est `catalog/schemas/`.

**Modèle de chat** (schéma exact : `catalog/schemas/model.schema.json`, exemple réel : `catalog/models/agent-fast.yaml`) :

```yaml
alias: agent-general
kind: chat                 # chat (défaut) ou embedding (ADR-19)
owner: ai-platform-team
status: active
provider: azure
model: <nom-du-modele>
model_version: "<version>"
model_format: OpenAI
deployment_name: <nom-du-deploiement>
deployment_type: DataZoneStandard
region: francecentral
protocol: responses        # ADR-06
context_window: 0          # à renseigner
max_output_tokens: 4096
max_request_kb: 1024
capabilities: [streaming, tools]
pricing:                   # EUR par million de tokens, à renseigner
  input: 0.0
  cached_input: 0.0
  output: 0.0
limits:
  capacity_thousand_tpm:   # milliers de tokens par minute et par environnement
    dev: 10
    prod: 10
fallback_alias: agent-fast # V2
offers: [model-gateway]
end_of_support: "<date>"
review_date: "<date>"
```

**Modèle d'embedding** (ADR-19, exemple réel : `catalog/models/embedding-default.yaml`) : mêmes champs, avec `kind: embedding`, `protocol: embeddings`, sans `max_output_tokens`, `cached_input` ni tarif de sortie (`output: 0`).

**Agent :**

```yaml
id: assistant-redaction
version: 1.0.0
owner: <responsable-fonctionnel>
class: C2
target_maturity: N3
runtime: managed           # ou "code" à partir de V2
model_alias: agent-general
instructions_file: prompts/assistant-redaction/v1.md
quotas:
  max_tokens_per_session: 50000
companies: [societe-a]
success_signal: "feedback positif ou absence de reformulation dans la session"
evaluation:
  dataset: evaluations/datasets/assistant-redaction-v1.jsonl
  thresholds:
    global_success: 0.90
    critical_success: 1.00
retention_days: 30
tools: []                  # V3
sources: []                # V3
memory: none               # V3
```

**Société (V2) :**

```yaml
id: societe-a
entra_tenant_id: <tenant>
legal_entity: <entité contractuelle>
cost_center: CC-1234
isolation: shared          # "dedicated" en V4
offers: [agent-platform, model-gateway]
allowed_models: [agent-general, agent-fast]
allowed_agents: [assistant-redaction]
quotas:
  tokens_per_month: 0      # à renseigner
budget_monthly_eur: 0      # à renseigner
overrun_policy: block      # ou "alert"
contacts: [<responsable>]
contract_period: {start: "<date>", end: "<date>"}
```
