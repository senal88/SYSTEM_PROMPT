#!/bin/bash
# Script para Verificar Child Nameservers
# Verifica se child nameservers estão configurados corretamente
#
# Uso: ./scripts/verificar-child-nameservers.sh [--domain DOMAIN] [--ip IP]

set -euo pipefail

# Cores
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
RED='\033[0;31m'
CYAN='\033[0;36m'
NC='\033[0m'

DOMAIN="mfotrust.com"
VPS_IP="147.79.81.59"
NS1="ns1"
NS2="ns2"

# Parse arguments
while [[ $# -gt 0 ]]; do
    case $1 in
        --domain)
            DOMAIN="$2"
            shift 2
            ;;
        --ip)
            VPS_IP="$2"
            shift 2
            ;;
        *)
            echo -e "${RED}Opção desconhecida: $1${NC}"
            exit 1
            ;;
    esac
done

echo -e "${BLUE}╔════════════════════════════════════════╗${NC}"
echo -e "${BLUE}║   VERIFICAÇÃO CHILD NAMESERVERS      ║${NC}"
echo -e "${BLUE}╚════════════════════════════════════════╝${NC}"
echo ""
echo -e "${CYAN}Domínio: ${DOMAIN}${NC}"
echo -e "${CYAN}VPS IP: ${VPS_IP}${NC}"
echo ""

ERRORS=0

# Verificar ns1
echo -e "${YELLOW}🔍 Verificando ${NS1}.${DOMAIN}...${NC}"
NS1_IP=$(dig ${NS1}.${DOMAIN} +short 2>/dev/null | head -1)
if [ "$NS1_IP" = "$VPS_IP" ]; then
    echo -e "${GREEN}   ✅ ${NS1}.${DOMAIN} → ${NS1_IP}${NC}"
else
    echo -e "${RED}   ❌ ${NS1}.${DOMAIN} → ${NS1_IP} (esperado: ${VPS_IP})${NC}"
    ERRORS=$((ERRORS + 1))
fi

# Verificar ns2
echo -e "${YELLOW}🔍 Verificando ${NS2}.${DOMAIN}...${NC}"
NS2_IP=$(dig ${NS2}.${DOMAIN} +short 2>/dev/null | head -1)
if [ "$NS2_IP" = "$VPS_IP" ]; then
    echo -e "${GREEN}   ✅ ${NS2}.${DOMAIN} → ${NS2_IP}${NC}"
else
    echo -e "${RED}   ❌ ${NS2}.${DOMAIN} → ${NS2_IP} (esperado: ${VPS_IP})${NC}"
    ERRORS=$((ERRORS + 1))
fi

echo ""

# Verificar nameservers do domínio
echo -e "${YELLOW}🔍 Verificando nameservers de ${DOMAIN}...${NC}"
DOMAIN_NS=$(dig ${DOMAIN} NS +short 2>/dev/null)
if echo "$DOMAIN_NS" | grep -q "${NS1}.${DOMAIN}"; then
    echo -e "${GREEN}   ✅ ${NS1}.${DOMAIN} está configurado${NC}"
else
    echo -e "${RED}   ❌ ${NS1}.${DOMAIN} NÃO está configurado${NC}"
    ERRORS=$((ERRORS + 1))
fi

if echo "$DOMAIN_NS" | grep -q "${NS2}.${DOMAIN}"; then
    echo -e "${GREEN}   ✅ ${NS2}.${DOMAIN} está configurado${NC}"
else
    echo -e "${RED}   ❌ ${NS2}.${DOMAIN} NÃO está configurado${NC}"
    ERRORS=$((ERRORS + 1))
fi

echo ""
echo -e "${CYAN}Nameservers encontrados:${NC}"
echo "$DOMAIN_NS" | while read ns; do
    echo -e "   - $ns"
done

echo ""

# Verificar resolução do domínio
echo -e "${YELLOW}🔍 Verificando resolução de ${DOMAIN}...${NC}"
DOMAIN_IP=$(dig ${DOMAIN} +short 2>/dev/null | head -1)
if [ -n "$DOMAIN_IP" ]; then
    echo -e "${GREEN}   ✅ ${DOMAIN} → ${DOMAIN_IP}${NC}"
else
    echo -e "${RED}   ❌ ${DOMAIN} não resolve${NC}"
    ERRORS=$((ERRORS + 1))
fi

echo ""

# Resumo
if [ $ERRORS -eq 0 ]; then
    echo -e "${GREEN}✅ Todos os testes passaram!${NC}"
    echo -e "${CYAN}   Child nameservers estão configurados corretamente${NC}"
else
    echo -e "${RED}❌ ${ERRORS} erro(s) encontrado(s)${NC}"
    echo -e "${YELLOW}   Verifique a configuração no painel Hostinger e Registro.br${NC}"
fi

echo ""

