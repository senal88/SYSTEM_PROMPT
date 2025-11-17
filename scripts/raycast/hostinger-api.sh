#!/bin/bash
#################################################################################
# Raycast Script - Hostinger API Commands
# Versão: 1.0.0
# Objetivo: Comandos Raycast CLI para gerenciar VPS via Hostinger API
#################################################################################

set -euo pipefail

# Cores
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
RED='\033[0;31m'
NC='\033[0m'

# Configuração
DOTFILES_DIR="${HOME}/Dotfiles"
API_BASE_URL="https://developers.hostinger.com/api"

# Carregar API Token
load_api_token() {
    # Tentar 1Password primeiro
    if command -v op &> /dev/null && op whoami &>/dev/null 2>&1; then
        export HOSTINGER_API_TOKEN=$(op read "op://1p_macos/API-VPS-HOSTINGER/credential" 2>/dev/null || \
                                      op read "op://Personal/API-VPS-HOSTINGER/credential" 2>/dev/null || \
                                      echo "")
    fi

    # Fallback para arquivo local
    if [ -z "${HOSTINGER_API_TOKEN:-}" ] && [ -f "${DOTFILES_DIR}/credentials/api-keys/hostinger-api-key.txt" ]; then
        export HOSTINGER_API_TOKEN=$(cat "${DOTFILES_DIR}/credentials/api-keys/hostinger-api-key.txt")
    fi

    if [ -z "${HOSTINGER_API_TOKEN:-}" ]; then
        echo "❌ HOSTINGER_API_TOKEN não configurado"
        exit 1
    fi
}

# Função para fazer requisições à API
api_request() {
    local method="$1"
    local endpoint="$2"
    local data="${3:-}"

    local curl_cmd="curl -s -X ${method} \"${API_BASE_URL}${endpoint}\" \
        -H \"Authorization: Bearer ${HOSTINGER_API_TOKEN}\" \
        -H \"Content-Type: application/json\""

    if [ -n "$data" ]; then
        curl_cmd="${curl_cmd} -d '${data}'"
    fi

    eval "$curl_cmd" | jq '.' 2>/dev/null || eval "$curl_cmd"
}

# Listar VMs
list_vms() {
    load_api_token
    echo "📋 Listando Virtual Machines..."
    api_request "GET" "/vps/v1/virtual-machines"
}

# Obter detalhes de uma VM
get_vm_details() {
    local vm_id="$1"
    load_api_token
    echo "🔍 Detalhes da VM ${vm_id}..."
    api_request "GET" "/vps/v1/virtual-machines/${vm_id}"
}

# Listar ações de uma VM
get_vm_actions() {
    local vm_id="$1"
    load_api_token
    echo "📜 Ações da VM ${vm_id}..."
    api_request "GET" "/vps/v1/virtual-machines/${vm_id}/actions"
}

# Iniciar VM
start_vm() {
    local vm_id="$1"
    load_api_token
    echo "▶️  Iniciando VM ${vm_id}..."
    api_request "POST" "/vps/v1/virtual-machines/${vm_id}/start"
}

# Parar VM
stop_vm() {
    local vm_id="$1"
    load_api_token
    echo "⏹️  Parando VM ${vm_id}..."
    api_request "POST" "/vps/v1/virtual-machines/${vm_id}/stop"
}

# Reiniciar VM
restart_vm() {
    local vm_id="$1"
    load_api_token
    echo "🔄 Reiniciando VM ${vm_id}..."
    api_request "POST" "/vps/v1/virtual-machines/${vm_id}/restart"
}

# Listar backups
list_backups() {
    local vm_id="$1"
    load_api_token
    echo "💾 Backups da VM ${vm_id}..."
    api_request "GET" "/vps/v1/virtual-machines/${vm_id}/backups"
}

# Listar snapshots
list_snapshots() {
    local vm_id="$1"
    load_api_token
    echo "📸 Snapshots da VM ${vm_id}..."
    api_request "GET" "/vps/v1/virtual-machines/${vm_id}/snapshot"
}

# Obter métricas
get_metrics() {
    local vm_id="$1"
    local date_from="${2:-$(date -u -d '7 days ago' +%Y-%m-%d)}"
    local date_to="${3:-$(date -u +%Y-%m-%d)}"
    load_api_token
    echo "📊 Métricas da VM ${vm_id} (${date_from} a ${date_to})..."
    api_request "GET" "/vps/v1/virtual-machines/${vm_id}/metrics?date_from=${date_from}&date_to=${date_to}"
}

# Listar firewalls
list_firewalls() {
    load_api_token
    echo "🔥 Listando Firewalls..."
    api_request "GET" "/vps/v1/firewall"
}

# Listar chaves públicas SSH
list_ssh_keys() {
    load_api_token
    echo "🔑 Listando Chaves SSH..."
    api_request "GET" "/vps/v1/public-keys"
}

# Testar conexão API
test_api() {
    load_api_token
    echo "🧪 Testando conexão com Hostinger API..."
    api_request "GET" "/vps/v1/virtual-machines"
    echo ""
    echo "✅ Conexão bem-sucedida!"
}

# Menu principal
main() {
    local command="${1:-test}"

    case "$command" in
        "list"|"vms")
            list_vms
            ;;
        "details")
            if [ -z "${2:-}" ]; then
                echo "❌ Uso: $0 details <vm_id>"
                exit 1
            fi
            get_vm_details "$2"
            ;;
        "actions")
            if [ -z "${2:-}" ]; then
                echo "❌ Uso: $0 actions <vm_id>"
                exit 1
            fi
            get_vm_actions "$2"
            ;;
        "start")
            if [ -z "${2:-}" ]; then
                echo "❌ Uso: $0 start <vm_id>"
                exit 1
            fi
            start_vm "$2"
            ;;
        "stop")
            if [ -z "${2:-}" ]; then
                echo "❌ Uso: $0 stop <vm_id>"
                exit 1
            fi
            stop_vm "$2"
            ;;
        "restart")
            if [ -z "${2:-}" ]; then
                echo "❌ Uso: $0 restart <vm_id>"
                exit 1
            fi
            restart_vm "$2"
            ;;
        "backups")
            if [ -z "${2:-}" ]; then
                echo "❌ Uso: $0 backups <vm_id>"
                exit 1
            fi
            list_backups "$2"
            ;;
        "snapshots")
            if [ -z "${2:-}" ]; then
                echo "❌ Uso: $0 snapshots <vm_id>"
                exit 1
            fi
            list_snapshots "$2"
            ;;
        "metrics")
            if [ -z "${2:-}" ]; then
                echo "❌ Uso: $0 metrics <vm_id> [date_from] [date_to]"
                exit 1
            fi
            get_metrics "$2" "${3:-}" "${4:-}"
            ;;
        "firewalls")
            list_firewalls
            ;;
        "ssh-keys")
            list_ssh_keys
            ;;
        "test")
            test_api
            ;;
        *)
            echo "📚 Comandos disponíveis:"
            echo "  list, vms              - Listar todas as VMs"
            echo "  details <vm_id>        - Detalhes de uma VM"
            echo "  actions <vm_id>        - Ações de uma VM"
            echo "  start <vm_id>          - Iniciar VM"
            echo "  stop <vm_id>           - Parar VM"
            echo "  restart <vm_id>       - Reiniciar VM"
            echo "  backups <vm_id>        - Listar backups"
            echo "  snapshots <vm_id>      - Listar snapshots"
            echo "  metrics <vm_id>        - Obter métricas"
            echo "  firewalls              - Listar firewalls"
            echo "  ssh-keys               - Listar chaves SSH"
            echo "  test                   - Testar conexão API"
            ;;
    esac
}

main "$@"
