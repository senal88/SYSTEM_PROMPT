#!/bin/bash
# Script para Exportar Registros DNS Atuais
# Exporta todos os registros DNS do domínio para backup
#
# Uso: ./scripts/exportar-dns-atual.sh [--domain DOMAIN] [--output FILE]

set -euo pipefail

# Cores
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
RED='\033[0;31m'
CYAN='\033[0;36m'
NC='\033[0m'

DOMAIN="mfotrust.com"
OUTPUT_FILE="automation_1password/exports/dns-${DOMAIN}-$(date +%Y%m%d_%H%M%S).txt"

# Parse arguments
while [[ $# -gt 0 ]]; do
    case $1 in
        --domain)
            DOMAIN="$2"
            shift 2
            ;;
        --output)
            OUTPUT_FILE="$2"
            shift 2
            ;;
        *)
            echo -e "${RED}Opção desconhecida: $1${NC}"
            exit 1
            ;;
    esac
done

# Criar diretório se não existir
mkdir -p "$(dirname "$OUTPUT_FILE")"

echo -e "${BLUE}╔════════════════════════════════════════╗${NC}"
echo -e "${BLUE}║   EXPORTAR REGISTROS DNS             ║${NC}"
echo -e "${BLUE}╚════════════════════════════════════════╝${NC}"
echo ""
echo -e "${CYAN}Domínio: ${DOMAIN}${NC}"
echo -e "${CYAN}Arquivo: ${OUTPUT_FILE}${NC}"
echo ""

echo -e "${YELLOW}📊 Coletando registros DNS...${NC}"

# Criar arquivo de export
cat > "$OUTPUT_FILE" <<EOF
# Export de Registros DNS - ${DOMAIN}
# Data: $(date)
# Gerado por: exportar-dns-atual.sh

EOF

# Nameservers
echo -e "${CYAN}📡 Nameservers...${NC}"
echo "" >> "$OUTPUT_FILE"
echo "## Nameservers (NS)" >> "$OUTPUT_FILE"
NS_RECORDS=$(dig ${DOMAIN} NS +short 2>/dev/null)
if [ -n "$NS_RECORDS" ]; then
    echo "$NS_RECORDS" | while read ns; do
        echo "NS  @  ${ns}" >> "$OUTPUT_FILE"
    done
else
    echo "# Nenhum nameserver encontrado" >> "$OUTPUT_FILE"
fi

# Registros A
echo -e "${CYAN}📍 Registros A...${NC}"
echo "" >> "$OUTPUT_FILE"
echo "## Registros A" >> "$OUTPUT_FILE"
A_RECORDS=$(dig ${DOMAIN} A +short 2>/dev/null)
if [ -n "$A_RECORDS" ]; then
    echo "$A_RECORDS" | while read ip; do
        echo "A  @  ${ip}" >> "$OUTPUT_FILE"
    done
fi

# Registros AAAA (IPv6)
AAAA_RECORDS=$(dig ${DOMAIN} AAAA +short 2>/dev/null)
if [ -n "$AAAA_RECORDS" ]; then
    echo "$AAAA_RECORDS" | while read ipv6; do
        echo "AAAA  @  ${ipv6}" >> "$OUTPUT_FILE"
    done
fi

# Registros MX
echo -e "${CYAN}📧 Registros MX...${NC}"
echo "" >> "$OUTPUT_FILE"
echo "## Registros MX (Email)" >> "$OUTPUT_FILE"
MX_RECORDS=$(dig ${DOMAIN} MX +short 2>/dev/null)
if [ -n "$MX_RECORDS" ]; then
    echo "$MX_RECORDS" | while read priority server; do
        echo "MX  @  ${priority}  ${server}" >> "$OUTPUT_FILE"
    done
else
    echo "# Nenhum registro MX encontrado" >> "$OUTPUT_FILE"
fi

# Registros TXT
echo -e "${CYAN}📝 Registros TXT...${NC}"
echo "" >> "$OUTPUT_FILE"
echo "## Registros TXT" >> "$OUTPUT_FILE"
TXT_RECORDS=$(dig ${DOMAIN} TXT +short 2>/dev/null)
if [ -n "$TXT_RECORDS" ]; then
    echo "$TXT_RECORDS" | while read txt; do
        echo "TXT  @  ${txt}" >> "$OUTPUT_FILE"
    done
fi

# SPF
SPF=$(dig ${DOMAIN} TXT +short 2>/dev/null | grep -i "v=spf1" || echo "")
if [ -n "$SPF" ]; then
    echo "TXT  @  ${SPF}  (SPF)" >> "$OUTPUT_FILE"
fi

# DMARC
DMARC=$(dig _dmarc.${DOMAIN} TXT +short 2>/dev/null | grep -i "v=dmarc1" || echo "")
if [ -n "$DMARC" ]; then
    echo "TXT  _dmarc  ${DMARC}  (DMARC)" >> "$OUTPUT_FILE"
fi

# DKIM
echo "" >> "$OUTPUT_FILE"
echo "## Registros DKIM" >> "$OUTPUT_FILE"
DKIM_KEYS=("hostingermail-a" "hostingermail-b" "hostingermail-c" "default")
for key in "${DKIM_KEYS[@]}"; do
    DKIM=$(dig ${key}._domainkey.${DOMAIN} TXT +short 2>/dev/null || echo "")
    if [ -n "$DKIM" ]; then
        echo "TXT  ${key}._domainkey  ${DKIM}" >> "$OUTPUT_FILE"
    fi
done

# Registros CNAME
echo -e "${CYAN}🔗 Registros CNAME...${NC}"
echo "" >> "$OUTPUT_FILE"
echo "## Registros CNAME" >> "$OUTPUT_FILE"
# Verificar CNAMEs comuns
CNAME_NAMES=("www" "ftp" "mail" "autodiscover" "autoconfig")
for name in "${CNAME_NAMES[@]}"; do
    CNAME=$(dig ${name}.${DOMAIN} CNAME +short 2>/dev/null || echo "")
    if [ -n "$CNAME" ]; then
        echo "CNAME  ${name}  ${CNAME}" >> "$OUTPUT_FILE"
    fi
done

# Verificar todos os CNAMEs via ANY
ANY_RECORDS=$(dig ${DOMAIN} ANY +noall +answer 2>/dev/null | grep "CNAME" || echo "")
if [ -n "$ANY_RECORDS" ]; then
    echo "$ANY_RECORDS" | awk '{print "CNAME  " $1 "  " $5}' >> "$OUTPUT_FILE"
fi

# Resumo
echo "" >> "$OUTPUT_FILE"
echo "## Resumo" >> "$OUTPUT_FILE"
echo "# Total de nameservers: $(echo "$NS_RECORDS" | wc -l | tr -d ' ')" >> "$OUTPUT_FILE"
echo "# Total de registros MX: $(echo "$MX_RECORDS" | wc -l | tr -d ' ')" >> "$OUTPUT_FILE"
echo "# SPF: $([ -n "$SPF" ] && echo "Configurado" || echo "Não configurado")" >> "$OUTPUT_FILE"
echo "# DMARC: $([ -n "$DMARC" ] && echo "Configurado" || echo "Não configurado")" >> "$OUTPUT_FILE"

echo ""
echo -e "${GREEN}✅ Export concluído!${NC}"
echo -e "${CYAN}   Arquivo: ${OUTPUT_FILE}${NC}"
echo ""

# Mostrar preview
echo -e "${YELLOW}📄 Preview (primeiras 30 linhas):${NC}"
head -30 "$OUTPUT_FILE"
echo ""

