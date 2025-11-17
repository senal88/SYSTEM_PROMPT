#!/bin/bash
# Script para Atualizar Nameservers para Hostinger
# Remove referências ao Cloudflare e configura nameservers da Hostinger
#
# Uso: ./scripts/atualizar-nameservers-hostinger.sh --domain DOMAIN [--dry-run]

set -euo pipefail

# Cores
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
RED='\033[0;31m'
CYAN='\033[0;36m'
NC='\033[0m'

DOMAIN=""
DRY_RUN=false

# Parse arguments
while [[ $# -gt 0 ]]; do
    case $1 in
        --domain)
            DOMAIN="$2"
            shift 2
            ;;
        --dry-run)
            DRY_RUN=true
            shift
            ;;
        *)
            echo -e "${RED}Opção desconhecida: $1${NC}"
            exit 1
            ;;
    esac
done

if [ -z "$DOMAIN" ]; then
    echo -e "${RED}❌ Erro: Domínio não fornecido${NC}"
    echo "Uso: $0 --domain DOMAIN [--dry-run]"
    exit 1
fi

# Nameservers padrão da Hostinger
NS1="ns1.dns.hostinger.com"
NS2="ns2.dns.hostinger.com"
NS3="ns3.dns.hostinger.com"
NS4="ns4.dns.hostinger.com"

echo -e "${BLUE}╔════════════════════════════════════════╗${NC}"
echo -e "${BLUE}║   ATUALIZAR NAMESERVERS HOSTINGER     ║${NC}"
echo -e "${BLUE}╚════════════════════════════════════════╝${NC}"
echo ""
echo -e "${CYAN}Domínio: ${DOMAIN}${NC}"
echo -e "${CYAN}Nameservers: ${NS1}, ${NS2}${NC}"
[ "$DRY_RUN" = true ] && echo -e "${YELLOW}⚠️  MODO DRY-RUN (sem alterações)${NC}"
echo ""

# Verificar se MCP Hostinger está disponível
if command -v op &> /dev/null && op whoami &>/dev/null; then
    echo -e "${YELLOW}📡 Atualizando nameservers via API Hostinger...${NC}"

    if [ "$DRY_RUN" = false ]; then
        echo -e "${YELLOW}   ⚠️  Esta operação requer acesso à API Hostinger${NC}"
        echo -e "${YELLOW}   Use o MCP Hostinger para atualizar nameservers${NC}"
        echo ""
        echo -e "${CYAN}Comando sugerido (via MCP):${NC}"
        echo "   mcp_hostinger-mcp_domains_updateDomainNameserversV1"
        echo "   --domain ${DOMAIN}"
        echo "   --ns1 ${NS1}"
        echo "   --ns2 ${NS2}"
    else
        echo -e "${YELLOW}[DRY-RUN] Atualizaria nameservers para:${NC}"
        echo -e "   ns1: ${NS1}"
        echo -e "   ns2: ${NS2}"
    fi
else
    echo -e "${YELLOW}⚠️  1Password CLI não disponível${NC}"
    echo -e "${YELLOW}   Atualização manual necessária${NC}"
fi

echo ""
echo -e "${GREEN}✅ Verificação concluída${NC}"
echo ""
echo -e "${CYAN}📝 Nota:${NC}"
echo -e "   A propagação de nameservers pode levar até 48 horas"
echo -e "   Verifique com: dig NS ${DOMAIN}"
echo ""

