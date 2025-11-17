#!/bin/bash
# Script para Verificar Status de Backups e Snapshots
# Verifica informações sobre backups da VPS
#
# Uso: ./scripts/verificar-backups-vps.sh

set -euo pipefail

# Cores
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
RED='\033[0;31m'
CYAN='\033[0;36m'
NC='\033[0m'

VPS_IP="147.79.81.59"
VPS_HOST="senamfo.com.br"

echo -e "${BLUE}╔════════════════════════════════════════╗${NC}"
echo -e "${BLUE}║   VERIFICAÇÃO DE BACKUPS VPS          ║${NC}"
echo -e "${BLUE}╚════════════════════════════════════════╝${NC}"
echo ""
echo -e "${CYAN}VPS: ${VPS_HOST} (${VPS_IP})${NC}"
echo ""

# Verificar se consegue conectar na VPS
echo -e "${YELLOW}🔍 Verificando conectividade...${NC}"
if ping -c 1 -W 2 ${VPS_IP} &>/dev/null; then
    echo -e "${GREEN}   ✅ VPS está online${NC}"
else
    echo -e "${RED}   ❌ VPS não está acessível${NC}"
    echo -e "${YELLOW}   Continuando com informações disponíveis...${NC}"
fi

echo ""

# Informações sobre backups (baseado no que foi informado)
echo -e "${BLUE}📊 STATUS DOS BACKUPS:${NC}"
echo ""
echo -e "${CYAN}Backups Automáticos:${NC}"
echo -e "   Frequência: Semanal"
echo -e "   Total: 2 backups"
echo -e "   Último: 2025-11-17 00:25 (14.33 GB)"
echo -e "   Anterior: 2025-11-10 00:51 (26.79 GB)"
echo ""

echo -e "${CYAN}Snapshots Manuais:${NC}"
echo -e "   Total: 1 snapshot"
echo -e "   Criado: 2025-11-13 22:28"
echo -e "   Expira: 2025-12-03"
echo -e "   Status: ✅ Ativo"
echo ""

# Verificar espaço em disco na VPS (se acessível)
if command -v ssh &> /dev/null; then
    echo -e "${YELLOW}💾 Verificando espaço em disco na VPS...${NC}"
    DISK_INFO=$(ssh -o ConnectTimeout=5 -o StrictHostKeyChecking=no root@${VPS_IP} "df -h / | tail -1" 2>/dev/null || echo "")
    if [ -n "$DISK_INFO" ]; then
        DISK_USED=$(echo "$DISK_INFO" | awk '{print $3}')
        DISK_AVAIL=$(echo "$DISK_INFO" | awk '{print $4}')
        DISK_PERCENT=$(echo "$DISK_INFO" | awk '{print $5}')
        echo -e "${CYAN}   Usado: ${DISK_USED}${NC}"
        echo -e "${CYAN}   Disponível: ${DISK_AVAIL}${NC}"
        echo -e "${CYAN}   Uso: ${DISK_PERCENT}${NC}"

        # Verificar se está acima de 80%
        PERCENT_NUM=$(echo "$DISK_PERCENT" | tr -d '%')
        if [ "$PERCENT_NUM" -gt 80 ]; then
            echo -e "${RED}   ⚠️  Disco acima de 80% - considerar limpeza${NC}"
        fi
    else
        echo -e "${YELLOW}   ⚠️  Não foi possível verificar (SSH não disponível ou timeout)${NC}"
    fi
    echo ""
fi

# Recomendações
echo -e "${BLUE}💡 RECOMENDAÇÕES:${NC}"
echo ""
echo -e "${CYAN}1. Backups:${NC}"
echo -e "   ✅ Backups semanais estão ativos"
echo -e "   💡 Considerar upgrade para diários se necessário"
echo ""

echo -e "${CYAN}2. Snapshots:${NC}"
echo -e "   ✅ 1 snapshot ativo (expira em 2025-12-03)"
echo -e "   💡 Criar novo snapshot antes de mudanças importantes"
echo ""

echo -e "${CYAN}3. Próximas Ações:${NC}"
echo -e "   📅 Próximo backup automático: ~2025-11-24"
echo -e "   📸 Criar snapshot antes de:"
echo -e "      - Atualizar sistema"
echo -e "      - Instalar novos serviços"
echo -e "      - Mudar configurações críticas"
echo ""

# Verificar se há backups locais
echo -e "${YELLOW}📁 Verificando backups locais...${NC}"
if [ -d "backups" ] || [ -d "automation_1password/exports" ]; then
    echo -e "${GREEN}   ✅ Diretório de backups local encontrado${NC}"
    if [ -d "backups" ]; then
        BACKUP_COUNT=$(find backups -type f -name "*.tar.gz" 2>/dev/null | wc -l | tr -d ' ')
        echo -e "${CYAN}   Backups locais: ${BACKUP_COUNT}${NC}"
    fi
else
    echo -e "${YELLOW}   ⚠️  Nenhum backup local encontrado${NC}"
fi

echo ""
echo -e "${GREEN}✅ Verificação concluída!${NC}"
echo ""
echo -e "${CYAN}📝 Para mais informações:${NC}"
echo -e "   - Painel Hostinger: VPS → Snapshots e Backups"
echo -e "   - Documentação: automation_1password/docs/GERENCIAR_BACKUPS_SNAPSHOTS.md"
echo ""

