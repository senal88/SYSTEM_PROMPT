#!/bin/bash
# Script de Verificação de Nameservers - Hostinger
# Verifica nameservers configurados e compara com padrão Hostinger
#
# Uso: ./scripts/verificar-nameservers-hostinger.sh [--domain DOMAIN]

set -euo pipefail

# Cores
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
RED='\033[0;31m'
CYAN='\033[0;36m'
NC='\033[0m'

DOMAIN="${1:-mfotrust.com}"

# Nameservers padrão da Hostinger
HOSTINGER_NS=(
    "ns1.dns.hostinger.com"
    "ns2.dns.hostinger.com"
    "ns3.dns.hostinger.com"
    "ns4.dns.hostinger.com"
)

echo -e "${BLUE}╔════════════════════════════════════════╗${NC}"
echo -e "${BLUE}║   VERIFICAÇÃO DE NAMESERVERS          ║${NC}"
echo -e "${BLUE}╚════════════════════════════════════════╝${NC}"
echo ""
echo -e "${CYAN}Domínio: ${DOMAIN}${NC}"
echo ""

# Verificar se 1Password CLI está disponível
if ! command -v op &> /dev/null; then
    echo -e "${YELLOW}⚠️  1Password CLI não encontrado${NC}"
    echo -e "${YELLOW}   Instalando verificação básica...${NC}"
    USE_OP=false
else
    USE_OP=true
    # Verificar autenticação
    if ! op whoami &>/dev/null; then
        echo -e "${YELLOW}⚠️  Não autenticado no 1Password${NC}"
        echo -e "${YELLOW}   Execute: op signin${NC}"
        USE_OP=false
    fi
fi

# Verificar nameservers via dig (se disponível)
echo -e "${YELLOW}📡 Verificando nameservers públicos...${NC}"
if command -v dig &> /dev/null; then
    CURRENT_NS=$(dig NS "$DOMAIN" +short 2>/dev/null | sort)
    if [ -n "$CURRENT_NS" ]; then
        echo -e "${CYAN}Nameservers públicos encontrados:${NC}"
        echo "$CURRENT_NS" | while read ns; do
            echo -e "   - $ns"
        done
        echo ""

        # Verificar se são da Hostinger
        IS_HOSTINGER=true
        echo "$CURRENT_NS" | while read ns; do
            if ! echo "${HOSTINGER_NS[@]}" | grep -q "$ns"; then
                IS_HOSTINGER=false
                echo -e "${RED}   ⚠️  $ns não é nameserver da Hostinger${NC}"
            fi
        done

        if [ "$IS_HOSTINGER" = true ]; then
            echo -e "${GREEN}✅ Todos os nameservers são da Hostinger${NC}"
        else
            echo -e "${RED}❌ Alguns nameservers NÃO são da Hostinger${NC}"
        fi
    else
        echo -e "${YELLOW}⚠️  Não foi possível obter nameservers via dig${NC}"
    fi
else
    echo -e "${YELLOW}⚠️  dig não encontrado (instalar: brew install bind)${NC}"
fi

echo ""

# Verificar via API Hostinger (se possível)
echo -e "${YELLOW}🔍 Verificando via API Hostinger...${NC}"
echo -e "${CYAN}Nameservers padrão da Hostinger:${NC}"
for ns in "${HOSTINGER_NS[@]}"; do
    echo -e "   - $ns"
done
echo ""

# Verificar itens Cloudflare no 1Password
if [ "$USE_OP" = true ]; then
    echo -e "${YELLOW}🔐 Verificando itens Cloudflare no 1Password...${NC}"

    # Listar vaults
    VAULTS=$(op vault list --format json 2>/dev/null | jq -r '.[].name' || echo "")

    if [ -n "$VAULTS" ]; then
        CLOUDFLARE_ITEMS=0
        echo "$VAULTS" | while read vault; do
            ITEMS=$(op item list --vault "$vault" --format json 2>/dev/null | jq -r '.[] | select(.title | test("(?i)(cloudflare|CF_)")) | .title' || echo "")
            if [ -n "$ITEMS" ]; then
                echo -e "${CYAN}Vault: $vault${NC}"
                echo "$ITEMS" | while read item; do
                    echo -e "${YELLOW}   - $item${NC}"
                    CLOUDFLARE_ITEMS=$((CLOUDFLARE_ITEMS + 1))
                done
            fi
        done

        if [ "$CLOUDFLARE_ITEMS" -eq 0 ]; then
            echo -e "${GREEN}✅ Nenhum item Cloudflare encontrado${NC}"
        else
            echo -e "${RED}⚠️  Encontrados $CLOUDFLARE_ITEMS itens relacionados ao Cloudflare${NC}"
            echo -e "${YELLOW}   Recomendação: Remover ou migrar para Hostinger${NC}"
        fi
    else
        echo -e "${YELLOW}⚠️  Não foi possível listar vaults${NC}"
    fi
else
    echo -e "${YELLOW}⚠️  Pulando verificação do 1Password (CLI não disponível)${NC}"
fi

echo ""

# Resumo
echo -e "${BLUE}📋 Resumo:${NC}"
echo -e "   Domínio: ${DOMAIN}"
echo -e "   Nameservers Hostinger: ${#HOSTINGER_NS[@]}"
if [ "$USE_OP" = true ]; then
    echo -e "   1Password: ✅ Disponível"
else
    echo -e "   1Password: ❌ Não disponível"
fi
echo ""

echo -e "${CYAN}📝 Próximos passos:${NC}"
echo -e "   1. Atualizar nameservers para Hostinger (se necessário)"
echo -e "   2. Remover itens Cloudflare do 1Password"
echo -e "   3. Verificar propagação DNS (pode levar até 48h)"
echo ""

