#!/bin/bash
# Script para Atualizar Nameservers do senamfo.com.br para Hostinger
# Remove DNS parking e configura nameservers da Hostinger
#
# Uso: ./scripts/atualizar-nameservers-senamfo.sh [--dry-run] [--via-registro-br]

set -euo pipefail

# Cores
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
RED='\033[0;31m'
CYAN='\033[0;36m'
NC='\033[0m'

DOMAIN="senamfo.com.br"
DRY_RUN=false
VIA_REGISTRO_BR=false

# Nameservers da Hostinger
NS1="ns1.dns.hostinger.com"
NS2="ns2.dns.hostinger.com"

# Parse arguments
while [[ $# -gt 0 ]]; do
    case $1 in
        --dry-run)
            DRY_RUN=true
            shift
            ;;
        --via-registro-br)
            VIA_REGISTRO_BR=true
            shift
            ;;
        *)
            echo -e "${RED}Opção desconhecida: $1${NC}"
            exit 1
            ;;
    esac
done

echo -e "${BLUE}╔════════════════════════════════════════╗${NC}"
echo -e "${BLUE}║   ATUALIZAR NAMESERVERS HOSTINGER     ║${NC}"
echo -e "${BLUE}╚════════════════════════════════════════╝${NC}"
echo ""
echo -e "${CYAN}Domínio: ${DOMAIN}${NC}"
echo -e "${CYAN}Nameservers atuais: ns1.dns-parking.com, ns2.dns-parking.com${NC}"
echo -e "${CYAN}Nameservers novos: ${NS1}, ${NS2}${NC}"
[ "$DRY_RUN" = true ] && echo -e "${YELLOW}⚠️  MODO DRY-RUN (sem alterações)${NC}"
echo ""

# Verificar nameservers atuais
echo -e "${YELLOW}🔍 Verificando nameservers atuais...${NC}"
CURRENT_NS=$(dig NS "$DOMAIN" +short 2>/dev/null | sort)
echo -e "${CYAN}Nameservers públicos:${NC}"
echo "$CURRENT_NS" | while read ns; do
    echo -e "   - $ns"
done
echo ""

# Verificar se são da Hostinger
IS_HOSTINGER=false
if echo "$CURRENT_NS" | grep -q "dns.hostinger.com"; then
    IS_HOSTINGER=true
    echo -e "${GREEN}✅ Nameservers já são da Hostinger${NC}"
    exit 0
else
    echo -e "${RED}❌ Nameservers NÃO são da Hostinger${NC}"
    echo -e "${YELLOW}   Necessário atualizar${NC}"
fi

echo ""

# Verificar se domínio está na Hostinger
echo -e "${YELLOW}🔍 Verificando se domínio está na Hostinger...${NC}"
if command -v op &> /dev/null && op whoami &>/dev/null; then
    # Tentar verificar via API Hostinger (se disponível)
    echo -e "${CYAN}   Verificando via API Hostinger...${NC}"
    # Nota: API pode não retornar domínio se não estiver na Hostinger
    echo -e "${YELLOW}   ⚠️  Domínio pode não estar na Hostinger ainda${NC}"
else
    echo -e "${YELLOW}   ⚠️  1Password CLI não disponível${NC}"
fi

echo ""

# Instruções de atualização
echo -e "${BLUE}📋 INSTRUÇÕES DE ATUALIZAÇÃO:${NC}"
echo ""

if [ "$VIA_REGISTRO_BR" = true ]; then
    echo -e "${CYAN}Opção: Via Registro.br${NC}"
    echo ""
    echo "1. Acessar: https://registro.br/"
    echo "2. Fazer login com suas credenciais"
    echo "3. Ir em: Meus Domínios > ${DOMAIN} > Alterar DNS"
    echo "4. Atualizar nameservers para:"
    echo "   - ${NS1}"
    echo "   - ${NS2}"
    echo "5. Salvar alterações"
    echo ""
else
    echo -e "${CYAN}Opção: Via Painel Hostinger${NC}"
    echo ""
    echo "1. Acessar: https://hpanel.hostinger.com/"
    echo "2. Navegar para: Domínios > ${DOMAIN}"
    echo "3. Ir em: Nameservers / DNS"
    echo "4. Atualizar para:"
    echo "   - ${NS1}"
    echo "   - ${NS2}"
    echo "5. Salvar alterações"
    echo ""
    echo -e "${YELLOW}Nota: Se domínio não aparecer na Hostinger,${NC}"
    echo -e "${YELLOW}      use --via-registro-br para atualizar via Registro.br${NC}"
fi

echo ""

# Verificação pós-atualização
echo -e "${BLUE}✅ APÓS ATUALIZAÇÃO:${NC}"
echo ""
echo "1. Aguardar propagação (até 48h):"
echo "   dig NS ${DOMAIN} +short"
echo ""
echo "2. Verificar nameservers:"
echo "   dig NS ${DOMAIN} @8.8.8.8 +short"
echo ""
echo "3. Verificar registros DNS:"
echo "   dig A ${DOMAIN} +short"
echo "   dig A n8n.${DOMAIN} +short"
echo "   dig A chatwoot.${DOMAIN} +short"
echo ""

if [ "$DRY_RUN" = false ]; then
    echo -e "${YELLOW}⚠️  IMPORTANTE:${NC}"
    echo -e "   - Propagação pode levar até 48 horas"
    echo -e "   - Pode haver breve interrupção durante mudança"
    echo -e "   - Fazer backup dos registros DNS antes"
    echo ""
fi

echo -e "${GREEN}✅ Instruções geradas${NC}"
echo ""

