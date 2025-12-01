#!/bin/bash
# Script Master de Setup e Instalação do Sistema de Monitoramento Dell MS3320W
# Objetivo: Instalar dependências e configurar sistema completo de monitoramento
# Autor: Sistema de Automação Dotfiles
# Data: $(date +%Y-%m-%d)

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
LOG_DIR="${HOME}/.local/logs/bluetooth"

# Cores para output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Função de logging
log() {
    local level="$1"
    shift
    local message="$*"
    local timestamp=$(date '+%Y-%m-%d %H:%M:%S')
    case "$level" in
        ERROR)
            echo -e "${RED}[${timestamp}] [${level}] ${message}${NC}"
            ;;
        SUCCESS)
            echo -e "${GREEN}[${timestamp}] [${level}] ${message}${NC}"
            ;;
        WARN)
            echo -e "${YELLOW}[${timestamp}] [${level}] ${message}${NC}"
            ;;
        *)
            echo "[${timestamp}] [${level}] ${message}"
            ;;
    esac
}

# Criar diretórios necessários
mkdir -p "${LOG_DIR}"
mkdir -p "${LOG_DIR}/reports"

log "INFO" "=== SETUP DO SISTEMA DE MONITORAMENTO DELL MS3320W ==="
log "INFO" ""

# 1. Verificar e instalar dependências
log "INFO" "--- 1. VERIFICANDO DEPENDÊNCIAS ---"

# Verificar Homebrew
if ! command -v brew &> /dev/null; then
    log "ERROR" "Homebrew não está instalado. Instale primeiro: https://brew.sh"
    exit 1
fi
log "SUCCESS" "Homebrew encontrado"

# Instalar blueutil
if ! command -v blueutil &> /dev/null; then
    log "INFO" "Instalando blueutil..."
    brew install blueutil
    log "SUCCESS" "blueutil instalado"
else
    log "SUCCESS" "blueutil já está instalado"
fi

# Instalar bluetoothconnector
if ! command -v bluetoothconnector &> /dev/null; then
    log "INFO" "Instalando bluetoothconnector..."
    brew install bluetoothconnector
    log "SUCCESS" "bluetoothconnector instalado"
else
    log "SUCCESS" "bluetoothconnector já está instalado"
fi

# Verificar bc (geralmente já vem com macOS)
if ! command -v bc &> /dev/null; then
    log "WARN" "bc não encontrado, mas geralmente vem com macOS"
fi

log "INFO" ""

# 2. Tornar scripts executáveis
log "INFO" "--- 2. CONFIGURANDO SCRIPTS ---"
chmod +x "${SCRIPT_DIR}"/*.sh
log "SUCCESS" "Scripts configurados com permissões de execução"

log "INFO" ""

# 3. Executar diagnóstico inicial
log "INFO" "--- 3. EXECUTANDO DIAGNÓSTICO INICIAL ---"
log "INFO" "Isso pode levar alguns minutos..."
"${SCRIPT_DIR}/dell-ms3320w-diagnostico.sh"
log "SUCCESS" "Diagnóstico inicial concluído"

log "INFO" ""

# 4. Perguntar se deseja instalar LaunchAgent
log "INFO" "--- 4. CONFIGURAÇÃO DE MONITORAMENTO AUTOMÁTICO ---"
echo ""
read -p "Deseja instalar o monitoramento automático em background? (s/N): " -n 1 -r
echo ""
if [[ $REPLY =~ ^[Ss]$ ]]; then
    log "INFO" "Instalando LaunchAgent..."
    "${SCRIPT_DIR}/dell-ms3320w-launchagent.sh"
    log "SUCCESS" "Monitoramento automático configurado"
else
    log "INFO" "Monitoramento automático não instalado. Você pode instalá-lo depois com:"
    log "INFO" "  ${SCRIPT_DIR}/dell-ms3320w-launchagent.sh"
fi

log "INFO" ""

# 5. Resumo final
log "SUCCESS" "=== SETUP CONCLUÍDO COM SUCESSO ==="
echo ""
echo "═══════════════════════════════════════════════════════════════"
echo "  SISTEMA DE MONITORAMENTO CONFIGURADO"
echo "═══════════════════════════════════════════════════════════════"
echo ""
echo "Scripts disponíveis:"
echo "  📊 Diagnóstico:     ${SCRIPT_DIR}/dell-ms3320w-diagnostico.sh"
echo "  👁️  Monitoramento:   ${SCRIPT_DIR}/dell-ms3320w-monitor.sh"
echo "  🔄 Reconexão:       ${SCRIPT_DIR}/dell-ms3320w-reconnect.sh"
echo "  📈 Análise:         ${SCRIPT_DIR}/dell-ms3320w-analise.sh"
echo "  🤖 LaunchAgent:     ${SCRIPT_DIR}/dell-ms3320w-launchagent.sh"
echo ""
echo "Logs:"
echo "  📁 ${LOG_DIR}"
echo ""
echo "Próximos passos:"
echo "  1. Execute o diagnóstico para coletar informações iniciais:"
echo "     ${SCRIPT_DIR}/dell-ms3320w-diagnostico.sh"
echo ""
echo "  2. Inicie o monitoramento manual (ou aguarde o LaunchAgent):"
echo "     ${SCRIPT_DIR}/dell-ms3320w-monitor.sh"
echo ""
echo "  3. Após algumas horas, execute a análise:"
echo "     ${SCRIPT_DIR}/dell-ms3320w-analise.sh"
echo ""
echo "═══════════════════════════════════════════════════════════════"

