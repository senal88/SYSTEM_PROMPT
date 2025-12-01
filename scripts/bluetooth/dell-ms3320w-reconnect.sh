#!/bin/bash
# Script de Reconexão Automática do Mouse Bluetooth Dell MS3320W
# Objetivo: Forçar reconexão quando o mouse desconectar
# Autor: Sistema de Automação Dotfiles
# Data: $(date +%Y-%m-%d)

set -euo pipefail

# Configurações
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
LOG_DIR="${HOME}/.local/logs/bluetooth"
LOG_FILE="${LOG_DIR}/dell-ms3320w-reconnect-$(date +%Y%m%d_%H%M%S).log"
MOUSE_NAME="MS3320W"
MOUSE_NAME_ALT="Dell.*Mouse"
MAX_RETRIES=5
RETRY_DELAY=3
BACKOFF_MULTIPLIER=1.5

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
is_mouse_connected() {
    # Verificar via IORegistry (mais confiável)
    if ioreg -p IOUSB -l -w 0 2>/dev/null | grep -qi "dell.*mouse\|ms3320"; then
        return 0
    fi

    # Verificar via system_profiler
    if system_profiler SPBluetoothDataType 2>/dev/null | \
        grep -A 20 -i "${MOUSE_NAME}\|${MOUSE_NAME_ALT}" | \
        grep -qi "connected\|yes"; then
        return 0
    fi

    return 1
}

# Função para encontrar o endereço MAC do mouse
find_mouse_mac() {
    local mac=""

    # Tentar encontrar via system_profiler
    mac=$(system_profiler SPBluetoothDataType 2>/dev/null | \
        grep -B 5 -A 15 -i "${MOUSE_NAME}\|${MOUSE_NAME_ALT}" | \
        grep -i "address" | \
        head -1 | \
        awk '{print $2}' | \
        tr -d ':' | \
        sed 's/\(..\)/\1:/g; s/:$//')

    # Se não encontrou, tentar via defaults
    if [ -z "$mac" ]; then
        mac=$(defaults read /Library/Preferences/com.apple.Bluetooth.plist 2>/dev/null | \
            grep -B 10 -i "${MOUSE_NAME}" | \
            grep -i "address\|bluetoothaddress" | \
            head -1 | \
            awk -F'"' '{print $2}' | \
            tr -d ':' | \
            sed 's/\(..\)/\1:/g; s/:$//')
    fi

    echo "$mac"
}

# Função para desligar e ligar o Bluetooth
toggle_bluetooth() {
    log "INFO" "Alternando estado do Bluetooth..."

    if command -v blueutil &> /dev/null; then
        blueutil -p 0
        sleep 2
        blueutil -p 1
        sleep 3
        log "INFO" "Bluetooth reiniciado via blueutil"
        return 0
    else
        log "WARN" "blueutil não instalado. Tentando método alternativo..."
        # Método alternativo via AppleScript
        osascript -e 'tell application "System Events" to tell process "System Settings" to keystroke "b" using {command down, shift down}' 2>/dev/null || \
        log "WARN" "Não foi possível alternar Bluetooth automaticamente"
        return 1
    fi
}

# Função para desconectar e reconectar o mouse
reconnect_mouse() {
    local mac="$1"
    local success=false

    log "INFO" "Tentando reconectar mouse (MAC: ${mac})..."

    # Método 1: Usar bluetoothconnector (se disponível)
    if command -v bluetoothconnector &> /dev/null; then
        log "INFO" "Usando bluetoothconnector para reconectar..."
        if bluetoothconnector --disconnect "${mac}" 2>/dev/null; then
            log "INFO" "Mouse desconectado com sucesso"
            sleep 2
        fi

        if bluetoothconnector --connect "${mac}" 2>/dev/null; then
            sleep 3
            if is_mouse_connected; then
                log "SUCCESS" "Mouse reconectado com sucesso via bluetoothconnector"
                success=true
            fi
        fi
    fi

    # Método 2: Usar blueutil (se disponível)
    if [ "$success" = false ] && command -v blueutil &> /dev/null; then
        log "INFO" "Tentando reconectar via blueutil..."
        # blueutil não tem comando direto de connect/disconnect, mas podemos tentar resetar
        toggle_bluetooth
        sleep 5
        if is_mouse_connected; then
            log "SUCCESS" "Mouse reconectado após reset do Bluetooth"
            success=true
        fi
    fi

    # Método 3: Usar AppleScript para abrir Preferências do Sistema
    if [ "$success" = false ]; then
        log "INFO" "Tentando reconectar via interface do sistema..."
        osascript <<EOF 2>/dev/null || true
tell application "System Settings"
    activate
    delay 1
    tell application "System Events"
        tell process "System Settings"
            click menu item "Bluetooth" of menu "View" of menu bar 1
            delay 2
            -- Tentar encontrar e clicar no mouse na lista
            try
                set mouseRow to first row of table 1 of scroll area 1 whose name contains "${MOUSE_NAME}"
                click mouseRow
                delay 1
                -- Tentar clicar em "Conectar" se disponível
                try
                    click button "Conectar" of mouseRow
                end try
            end try
        end tell
    end tell
end tell
EOF
        sleep 5
        if is_mouse_connected; then
            log "SUCCESS" "Mouse reconectado via interface do sistema"
            success=true
        fi
    fi

    echo "$success"
}

# Função principal de reconexão com retry
main_reconnect() {
    local attempt=1
    local current_delay=$RETRY_DELAY
    local mac=""

    log "INFO" "=== INÍCIO DA TENTATIVA DE RECONEXÃO ==="

    # Verificar se já está conectado
    if is_mouse_connected; then
        log "INFO" "Mouse já está conectado. Nenhuma ação necessária."
        return 0
    fi

    # Encontrar MAC address
    log "INFO" "Buscando endereço MAC do mouse..."
    mac=$(find_mouse_mac)

    if [ -z "$mac" ]; then
        log "WARN" "Não foi possível encontrar o endereço MAC do mouse"
        log "INFO" "Tentando métodos alternativos de reconexão..."
        mac="unknown"
    else
        log "INFO" "Endereço MAC encontrado: ${mac}"
    fi

    # Tentativas de reconexão
    while [ $attempt -le $MAX_RETRIES ]; do
        log "INFO" "Tentativa ${attempt}/${MAX_RETRIES} de reconexão..."

        if [ "$mac" != "unknown" ]; then
            if reconnect_mouse "$mac"; then
                log "SUCCESS" "Reconexão bem-sucedida na tentativa ${attempt}"
                return 0
            fi
        else
            # Se não temos MAC, tentar resetar Bluetooth
            if toggle_bluetooth; then
                sleep 5
                if is_mouse_connected; then
                    log "SUCCESS" "Mouse reconectado após reset do Bluetooth"
                    return 0
                fi
            fi
        fi

        if [ $attempt -lt $MAX_RETRIES ]; then
            log "WARN" "Tentativa ${attempt} falhou. Aguardando ${current_delay} segundos antes da próxima tentativa..."
            sleep "${current_delay}"
            current_delay=$(echo "$current_delay * $BACKOFF_MULTIPLIER" | bc | cut -d. -f1)
        fi

        attempt=$((attempt + 1))
    done

    log "ERROR" "Falha ao reconectar após ${MAX_RETRIES} tentativas"
    log "INFO" "Recomendações:"
    log "INFO" "  1. Verificar se o mouse está ligado"
    log "INFO" "  2. Verificar bateria do mouse"
    log "INFO" "  3. Verificar se o mouse está no modo de pareamento"
    log "INFO" "  4. Tentar reconectar manualmente via Preferências do Sistema"

    return 1
}

# Executar reconexão
main_reconnect
exit $?

