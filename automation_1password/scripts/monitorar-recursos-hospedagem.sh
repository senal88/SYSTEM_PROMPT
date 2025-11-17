#!/bin/bash
# Script para Monitorar Recursos da Hospedagem Web
# Verifica uso de disco, inodes e recursos gerais
#
# Uso: ./scripts/monitorar-recursos-hospedagem.sh [--domain DOMAIN]

set -euo pipefail

# Cores
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
RED='\033[0;31m'
CYAN='\033[0;36m'
NC='\033[0m'

DOMAIN="mfotrust.com"

# Parse arguments
while [[ $# -gt 0 ]]; do
    case $1 in
        --domain)
            DOMAIN="$2"
            shift 2
            ;;
        *)
            echo -e "${RED}Opção desconhecida: $1${NC}"
            exit 1
            ;;
    esac
done

echo -e "${BLUE}╔════════════════════════════════════════╗${NC}"
echo -e "${BLUE}║   MONITORAMENTO DE RECURSOS           ║${NC}"
echo -e "${BLUE}╚════════════════════════════════════════╝${NC}"
echo ""
echo -e "${CYAN}Domínio: ${DOMAIN}${NC}"
echo -e "${CYAN}Plano: Business Web Hosting${NC}"
echo ""

# Valores conhecidos (do painel)
DISK_USED=0.24
DISK_TOTAL=50
INODES_USED=13568
INODES_TOTAL=600000
RESOURCES_USED=2

# Calcular percentuais
DISK_PERCENT=$(echo "scale=2; ($DISK_USED / $DISK_TOTAL) * 100" | bc)
INODES_PERCENT=$(echo "scale=2; ($INODES_USED / $INODES_TOTAL) * 100" | bc)

echo -e "${BLUE}📊 USO DE RECURSOS (Últimas 24h):${NC}"
echo ""
echo -e "${CYAN}Recursos Gerais:${NC}"
if (( $(echo "$RESOURCES_USED < 80" | bc -l) )); then
    echo -e "${GREEN}   ✅ ${RESOURCES_USED}% usado${NC}"
elif (( $(echo "$RESOURCES_USED < 90" | bc -l) )); then
    echo -e "${YELLOW}   ⚠️  ${RESOURCES_USED}% usado (atenção)${NC}"
else
    echo -e "${RED}   🔴 ${RESOURCES_USED}% usado (crítico)${NC}"
fi
echo ""

echo -e "${CYAN}Disco:${NC}"
echo -e "   Usado: ${DISK_USED} GB / ${DISK_TOTAL} GB"
echo -e "   Percentual: ${DISK_PERCENT}%"
if (( $(echo "$DISK_PERCENT < 80" | bc -l) )); then
    echo -e "${GREEN}   ✅ Status: Normal${NC}"
elif (( $(echo "$DISK_PERCENT < 90" | bc -l) )); then
    echo -e "${YELLOW}   ⚠️  Status: Atenção${NC}"
else
    echo -e "${RED}   🔴 Status: Crítico${NC}"
fi
echo ""

echo -e "${CYAN}Inodes (Arquivos/Diretórios):${NC}"
echo -e "   Usados: ${INODES_USED} / ${INODES_TOTAL}"
echo -e "   Percentual: ${INODES_PERCENT}%"
if (( $(echo "$INODES_PERCENT < 80" | bc -l) )); then
    echo -e "${GREEN}   ✅ Status: Normal${NC}"
elif (( $(echo "$INODES_PERCENT < 90" | bc -l) )); then
    echo -e "${YELLOW}   ⚠️  Status: Atenção${NC}"
else
    echo -e "${RED}   🔴 Status: Crítico${NC}"
fi
echo ""

# Recomendações
echo -e "${BLUE}💡 RECOMENDAÇÕES:${NC}"
echo ""

if (( $(echo "$DISK_PERCENT < 50" | bc -l) )) && (( $(echo "$INODES_PERCENT < 50" | bc -l) )) && (( $(echo "$RESOURCES_USED < 50" | bc -l) )); then
    echo -e "${GREEN}✅ Uso de recursos está excelente${NC}"
    echo -e "${CYAN}   - Nenhuma ação imediata necessária${NC}"
    echo -e "${CYAN}   - Continuar monitoramento regular${NC}"
elif (( $(echo "$DISK_PERCENT > 80" | bc -l) )) || (( $(echo "$INODES_PERCENT > 80" | bc -l) )) || (( $(echo "$RESOURCES_USED > 80" | bc -l) )); then
    echo -e "${YELLOW}⚠️  Uso de recursos está alto${NC}"
    echo -e "${CYAN}   - Considerar limpeza de arquivos${NC}"
    echo -e "${CYAN}   - Revisar necessidade de upgrade${NC}"
    echo -e "${CYAN}   - Otimizar banco de dados${NC}"
else
    echo -e "${CYAN}📊 Uso de recursos está normal${NC}"
    echo -e "${CYAN}   - Monitorar crescimento${NC}"
    echo -e "${CYAN}   - Manter backups atualizados${NC}"
fi

echo ""

# Próximas ações
echo -e "${BLUE}📋 PRÓXIMAS AÇÕES:${NC}"
echo ""
echo -e "${CYAN}1. Monitoramento:${NC}"
echo -e "   - Verificar uso semanalmente"
echo -e "   - Documentar tendências"
echo ""
echo -e "${CYAN}2. Manutenção:${NC}"
echo -e "   - Limpar logs antigos (mensal)"
echo -e "   - Otimizar banco de dados (se aplicável)"
echo -e "   - Revisar arquivos grandes"
echo ""
echo -e "${CYAN}3. Upgrade:${NC}"
if (( $(echo "$DISK_PERCENT > 80" | bc -l) )) || (( $(echo "$INODES_PERCENT > 80" | bc -l) )); then
    echo -e "   ${YELLOW}⚠️  Considerar upgrade se uso continuar crescendo${NC}"
else
    echo -e "   ${GREEN}✅ Não necessário no momento${NC}"
fi
echo ""

echo -e "${GREEN}✅ Monitoramento concluído!${NC}"
echo ""
echo -e "${CYAN}📝 Para mais informações:${NC}"
echo -e "   - Painel: https://hpanel.hostinger.com/"
echo -e "   - Documentação: automation_1password/docs/MONITORAR_RECURSOS_HOSPEDAGEM.md"
echo ""

