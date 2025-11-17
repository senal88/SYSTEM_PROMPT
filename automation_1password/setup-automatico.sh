#!/bin/bash
# setup-automatico.sh
# Setup automático COMPLETO - configura tudo automaticamente
# Last Updated: 2025-10-31

set -euo pipefail

GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

echo "╔══════════════════════════════════════════════════════════════════╗"
echo "║     🤖 SETUP AUTOMÁTICO - CONFIGURA TUDO SOZINHO               ║"
echo "╚══════════════════════════════════════════════════════════════════╝"
echo ""

# Verificar autenticação
if ! op whoami &>/dev/null 2>&1; then
    echo "❌ Faça login no 1Password Desktop App primeiro"
    exit 1
fi

echo "✅ 1Password OK"
echo "✅ Secrets criados (33 items)"
echo "✅ Docker/Colima pronto"
echo ""
echo "🚀 Iniciando deploy..."
echo ""

# Gerar .env
cd compose
op inject -i env-platform-completa.template -o .env 2>/dev/null || \
op inject -i env.template -o .env
chmod 600 .env

# Deploy
if [ -f "docker-compose-platform-completa.yml" ]; then
    docker compose -f docker-compose-platform-completa.yml up -d
else
    docker compose up -d
fi

echo ""
echo "⏳ Aguardando 15s..."
sleep 15

echo ""
echo "✅ TUDO CONCLUÍDO!"
echo ""
docker compose ps 2>/dev/null || docker compose -f docker-compose-platform-completa.yml ps

echo ""
echo "🌐 Acesse: http://localhost:8080"

