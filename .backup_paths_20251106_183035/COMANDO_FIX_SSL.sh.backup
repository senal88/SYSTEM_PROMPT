#!/bin/bash
# COMANDO_FIX_SSL.sh
# Script para diagnosticar e corrigir problemas de SSL
# Execute na VPS

set -euo pipefail

# Cores
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

log_info() {
    echo -e "${BLUE}ℹ️  $*${NC}" >&2
}

log_success() {
    echo -e "${GREEN}✅ $*${NC}" >&2
}

log_warning() {
    echo -e "${YELLOW}⚠️  $*${NC}" >&2
}

log_error() {
    echo -e "${RED}❌ $*${NC}" >&2
}

echo ""
log_info "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
log_info "DIAGNÓSTICO SSL - n8n.senamfo.com.br"
log_info "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""

# 1. Verificar certificado via curl
log_info "1. Verificando certificado SSL..."
cert_info=$(curl -vI --insecure https://n8n.senamfo.com.br 2>&1 | grep -iE "certificate|subject|issuer" | head -5 || echo "")
if [ -n "${cert_info}" ]; then
    echo "${cert_info}"
else
    log_warning "Não foi possível obter informações do certificado"
fi

echo ""

# 2. Verificar logs do Traefik
log_info "2. Verificando logs do Traefik (certificados)..."
acme_logs=$(docker logs traefik --tail=200 2>&1 | grep -iE "acme|certificate|cloudflare.*challenge" | tail -10 || echo "")
if [ -n "${acme_logs}" ]; then
    echo "${acme_logs}"
else
    log_warning "Nenhum log de certificado encontrado"
fi

echo ""

# 3. Verificar volume de certificados
log_info "3. Verificando volume de certificados do Traefik..."
if docker exec traefik test -f /letsencrypt/acme.json 2>/dev/null; then
    file_size=$(docker exec traefik stat -c%s /letsencrypt/acme.json 2>/dev/null || echo "0")
    if [ "${file_size}" -gt 0 ]; then
        log_success "Arquivo acme.json existe (${file_size} bytes)"
    else
        log_warning "Arquivo acme.json vazio ou não legível"
    fi
else
    log_warning "Arquivo acme.json não encontrado"
fi

echo ""

# 4. Verificar DNS e Proxy Cloudflare
log_info "4. Verificando DNS..."
dns_ip=$(host n8n.senamfo.com.br 2>/dev/null | grep -oE '147\.79\.81\.59' || echo "")
if [ -n "${dns_ip}" ]; then
    log_success "DNS aponta para VPS (147.79.81.59)"
else
    log_warning "DNS pode não estar apontando corretamente"
    host n8n.senamfo.com.br 2>/dev/null || true
fi

echo ""

# 5. Verificar resposta HTTP/HTTPS
log_info "5. Testando URLs..."
http_code=$(curl -s -o /dev/null -w "%{http_code}" --max-time 10 http://n8n.senamfo.com.br 2>/dev/null || echo "000")
https_code=$(curl -s -o /dev/null -w "%{http_code}" --insecure --max-time 10 https://n8n.senamfo.com.br 2>/dev/null || echo "000")

if [ "${http_code}" != "000" ]; then
    log_success "HTTP responde: ${http_code}"
else
    log_error "HTTP não responde"
fi

if [ "${https_code}" != "000" ]; then
    log_success "HTTPS responde: ${https_code}"
else
    log_error "HTTPS não responde"
fi

echo ""
log_info "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""

# Recomendações
log_info "🔍 DIAGNÓSTICO COMPLETO"
echo ""
log_warning "RECOMENDAÇÕES:"
echo ""
echo "1. Verificar Proxy Cloudflare:"
echo "   - Dashboard → DNS → n8n.senamfo.com.br"
echo "   - Ícone de nuvem deve estar LARANJA (proxy ativado)"
echo ""
echo "2. Verificar SSL Mode no Cloudflare:"
echo "   - SSL/TLS → Overview"
echo "   - Modo: Flexible (recomendado) ou Full"
echo ""
echo "3. Se usando Full mode:"
echo "   - Verificar se Traefik gerou certificado"
echo "   - Verificar logs do Traefik para erros ACME"
echo ""
echo "4. Aguardar propagação:"
echo "   - 1-2 minutos após mudanças"
echo "   - Limpar cache do navegador"
echo ""

