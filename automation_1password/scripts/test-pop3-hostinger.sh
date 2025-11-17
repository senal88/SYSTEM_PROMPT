#!/bin/bash
# Script para Testar POP3 Hostinger (Recebimento de Email)
# Testa autenticação e listagem de emails via POP3
#
# Uso: ./scripts/test-pop3-hostinger.sh [--user EMAIL] [--pass PASSWORD]

set -euo pipefail

# Cores
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
RED='\033[0;31m'
CYAN='\033[0;36m'
NC='\033[0m'

# Configurações
POP3_HOST="pop.hostinger.com"
POP3_PORT="995"
EMAIL="sena@mfotrust.com"
PASSWORD="Gm@1L#Env"

# Parse arguments
while [[ $# -gt 0 ]]; do
    case $1 in
        --user)
            EMAIL="$2"
            shift 2
            ;;
        --pass)
            PASSWORD="$2"
            shift 2
            ;;
        *)
            echo -e "${RED}Opção desconhecida: $1${NC}"
            exit 1
            ;;
    esac
done

echo -e "${BLUE}╔════════════════════════════════════════╗${NC}"
echo -e "${BLUE}║   TESTE POP3 HOSTINGER (RECEBIMENTO)  ║${NC}"
echo -e "${BLUE}╚════════════════════════════════════════╝${NC}"
echo ""
echo -e "${CYAN}Servidor: ${POP3_HOST}:${POP3_PORT}${NC}"
echo -e "${CYAN}Usuário: ${EMAIL}${NC}"
echo ""

echo -e "${YELLOW}📬 Conectando e testando POP3...${NC}"
echo ""

# Executar comandos POP3
(
    sleep 1
    echo "USER ${EMAIL}"
    sleep 1
    echo "PASS ${PASSWORD}"
    sleep 2
    echo "STAT"
    sleep 1
    echo "LIST"
    sleep 1
    echo "RETR 1"
    sleep 2
    echo "QUIT"
    sleep 1
) | openssl s_client -crlf -connect "${POP3_HOST}:${POP3_PORT}" -quiet 2>/dev/null | head -100

echo ""
echo -e "${GREEN}✅ Teste POP3 concluído${NC}"
echo ""

