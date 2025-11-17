#!/bin/bash
# Script Completo de Teste de Email - Hostinger
# Testa SMTP, IMAP e POP3 para mfotrust.com
#
# Uso: ./scripts/test-email-hostinger-completo.sh [--user EMAIL] [--pass PASSWORD]

set -euo pipefail

# Cores
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
RED='\033[0;31m'
CYAN='\033[0;36m'
NC='\033[0m'

# Configurações padrão
EMAIL="sena@mfotrust.com"
PASSWORD="Gm@1L#Env"
SMTP_HOST="smtp.hostinger.com"
SMTP_PORT="465"
IMAP_HOST="imap.hostinger.com"
IMAP_PORT="993"
POP3_HOST="pop.hostinger.com"
POP3_PORT="995"

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
echo -e "${BLUE}║   TESTE COMPLETO DE EMAIL HOSTINGER  ║${NC}"
echo -e "${BLUE}╚════════════════════════════════════════╝${NC}"
echo ""
echo -e "${CYAN}Email: ${EMAIL}${NC}"
echo -e "${CYAN}Domínio: mfotrust.com${NC}"
echo ""

# Função para codificar base64
encode_base64() {
    echo -n "$1" | base64
}

# Função para testar SMTP
test_smtp() {
    echo -e "${YELLOW}📤 Testando SMTP (Envio)...${NC}"
    echo ""

    EMAIL_B64=$(encode_base64 "$EMAIL")
    PASS_B64=$(encode_base64 "$PASSWORD")

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
        echo "RCPT TO:<${EMAIL}>"
        sleep 1
        echo "DATA"
        sleep 1
        echo "Subject: Teste SMTP Hostinger"
        echo "From: ${EMAIL}"
        echo "To: ${EMAIL}"
        echo ""
        echo "Este é um email de teste enviado via SMTP Hostinger."
        echo "Data: $(date)"
        echo "."
        sleep 1
        echo "QUIT"
        sleep 1
    ) | openssl s_client -crlf -connect "${SMTP_HOST}:${SMTP_PORT}" -quiet 2>/dev/null | grep -E "(250|235|354|221|OK|ERROR)" || true

    echo ""
    echo -e "${GREEN}✅ Teste SMTP concluído${NC}"
    echo ""
}

# Função para testar IMAP
test_imap() {
    echo -e "${YELLOW}📥 Testando IMAP (Recebimento)...${NC}"
    echo ""

    (
        sleep 1
        echo "a LOGIN ${EMAIL} ${PASSWORD}"
        sleep 2
        echo "a LIST \"\" \"*\""
        sleep 1
        echo "a SELECT INBOX"
        sleep 1
        echo "a FETCH 1:* (FLAGS)"
        sleep 1
        echo "a LOGOUT"
        sleep 1
    ) | openssl s_client -crlf -connect "${IMAP_HOST}:${IMAP_PORT}" -quiet 2>/dev/null | head -50

    echo ""
    echo -e "${GREEN}✅ Teste IMAP concluído${NC}"
    echo ""
}

# Função para testar POP3
test_pop3() {
    echo -e "${YELLOW}📬 Testando POP3 (Recebimento alternativo)...${NC}"
    echo ""

    (
        sleep 1
        echo "USER ${EMAIL}"
        sleep 1
        echo "PASS ${PASSWORD}"
        sleep 2
        echo "LIST"
        sleep 1
        echo "STAT"
        sleep 1
        echo "QUIT"
        sleep 1
    ) | openssl s_client -crlf -connect "${POP3_HOST}:${POP3_PORT}" -quiet 2>/dev/null | head -30

    echo ""
    echo -e "${GREEN}✅ Teste POP3 concluído${NC}"
    echo ""
}

# Função para verificar DNS
check_dns() {
    echo -e "${YELLOW}🔍 Verificando registros DNS...${NC}"
    echo ""

    echo -e "${CYAN}MX Records:${NC}"
    dig mfotrust.com MX +short | while read line; do
        echo -e "   $line"
    done

    echo ""
    echo -e "${CYAN}SPF Record:${NC}"
    dig mfotrust.com TXT +short | grep -i spf || echo "   Não encontrado"

    echo ""
    echo -e "${CYAN}DKIM Record:${NC}"
    dig default._domainkey.mfotrust.com TXT +short || echo "   Não encontrado"

    echo ""
    echo -e "${CYAN}DMARC Record:${NC}"
    dig _dmarc.mfotrust.com TXT +short || echo "   Não encontrado"

    echo ""
}

# Menu principal
echo -e "${BLUE}Escolha o teste:${NC}"
echo "  1) Verificar DNS"
echo "  2) Testar SMTP (Envio)"
echo "  3) Testar IMAP (Recebimento)"
echo "  4) Testar POP3 (Recebimento alternativo)"
echo "  5) Testar TUDO"
echo ""
read -p "Opção [1-5]: " option

case $option in
    1)
        check_dns
        ;;
    2)
        test_smtp
        ;;
    3)
        test_imap
        ;;
    4)
        test_pop3
        ;;
    5)
        check_dns
        test_smtp
        test_imap
        test_pop3
        ;;
    *)
        echo -e "${RED}Opção inválida${NC}"
        exit 1
        ;;
esac

echo -e "${GREEN}✅ Todos os testes concluídos!${NC}"
echo ""

