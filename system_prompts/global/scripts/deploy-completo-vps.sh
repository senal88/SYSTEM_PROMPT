#!/usr/bin/env bash

################################################################################
# 🚀 DEPLOY COMPLETO PARA VPS
# Deploy completo do sistema de prompts globais para a VPS Ubuntu
#
# STATUS: ATIVO (2025-11-28)
# PROPÓSITO: Deploy automatizado completo na VPS
# VERSÃO: 1.0.0
################################################################################

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
GLOBAL_DIR="$(cd "${SCRIPT_DIR}/.." && pwd)"
DOTFILES_DIR="${DOTFILES_DIR:-${HOME}/Dotfiles}"
VPS_HOST="${VPS_HOST:-admin-vps}"
VPS_USER="${VPS_USER:-admin}"
VPS_DOTFILES="${VPS_DOTFILES:-/home/admin/Dotfiles}"
VPS_SYSTEM_PROMPTS="${VPS_DOTFILES}/system_prompts/global"

# Cores
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

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

# Validar conexão SSH
validate_ssh() {
    log_info "Testando conexão SSH com ${VPS_USER}@${VPS_HOST}..."
    if ssh -o ConnectTimeout=5 -o BatchMode=yes "${VPS_USER}@${VPS_HOST}" "echo 'OK'" >/dev/null 2>&1; then
        log_success "Conexão SSH estabelecida"
        return 0
    else
        log_error "Não foi possível conectar via SSH"
        log_info "Verifique:"
        log_info "  - Alias SSH: ssh ${VPS_HOST}"
        log_info "  - Chaves SSH autorizadas"
        log_info "  - Host acessível"
        return 1
    fi
}

# Criar estrutura na VPS
create_structure() {
    log_info "Criando estrutura de diretórios na VPS..."
    ssh "${VPS_USER}@${VPS_HOST}" "mkdir -p ${VPS_SYSTEM_PROMPTS}/{prompts/{system,audit,revision},docs/{checklists,summaries,corrections},consolidated,scripts,governance,audit,prompts_temp,logs}" || {
        log_error "Falha ao criar estrutura"
        return 1
    }
    log_success "Estrutura criada"
}

# Deploy de arquivos principais
deploy_files() {
    log_info "Enviando arquivos principais..."
    
    # README e CHANGELOG
    scp "${GLOBAL_DIR}/README.md" "${VPS_USER}@${VPS_HOST}:${VPS_SYSTEM_PROMPTS}/" || log_warning "Falha ao enviar README.md"
    scp "${GLOBAL_DIR}/CHANGELOG.md" "${VPS_USER}@${VPS_HOST}:${VPS_SYSTEM_PROMPTS}/" || log_warning "Falha ao enviar CHANGELOG.md"
    
    # Prompts
    scp -r "${GLOBAL_DIR}/prompts/"* "${VPS_USER}@${VPS_HOST}:${VPS_SYSTEM_PROMPTS}/prompts/" || log_warning "Falha ao enviar prompts"
    
    # Scripts
    scp -r "${GLOBAL_DIR}/scripts/"* "${VPS_USER}@${VPS_HOST}:${VPS_SYSTEM_PROMPTS}/scripts/" || log_warning "Falha ao enviar scripts"
    
    # Docs
    scp -r "${GLOBAL_DIR}/docs/"* "${VPS_USER}@${VPS_HOST}:${VPS_SYSTEM_PROMPTS}/docs/" || log_warning "Falha ao enviar docs"
    
    # Governance
    scp -r "${GLOBAL_DIR}/governance/"* "${VPS_USER}@${VPS_HOST}:${VPS_SYSTEM_PROMPTS}/governance/" || log_warning "Falha ao enviar governance"
    
    log_success "Arquivos enviados"
}

# Configurar permissões
set_permissions() {
    log_info "Configurando permissões..."
    ssh "${VPS_USER}@${VPS_HOST}" "chmod +x ${VPS_SYSTEM_PROMPTS}/scripts/*.sh 2>/dev/null || true" || log_warning "Falha ao configurar permissões"
    log_success "Permissões configuradas"
}

# Validar deploy
validate_deploy() {
    log_info "Validando deploy..."
    ssh "${VPS_USER}@${VPS_HOST}" "test -f ${VPS_SYSTEM_PROMPTS}/README.md && echo 'OK'" || {
        log_error "Deploy não validado"
        return 1
    }
    log_success "Deploy validado"
}

# Main
main() {
    print_header "🚀 DEPLOY COMPLETO PARA VPS"
    
    if ! validate_ssh; then
        exit 1
    fi
    
    create_structure
    deploy_files
    set_permissions
    validate_deploy
    
    echo ""
    log_success "✅ Deploy completo concluído!"
    echo ""
    log_info "Sistema disponível em: ${VPS_SYSTEM_PROMPTS}"
    echo ""
}

main "$@"

