# laa-data-pact-broker

[![Ministry of Justice Repository Compliance Badge](https://github-community.service.justice.gov.uk/repository-standards/api/laa-data-pact-broker/badge)](https://github-community.service.justice.gov.uk/repository-standards/laa-data-pact-broker)

This repository contains the deployment script for the [Pact broker](https://docs.pact.io/pact_broker)
used by the LAA Data Stewardship team.

It deploys the [`pactfoundation/pact-broker`](https://hub.docker.com/r/pactfoundation/pact-broker) image,
see [`kubectl-deploy/deployment.yml`](kubectl-deploy/deployment.yml) for details.

## Repository structure

This repository hosts a single, shared Pact Broker deployment used by multiple
services. Shared deployment and repository configuration lives at the root
(`kubectl-deploy/`, `deploy.sh`, `.github/`, `CODEOWNERS`), while each
consuming/providing service has its own directory for its Pact configuration
(webhook definitions and a local `docker-compose.yml` for testing against the
broker without touching the shared deployed instance):

```
laa-data-pact-broker/
├── kubectl-deploy/            # shared broker deployment manifests
├── deploy.sh                  # shared deploy script
├── seed/                      # shared webhook-seeding script
├── pda-r2/
│   ├── docker-compose.yml
│   └── README.md
├── data-claims-api/
│   ├── docker-compose.yml
│   ├── README.md
│   └── webhook-laa-data-claims-api.json
├── provider-data-api/
│   ├── docker-compose.yml
│   ├── README.md
│   └── webhook-laa-data-provider-data-service.json
├── data-access-api/
│   ├── docker-compose.yml
│   ├── README.md
│   └── webhook-laa-data-access-api.json
├── legal-framework-api/
│   ├── docker-compose.yml
│   ├── README.md
│   └── webhook-legal-framework-api.json
├── .github/
├── CODEOWNERS
└── README.md
```

Ownership of each service directory is set in [`.github/CODEOWNERS`](.github/CODEOWNERS),
so changes within a directory automatically request review from the owning team.
Shared configuration and infrastructure remain owned by the platform/broker team.

### Adding a new service

1. Create a new top-level directory named after the service (e.g. `my-service/`).
2. Add a `docker-compose.yml` (see an existing service directory for a template)
   so the owning team can run a local Pact Broker for testing.
3. Add a `webhook-*.json` file describing the webhook to trigger provider
   verification (see an existing service directory for an example), then add
   an `upsert_webhook` line for it in [`seed/create-webhooks.sh`](seed/create-webhooks.sh).
4. Add a short `README.md` describing the directory's contents and owning team.
5. Add an entry for the new directory in [`.github/CODEOWNERS`](.github/CODEOWNERS)
   naming the owning team.

## Pre-requisites

- [Access to Cloud Platform](https://user-guide.cloud-platform.service.justice.gov.uk/documentation/getting-started/kubectl-config.html#authentication)
- Access to the [`laa-data-pact-broker`](https://github.com/ministryofjustice/cloud-platform-environments/tree/main/namespaces/live.cloud-platform.service.justice.gov.uk/laa-data-pact-broker) namespace
  (through the [`laa-data-stewardship-cse-team`](https://github.com/orgs/ministryofjustice/teams/laa-data-stewardship-cse-team) GitHub team)

## Deploy

Each `main` commit deploys the application via [`./deploy.sh`](./deploy.sh)

## Create webhooks

All webhooks are in the [`seed`](./seed) directory and are all automatically deployed
during `main` build via [`seed/create-webhooks.sh`](./seed/create-webhooks.sh)

### When to use webhooks

Webhooks can trigger builds when

- contract changes are pushed by consumers (to trigger a build [example](seed/webhook-laa-data-provider-data-service.json) to ensure provider can meet consumer's expectations)
- when the build result is back, the results are published back to the Pact broker and then communicate the status to github PR/commit status: [example](seed/TODO))

### Webhook configuration

- `GH_PAT_ACCESS_TOKEN` to set the verification result as a GitHub build status on a commit. It needs a [personal access token][pat] with `repo:status` permission and [authorised SAML][saml]. This is required to be in GitHub as the webhook requires access
- to an active token and not a temporary one availbable only during hte lifecylce of the workflow
- `PACT_BROKER_USERNAME` and `PACT_BROKER_PASSWORD` are the basic auth username/password.

## Secrets

| Secret                 | In Kubernetes                                                         | In GitHub                                                                                                                 | How to refresh                                                                                                          |
|------------------------|-----------------------------------------------------------------------|---------------------------------------------------------------------------------------------------------------------------|-------------------------------------------------------------------------------------------------------------------------|
| `GH_PAT_ACCESS_TOKEN`  | no                                                                    | yes                                                                                                                       | [Generate][pat] a new GitHub [PAT][setting-pat] with `repo:status` permission. Please "**Configure SSO**" on the token.    |
| `PACT_BROKER_USERNAME` | ✅ yes, `laa-data-pact-broker-secrets/PACT_BROKER_BASIC_AUTH_USERNAME` | no                                                                                                                        | Create a new random password, update the Kubernetes secret.                                                                |
| `PACT_BROKER_PASSWORD` | ✅ yes, `laa-data-pact-broker-secrets/PACT_BROKER_BASIC_AUTH_PASSWORD` | no                                                                                                                        | Create a new username, update the Kubernetes secret.                                                                       |



[pat]: https://docs.github.com/en/github/authenticating-to-github/keeping-your-account-and-data-secure/creating-a-personal-access-token
[setting-pat]: https://github.com/settings/tokens
[saml]: https://docs.github.com/en/github/authenticating-to-github/authenticating-with-saml-single-sign-on/authorizing-a-personal-access-token-for-use-with-saml-single-sign-on
