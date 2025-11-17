#!/bin/bash
# Script para Configurar Child Nameservers na VPS
# Instala e configura BIND9 para servir DNS do domínio
#
# Uso: ./scripts/configurar-child-nameservers.sh [--domain DOMAIN] [--ip IP]

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
echo -e "${BLUE}║   CONFIGURAR CHILD NAMESERVERS       ║${NC}"
echo -e "${BLUE}╚════════════════════════════════════════╝${NC}"
echo ""
echo -e "${CYAN}Domínio: ${DOMAIN}${NC}"
echo -e "${CYAN}VPS IP: ${VPS_IP}${NC}"
echo -e "${CYAN}Nameservers: ${NS1}.${DOMAIN}, ${NS2}.${DOMAIN}${NC}"
echo ""

# Verificar se está rodando na VPS
if [ ! -f /etc/os-release ] || ! grep -q "Ubuntu\|Debian" /etc/os-release; then
    echo -e "${RED}❌ Este script deve ser executado na VPS Ubuntu${NC}"
    echo -e "${YELLOW}   Execute via SSH: ssh root@${VPS_IP}${NC}"
    exit 1
fi

# Verificar se é root
if [ "$EUID" -ne 0 ]; then
    echo -e "${RED}❌ Execute como root: sudo $0${NC}"
    exit 1
fi

echo -e "${YELLOW}📦 Instalando BIND9...${NC}"
apt update
apt install -y bind9 bind9utils bind9-doc dnsutils

echo ""
echo -e "${YELLOW}⚙️  Configurando BIND9...${NC}"

# Backup da configuração original
cp /etc/bind/named.conf.options /etc/bind/named.conf.options.bak

# Configurar named.conf.options
cat > /etc/bind/named.conf.options <<EOF
options {
    directory "/var/cache/bind";

    // Forwarders (Google DNS)
    forwarders {
        8.8.8.8;
        8.8.4.4;
    };

    // Permitir queries
    allow-query { any; };
    recursion yes;

    // DNSSEC
    dnssec-validation auto;

    listen-on-v6 { any; };
};
EOF

# Adicionar zone ao named.conf.local
if ! grep -q "zone \"${DOMAIN}\"" /etc/bind/named.conf.local; then
    cat >> /etc/bind/named.conf.local <<EOF

zone "${DOMAIN}" {
    type master;
    file "/etc/bind/db.${DOMAIN}";
};
EOF
fi

# Criar arquivo de zone
cat > /etc/bind/db.${DOMAIN} <<EOF
\$TTL    14400
@       IN      SOA     ${NS1}.${DOMAIN}. admin.${DOMAIN}. (
                        $(date +%Y%m%d%H)  ; Serial
                        14400       ; Refresh
                        3600        ; Retry
                        604800      ; Expire
                        86400       ; Minimum TTL
                        )

; Nameservers
@       IN      NS      ${NS1}.${DOMAIN}.
@       IN      NS      ${NS2}.${DOMAIN}.

; A Records
@       IN      A       ${VPS_IP}
${NS1}  IN      A       ${VPS_IP}
${NS2}  IN      A       ${VPS_IP}
www     IN      A       ${VPS_IP}

; MX Records
@       IN      MX      5   mx1.hostinger.com.
@       IN      MX      10  mx2.hostinger.com.

; TXT Records
@       IN      TXT     "v=spf1 include:_spf.mail.hostinger.com ~all"

; DKIM Records
hostingermail-a._domainkey    IN      CNAME   hostingermail-a.dkim.mail.hostinger.com.
hostingermail-b._domainkey    IN      CNAME   hostingermail-b.dkim.mail.hostinger.com.
hostingermail-c._domainkey    IN      CNAME   hostingermail-c.dkim.mail.hostinger.com.

; DMARC
_dmarc  IN      TXT     "v=DMARC1; p=none"
EOF

echo ""
echo -e "${YELLOW}🔍 Validando configuração...${NC}"

# Validar configuração
if named-checkconf; then
    echo -e "${GREEN}   ✅ named.conf válido${NC}"
else
    echo -e "${RED}   ❌ Erro em named.conf${NC}"
    exit 1
fi

if named-checkzone ${DOMAIN} /etc/bind/db.${DOMAIN}; then
    echo -e "${GREEN}   ✅ Zone ${DOMAIN} válida${NC}"
else
    echo -e "${RED}   ❌ Erro na zone ${DOMAIN}${NC}"
    exit 1
fi

echo ""
echo -e "${YELLOW}🔥 Reiniciando BIND9...${NC}"
systemctl restart bind9
systemctl enable bind9

# Verificar status
if systemctl is-active --quiet bind9; then
    echo -e "${GREEN}   ✅ BIND9 está rodando${NC}"
else
    echo -e "${RED}   ❌ BIND9 não está rodando${NC}"
    systemctl status bind9
    exit 1
fi

echo ""
echo -e "${YELLOW}🔥 Configurando firewall...${NC}"
ufw allow 53/tcp
ufw allow 53/udp

echo ""
echo -e "${YELLOW}🧪 Testando DNS local...${NC}"

# Testar resolução local
if dig @127.0.0.1 ${DOMAIN} +short | grep -q "${VPS_IP}"; then
    echo -e "${GREEN}   ✅ DNS local funcionando${NC}"
else
    echo -e "${YELLOW}   ⚠️  DNS local pode precisar de alguns segundos${NC}"
fi

# Testar nameservers
if dig @127.0.0.1 ${NS1}.${DOMAIN} +short | grep -q "${VPS_IP}"; then
    echo -e "${GREEN}   ✅ ${NS1}.${DOMAIN} resolvendo corretamente${NC}"
else
    echo -e "${YELLOW}   ⚠️  ${NS1}.${DOMAIN} pode precisar de alguns segundos${NC}"
fi

echo ""
echo -e "${GREEN}✅ Configuração concluída!${NC}"
echo ""
echo -e "${CYAN}📋 PRÓXIMOS PASSOS:${NC}"
echo ""
echo "1. Criar child nameservers no painel Hostinger:"
echo "   - ${NS1}.${DOMAIN} → ${VPS_IP}"
echo "   - ${NS2}.${DOMAIN} → ${VPS_IP}"
echo ""
echo "2. Atualizar nameservers no Registro.br:"
echo "   - Remover: ns1.dns-parking.com, ns2.dns-parking.com"
echo "   - Adicionar: ${NS1}.${DOMAIN}, ${NS2}.${DOMAIN}"
echo ""
echo "3. Verificar propagação (pode levar até 48h):"
echo "   dig ${DOMAIN} NS +short"
echo "   dig ${NS1}.${DOMAIN} +short"
echo ""
echo -e "${CYAN}📝 Arquivos criados:${NC}"
echo "   - /etc/bind/db.${DOMAIN}"
echo "   - /etc/bind/named.conf.local (atualizado)"
echo "   - /etc/bind/named.conf.options (atualizado)"
echo ""

