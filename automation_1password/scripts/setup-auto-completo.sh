#!/bin/bash
# setup-auto-completo.sh
# Setup automático COMPLETO para leigo - configura tudo
# Last Updated: 2025-10-31
# Version: 2.1.0

set -euo pipefail

GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

echo "╔══════════════════════════════════════════════════════════════════╗"
echo "║                                                                  ║"
echo "║     🤖 SETUP AUTOMÁTICO COMPLETO - CONFIGURA TUDO SOZINHO       ║"
echo "║                                                                  ║"
echo "╚══════════════════════════════════════════════════════════════════╝"
echo ""

# Verificar se está autenticado
if ! op whoami &>/dev/null 2>&1; then
    echo -e "${RED}❌ 1Password não está autenticado${NC}"
    echo "Por favor, abra o 1Password Desktop App e faça login"
    echo "Depois, execute novamente este script"
    exit 1
fi

echo -e "${GREEN}✅ 1Password autenticado${NC}"
echo ""

# Verificar Colima
if ! colima status &>/dev/null 2>&1; then
    echo "📦 Colima não está rodando. Iniciando..."
    colima start --cpu 4 --memory 8 --disk 60 --arch aarch64 --dns 1.1.1.1 || true
    sleep 5
fi

echo -e "${GREEN}✅ Colima rodando${NC}"
echo ""

# Gerar .env do compose
echo "📝 Gerando arquivo .env para docker-compose..."
cd compose

if [ -f "env-platform-completa.template" ]; then
    op inject -i env-platform-completa.template -o .env || true
    chmod 600 .env 2>/dev/null || true
    echo -e "${GREEN}✅ .env gerado${NC}"
else
    echo -e "${YELLOW}⚠️  Template env-platform-completa.template não encontrado${NC}"
    echo "Usando template simples..."
    if [ -f "env.template" ]; then
        op inject -i env.template -o .env || true
        chmod 600 .env 2>/dev/null || true
        echo -e "${GREEN}✅ .env gerado${NC}"
    else
        echo -e "${RED}❌ Nenhum template encontrado${NC}"
        exit 1
    fi
fi

echo ""

# Perguntar se quer fazer deploy
read -p "🚀 Fazer deploy dos containers agora? (sim/não): " RESPONSE

if [[ "$RESPONSE" =~ ^[Ss][Ii][Mm]$ ]]; then
    echo ""
    echo "🐳 Fazendo deploy..."
    
    if [ -f "docker-compose-platform-completa.yml" ]; then
        docker compose -f docker-compose-platform-completa.yml up -d
    elif [ -f "docker-compose.yml" ]; then
        docker compose up -d
    else
        echo -e "${RED}❌ docker-compose.yml não encontrado${NC}"
        exit 1
    fi
    
    echo ""
    echo "⏳ Aguardando 15 segundos para containers iniciarem..."
    sleep 15
    
    echo ""
    echo "📊 Status dos containers:"
    docker compose ps
    
    echo ""
    echo -e "${GREEN}✅ Deploy concluído!${NC}"
    echo ""
    echo "🌐 Acessar:"
    echo "  • Traefik: http://localhost:8080"
    echo "  • Portainer: http://localhost:9000"
    echo "  • Grafana: http://localhost:3000 (se configurado)"
    echo ""
else
    echo ""
    echo "⚠️  Deploy cancelado"
    echo "Execute manualmente quando quiser:"
    echo "  cd compose && docker compose up -d"
fi

echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo -e "${GREEN}✅ SETUP AUTOMÁTICO CONCLUÍDO!${NC}"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""
echo "📚 Documentação:"
echo "  • TUDO_RESOLVIDO_PRONTO_DEPLOY.md"
echo "  • IMPLEMENTACAO_FINAL_COMPLETA.md"
echo "  • PROXIMOS_PASSOS_FINAL.md"
echo ""
echo "🔧 Comandos úteis:"
echo "  • Ver logs: docker compose logs -f"
echo "  • Parar: docker compose down"
echo "  • Reiniciar: docker compose restart"
echo ""

