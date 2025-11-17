#!/bin/bash
# Script para Testar SMTP Hostinger (Envio de Email)
# Testa autenticação e envio de email via SMTP
#
# Uso: ./scripts/test-smtp-hostinger.sh [--user EMAIL] [--pass PASSWORD] [--to DESTINO]

set -euo pipefail

# Cores
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
RED='\033[0;31m'
CYAN='\033[0;36m'
NC='\033[0m'

# Configurações
SMTP_HOST="smtp.hostinger.com"
SMTP_PORT="465"
EMAIL="sena@mfotrust.com"
PASSWORD="Gm@1L#Env"
TO_EMAIL="${EMAIL}"  # Por padrão, envia para si mesmo

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
        --to)
            TO_EMAIL="$2"
            shift 2
            ;;
        *)
            echo -e "${RED}Opção desconhecida: $1${NC}"
            exit 1
            ;;
    esac
done

echo -e "${BLUE}╔════════════════════════════════════════╗${NC}"
echo -e "${BLUE}║   TESTE SMTP HOSTINGER (ENVIO)       ║${NC}"
echo -e "${BLUE}╚════════════════════════════════════════╝${NC}"
echo ""
echo -e "${CYAN}Servidor: ${SMTP_HOST}:${SMTP_PORT}${NC}"
echo -e "${CYAN}De: ${EMAIL}${NC}"
echo -e "${CYAN}Para: ${TO_EMAIL}${NC}"
echo ""

# Codificar credenciais em base64
EMAIL_B64=$(echo -n "$EMAIL" | base64)
PASS_B64=$(echo -n "$PASSWORD" | base64)

echo -e "${YELLOW}📤 Conectando e testando SMTP...${NC}"
echo ""

# Executar comandos SMTP
(
    sleep 1
    echo "EHLO mfotrust.com"
    sleep 1
    echo "AUTH LOGIN"
    sleep 1
    echo "$EMAIL_B64"
    sleep 1
    echo "$PASS_B64"
    sleep 2
    echo "MAIL FROM:<${EMAIL}>"
    sleep 1
    echo "RCPT TO:<${TO_EMAIL}>"
    sleep 1
    echo "DATA"
    sleep 1
    echo "Subject: Teste SMTP Hostinger - $(date +%Y-%m-%d\ %H:%M:%S)"
    echo "From: ${EMAIL}"
    echo "To: ${TO_EMAIL}"
    echo "Date: $(date -R)"
    echo ""
    echo "Este é um email de teste enviado via SMTP Hostinger."
    echo ""
    echo "Detalhes do teste:"
    echo "- Servidor: ${SMTP_HOST}:${SMTP_PORT}"
    echo "- Data/Hora: $(date)"
    echo "- Protocolo: SMTP com SSL/TLS"
    echo ""
    echo "Se você recebeu este email, o SMTP está funcionando corretamente!"
    echo "."
    sleep 1
    echo "QUIT"
    sleep 1
) | openssl s_client -crlf -connect "${SMTP_HOST}:${SMTP_PORT}" 2>/dev/null | grep -E "(250|235|354|221|OK|ERROR|Authentication)" || true

echo ""
echo -e "${GREEN}✅ Teste SMTP concluído${NC}"
echo ""
echo -e "${CYAN}📝 Verifique a caixa de entrada de ${TO_EMAIL}${NC}"
echo ""

