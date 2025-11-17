#!/bin/bash
# Script para Testar Conexão IMAP Hostinger
# Testa login, listagem de pastas e leitura de emails
#
# Uso: ./scripts/test-imap-hostinger.sh [--user USER] [--pass PASSWORD]

set -euo pipefail

# Cores
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
RED='\033[0;31m'
CYAN='\033[0;36m'
NC='\033[0m'

# Configurações padrão
IMAP_HOST="imap.hostinger.com"
IMAP_PORT="993"
USERNAME="sena@mfotrust.com"
PASSWORD="Gm@1L#Env"

# Parse arguments
while [[ $# -gt 0 ]]; do
    case $1 in
        --user)
            USERNAME="$2"
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
echo -e "${BLUE}║   TESTE DE CONEXÃO IMAP HOSTINGER    ║${NC}"
echo -e "${BLUE}╚════════════════════════════════════════╝${NC}"
echo ""
echo -e "${CYAN}Servidor: ${IMAP_HOST}:${IMAP_PORT}${NC}"
echo -e "${CYAN}Usuário: ${USERNAME}${NC}"
echo ""

# Criar arquivo temporário com comandos IMAP
TMP_FILE=$(mktemp)
cat > "$TMP_FILE" <<EOF
a LOGIN ${USERNAME} ${PASSWORD}
a LIST "" "*"
a SELECT INBOX
a FETCH 1:* (FLAGS)
a LOGOUT
EOF

echo -e "${YELLOW}📧 Testando conexão IMAP...${NC}"
echo ""

# Executar comandos via openssl
if openssl s_client -crlf -connect "${IMAP_HOST}:${IMAP_PORT}" < "$TMP_FILE" 2>/dev/null; then
    echo ""
    echo -e "${GREEN}✅ Teste concluído${NC}"
else
    echo ""
    echo -e "${RED}❌ Erro na conexão${NC}"
    rm -f "$TMP_FILE"
    exit 1
fi

# Limpar arquivo temporário
rm -f "$TMP_FILE"

echo ""
echo -e "${CYAN}📝 Comandos executados:${NC}"
echo "   1. LOGIN ${USERNAME}"
echo "   2. LIST \"\" \"*\""
echo "   3. SELECT INBOX"
echo "   4. FETCH 1:* (FLAGS)"
echo "   5. LOGOUT"
echo ""

