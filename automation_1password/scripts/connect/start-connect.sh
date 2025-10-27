#!/bin/bash
set -e
source ~/.1password/.env

echo "🐳 Iniciando containers 1Password Connect..."
docker compose -f ~/Dotfiles/automation_1password/connect/docker-compose.yml up -d

echo "⏳ Aguardando inicialização..."
sleep 5

echo "🔍 Verificando status local..."
curl -s ${OP_CONNECT_HOST}/health | jq .
