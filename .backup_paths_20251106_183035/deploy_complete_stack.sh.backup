#!/bin/bash
# deploy_complete_stack.sh
# Deploy completo da stack plataforma
# Last Updated: 2025-10-31
# Version: 2.1.0

set -euo pipefail

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
COMPOSE_DIR="${REPO_ROOT}/compose"

echo "🚀 Deploy Completo da Stack Plataforma"
echo "========================================="

# Verificar 1Password
if ! op whoami &>/dev/null 2>&1; then
    echo "❌ 1Password não autenticado. Execute: op signin"
    exit 1
fi

# Verificar Colima
if ! colima status &>/dev/null 2>&1; then
    echo "⚠️  Colima não está rodando. Iniciando..."
    colima start --cpu 4 --memory 8 --disk 60 --arch aarch64 --dns 1.1.1.1
fi

# Gerar .env
echo "📝 Gerando arquivo .env..."
cd "${COMPOSE_DIR}"
if [ -f "env.template" ]; then
    op inject -i env.template -o .env
    chmod 600 .env
    echo "✅ .env gerado"
else
    echo "❌ env.template não encontrado"
    exit 1
fi

# Deploy
echo "🐳 Fazendo deploy da stack..."
docker compose up -d

echo "⏳ Aguardando inicialização (10s)..."
sleep 10

# Status
echo ""
echo "📊 Status dos containers:"
docker compose ps

echo ""
echo "✅ Deploy concluído!"
echo ""
echo "🌐 Serviços disponíveis:"
echo "  • Traefik Dashboard: http://localhost:8080"
echo "  • Portainer: http://localhost:9000"
echo "  • NocoDB: ver docker compose logs nocodb"
echo "  • Appsmith: ver docker compose logs appsmith"
echo "  • n8n: ver docker compose logs n8n"
echo "  • LM Studio: ver docker compose logs lmstudio"

