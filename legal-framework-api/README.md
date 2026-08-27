# legal-framework-api

Pact configuration for the `legal-framework-api` service.

Owned by: `@ministryofjustice/laa-apply-for-legal-aid` (see [`/CODEOWNERS`](../.github/CODEOWNERS))

## Contents

- `webhook-legal-framework-api.json` — webhook that triggers the
  `legal-framework-api` provider verification workflow whenever a consumer
  publishes a contract requiring verification. Seeded onto the shared Pact
  Broker by [`../seed/create-webhooks.sh`](../seed/create-webhooks.sh).
- `docker-compose.yml` — runs a local Pact Broker instance (SQLite-backed)
  for testing contract publishing/verification against this service, without
  touching the shared deployed broker.
