# Événement d'usage

Une ligne par requête, même format pour tous les canaux.

```json
{
  "timestamp": "2026-11-16T10:00:00Z",
  "trace_id": "<identifiant W3C>",
  "environment": "prod",
  "company_id": "societe-a",
  "user_id": "<identifiant pseudonymisé>",
  "application_id": "<application cliente>",
  "channel": "power-platform",
  "offer_id": "agent-platform",
  "project_id": "<projet>",
  "session_id": "<session>",
  "agent_id": "assistant-redaction",
  "agent_version": "1.0.0",
  "model_alias": "agent-general",
  "deployment": "<déploiement exécuté>",
  "model_version": "<version>",
  "input_tokens": 0,
  "cached_input_tokens": 0,
  "output_tokens": 0,
  "reasoning_tokens": 0,
  "tool_calls": 0,
  "estimated_cost_eur": 0.0,
  "status": "success",
  "http_status": 200,
  "latency_ms": 0,
  "time_to_first_token_ms": 0,
  "retries": 0,
  "truncated": false
}
```
