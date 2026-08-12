# pda-r2

Pact configuration for the PDA-R2 service.

Owned by: `@ministryofjustice/laa-data-stewardship-cse-team` (see [`/CODEOWNERS`](../.github/CODEOWNERS))

## Contents

- `docker-compose.yml` — runs a local Pact Broker instance (SQLite-backed) for
  testing contract publishing/verification against this service, without
  touching the shared deployed broker.

This directory does not currently have a webhook configured against the
shared Pact Broker (see [`../README.md`](../README.md#adding-a-new-service)
for how to add one once PDA-R2's contract-testing workflow is in place).
