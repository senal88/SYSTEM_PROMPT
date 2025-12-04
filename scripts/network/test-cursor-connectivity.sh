#!/bin/bash
# ============================================================
# TESTE DE CONECTIVIDADE - CURSOR API
# ============================================================
# Script rápido para testar conectividade com api2.cursor.sh
# Versão: 1.0.0
# Data: 2025-01-17
# ============================================================

set -euo pipefail
IFS=$'\n\t'

# Cores
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

TARGET_DOMAIN="${1:-api2.cursor.sh}"
TIMEOUT=10

print_test() {
    local test_name="$1"
    local command="$2"

    echo -n "Testando $test_name... "

    if eval "$command" >/dev/null 2>&1; then
        echo -e "${GREEN}✅ OK${NC}"
        return 0
    else
        echo -e "${RED}❌ FALHOU${NC}"
        return 1
    fi
}

echo "============================================================"
echo "TESTE DE CONECTIVIDADE - $TARGET_DOMAIN"
echo "============================================================"
echo ""

# Teste 1: Conectividade básica
print_test "Conectividade básica (ping 8.8.8.8)" "ping -c 1 -W 2000 8.8.8.8"

# Teste 2: DNS básico
print_test "DNS básico (google.com)" "nslookup google.com"

# Teste 3: Resolução DNS do domínio
echo -n "Testando resolução DNS de $TARGET_DOMAIN... "
if RESOLVED_IP=$(nslookup "$TARGET_DOMAIN" 2>/dev/null | grep -A 1 "Name:" | grep "Address:" | awk '{print $2}' | head -1); then
    if [ -n "$RESOLVED_IP" ]; then
        echo -e "${GREEN}✅ OK${NC} (IP: $RESOLVED_IP)"
    else
        echo -e "${RED}❌ FALHOU${NC} (DNS não retornou IP)"
    fi
else
    echo -e "${RED}❌ FALHOU${NC} (nslookup falhou)"
fi

# Teste 4: Conexão HTTPS
echo -n "Testando conexão HTTPS... "
HTTP_CODE=$(curl -s -o /dev/null -w "%{http_code}" --connect-timeout "$TIMEOUT" --max-time "$TIMEOUT" "https://$TARGET_DOMAIN" 2>/dev/null || echo "000")

if [ "$HTTP_CODE" != "000" ] && [ "$HTTP_CODE" != "" ]; then
    echo -e "${GREEN}✅ OK${NC} (HTTP $HTTP_CODE)"
else
    echo -e "${RED}❌ FALHOU${NC} (código: $HTTP_CODE)"
fi

# Teste 5: Teste com dig (se disponível)
if command -v dig >/dev/null 2>&1; then
    print_test "Resolução DNS (dig)" "dig +short $TARGET_DOMAIN"
fi

# Teste 6: Teste de porta específica (443)
echo -n "Testando porta 443... "
if nc -z -G 5 "$TARGET_DOMAIN" 443 2>/dev/null; then
    echo -e "${GREEN}✅ OK${NC}"
else
    echo -e "${YELLOW}⚠️  FALHOU${NC} (pode ser bloqueado por firewall)"
fi

echo ""
echo "============================================================"
echo "TESTE CONCLUÍDO"
echo "============================================================"
echo ""
echo "Se algum teste falhou, execute:"
echo "  ${DOTFILES_DIR:-$HOME/Dotfiles}/scripts/network/fix-dns-and-trust-network.sh"
echo ""
