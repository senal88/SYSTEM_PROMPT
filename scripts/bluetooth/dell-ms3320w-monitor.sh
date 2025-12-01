#!/bin/bash
# Script de Monitoramento Contínuo do Mouse Bluetooth Dell MS3320W
# Objetivo: Monitorar conexão e detectar desconexões em tempo real
# Autor: Sistema de Automação Dotfiles
# Data: $(date +%Y-%m-%d)

set -euo pipefail

# Configurações
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
LOG_DIR="${HOME}/.local/logs/bluetooth"
LOG_FILE="${LOG_DIR}/dell-ms3320w-monitor-$(date +%Y%m%d_%H%M%S).log"
STATUS_FILE="${LOG_DIR}/dell-ms3320w-status.json"
MOUSE_NAME="MS3320W"
MOUSE_NAME_ALT="Dell.*Mouse"
CHECK_INTERVAL=5  # Verificar a cada 5 segundos
MAX_RETRIES=3
RETRY_DELAY=2

# Criar diretório de logs
mkdir -p "${LOG_DIR}"

# Função de logging
log() {
    local level="$1"
    shift
    local message="$*"
    local timestamp=$(date '+%Y-%m-%d %H:%M:%S')
    echo "[${timestamp}] [${level}] ${message}" | tee -a "${LOG_FILE}"
}

# Função para verificar se o mouse está conectado
check_mouse_connected() {
    local connected=false

    # Método 1: Verificar via system_profiler
    if system_profiler SPBluetoothDataType 2>/dev/null | grep -qi "${MOUSE_NAME}\|${MOUSE_NAME_ALT}"; then
        if system_profiler SPBluetoothDataType 2>/dev/null | grep -A 20 -i "${MOUSE_NAME}\|${MOUSE_NAME_ALT}" | grep -qi "connected\|yes"; then
            connected=true
        fi
    fi

    # Método 2: Verificar via IORegistry (mais confiável)
    if ioreg -p IOUSB -l -w 0 2>/dev/null | grep -qi "dell.*mouse\|ms3320"; then
        connected=true
    fi

    # Método 3: Verificar via bluetoothconnector (se disponível)
    if command -v bluetoothconnector &> /dev/null; then
        if bluetoothconnector -l 2>/dev/null | grep -qi "${MOUSE_NAME}"; then
            connected=true
        fi
    fi

    echo "$connected"
}

# Função para obter informações detalhadas do mouse
get_mouse_info() {
    local info=""

    # Tentar obter informações via system_profiler
    info=$(system_profiler SPBluetoothDataType 2>/dev/null | \
        grep -A 30 -i "${MOUSE_NAME}\|${MOUSE_NAME_ALT}" | \
        head -20)

    if [ -z "$info" ]; then
        info="Informações não disponíveis"
    fi

    echo "$info"
}

# Função para atualizar arquivo de status JSON
update_status_file() {
    local status="$1"
    local timestamp=$(date -u +"%Y-%m-%dT%H:%M:%SZ")
    local info=$(get_mouse_info | head -5 | tr '\n' ' ')

    cat > "${STATUS_FILE}" <<EOF
{
  "device": "Dell MS3320W",
  "status": "${status}",
  "timestamp": "${timestamp}",
  "last_check": "$(date '+%Y-%m-%d %H:%M:%S')",
  "info": "${info}",
  "check_count": ${CHECK_COUNT:-0},
  "disconnect_count": ${DISCONNECT_COUNT:-0},
  "reconnect_count": ${RECONNECT_COUNT:-0}
}
EOF
}

# Função para registrar evento de desconexão
log_disconnect() {
    local reason="${1:-Desconhecido}"
    log "ERROR" "DESCONEXÃO DETECTADA - Razão: ${reason}"
    log "INFO" "Informações do dispositivo no momento da desconexão:"
    get_mouse_info | while IFS= read -r line; do
        log "INFO" "  ${line}"
    done

    # Coletar logs do sistema
    log "INFO" "Coletando logs do sistema relacionados..."
    log show --predicate 'subsystem == "com.apple.bluetooth"' --last 5m --info 2>/dev/null | \
        grep -i "dell\|ms3320\|mouse\|disconnect\|error" | \
        tail -20 | while IFS= read -r line; do
            log "DEBUG" "  ${line}"
        done || log "WARN" "Não foi possível coletar logs do sistema"
}

# Função para registrar evento de reconexão
log_reconnect() {
    log "SUCCESS" "RECONEXÃO BEM-SUCEDIDA"
    log "INFO" "Informações do dispositivo após reconexão:"
    get_mouse_info | while IFS= read -r line; do
        log "INFO" "  ${line}"
    done
}

# Variáveis de controle
CHECK_COUNT=0
DISCONNECT_COUNT=0
RECONNECT_COUNT=0
LAST_STATUS="unknown"
CONSECUTIVE_FAILURES=0

log "INFO" "=== INÍCIO DO MONITORAMENTO DELL MS3320W ==="
log "INFO" "Intervalo de verificação: ${CHECK_INTERVAL} segundos"
log "INFO" "Arquivo de status: ${STATUS_FILE}"
log "INFO" "Pressione Ctrl+C para parar o monitoramento"

# Loop principal de monitoramento
trap 'log "INFO" "Monitoramento interrompido pelo usuário"; exit 0' INT TERM

while true; do
    CHECK_COUNT=$((CHECK_COUNT + 1))
    CURRENT_STATUS=$(check_mouse_connected)

    if [ "$CURRENT_STATUS" = "true" ]; then
        if [ "$LAST_STATUS" != "connected" ]; then
            if [ "$LAST_STATUS" = "disconnected" ]; then
                log_reconnect
                RECONNECT_COUNT=$((RECONNECT_COUNT + 1))
            else
                log "INFO" "Mouse conectado (primeira verificação)"
            fi
            LAST_STATUS="connected"
            CONSECUTIVE_FAILURES=0
        fi
        update_status_file "connected"
    else
        if [ "$LAST_STATUS" != "disconnected" ]; then
            log_disconnect "Verificação falhou"
            DISCONNECT_COUNT=$((DISCONNECT_COUNT + 1))
            LAST_STATUS="disconnected"
        fi
        CONSECUTIVE_FAILURES=$((CONSECUTIVE_FAILURES + 1))
        update_status_file "disconnected"

        # Se houver múltiplas falhas consecutivas, tentar reconectar
        if [ $CONSECUTIVE_FAILURES -ge 3 ]; then
            log "WARN" "Múltiplas falhas consecutivas detectadas (${CONSECUTIVE_FAILURES})"
            log "INFO" "Chamando script de reconexão..."
            if [ -f "${SCRIPT_DIR}/dell-ms3320w-reconnect.sh" ]; then
                "${SCRIPT_DIR}/dell-ms3320w-reconnect.sh" >> "${LOG_FILE}" 2>&1 || \
                    log "ERROR" "Falha ao executar script de reconexão"
            else
                log "WARN" "Script de reconexão não encontrado: ${SCRIPT_DIR}/dell-ms3320w-reconnect.sh"
            fi
            CONSECUTIVE_FAILURES=0
        fi
    fi

    # Log periódico a cada 60 verificações (5 minutos)
    if [ $((CHECK_COUNT % 60)) -eq 0 ]; then
        log "INFO" "Status: ${LAST_STATUS} | Verificações: ${CHECK_COUNT} | Desconexões: ${DISCONNECT_COUNT} | Reconexões: ${RECONNECT_COUNT}"
    fi

    sleep "${CHECK_INTERVAL}"
done

