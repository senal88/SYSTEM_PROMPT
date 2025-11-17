#!/usr/bin/env bash
set -euo pipefail

# update_dns.sh
# Atualiza (ou cria) um registro A proxied no Cloudflare para o IP público atual.
#
# Uso:
#   export CLOUDFLARE_API_TOKEN=op://vault/item/api_token
#   export CLOUDFLARE_ZONE_ID=op://vault/item/zone_id
#   bash scripts/cloudflare/update_dns.sh subdominio.dominio.com

if [[ -z "${CLOUDFLARE_API_TOKEN:-}" ]]; then
  echo "❌ CLOUDFLARE_API_TOKEN não definido. Use op read ou export previamente."
  exit 1
fi

if [[ -z "${CLOUDFLARE_ZONE_ID:-}" ]]; then
  echo "❌ CLOUDFLARE_ZONE_ID não definido."
  exit 1
fi

SUBDOMAIN="${1:-}"
if [[ -z "${SUBDOMAIN}" ]]; then
  echo "Uso: $0 subdominio.dominio.com"
  exit 1
fi

TARGET_IP="$(curl -fsS https://ipv4.icanhazip.com || true)"
if [[ -z "${TARGET_IP}" ]]; then
  echo "❌ Não foi possível obter IP público."
  exit 1
fi
TARGET_IP="${TARGET_IP//$'\n'/}"

API_BASE="https://api.cloudflare.com/client/v4"
AUTH_HEADER="Authorization: Bearer ${CLOUDFLARE_API_TOKEN}"

RECORD_ID="$(curl -fsS -X GET \
  -H "${AUTH_HEADER}" \
  -H "Content-Type: application/json" \
  "${API_BASE}/zones/${CLOUDFLARE_ZONE_ID}/dns_records?name=${SUBDOMAIN}" \
  | jq -r '.result[0].id // empty')"

payload() {
  cat <<JSON
{
  "type": "A",
  "name": "${SUBDOMAIN}",
  "content": "${TARGET_IP}",
  "ttl": 120,
  "proxied": true
}
JSON
}

if [[ -n "${RECORD_ID}" ]]; then
  curl -fsS -X PUT \
    -H "${AUTH_HEADER}" \
    -H "Content-Type: application/json" \
    --data "$(payload)" \
    "${API_BASE}/zones/${CLOUDFLARE_ZONE_ID}/dns_records/${RECORD_ID}" >/dev/null
  echo "✅ Registro DNS atualizado: ${SUBDOMAIN} → ${TARGET_IP}"
else
  curl -fsS -X POST \
    -H "${AUTH_HEADER}" \
    -H "Content-Type: application/json" \
    --data "$(payload)" \
    "${API_BASE}/zones/${CLOUDFLARE_ZONE_ID}/dns_records" >/dev/null
  echo "✅ Registro DNS criado: ${SUBDOMAIN} → ${TARGET_IP}"
fi
