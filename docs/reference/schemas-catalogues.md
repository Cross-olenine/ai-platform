# Exemples d'entrées de catalogue

Exemples illustratifs. Le schéma exact est à fixer en V1.

**Modèle :**

```yaml
alias: agent-general
owner: ai-platform-team
status: active
provider: azure
model: <nom-du-modele>
model_version: "<version>"
deployment_name: <nom-du-deploiement>
deployment_type: DataZoneStandard
region: swedencentral
protocol: responses
context_window: 0          # à renseigner
max_output_tokens: 4096
capabilities: [streaming, tools]
pricing:                   # par million de tokens, à renseigner
  input: 0.0
  cached_input: 0.0
  output: 0.0
limits:
  tokens_per_minute: 0     # à renseigner
fallback_alias: agent-fast # V2
offers: [agent-platform]
end_of_support: "<date>"
review_date: "<date>"
```

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
