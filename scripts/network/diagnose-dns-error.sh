#!/bin/bash
# ============================================================
# DIAGNÓSTICO DE ERRO DNS - getaddrinfo ENOTFOUND
# ============================================================
# Script para diagnosticar erros de resolução DNS
# Especialmente para api2.cursor.sh e outros serviços
# Versão: 1.0.0
# Data: 2025-01-17
# ============================================================

set -euo pipefail
IFS=$'\n\t'

# Cores para output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Configurações
TARGET_DOMAIN="${1:-api2.cursor.sh}"
LOG_FILE="${HOME}/.dotfiles/logs/dns-diagnostic-$(date +%Y%m%d_%H%M%S).log"
DOTFILES_DIR="${DOTFILES_DIR:-${HOME}/Dotfiles}"

# Criar diretório de logs se não existir
mkdir -p "$(dirname "$LOG_FILE")"

# Função de logging
log() {
    local level="$1"
    shift
    local message="$*"
    local timestamp=$(date '+%Y-%m-%d %H:%M:%S')
    echo "[$timestamp] [$level] $message" | tee -a "$LOG_FILE"
}

# Função de output colorido
print_status() {
    local status="$1"
    local message="$2"
    case "$status" in
        "OK")
            echo -e "${GREEN}✅ $message${NC}" | tee -a "$LOG_FILE"
            ;;
        "ERROR")
            echo -e "${RED}❌ $message${NC}" | tee -a "$LOG_FILE"
            ;;
        "WARNING")
            echo -e "${YELLOW}⚠️  $message${NC}" | tee -a "$LOG_FILE"
            ;;
        "INFO")
            echo -e "${BLUE}ℹ️  $message${NC}" | tee -a "$LOG_FILE"
            ;;
    esac
}

# Cabeçalho
echo "============================================================"
echo "DIAGNÓSTICO DE ERRO DNS - getaddrinfo ENOTFOUND"
echo "============================================================"
echo "Domínio alvo: $TARGET_DOMAIN"
echo "Log: $LOG_FILE"
echo "============================================================"
echo ""

log "INFO" "Iniciando diagnóstico para $TARGET_DOMAIN"

# ============================================================
# 1. VERIFICAÇÃO DE CONECTIVIDADE BÁSICA
# ============================================================
print_status "INFO" "1. Verificando conectividade básica..."

# Teste de conectividade geral
if ping -c 2 -W 2000 8.8.8.8 >/dev/null 2>&1; then
    print_status "OK" "Conectividade de rede básica: OK"
else
    print_status "ERROR" "Sem conectividade de rede básica"
    exit 1
fi

# Teste de DNS público
if nslookup google.com >/dev/null 2>&1; then
    print_status "OK" "Resolução DNS básica: OK"
else
    print_status "ERROR" "Falha na resolução DNS básica"
fi

# ============================================================
# 2. VERIFICAÇÃO DE SERVIDORES DNS
# ============================================================
print_status "INFO" "2. Verificando servidores DNS configurados..."

# Obter interface de rede ativa
ACTIVE_INTERFACE=$(route get default 2>/dev/null | grep "interface" | awk '{print $2}' || echo "")
if [ -z "$ACTIVE_INTERFACE" ]; then
    print_status "WARNING" "Não foi possível detectar interface de rede ativa"
else
    print_status "INFO" "Interface ativa: $ACTIVE_INTERFACE"

    # Obter nome do serviço de rede
    SERVICE_NAME=$(networksetup -listnetworkserviceorder | grep "$ACTIVE_INTERFACE" | awk -F  "(, )|(: )|[)]" '{print $2}' || echo "")

    if [ -n "$SERVICE_NAME" ]; then
        print_status "INFO" "Serviço de rede: $SERVICE_NAME"

        # Obter servidores DNS
        DNS_SERVERS=$(networksetup -getdnsservers "$SERVICE_NAME" 2>/dev/null || echo "")
        if [ -n "$DNS_SERVERS" ] && [ "$DNS_SERVERS" != "There aren't any DNS Servers set on $SERVICE_NAME." ]; then
            print_status "OK" "Servidores DNS configurados:"
            echo "$DNS_SERVERS" | while read -r dns; do
                echo "  - $dns"
            done
        else
            print_status "WARNING" "Nenhum servidor DNS específico configurado (usando padrão do sistema)"
        fi
    fi
fi

# Verificar configuração DNS do sistema
print_status "INFO" "Configuração DNS do sistema (scutil):"
scutil --dns | grep -A 3 "resolver #1" | head -5 | while read -r line; do
    echo "  $line"
done

# ============================================================
# 3. TESTE DE RESOLUÇÃO DNS PARA DOMÍNIO ALVO
# ============================================================
print_status "INFO" "3. Testando resolução DNS para $TARGET_DOMAIN..."

# Teste com nslookup
if nslookup "$TARGET_DOMAIN" >/dev/null 2>&1; then
    RESOLVED_IP=$(nslookup "$TARGET_DOMAIN" 2>/dev/null | grep -A 1 "Name:" | grep "Address:" | awk '{print $2}' | head -1)
    if [ -n "$RESOLVED_IP" ]; then
        print_status "OK" "DNS resolveu $TARGET_DOMAIN para: $RESOLVED_IP"
    else
        print_status "WARNING" "DNS resolveu mas não foi possível obter IP"
    fi
else
    print_status "ERROR" "Falha na resolução DNS para $TARGET_DOMAIN"
fi

# Teste com dig
if command -v dig >/dev/null 2>&1; then
    DIG_RESULT=$(dig +short "$TARGET_DOMAIN" 2>/dev/null || echo "")
    if [ -n "$DIG_RESULT" ]; then
        print_status "OK" "dig resolveu $TARGET_DOMAIN: $DIG_RESULT"
    else
        print_status "ERROR" "dig falhou para $TARGET_DOMAIN"
    fi
fi

# Teste com host
if command -v host >/dev/null 2>&1; then
    HOST_RESULT=$(host "$TARGET_DOMAIN" 2>/dev/null || echo "")
    if [ -n "$HOST_RESULT" ]; then
        print_status "OK" "host resolveu $TARGET_DOMAIN"
        echo "  $HOST_RESULT"
    else
        print_status "ERROR" "host falhou para $TARGET_DOMAIN"
    fi
fi

# ============================================================
# 4. TESTE DE CONECTIVIDADE TCP/HTTPS
# ============================================================
print_status "INFO" "4. Testando conectividade TCP/HTTPS para $TARGET_DOMAIN..."

# Teste de ping
if ping -c 2 -W 2000 "$TARGET_DOMAIN" >/dev/null 2>&1; then
    print_status "OK" "Ping para $TARGET_DOMAIN: OK"
else
    print_status "WARNING" "Ping para $TARGET_DOMAIN falhou (pode ser bloqueado por firewall)"
fi

# Teste de conexão HTTPS
if curl -s -o /dev/null -w "%{http_code}" --connect-timeout 5 --max-time 10 "https://$TARGET_DOMAIN" >/dev/null 2>&1; then
    HTTP_CODE=$(curl -s -o /dev/null -w "%{http_code}" --connect-timeout 5 --max-time 10 "https://$TARGET_DOMAIN" 2>/dev/null || echo "000")
    if [ "$HTTP_CODE" != "000" ]; then
        print_status "OK" "Conexão HTTPS para $TARGET_DOMAIN: OK (HTTP $HTTP_CODE)"
    else
        print_status "ERROR" "Conexão HTTPS para $TARGET_DOMAIN: FALHOU"
    fi
else
    print_status "ERROR" "Conexão HTTPS para $TARGET_DOMAIN: FALHOU"
fi

# ============================================================
# 5. VERIFICAÇÃO DE REDE CONFIÁVEL (macOS)
# ============================================================
print_status "INFO" "5. Verificando status de rede confiável (macOS)..."

# Verificar se a rede atual é confiável
CURRENT_NETWORK=$(networksetup -getairportnetwork en0 2>/dev/null | awk -F': ' '{print $2}' || echo "")
if [ -n "$CURRENT_NETWORK" ]; then
    print_status "INFO" "Rede Wi-Fi atual: $CURRENT_NETWORK"

    # Verificar se está em lista de redes confiáveis
    # macOS não expõe isso diretamente, mas podemos verificar via System Preferences
    print_status "INFO" "Verifique manualmente em: System Preferences > Network > Advanced > Proxies"
    print_status "INFO" "Certifique-se de que 'Automatic Proxy Configuration' não está bloqueando conexões"
fi

# ============================================================
# 6. VERIFICAÇÃO DE FIREWALL E PROXY
# ============================================================
print_status "INFO" "6. Verificando configurações de firewall e proxy..."

# Verificar firewall
FIREWALL_STATUS=$(/usr/libexec/ApplicationFirewall/socketfilterfw --getglobalstate 2>/dev/null | grep -i "enabled" || echo "disabled")
if echo "$FIREWALL_STATUS" | grep -qi "enabled"; then
    print_status "WARNING" "Firewall do macOS está ATIVO"
    print_status "INFO" "Verifique se Cursor.app está na lista de exceções"
else
    print_status "OK" "Firewall do macOS está desativado ou não configurado"
fi

# Verificar proxy
if [ -n "$SERVICE_NAME" ]; then
    PROXY_AUTO=$(networksetup -getautoproxyurl "$SERVICE_NAME" 2>/dev/null | grep -i "enabled" || echo "")
    if [ -n "$PROXY_AUTO" ]; then
        print_status "WARNING" "Proxy automático está configurado para $SERVICE_NAME"
        networksetup -getautoproxyurl "$SERVICE_NAME" 2>/dev/null | head -3
    else
        print_status "OK" "Nenhum proxy automático configurado"
    fi
fi

# ============================================================
# 7. VERIFICAÇÃO DE CACHE DNS
# ============================================================
print_status "INFO" "7. Verificando cache DNS..."

# macOS usa mDNSResponder para cache DNS
if sudo dscacheutil -q host -a name "$TARGET_DOMAIN" 2>/dev/null | grep -q "name:"; then
    print_status "OK" "Domínio encontrado no cache DNS"
    sudo dscacheutil -q host -a name "$TARGET_DOMAIN" 2>/dev/null | head -5
else
    print_status "INFO" "Domínio não encontrado no cache DNS (normal se nunca foi resolvido)"
fi

# ============================================================
# 8. DIAGNÓSTICO ESPECÍFICO PARA CURSOR
# ============================================================
print_status "INFO" "8. Diagnóstico específico para Cursor.app..."

# Verificar se Cursor está instalado
if [ -d "/Applications/Cursor.app" ]; then
    print_status "OK" "Cursor.app encontrado"

    # Verificar permissões de rede
    print_status "INFO" "Verificando permissões de rede do Cursor..."
    if tccutil reset All com.todesktop.230313mzl4w4u92 >/dev/null 2>&1; then
        print_status "WARNING" "Permissões de rede podem precisar ser reconfiguradas"
        print_status "INFO" "Vá para: System Preferences > Security & Privacy > Privacy > Full Disk Access"
    fi
else
    print_status "WARNING" "Cursor.app não encontrado em /Applications/"
fi

# ============================================================
# 9. RESUMO E RECOMENDAÇÕES
# ============================================================
echo ""
echo "============================================================"
print_status "INFO" "RESUMO DO DIAGNÓSTICO"
echo "============================================================"

# Coletar resultados
DNS_RESOLVES=false
HTTPS_WORKS=false

if nslookup "$TARGET_DOMAIN" >/dev/null 2>&1; then
    DNS_RESOLVES=true
fi

if curl -s -o /dev/null -w "%{http_code}" --connect-timeout 5 --max-time 10 "https://$TARGET_DOMAIN" >/dev/null 2>&1; then
    HTTPS_WORKS=true
fi

# Gerar recomendações
echo ""
print_status "INFO" "RECOMENDAÇÕES:"

if [ "$DNS_RESOLVES" = false ]; then
    print_status "ERROR" "1. DNS não está resolvendo $TARGET_DOMAIN"
    echo "   Solução: Execute o script de correção automática"
    echo "   Comando: ${DOTFILES_DIR}/scripts/network/fix-dns-and-trust-network.sh"
fi

if [ "$HTTPS_WORKS" = false ]; then
    print_status "ERROR" "2. Conexão HTTPS falhando"
    echo "   Possíveis causas:"
    echo "   - Rede não confiável (especialmente em redes públicas como Insper)"
    echo "   - Firewall bloqueando conexões"
    echo "   - Proxy configurado incorretamente"
    echo ""
    echo "   Soluções:"
    echo "   1. Tornar rede confiável: ${DOTFILES_DIR}/scripts/network/fix-dns-and-trust-network.sh"
    echo "   2. Verificar firewall: System Preferences > Security & Privacy > Firewall"
    echo "   3. Verificar proxy: System Preferences > Network > Advanced > Proxies"
fi

if [ "$DNS_RESOLVES" = true ] && [ "$HTTPS_WORKS" = true ]; then
    print_status "OK" "Tudo parece estar funcionando corretamente!"
    print_status "INFO" "Se o erro persistir, pode ser um problema temporário do serviço"
fi

echo ""
echo "============================================================"
print_status "INFO" "Log completo salvo em: $LOG_FILE"
echo "============================================================"

log "INFO" "Diagnóstico concluído"

exit 0
