#!/bin/bash
# COMANDO_RAPIDO_FIX.sh
# Resolve conflito Traefik - Porta 80
# Execute na VPS

set -euo pipefail

echo "🔍 Verificando Traefik existente..."
docker ps --filter 'name=traefik' --format '{{.Names}}'

echo ""
echo "⚠️  Parando Traefik antigo..."
docker stop traefik || echo "Traefik não estava rodando"
docker rm traefik || echo "Traefik já foi removido"

echo ""
echo "✅ Verificando porta 80..."
if docker ps --format '{{.Ports}}' | grep -q ':80'; then
    echo "❌ Ainda há algo na porta 80:"
    docker ps --format 'table {{.Names}}\t{{.Ports}}' | grep 80
    exit 1
else
    echo "✅ Porta 80 livre!"
fi

echo ""
echo "🚀 Iniciando novo Traefik..."
cd ~/automation_1password/prod
docker compose -f docker-compose.traefik.yml up -d traefik

echo ""
echo "⏳ Aguardando Traefik iniciar..."
sleep 5

echo ""
echo "📊 Status final:"
docker compose -f docker-compose.traefik.yml ps

echo ""
echo "✅ Concluído! Traefik novo deve estar rodando."

