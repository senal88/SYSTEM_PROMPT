#!/bin/bash
# COMANDO_APLICAR_FIX.sh
# Aplica correção do resolver Traefik
# Execute na VPS

set -euo pipefail

echo "🔧 Aplicando correção do Traefik resolver..."

cd ~/automation_1password/prod

echo ""
echo "📋 Recriando n8n com labels corrigidas..."
docker compose -f docker-compose.traefik-existing.yml up -d --force-recreate n8n

echo ""
echo "⏳ Aguardando n8n reiniciar..."
sleep 10

echo ""
echo "📊 Verificando status..."
docker compose -f docker-compose.traefik-existing.yml ps n8n

echo ""
echo "🔍 Verificando logs do Traefik (últimas 30 linhas)..."
docker logs traefik --tail=30 | grep -E "n8n|error|router" || echo "Nenhum erro relacionado a n8n encontrado"

echo ""
echo "✅ Correção aplicada!"
echo ""
echo "Testar acesso:"
echo "  curl -I http://n8n.senamfo.com.br"
echo "  ou"
echo "  curl -I https://n8n.senamfo.com.br"

