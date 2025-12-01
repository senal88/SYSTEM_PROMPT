#!/bin/bash

################################################################################
# 🚀 EXECUTOR DE AUDITORIA DOCKER NA VPS
# Envia e executa o script de auditoria Docker na VPS via SSH
################################################################################

set +euo pipefail 2>/dev/null || set +e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
AUDIT_SCRIPT="${SCRIPT_DIR}/auditar-docker.sh"

# Detectar VPS do SSH config
VPS_HOST="${VPS_HOST:-$(
    if [ -f "$HOME/.ssh/config" ]; then
        grep -A 5 "^Host.*vps\|^Host.*admin-vps" "$HOME/.ssh/config" 2>/dev/null | \
        grep -E "^Host " | head -1 | awk '{print $2}' || echo "admin-vps"
    else
        echo "admin-vps"
    fi
)}"

# Cores
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
NC='\033[0m'

echo -e "${BLUE}🚀 Executando auditoria Docker na VPS...${NC}"
echo -e "${BLUE}Host: ${VPS_HOST}${NC}"
echo ""

# Verificar se o script existe
if [ ! -f "$AUDIT_SCRIPT" ]; then
    echo "❌ Script de auditoria não encontrado: $AUDIT_SCRIPT"
    exit 1
fi

# Enviar e executar na VPS
echo "📤 Enviando script para VPS..."
scp "$AUDIT_SCRIPT" "${VPS_HOST}:/tmp/auditar-docker.sh" 2>&1

if [ $? -eq 0 ]; then
    echo -e "${GREEN}✅ Script enviado${NC}"
    echo ""
    echo "🔍 Executando auditoria..."
    echo ""

    ssh "${VPS_HOST}" "bash /tmp/auditar-docker.sh"

    echo ""
    echo -e "${GREEN}✅ Auditoria concluída${NC}"
    echo ""
    echo "Para copiar os resultados localmente:"
    echo "  ssh ${VPS_HOST} 'find /tmp -name \"docker_audit_*\" -type d -maxdepth 1 | tail -1' | xargs -I {} scp -r ${VPS_HOST}:{} ./docker-audit-results/"
else
    echo "❌ Erro ao enviar script para VPS"
    exit 1
fi

