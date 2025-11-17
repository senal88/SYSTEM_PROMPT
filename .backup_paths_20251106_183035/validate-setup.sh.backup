#!/bin/bash
set -e
source ~/.1password/.env

echo "🔍 Validando conexão com 1Password Connect..."
curl -s ${OP_CONNECT_HOST}/health | jq .