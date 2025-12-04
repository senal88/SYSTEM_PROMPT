#!/bin/bash
# ============================================================
# MONITORAMENTO CONTÍNUO DE REDE
# ============================================================
# Monitora conectividade e corrige automaticamente problemas
# Versão: 1.0.0
# Data: 2025-01-17
# ============================================================

set -euo pipefail
IFS=$'\n\t'

# Configurações
DOTFILES_DIR="${DOTFILES_DIR:-${HOME}/Dotfiles}"
TARGET_DOMAIN="${1:-api2.cursor.sh}"
CHECK_INTERVAL="${2:-300}"  # 5 minutos por padrão
LOG_FILE="${HOME}/.dotfiles/logs/network-monitor-$(date +%Y%m%d).log"
FIX_SCRIPT="${DOTFILES_DIR}/scripts/network/fix-all-automatic.sh"

# Cores
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
NC='\033[0m'

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

# Teste rápido de conectividade
quick_test() {
    # Teste DNS
    if ! nslookup "$TARGET_DOMAIN" >/dev/null 2>&1; then
        return 1
    fi

    # Teste HTTPS
    HTTP_CODE=$(curl -s -o /dev/null -w "%{http_code}" --connect-timeout 5 --max-time 10 "https://$TARGET_DOMAIN" 2>/dev/null || echo "000")
    if [ "$HTTP_CODE" = "000" ] || [ -z "$HTTP_CODE" ]; then
        return 1
    fi

    return 0
}

# Main loop
main() {
    echo "============================================================"
    echo "MONITORAMENTO CONTÍNUO DE REDE"
    echo "============================================================"
    echo "Domínio alvo: $TARGET_DOMAIN"
    echo "Intervalo de verificação: ${CHECK_INTERVAL}s"
    echo "Log: $LOG_FILE"
    echo "============================================================"
    echo ""
    echo "Pressione Ctrl+C para parar"
    echo ""

    log "INFO" "Iniciando monitoramento contínuo"

    local check_count=0
    local failure_count=0

    while true; do
        check_count=$((check_count + 1))
        local timestamp=$(date '+%Y-%m-%d %H:%M:%S')

        echo -n "[$timestamp] Verificação #$check_count... "

        if quick_test; then
            echo -e "${GREEN}✅ OK${NC}"
            log "INFO" "Verificação #$check_count: OK"
            failure_count=0
        else
            failure_count=$((failure_count + 1))
            echo -e "${RED}❌ FALHOU${NC}"
            log "WARNING" "Verificação #$check_count: FALHOU (falhas consecutivas: $failure_count)"

            # Se falhou 2 vezes consecutivas, tentar corrigir
            if [ $failure_count -ge 2 ]; then
                echo -e "${YELLOW}⚠️  Problema detectado! Aplicando correção automática...${NC}"
                log "WARNING" "Aplicando correção automática após $failure_count falhas"

                if [ -f "$FIX_SCRIPT" ] && [ -x "$FIX_SCRIPT" ]; then
                    if "$FIX_SCRIPT" "$TARGET_DOMAIN" >> "$LOG_FILE" 2>&1; then
                        echo -e "${GREEN}✅ Correção aplicada com sucesso${NC}"
                        log "INFO" "Correção aplicada com sucesso"
                        failure_count=0
                    else
                        echo -e "${RED}❌ Falha ao aplicar correção${NC}"
                        log "ERROR" "Falha ao aplicar correção automática"
                    fi
                else
                    echo -e "${RED}❌ Script de correção não encontrado${NC}"
                    log "ERROR" "Script de correção não encontrado: $FIX_SCRIPT"
                fi
            fi
        fi

        # Aguardar próximo check
        sleep "$CHECK_INTERVAL"
    done
}

# Trap para cleanup
trap 'echo ""; log "INFO" "Monitoramento interrompido pelo usuário"; exit 0' INT TERM

# Executar
main "$@"
