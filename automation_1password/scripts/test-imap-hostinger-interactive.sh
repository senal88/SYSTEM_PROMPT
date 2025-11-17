#!/bin/bash
# Script Interativo para Testar Conexão IMAP Hostinger
# Executa comandos IMAP via openssl de forma interativa
#
# Uso: ./scripts/test-imap-hostinger-interactive.sh

set -euo pipefail

# Cores
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
RED='\033[0;31m'
CYAN='\033[0;36m'
NC='\033[0m'

IMAP_HOST="imap.hostinger.com"
IMAP_PORT="993"
USERNAME="sena@mfotrust.com"
PASSWORD="Gm@1L#Env"

echo -e "${BLUE}╔════════════════════════════════════════╗${NC}"
echo -e "${BLUE}║   TESTE IMAP HOSTINGER (Interativo)   ║${NC}"
echo -e "${BLUE}╚════════════════════════════════════════╝${NC}"
echo ""
echo -e "${CYAN}Servidor: ${IMAP_HOST}:${IMAP_PORT}${NC}"
echo -e "${CYAN}Usuário: ${USERNAME}${NC}"
echo ""
echo -e "${YELLOW}📧 Conectando e executando comandos IMAP...${NC}"
echo ""
echo -e "${CYAN}Comandos a executar:${NC}"
echo "  1. a LOGIN ${USERNAME} [senha]"
echo "  2. a LIST \"\" \"*\""
echo "  3. a SELECT INBOX"
echo "  4. a FETCH 1:* (FLAGS)"
echo "  5. a LOGOUT"
echo ""

# Criar script expect temporário
EXPECT_SCRIPT=$(mktemp)
cat > "$EXPECT_SCRIPT" <<EOF
#!/usr/bin/expect -f
set timeout 30
spawn openssl s_client -crlf -connect ${IMAP_HOST}:${IMAP_PORT}
expect "Server ready"
send "a LOGIN ${USERNAME} ${PASSWORD}\r"
expect "OK"
send "a LIST \"\" \"*\"\r"
expect "OK"
send "a SELECT INBOX\r"
expect "OK"
send "a FETCH 1:* (FLAGS)\r"
expect "OK"
send "a LOGOUT\r"
expect eof
EOF

chmod +x "$EXPECT_SCRIPT"

# Verificar se expect está instalado
if ! command -v expect &> /dev/null; then
    echo -e "${YELLOW}⚠️  expect não está instalado${NC}"
    echo -e "${CYAN}Instalando expect...${NC}"
    if [[ "$OSTYPE" == "darwin"* ]]; then
        if command -v brew &> /dev/null; then
            brew install expect
        else
            echo -e "${RED}❌ Homebrew não encontrado. Instale expect manualmente.${NC}"
            rm -f "$EXPECT_SCRIPT"
            exit 1
        fi
    else
        echo -e "${RED}❌ Sistema não suportado. Instale expect manualmente.${NC}"
        rm -f "$EXPECT_SCRIPT"
        exit 1
    fi
fi

# Executar script expect
if expect -f "$EXPECT_SCRIPT"; then
    echo ""
    echo -e "${GREEN}✅ Teste concluído${NC}"
else
    echo ""
    echo -e "${RED}❌ Erro na execução${NC}"
    rm -f "$EXPECT_SCRIPT"
    exit 1
fi

# Limpar
rm -f "$EXPECT_SCRIPT"

echo ""

