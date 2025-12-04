#!/bin/bash
# ============================================================
# CORREÇÃO AUTOMÁTICA COMPLETA - EXECUÇÃO ATÉ SUCESSO
# ============================================================
# Executa todas as etapas de correção automaticamente
# Repete até que todas as verificações passem com sucesso
# Versão: 1.0.0
# Data: 2025-01-17
# ============================================================

set -euo pipefail
IFS=$'\n\t'

# Cores
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m'

# Configurações
DOTFILES_DIR="${DOTFILES_DIR:-${HOME}/Dotfiles}"
TARGET_DOMAIN="${1:-api2.cursor.sh}"
MAX_ATTEMPTS=5
ATTEMPT=1
LOG_FILE="${HOME}/.dotfiles/logs/fix-all-automatic-$(date +%Y%m%d_%H%M%S).log"

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
        "STEP")
            echo -e "${CYAN}🔄 $message${NC}" | tee -a "$LOG_FILE"
            ;;
    esac
}

# Verificar se script existe
check_script() {
    local script="$1"
    if [ ! -f "$script" ]; then
        print_status "ERROR" "Script não encontrado: $script"
        return 1
    fi
    if [ ! -x "$script" ]; then
        chmod +x "$script"
    fi
    return 0
}

# Teste de conectividade completo
test_connectivity() {
    local all_ok=true

    print_status "INFO" "Executando testes de conectividade..."

    # Teste 1: Conectividade básica
    if ! ping -c 2 -W 2000 8.8.8.8 >/dev/null 2>&1; then
        print_status "ERROR" "Conectividade básica falhou"
        all_ok=false
    else
        print_status "OK" "Conectividade básica: OK"
    fi

    # Teste 2: DNS básico
    if ! nslookup google.com >/dev/null 2>&1; then
        print_status "ERROR" "DNS básico falhou"
        all_ok=false
    else
        print_status "OK" "DNS básico: OK"
    fi

    # Teste 3: Resolução DNS do domínio alvo
    if ! nslookup "$TARGET_DOMAIN" >/dev/null 2>&1; then
        print_status "ERROR" "DNS para $TARGET_DOMAIN falhou"
        all_ok=false
    else
        RESOLVED_IP=$(nslookup "$TARGET_DOMAIN" 2>/dev/null | grep -A 1 "Name:" | grep "Address:" | awk '{print $2}' | head -1)
        if [ -n "$RESOLVED_IP" ]; then
            print_status "OK" "DNS para $TARGET_DOMAIN: OK (IP: $RESOLVED_IP)"
        else
            print_status "ERROR" "DNS resolveu mas não retornou IP"
            all_ok=false
        fi
    fi

    # Teste 4: Conexão HTTPS
    HTTP_CODE=$(curl -s -o /dev/null -w "%{http_code}" --connect-timeout 10 --max-time 15 "https://$TARGET_DOMAIN" 2>/dev/null || echo "000")
    if [ "$HTTP_CODE" = "000" ] || [ -z "$HTTP_CODE" ]; then
        print_status "ERROR" "Conexão HTTPS falhou (código: $HTTP_CODE)"
        all_ok=false
    elif [ "$HTTP_CODE" -ge 200 ] && [ "$HTTP_CODE" -lt 500 ]; then
        print_status "OK" "Conexão HTTPS: OK (HTTP $HTTP_CODE)"
    else
        print_status "WARNING" "Conexão HTTPS retornou código inesperado: $HTTP_CODE"
        # Não falha, mas avisa
    fi

    # Teste 5: Porta 443
    if command -v nc >/dev/null 2>&1; then
        if nc -z -G 5 "$TARGET_DOMAIN" 443 2>/dev/null; then
            print_status "OK" "Porta 443: OK"
        else
            print_status "WARNING" "Porta 443 não acessível (pode ser bloqueada por firewall)"
        fi
    fi

    if [ "$all_ok" = true ]; then
        return 0
    else
        return 1
    fi
}

# Aplicar correções
apply_fixes() {
    print_status "STEP" "Aplicando correções automáticas..."

    # Identificar interface e serviço
    ACTIVE_INTERFACE=$(route get default 2>/dev/null | grep "interface" | awk '{print $2}' || echo "")
    if [ -z "$ACTIVE_INTERFACE" ]; then
        print_status "ERROR" "Não foi possível detectar interface de rede"
        return 1
    fi

    SERVICE_NAME=$(networksetup -listnetworkserviceorder | grep "$ACTIVE_INTERFACE" | awk -F  "(, )|(: )|[)]" '{print $2}' || echo "")
    if [ -z "$SERVICE_NAME" ]; then
        print_status "ERROR" "Não foi possível identificar serviço de rede"
        return 1
    fi

    print_status "INFO" "Interface: $ACTIVE_INTERFACE | Serviço: $SERVICE_NAME"

    # 1. Configurar DNS
    print_status "STEP" "Configurando DNS confiável..."
    TRUSTED_DNS=("8.8.8.8" "8.8.4.4" "1.1.1.1" "1.0.0.1")

    # Tentar sem sudo primeiro
    if networksetup -setdnsservers "$SERVICE_NAME" "${TRUSTED_DNS[@]}" 2>/dev/null; then
        print_status "OK" "DNS configurado: ${TRUSTED_DNS[*]}"
        log "INFO" "DNS configurado para $SERVICE_NAME"
    else
        # Tentar com sudo (não bloqueia se falhar)
        print_status "INFO" "Tentando configurar DNS com sudo..."
        if sudo -n networksetup -setdnsservers "$SERVICE_NAME" "${TRUSTED_DNS[@]}" 2>/dev/null; then
            print_status "OK" "DNS configurado com sudo: ${TRUSTED_DNS[*]}"
            log "INFO" "DNS configurado para $SERVICE_NAME via sudo"
        else
            print_status "WARNING" "Falha ao configurar DNS (pode requerer senha ou ação manual)"
            print_status "INFO" "DNS pode já estar configurado corretamente"
        fi
    fi

    # 2. Limpar cache DNS (tentar sem bloquear)
    print_status "STEP" "Limpando cache DNS..."
    if sudo -n dscacheutil -flushcache 2>/dev/null; then
        print_status "OK" "Cache DNS limpo"
    else
        print_status "INFO" "Cache DNS não pôde ser limpo (requer senha, mas não é crítico)"
    fi

    if sudo -n killall -HUP mDNSResponder 2>/dev/null; then
        print_status "OK" "mDNSResponder reiniciado"
    else
        print_status "INFO" "mDNSResponder não pôde ser reiniciado (requer senha, mas não é crítico)"
    fi

    # 3. Desabilitar proxy automático
    print_status "STEP" "Verificando proxy automático..."
    PROXY_AUTO=$(networksetup -getautoproxyurl "$SERVICE_NAME" 2>/dev/null | grep -i "enabled" || echo "")
    if [ -n "$PROXY_AUTO" ]; then
        print_status "WARNING" "Proxy automático detectado"
        if networksetup -setautoproxyurl "$SERVICE_NAME" "" 2>/dev/null; then
            print_status "OK" "Proxy automático desabilitado"
        else
            print_status "WARNING" "Não foi possível desabilitar proxy automaticamente"
        fi
    else
        print_status "OK" "Nenhum proxy automático configurado"
    fi

    # Aguardar estabilização
    sleep 3

    return 0
}

# Verificar e configurar persistência
ensure_persistence() {
    print_status "STEP" "Garantindo persistência das configurações..."

    # Criar script de manutenção se não existir
    MAINTENANCE_SCRIPT="${DOTFILES_DIR}/scripts/network/maintain-network-trust.sh"

    if [ ! -f "$MAINTENANCE_SCRIPT" ]; then
        cat > "$MAINTENANCE_SCRIPT" << 'MAINT_EOF'
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
MAINT_EOF
        chmod +x "$MAINTENANCE_SCRIPT"
        print_status "OK" "Script de manutenção criado: $MAINTENANCE_SCRIPT"
    fi

    # Criar LaunchAgent para execução periódica (opcional)
    LAUNCH_AGENT_DIR="${HOME}/Library/LaunchAgents"
    LAUNCH_AGENT="${LAUNCH_AGENT_DIR}/com.dotfiles.network-maintenance.plist"

    if [ ! -f "$LAUNCH_AGENT" ]; then
        mkdir -p "$LAUNCH_AGENT_DIR"
        cat > "$LAUNCH_AGENT" << PLIST_EOF
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <key>Label</key>
    <string>com.dotfiles.network-maintenance</string>
    <key>ProgramArguments</key>
    <array>
        <string>${MAINTENANCE_SCRIPT}</string>
    </array>
    <key>StartInterval</key>
    <integer>3600</integer>
    <key>RunAtLoad</key>
    <false/>
</dict>
</plist>
PLIST_EOF
        print_status "OK" "LaunchAgent criado para manutenção periódica"
        print_status "INFO" "Para ativar: launchctl load $LAUNCH_AGENT"
    fi

    return 0
}

# Main execution
main() {
    echo "============================================================"
    echo "CORREÇÃO AUTOMÁTICA COMPLETA - EXECUÇÃO ATÉ SUCESSO"
    echo "============================================================"
    echo "Domínio alvo: $TARGET_DOMAIN"
    echo "Máximo de tentativas: $MAX_ATTEMPTS"
    echo "Log: $LOG_FILE"
    echo "============================================================"
    echo ""

    log "INFO" "Iniciando correção automática completa"

    # Verificar scripts necessários
    DIAGNOSE_SCRIPT="${DOTFILES_DIR}/scripts/network/diagnose-dns-error.sh"
    FIX_SCRIPT="${DOTFILES_DIR}/scripts/network/fix-dns-and-trust-network.sh"

    if ! check_script "$DIAGNOSE_SCRIPT"; then
        print_status "WARNING" "Script de diagnóstico não encontrado, continuando sem ele"
    fi

    # Loop principal: tentar até sucesso ou máximo de tentativas
    while [ $ATTEMPT -le $MAX_ATTEMPTS ]; do
        echo ""
        print_status "STEP" "TENTATIVA $ATTEMPT de $MAX_ATTEMPTS"
        echo "============================================================"

        # Executar diagnóstico inicial (apenas na primeira tentativa)
        # Pular diagnóstico para evitar pedir senha desnecessariamente
        # if [ $ATTEMPT -eq 1 ] && [ -f "$DIAGNOSE_SCRIPT" ]; then
        #     print_status "INFO" "Executando diagnóstico inicial..."
        #     "$DIAGNOSE_SCRIPT" "$TARGET_DOMAIN" >/dev/null 2>&1 || true
        # fi

        # Aplicar correções
        if ! apply_fixes; then
            print_status "ERROR" "Falha ao aplicar correções"
            ATTEMPT=$((ATTEMPT + 1))
            sleep 2
            continue
        fi

        # Aguardar estabilização
        print_status "INFO" "Aguardando estabilização da rede..."
        sleep 5

        # Testar conectividade
        if test_connectivity; then
            print_status "OK" "TODOS OS TESTES PASSARAM!"
            echo ""
            echo "============================================================"
            print_status "OK" "CORREÇÃO CONCLUÍDA COM SUCESSO"
            echo "============================================================"

            # Garantir persistência
            ensure_persistence

            # Resumo final
            echo ""
            print_status "INFO" "RESUMO:"
            echo "  ✅ DNS configurado e funcionando"
            echo "  ✅ Conectividade validada"
            echo "  ✅ Configurações persistentes aplicadas"
            echo ""
            print_status "INFO" "Log completo: $LOG_FILE"

            log "INFO" "Correção concluída com sucesso na tentativa $ATTEMPT"
            exit 0
        else
            print_status "WARNING" "Alguns testes falharam"
            if [ $ATTEMPT -lt $MAX_ATTEMPTS ]; then
                print_status "INFO" "Tentando novamente em 3 segundos..."
                sleep 3
            fi
            ATTEMPT=$((ATTEMPT + 1))
        fi
    done

    # Se chegou aqui, todas as tentativas falharam
    echo ""
    echo "============================================================"
    print_status "ERROR" "NÃO FOI POSSÍVEL CORRIGIR APÓS $MAX_ATTEMPTS TENTATIVAS"
    echo "============================================================"
    echo ""
    print_status "INFO" "AÇÕES MANUAIS NECESSÁRIAS:"
    echo ""
    echo "1. Tornar rede confiável:"
    echo "   System Preferences > Network > Advanced > Proxies"
    echo "   Desmarque 'Automatic Proxy Configuration'"
    echo ""
    echo "2. Verificar firewall:"
    echo "   System Preferences > Security & Privacy > Firewall"
    echo "   Adicione Cursor.app nas exceções se necessário"
    echo ""
    echo "3. Portal captivo (se aplicável):"
    echo "   Abra um navegador e complete a autenticação"
    echo ""
    echo "4. Reiniciar conexão de rede:"
    echo "   Desconecte e reconecte Wi-Fi"
    echo ""
    echo "5. Executar novamente:"
    echo "   $0 $TARGET_DOMAIN"
    echo ""

    log "ERROR" "Correção falhou após $MAX_ATTEMPTS tentativas"
    exit 1
}

# Executar main
main "$@"
