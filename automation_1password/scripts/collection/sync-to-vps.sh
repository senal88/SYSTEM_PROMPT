#!/bin/bash
# sync-to-vps.sh
# Sincroniza dados coletados do macOS para a VPS Ubuntu
# Last Updated: 2025-11-01
# Version: 1.0.0

set -euo pipefail

# ============================================================================
# SOURCING LIB
# ============================================================================
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "${SCRIPT_DIR}/../.." && pwd)"
source "${SCRIPT_DIR}/../lib/logging.sh"

# ============================================================================
# CONFIGURAÇÕES
# ============================================================================
DATA_DIR="${REPO_ROOT}/dados"
PROD_DIR="${REPO_ROOT}/prod"
VPS_HOST="vps"  # Usando alias SSH
VPS_USER="${VPS_USER:-luiz.sena88}"
VPS_PATH="/home/${VPS_USER}/automation_1password"

# ============================================================================
# FUNÇÕES
# ============================================================================

check_ssh_connection() {
    log_section "🔌 Verificando Conexão SSH"
    
    if ssh -o ConnectTimeout=5 -o BatchMode=yes "${VPS_HOST}" "echo 'OK'" &>/dev/null; then
        log_success "Conexão SSH com ${VPS_HOST} funcional"
        return 0
    else
        log_error "Não foi possível conectar em ${VPS_HOST}"
        log_info "Verifique se o alias SSH 'vps' está configurado em ~/.ssh/config"
        return 1
    fi
}

sync_data_to_vps() {
    log_section "📤 Sincronizando Dados para VPS"
    
    # Criar diretório na VPS se não existir
    ssh "${VPS_HOST}" "mkdir -p ${VPS_PATH}/{dados,prod}" || {
        log_error "Falha ao criar diretórios na VPS"
        return 1
    }
    
    # Sincronizar dados (sem secrets!)
    log_info "Sincronizando dados/..."
    rsync -avz --progress \
        --exclude="*.env" \
        --exclude="*.secret" \
        --exclude="*.key" \
        "${DATA_DIR}/" \
        "${VPS_HOST}:${VPS_PATH}/dados/" || {
        log_error "Falha ao sincronizar dados"
        return 1
    }
    
    # Sincronizar prod/
    log_info "Sincronizando prod/..."
    rsync -avz --progress \
        "${PROD_DIR}/" \
        "${VPS_HOST}:${VPS_PATH}/prod/" || {
        log_error "Falha ao sincronizar prod"
        return 1
    }
    
    log_success "Dados sincronizados para ${VPS_HOST}:${VPS_PATH}/"
}

verify_sync() {
    log_section "✅ Verificando Sincronização"
    
    # Contar arquivos localmente
    local local_count=$(find "${DATA_DIR}" -type f 2>/dev/null | wc -l | tr -d ' ')
    
    # Contar arquivos na VPS
    local remote_count=$(ssh "${VPS_HOST}" "find ${VPS_PATH}/dados -type f 2>/dev/null | wc -l" | tr -d ' ')
    
    if [ "${local_count}" -eq "${remote_count}" ]; then
        log_success "${remote_count} arquivo(s) sincronizado(s)"
    else
        log_warning "Diferença detectada: Local=${local_count}, VPS=${remote_count}"
    fi
    
    # Listar arquivos sincronizados
    log_info "Arquivos na VPS:"
    ssh "${VPS_HOST}" "ls -lh ${VPS_PATH}/dados/" 2>/dev/null | tail -10 || true
    
    return 0
}

# ============================================================================
# MAIN
# ============================================================================

main() {
    log_section "🔄 Sincronização macOS → VPS"
    
    if [ ! -d "${DATA_DIR}" ]; then
        log_error "Diretório ${DATA_DIR} não encontrado"
        log_info "Execute primeiro: ./scripts/collection/collect-hybrid-environment.sh"
        return 1
    fi
    
    check_ssh_connection || return 1
    echo ""
    
    sync_data_to_vps || return 1
    echo ""
    
    verify_sync
    echo ""
    
    log_section "✅ Sincronização Completa"
    log_success "Dados disponíveis na VPS: ${VPS_PATH}/"
    echo ""
    echo "Para acessar na VPS:"
    echo "  ssh ${VPS_HOST}"
    echo "  cd ${VPS_PATH}"
    echo "  ls -la dados/ prod/"
    
    return 0
}

main "$@"

