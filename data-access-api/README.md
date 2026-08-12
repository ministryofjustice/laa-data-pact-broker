# data-access-api

Pact configuration for the `laa-data-access-api` service.

Owned by: `@ministryofjustice/laa-data-stewardship-access-team` (see [`/CODEOWNERS`](../.github/CODEOWNERS))

## Contents

- `webhook-laa-data-access-api.json` — webhook that triggers the
  `laa-data-access-api` provider verification workflow whenever a consumer
  publishes a contract requiring verification. Seeded onto the shared Pact
  Broker by [`../seed/create-webhooks.sh`](../seed/create-webhooks.sh).
- `docker-compose.yml` — runs a local Pact Broker instance (SQLite-backed)
  for testing contract publishing/verification against this service, without
  touching the shared deployed broker.
