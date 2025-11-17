#!/bin/bash
# Script para Verificar Registros DNS de Email
# Verifica MX, SPF, DKIM, DMARC para mfotrust.com
#
# Uso: ./scripts/verificar-dns-email.sh [--domain DOMAIN]

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
echo -e "${BLUE}║   VERIFICAÇÃO DNS DE EMAIL            ║${NC}"
echo -e "${BLUE}╚════════════════════════════════════════╝${NC}"
echo ""
echo -e "${CYAN}Domínio: ${DOMAIN}${NC}"
echo ""

# Verificar MX
echo -e "${YELLOW}📧 MX Records (Servidores de Email):${NC}"
MX_RECORDS=$(dig ${DOMAIN} MX +short 2>/dev/null)
if [ -n "$MX_RECORDS" ]; then
    echo "$MX_RECORDS" | while read priority server; do
        echo -e "${GREEN}   ✅ Prioridade ${priority}: ${server}${NC}"
    done
else
    echo -e "${RED}   ❌ Nenhum registro MX encontrado${NC}"
fi
echo ""

# Verificar SPF
echo -e "${YELLOW}🛡️  SPF Record (Proteção contra Spam):${NC}"
SPF_RECORD=$(dig ${DOMAIN} TXT +short 2>/dev/null | grep -i "v=spf1" || echo "")
if [ -n "$SPF_RECORD" ]; then
    echo -e "${GREEN}   ✅ SPF encontrado:${NC}"
    echo -e "${CYAN}   ${SPF_RECORD}${NC}"
else
    echo -e "${RED}   ❌ SPF não encontrado${NC}"
fi
echo ""

# Verificar DKIM
echo -e "${YELLOW}🔐 DKIM Records (Autenticação de Email):${NC}"
DKIM_KEYS=("default" "hostingermail-a" "hostingermail-b" "hostingermail-c")
DKIM_FOUND=false
for key in "${DKIM_KEYS[@]}"; do
    DKIM_RECORD=$(dig ${key}._domainkey.${DOMAIN} TXT +short 2>/dev/null)
    if [ -n "$DKIM_RECORD" ]; then
        echo -e "${GREEN}   ✅ ${key}._domainkey:${NC}"
        echo -e "${CYAN}   ${DKIM_RECORD}${NC}"
        DKIM_FOUND=true
    fi
done
if [ "$DKIM_FOUND" = false ]; then
    echo -e "${RED}   ❌ Nenhum registro DKIM encontrado${NC}"
fi
echo ""

# Verificar DMARC
echo -e "${YELLOW}📋 DMARC Record (Política de Email):${NC}"
DMARC_RECORD=$(dig _dmarc.${DOMAIN} TXT +short 2>/dev/null | grep -i "v=dmarc1" || echo "")
if [ -n "$DMARC_RECORD" ]; then
    echo -e "${GREEN}   ✅ DMARC encontrado:${NC}"
    echo -e "${CYAN}   ${DMARC_RECORD}${NC}"
else
    echo -e "${RED}   ❌ DMARC não encontrado${NC}"
fi
echo ""

# Verificar Nameservers
echo -e "${YELLOW}🌐 Nameservers:${NC}"
NS_RECORDS=$(dig ${DOMAIN} NS +short 2>/dev/null)
if [ -n "$NS_RECORDS" ]; then
    echo "$NS_RECORDS" | while read ns; do
        echo -e "${CYAN}   ${ns}${NC}"
    done
else
    echo -e "${RED}   ❌ Nameservers não encontrados${NC}"
fi
echo ""

# Resumo
echo -e "${BLUE}📊 Resumo:${NC}"
[ -n "$MX_RECORDS" ] && echo -e "${GREEN}   ✅ MX: Configurado${NC}" || echo -e "${RED}   ❌ MX: Não configurado${NC}"
[ -n "$SPF_RECORD" ] && echo -e "${GREEN}   ✅ SPF: Configurado${NC}" || echo -e "${RED}   ❌ SPF: Não configurado${NC}"
[ "$DKIM_FOUND" = true ] && echo -e "${GREEN}   ✅ DKIM: Configurado${NC}" || echo -e "${RED}   ❌ DKIM: Não configurado${NC}"
[ -n "$DMARC_RECORD" ] && echo -e "${GREEN}   ✅ DMARC: Configurado${NC}" || echo -e "${RED}   ❌ DMARC: Não configurado${NC}"
echo ""

