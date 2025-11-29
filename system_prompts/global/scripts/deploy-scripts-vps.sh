#!/usr/bin/env bash

################################################################################
# 🚀 DEPLOY SCRIPTS PARA VPS
# Deploy dos scripts de coleta e análise para a VPS Ubuntu
#
# STATUS: ATIVO (2025-11-28)
# PROPÓSITO: Deploy automatizado dos scripts VPS
# VERSÃO: 1.0.0
################################################################################

set -euo pipefail

# ============================================================================
# CONFIGURAÇÃO
# ============================================================================

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
DOTFILES_DIR="${DOTFILES_DIR:-${HOME}/Dotfiles}"
VPS_HOST="${VPS_HOST:-admin-vps}"
VPS_USER="${VPS_USER:-admin}"
VPS_DOTFILES="${VPS_DOTFILES:-/home/admin/Dotfiles}"

# Cores
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

# ============================================================================
# FUNÇÕES AUXILIARES
# ============================================================================

log_info() {
    echo -e "${BLUE}ℹ️${NC} $@"
}

log_success() {
    echo -e "${GREEN}✅${NC} $@"
}

log_warning() {
    echo -e "${YELLOW}⚠️${NC} $@"
}

log_error() {
    echo -e "${RED}❌${NC} $@"
}

print_header() {
    echo ""
    echo "╔════════════════════════════════════════════════════════════════════════════╗"
    echo "║ $1"
    echo "╚════════════════════════════════════════════════════════════════════════════╝"
    echo ""
}

# ============================================================================
# VALIDAÇÃO
# ============================================================================

validate_ssh_connection() {
    log_info "Testando conexão SSH com ${VPS_USER}@${VPS_HOST}..."
    if ssh -o ConnectTimeout=5 -o BatchMode=yes "${VPS_USER}@${VPS_HOST}" "echo 'OK'" >/dev/null 2>&1; then
        log_success "Conexão SSH estabelecida"
        return 0
    else
        log_error "Não foi possível conectar via SSH"
        log_info "Verifique:"
        log_info "  - Alias SSH configurado: ssh ${VPS_HOST}"
        log_info "  - Chaves SSH autorizadas"
        log_info "  - Host acessível"
        return 1
    fi
}

# ============================================================================
# DEPLOY
# ============================================================================

deploy_scripts() {
    print_header "🚀 DEPLOY SCRIPTS PARA VPS"

    local COleta_SCRIPT="${SCRIPT_DIR}/coleta-vps.sh"
    local ANALISE_SCRIPT="${SCRIPT_DIR}/analise-e-sintese-vps.sh"

    if [ ! -f "${COleta_SCRIPT}" ]; then
        log_error "Script não encontrado: ${COleta_SCRIPT}"
        return 1
    fi

    if [ ! -f "${ANALISE_SCRIPT}" ]; then
        log_error "Script não encontrado: ${ANALISE_SCRIPT}"
        return 1
    fi

    log_info "Criando estrutura de diretórios na VPS..."
    ssh "${VPS_USER}@${VPS_HOST}" "mkdir -p ${VPS_DOTFILES}/system_prompts/global/scripts" || {
        log_error "Falha ao criar diretórios na VPS"
        return 1
    }
    log_success "Estrutura criada"

    log_info "Enviando script de coleta..."
    scp "${COleta_SCRIPT}" "${VPS_USER}@${VPS_HOST}:${VPS_DOTFILES}/system_prompts/global/scripts/coleta-vps.sh" || {
        log_error "Falha ao enviar script de coleta"
        return 1
    }
    log_success "Script de coleta enviado"

    log_info "Enviando script de análise..."
    scp "${ANALISE_SCRIPT}" "${VPS_USER}@${VPS_HOST}:${VPS_DOTFILES}/system_prompts/global/scripts/analise-e-sintese-vps.sh" || {
        log_error "Falha ao enviar script de análise"
        return 1
    }
    log_success "Script de análise enviado"

    log_info "Configurando permissões de execução..."
    ssh "${VPS_USER}@${VPS_HOST}" "chmod +x ${VPS_DOTFILES}/system_prompts/global/scripts/*.sh" || {
        log_error "Falha ao configurar permissões"
        return 1
    }
    log_success "Permissões configuradas"

    log_info "Validando scripts na VPS..."
    ssh "${VPS_USER}@${VPS_HOST}" "ls -lh ${VPS_DOTFILES}/system_prompts/global/scripts/*.sh" || {
        log_error "Falha ao validar scripts"
        return 1
    }
    log_success "Scripts validados"

    echo ""
    log_success "✅ Deploy concluído com sucesso!"
    echo ""
    log_info "Scripts disponíveis na VPS:"
    log_info "  - ${VPS_DOTFILES}/system_prompts/global/scripts/coleta-vps.sh"
    log_info "  - ${VPS_DOTFILES}/system_prompts/global/scripts/analise-e-sintese-vps.sh"
    echo ""
    log_info "Para executar na VPS:"
    log_info "  ssh ${VPS_HOST}"
    log_info "  ${VPS_DOTFILES}/system_prompts/global/scripts/coleta-vps.sh"
    log_info "  ${VPS_DOTFILES}/system_prompts/global/scripts/analise-e-sintese-vps.sh"
    echo ""
}

# ============================================================================
# MAIN
# ============================================================================

main() {
    if ! validate_ssh_connection; then
        exit 1
    fi

    deploy_scripts
}

main "$@"

