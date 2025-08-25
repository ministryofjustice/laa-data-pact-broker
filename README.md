# Ministry of Justice Template Repository

[![Ministry of Justice Repository Compliance Badge](https://github-community.service.justice.gov.uk/repository-standards/api/template-repository/badge)](https://github-community.service.justice.gov.uk/repository-standards/template-repository)

# laa-data-pact-broker

This repository contains the deployment script for the [Pact broker](https://docs.pact.io/pact_broker)
used by the LAA Data Stewardship team.

It deploys the [`pactfoundation/pact-broker`](https://hub.docker.com/r/pactfoundation/pact-broker) image,
see [`kubectl-deploy/deployment.yml`](kubectl-deploy/deployment.yml) for details.

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

- contract changes are pushed by consumers (to trigger a build [example](seed/TODO) to ensure provider can meet consumer's expectations)
- when the build result is back, the results are published back to the Pact broker and then communicate the status to github PR/commit status: [example](seed/TODO))

### Webhook configuration

- `GITHUB_ACCESS_TOKEN` to set the verification result as a GitHub build status on a commit. It needs a [personal access token][pat] with `repo:status` permission and [authorised SAML][saml].
- `PACT_BROKER_USERNAME` and `PACT_BROKER_PASSWORD` are the basic auth username/password.

## Secrets

| Secret                 | In Kubernetes                                                         | How to refresh                                                                                                          |
|------------------------|-----------------------------------------------------------------------|-------------------------------------------------------------------------------------------------------------------------|
| `GITHUB_ACCESS_TOKEN`  | TODO                                                                  | [Generate][pat] a new GitHub [PAT][setting-pat] with `repo:status` permission. Please "**Configure SSO**" on the token. |
| `PACT_BROKER_USERNAME` | ✅ yes, `laa-data-pact-broker-secrets/PACT_BROKER_BASIC_AUTH_USERNAME` | Create a new random password, update the Kubernetes secret.                                                             |
| `PACT_BROKER_PASSWORD` | ✅ yes, `laa-data-pact-broker-secrets/PACT_BROKER_BASIC_AUTH_PASSWORD` | Create a new username, update the Kubernetes secret.                 |



[pat]: https://docs.github.com/en/github/authenticating-to-github/keeping-your-account-and-data-secure/creating-a-personal-access-token
[setting-pat]: https://github.com/settings/tokens
[saml]: https://docs.github.com/en/github/authenticating-to-github/authenticating-with-saml-single-sign-on/authorizing-a-personal-access-token-for-use-with-saml-single-sign-on
