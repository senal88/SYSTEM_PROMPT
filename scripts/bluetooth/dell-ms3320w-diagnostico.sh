#!/bin/bash
# Script de Diagnóstico do Mouse Bluetooth Dell MS3320W
# Objetivo: Coletar informações completas sobre o dispositivo e estado da conexão
# Autor: Sistema de Automação Dotfiles
# Data: $(date +%Y-%m-%d)

set -euo pipefail

# Configurações
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
LOG_DIR="${HOME}/.local/logs/bluetooth"
LOG_FILE="${LOG_DIR}/dell-ms3320w-diagnostico-$(date +%Y%m%d_%H%M%S).log"
MOUSE_NAME="MS3320W"
MOUSE_NAME_ALT="Dell.*Mouse"

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

log "INFO" "=== INÍCIO DO DIAGNÓSTICO DELL MS3320W ==="
log "INFO" "Script: ${BASH_SOURCE[0]}"
log "INFO" "Usuário: $(whoami)"
log "INFO" "Sistema: $(sw_vers -productName) $(sw_vers -productVersion)"
log "INFO" "Arquitetura: $(uname -m)"

# 1. Informações do Sistema Bluetooth
log "INFO" "--- 1. INFORMAÇÕES DO SISTEMA BLUETOOTH ---"
system_profiler SPBluetoothDataType 2>/dev/null | tee -a "${LOG_FILE}"

# 2. Listar todos os dispositivos Bluetooth pareados
log "INFO" "--- 2. DISPOSITIVOS BLUETOOTH PARREADOS ---"
defaults read /Library/Preferences/com.apple.Bluetooth.plist 2>/dev/null | \
    grep -i "devicecache\|name\|address" -A 2 | tee -a "${LOG_FILE}" || \
    log "WARN" "Não foi possível ler preferências do Bluetooth"

# 3. Buscar especificamente pelo mouse Dell MS3320W
log "INFO" "--- 3. BUSCA ESPECÍFICA PELO MOUSE DELL MS3320W ---"
system_profiler SPBluetoothDataType 2>/dev/null | \
    grep -i "dell\|ms3320\|mouse" -A 10 -B 5 | tee -a "${LOG_FILE}" || \
    log "WARN" "Mouse não encontrado na lista de dispositivos"

# 4. Verificar dispositivos HID conectados
log "INFO" "--- 4. DISPOSITIVOS HID CONECTADOS ---"
ioreg -p IOUSB -l -w 0 | grep -i "mouse\|dell\|ms3320" -A 5 -B 5 | tee -a "${LOG_FILE}" || \
    log "WARN" "Nenhum dispositivo HID Dell encontrado via IORegistry"

# 5. Logs do sistema relacionados ao Bluetooth (últimas 2 horas)
log "INFO" "--- 5. LOGS DO SISTEMA BLUETOOTH (ÚLTIMAS 2H) ---"
log show --predicate 'subsystem == "com.apple.bluetooth"' --last 2h --info 2>/dev/null | \
    grep -i "dell\|ms3320\|mouse\|disconnect\|connect\|error\|fail" -i | \
    tail -100 | tee -a "${LOG_FILE}" || \
    log "WARN" "Nenhum log relevante encontrado"

# 6. Verificar processos relacionados ao Bluetooth
log "INFO" "--- 6. PROCESSOS BLUETOOTH ATIVOS ---"
ps aux | grep -i "bluetooth\|blued\|bluetoothd" | grep -v grep | tee -a "${LOG_FILE}" || \
    log "WARN" "Nenhum processo Bluetooth encontrado"

# 7. Verificar estado do serviço Bluetooth
log "INFO" "--- 7. ESTADO DO SERVIÇO BLUETOOTH ---"
blueutil -p 2>/dev/null && log "INFO" "Bluetooth está ligado" || log "WARN" "Bluetooth pode estar desligado ou blueutil não instalado"

# 8. Tentar descobrir dispositivos Bluetooth próximos
log "INFO" "--- 8. DESCOBERTA DE DISPOSITIVOS PRÓXIMOS ---"
if command -v bluetoothconnector &> /dev/null; then
    bluetoothconnector -l 2>&1 | tee -a "${LOG_FILE}"
else
    log "WARN" "bluetoothconnector não instalado. Instale com: brew install bluetoothconnector"
fi

# 9. Verificar preferências de energia que podem afetar Bluetooth
log "INFO" "--- 9. CONFIGURAÇÕES DE ENERGIA ---"
pmset -g custom 2>/dev/null | tee -a "${LOG_FILE}" || \
    log "WARN" "Não foi possível ler configurações de energia"

# 10. Verificar interferências potenciais (WiFi, outros dispositivos)
log "INFO" "--- 10. INTERFERÊNCIAS POTENCIAIS ---"
networksetup -listallhardwareports 2>/dev/null | tee -a "${LOG_FILE}" || \
    log "WARN" "Não foi possível listar interfaces de rede"

# 11. Estatísticas de conexão Bluetooth
log "INFO" "--- 11. ESTATÍSTICAS DE CONEXÃO ---"
if command -v blueutil &> /dev/null; then
    blueutil --info 2>&1 | tee -a "${LOG_FILE}"
else
    log "WARN" "blueutil não instalado. Instale com: brew install blueutil"
fi

# 12. Verificar permissões e acessibilidade
log "INFO" "--- 12. PERMISSÕES E ACESSIBILIDADE ---"
log "INFO" "Verificando se assistente de acessibilidade tem permissões..."
# Nota: Permissões de acessibilidade precisam ser verificadas manualmente em Preferências do Sistema

log "INFO" "=== FIM DO DIAGNÓSTICO ==="
log "INFO" "Log completo salvo em: ${LOG_FILE}"

# Resumo
echo ""
echo "═══════════════════════════════════════════════════════════════"
echo "  DIAGNÓSTICO CONCLUÍDO"
echo "═══════════════════════════════════════════════════════════════"
echo "Log completo: ${LOG_FILE}"
echo ""
echo "Próximos passos:"
echo "1. Revisar o log completo para identificar padrões"
echo "2. Executar script de monitoramento: dell-ms3320w-monitor.sh"
echo "3. Configurar automação de reconexão: dell-ms3320w-reconnect.sh"
echo "═══════════════════════════════════════════════════════════════"

