#!/bin/bash
# ============================================================
# CORREÇÃO AUTOMÁTICA - DNS E REDE CONFIÁVEL
# ============================================================
# Script para corrigir problemas de DNS e tornar redes confiáveis
# Especialmente útil para redes públicas (Insper, etc.)
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
DOTFILES_DIR="${DOTFILES_DIR:-${HOME}/Dotfiles}"
LOG_FILE="${HOME}/.dotfiles/logs/network-fix-$(date +%Y%m%d_%H%M%S).log"
TARGET_DOMAIN="${1:-api2.cursor.sh}"

# DNS Servers confiáveis (Google e Cloudflare)
TRUSTED_DNS_SERVERS=("8.8.8.8" "8.8.4.4" "1.1.1.1" "1.0.0.1")

# Criar diretório de logs
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

# Verificar se está rodando como root (necessário para algumas operações)
check_sudo() {
    if [ "$EUID" -ne 0 ]; then
        print_status "INFO" "Algumas operações requerem sudo"
        print_status "INFO" "Você será solicitado a inserir sua senha"
        sudo -v
    fi
}

# Cabeçalho
echo "============================================================"
echo "CORREÇÃO AUTOMÁTICA - DNS E REDE CONFIÁVEL"
echo "============================================================"
echo "Domínio alvo: $TARGET_DOMAIN"
echo "Log: $LOG_FILE"
echo "============================================================"
echo ""

log "INFO" "Iniciando correção automática"

# ============================================================
# 1. IDENTIFICAR INTERFACE E SERVIÇO DE REDE ATIVO
# ============================================================
print_status "INFO" "1. Identificando interface de rede ativa..."

ACTIVE_INTERFACE=$(route get default 2>/dev/null | grep "interface" | awk '{print $2}' || echo "")
if [ -z "$ACTIVE_INTERFACE" ]; then
    print_status "ERROR" "Não foi possível detectar interface de rede ativa"
    exit 1
fi

print_status "OK" "Interface ativa: $ACTIVE_INTERFACE"

# Obter nome do serviço de rede
SERVICE_NAME=$(networksetup -listnetworkserviceorder | grep "$ACTIVE_INTERFACE" | awk -F  "(, )|(: )|[)]" '{print $2}' || echo "")

if [ -z "$SERVICE_NAME" ]; then
    print_status "ERROR" "Não foi possível identificar serviço de rede"
    exit 1
fi

print_status "OK" "Serviço de rede: $SERVICE_NAME"

# ============================================================
# 2. CONFIGURAR DNS CONFIÁVEL
# ============================================================
print_status "INFO" "2. Configurando servidores DNS confiáveis..."

# Verificar DNS atual
CURRENT_DNS=$(networksetup -getdnsservers "$SERVICE_NAME" 2>/dev/null || echo "")

if [ -n "$CURRENT_DNS" ] && [ "$CURRENT_DNS" != "There aren't any DNS Servers set on $SERVICE_NAME." ]; then
    print_status "INFO" "DNS atual configurado:"
    echo "$CURRENT_DNS" | while read -r dns; do
        echo "  - $dns"
    done
fi

# Configurar DNS confiável
print_status "INFO" "Configurando DNS: ${TRUSTED_DNS_SERVERS[*]}"

if networksetup -setdnsservers "$SERVICE_NAME" "${TRUSTED_DNS_SERVERS[@]}" 2>/dev/null; then
    print_status "OK" "DNS configurado com sucesso"
    log "INFO" "DNS configurado: ${TRUSTED_DNS_SERVERS[*]}"
else
    print_status "WARNING" "Falha ao configurar DNS (pode requerer sudo)"
    print_status "INFO" "Tentando com sudo..."

    if sudo networksetup -setdnsservers "$SERVICE_NAME" "${TRUSTED_DNS_SERVERS[@]}" 2>/dev/null; then
        print_status "OK" "DNS configurado com sucesso (via sudo)"
        log "INFO" "DNS configurado via sudo: ${TRUSTED_DNS_SERVERS[*]}"
    else
        print_status "ERROR" "Falha ao configurar DNS mesmo com sudo"
        print_status "INFO" "Configure manualmente em: System Preferences > Network > Advanced > DNS"
    fi
fi

# Verificar DNS configurado
VERIFIED_DNS=$(networksetup -getdnsservers "$SERVICE_NAME" 2>/dev/null || echo "")
if [ -n "$VERIFIED_DNS" ] && [ "$VERIFIED_DNS" != "There aren't any DNS Servers set on $SERVICE_NAME." ]; then
    print_status "OK" "DNS verificado:"
    echo "$VERIFIED_DNS" | while read -r dns; do
        echo "  - $dns"
    done
fi

# ============================================================
# 3. LIMPAR CACHE DNS
# ============================================================
print_status "INFO" "3. Limpando cache DNS..."

# Limpar cache do mDNSResponder
if sudo dscacheutil -flushcache 2>/dev/null; then
    print_status "OK" "Cache DNS do sistema limpo"
    log "INFO" "Cache DNS limpo via dscacheutil"
else
    print_status "WARNING" "Falha ao limpar cache DNS (pode não ser crítico)"
fi

# Limpar cache do mDNSResponder (método alternativo)
if sudo killall -HUP mDNSResponder 2>/dev/null; then
    print_status "OK" "mDNSResponder reiniciado"
    log "INFO" "mDNSResponder reiniciado"
else
    print_status "WARNING" "Falha ao reiniciar mDNSResponder"
fi

# Aguardar um pouco para o DNS se estabilizar
sleep 2

# ============================================================
# 4. TORNAR REDE CONFIÁVEL (macOS)
# ============================================================
print_status "INFO" "4. Configurando rede como confiável..."

# Obter SSID atual (se Wi-Fi)
if [[ "$SERVICE_NAME" == *"Wi-Fi"* ]] || [[ "$SERVICE_NAME" == *"WiFi"* ]]; then
    CURRENT_SSID=$(networksetup -getairportnetwork en0 2>/dev/null | awk -F': ' '{print $2}' || echo "")

    if [ -n "$CURRENT_SSID" ]; then
        print_status "INFO" "Rede Wi-Fi atual: $CURRENT_SSID"

        # macOS não permite tornar redes confiáveis via linha de comando diretamente
        # Mas podemos configurar para não usar proxy automático e desabilitar restrições
        print_status "INFO" "Configurando rede para permitir conexões diretas..."

        # Desabilitar proxy automático se estiver configurado
        PROXY_AUTO=$(networksetup -getautoproxyurl "$SERVICE_NAME" 2>/dev/null | grep -i "enabled" || echo "")
        if [ -n "$PROXY_AUTO" ]; then
            print_status "WARNING" "Proxy automático detectado"
            print_status "INFO" "Desabilitando proxy automático..."

            if networksetup -setautoproxyurl "$SERVICE_NAME" "" 2>/dev/null; then
                print_status "OK" "Proxy automático desabilitado"
            else
                print_status "WARNING" "Não foi possível desabilitar proxy automático via linha de comando"
                print_status "INFO" "Desabilite manualmente em: System Preferences > Network > Advanced > Proxies"
            fi
        else
            print_status "OK" "Nenhum proxy automático configurado"
        fi

        # Instruções para tornar rede confiável manualmente
        print_status "INFO" "Para tornar a rede '$CURRENT_SSID' confiável:"
        print_status "INFO" "1. Vá para: System Preferences > Network"
        print_status "INFO" "2. Selecione Wi-Fi > Advanced"
        print_status "INFO" "3. Aba 'Proxies' > Desmarque 'Automatic Proxy Configuration'"
        print_status "INFO" "4. Aba 'Hardware' > Configure como 'Automatic'"
        print_status "INFO" "5. Clique em 'OK' e 'Apply'"
    fi
else
    print_status "INFO" "Interface não é Wi-Fi, pulando configuração de SSID"
fi

# ============================================================
# 5. CONFIGURAR FIREWALL PARA CURSOR
# ============================================================
print_status "INFO" "5. Verificando configurações de firewall..."

# Verificar se firewall está ativo
FIREWALL_STATUS=$(/usr/libexec/ApplicationFirewall/socketfilterfw --getglobalstate 2>/dev/null | grep -i "enabled" || echo "disabled")

if echo "$FIREWALL_STATUS" | grep -qi "enabled"; then
    print_status "WARNING" "Firewall do macOS está ATIVO"

    # Verificar se Cursor está na lista de exceções
    if [ -d "/Applications/Cursor.app" ]; then
        CURSOR_PATH="/Applications/Cursor.app/Contents/MacOS/Cursor"

        if [ -f "$CURSOR_PATH" ]; then
            IS_EXCEPTION=$(/usr/libexec/ApplicationFirewall/socketfilterfw --getappblocked "$CURSOR_PATH" 2>/dev/null || echo "")

            if [ -n "$IS_EXCEPTION" ]; then
                if echo "$IS_EXCEPTION" | grep -qi "ALLOWED"; then
                    print_status "OK" "Cursor.app já está na lista de exceções do firewall"
                else
                    print_status "WARNING" "Cursor.app pode estar bloqueado pelo firewall"
                    print_status "INFO" "Adicione manualmente em: System Preferences > Security & Privacy > Firewall > Firewall Options"
                fi
            fi
        fi
    fi
else
    print_status "OK" "Firewall do macOS está desativado"
fi

# ============================================================
# 6. TESTAR CONECTIVIDADE
# ============================================================
print_status "INFO" "6. Testando conectividade após correções..."

# Aguardar um pouco para DNS se estabilizar
sleep 3

# Teste de DNS
print_status "INFO" "Testando resolução DNS para $TARGET_DOMAIN..."
if nslookup "$TARGET_DOMAIN" >/dev/null 2>&1; then
    RESOLVED_IP=$(nslookup "$TARGET_DOMAIN" 2>/dev/null | grep -A 1 "Name:" | grep "Address:" | awk '{print $2}' | head -1)
    print_status "OK" "DNS resolveu $TARGET_DOMAIN para: $RESOLVED_IP"
    log "INFO" "DNS resolveu $TARGET_DOMAIN para $RESOLVED_IP"
else
    print_status "ERROR" "DNS ainda não está resolvendo $TARGET_DOMAIN"
    print_status "INFO" "Tente novamente em alguns segundos ou reinicie a conexão de rede"
fi

# Teste de HTTPS
print_status "INFO" "Testando conexão HTTPS para $TARGET_DOMAIN..."
HTTP_CODE=$(curl -s -o /dev/null -w "%{http_code}" --connect-timeout 10 --max-time 15 "https://$TARGET_DOMAIN" 2>/dev/null || echo "000")

if [ "$HTTP_CODE" != "000" ] && [ "$HTTP_CODE" != "" ]; then
    print_status "OK" "Conexão HTTPS funcionando (HTTP $HTTP_CODE)"
    log "INFO" "HTTPS funcionando: HTTP $HTTP_CODE"
else
    print_status "WARNING" "Conexão HTTPS ainda falhando"
    print_status "INFO" "Isso pode ser normal se:"
    print_status "INFO" "  - A rede ainda está se estabilizando"
    print_status "INFO" "  - O serviço está temporariamente indisponível"
    print_status "INFO" "  - A rede requer autenticação adicional (portal captivo)"
fi

# ============================================================
# 7. CRIAR SCRIPT DE MANUTENÇÃO CONTÍNUA
# ============================================================
print_status "INFO" "7. Criando script de manutenção contínua..."

MAINTENANCE_SCRIPT="${DOTFILES_DIR}/scripts/network/maintain-network-trust.sh"

cat > "$MAINTENANCE_SCRIPT" << 'EOF'
#!/bin/bash
# Script de manutenção de rede confiável
# Executa verificações periódicas e corrige problemas comuns

DOTFILES_DIR="${DOTFILES_DIR:-${HOME}/Dotfiles}"
ACTIVE_INTERFACE=$(route get default 2>/dev/null | grep "interface" | awk '{print $2}' || echo "")
SERVICE_NAME=$(networksetup -listnetworkserviceorder | grep "$ACTIVE_INTERFACE" | awk -F  "(, )|(: )|[)]" '{print $2}' || echo "")

if [ -n "$SERVICE_NAME" ]; then
    # Verificar e corrigir DNS se necessário
    CURRENT_DNS=$(networksetup -getdnsservers "$SERVICE_NAME" 2>/dev/null || echo "")
    if [ -z "$CURRENT_DNS" ] || [ "$CURRENT_DNS" == "There aren't any DNS Servers set on $SERVICE_NAME." ]; then
        networksetup -setdnsservers "$SERVICE_NAME" 8.8.8.8 8.8.4.4 1.1.1.1 1.0.0.1 2>/dev/null || true
    fi
fi
EOF

chmod +x "$MAINTENANCE_SCRIPT"
print_status "OK" "Script de manutenção criado: $MAINTENANCE_SCRIPT"

# ============================================================
# 8. RESUMO E PRÓXIMOS PASSOS
# ============================================================
echo ""
echo "============================================================"
print_status "INFO" "CORREÇÃO CONCLUÍDA"
echo "============================================================"
echo ""

print_status "INFO" "PRÓXIMOS PASSOS MANUAIS (se necessário):"

echo ""
print_status "INFO" "1. Tornar rede confiável (IMPORTANTE para redes públicas):"
echo "   - System Preferences > Network"
echo "   - Selecione sua conexão > Advanced"
echo "   - Aba 'Proxies' > Desmarque 'Automatic Proxy Configuration'"
echo "   - Clique em 'OK' e 'Apply'"

echo ""
print_status "INFO" "2. Verificar firewall:"
echo "   - System Preferences > Security & Privacy > Firewall"
echo "   - Se ativo, adicione Cursor.app nas exceções"

echo ""
print_status "INFO" "3. Se estiver em rede com portal captivo:"
echo "   - Abra um navegador e complete a autenticação"
echo "   - Depois execute este script novamente"

echo ""
print_status "INFO" "4. Reiniciar conexão de rede (se problemas persistirem):"
echo "   - Desconecte e reconecte Wi-Fi"
echo "   - Ou execute: networksetup -setairportpower en0 off && networksetup -setairportpower en0 on"

echo ""
echo "============================================================"
print_status "INFO" "Log completo salvo em: $LOG_FILE"
print_status "INFO" "Execute diagnóstico novamente: ${DOTFILES_DIR}/scripts/network/diagnose-dns-error.sh"
echo "============================================================"

log "INFO" "Correção automática concluída"

exit 0
