#!/bin/bash -e

PACT_BROKER_USERNAME=$(kubectl get secret laa-data-pact-broker-secrets -n $NAMESPACE -o jsonpath='{.data.PACT_BROKER_BASIC_AUTH_USERNAME}'  | base64 --decode)
PACT_BROKER_PASSWORD=$(kubectl get secret laa-data-pact-broker-secrets -n $NAMESPACE -o jsonpath='{.data.PACT_BROKER_BASIC_AUTH_PASSWORD}'  | base64 --decode)

if [ "$GITHUB_ACCESS_TOKEN" = "" ] || [ "$PACT_BROKER_USERNAME" = "" ] || [ "$PACT_BROKER_PASSWORD" = "" ]; then
  echo "One or more environment variables are missing. Usage:"
  echo "GITHUB_ACCESS_TOKEN=token PACT_BROKER_USERNAME=user PACT_BROKER_PASSWORD=password $0"
  exit 1
fi

function upsert_webhook() {
  local file="$1"
  local webhookID="$2"
  echo "✨ applying $file..."
  sed "s/\${GITHUB_ACCESS_TOKEN}/$GITHUB_ACCESS_TOKEN/" "$file" |
    curl -X PUT \
      "https://laa-data-pact-broker.apps.live.cloud-platform.service.justice.gov.uk/webhooks/$webhookID" \
      --user "$PACT_BROKER_USERNAME:$PACT_BROKER_PASSWORD" \
      -H "Content-Type: application/json" \
      -d @-
  echo
  echo
}

function delete_webhook() {
  local webhookID="$1"
  echo "💥 deleting webhook $1..."
  curl -X DELETE \
    "https://laa-data-pact-broker.apps.live.cloud-platform.service.justice.gov.uk/webhooks/$webhookID" \
    --user "$PACT_BROKER_USERNAME:$PACT_BROKER_PASSWORD"
  echo
  echo
}

# these ".../webhooks/ID" IDs are randomly chosen -- they will be either "created or updated" so pick anything for new webhooks
# for pedantics: Pact generates these via `SecureRandom.urlsafe_base64`: https://ruby-doc.org/stdlib-3.0.1/libdoc/securerandom/rdoc/Random/Formatter.html#method-i-urlsafe_base64
#upsert_webhook "webhook-laa-data-provider-data-service.json" "4wniGo-GXnLTM6Qx1YqlmQ"
