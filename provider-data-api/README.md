# provider-data-api

Pact configuration for the `laa-data-provider-data` service.

Owned by: `@ministryofjustice/laa-data-stewardship-cse-team` (see [`/CODEOWNERS`](../.github/CODEOWNERS))

## Contents

- `webhook-laa-data-provider-data-service.json` — webhook that triggers the
  `provider-data-api` provider verification workflow whenever a consumer
  publishes a contract requiring verification. Seeded onto the shared Pact
  Broker by [`../seed/create-webhooks.sh`](../seed/create-webhooks.sh).
- `docker-compose.yml` — runs a local Pact Broker instance (SQLite-backed)
  for testing contract publishing/verification against this service, without
  touching the shared deployed broker.
