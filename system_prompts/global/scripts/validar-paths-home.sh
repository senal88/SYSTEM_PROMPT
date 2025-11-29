#!/usr/bin/env bash

################################################################################
# ✅ VALIDAR PATHS HOME
# Valida paths HOME antes de operações para prevenir erros de interpretação
#
# STATUS: ATIVO (2025-11-28)
# PROPÓSITO: Prevenir erros de interpretação por LLMs
# VERSÃO: 1.0.0
################################################################################

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
GLOBAL_DIR="$(cd "${SCRIPT_DIR}/.." && pwd)"

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

# Validar HOME
if [ -z "${HOME:-}" ]; then
    log_error "HOME não está definido!"
    exit 1
fi

log_success "HOME validado: ${HOME}"

# Paths críticos para validar
CRITICAL_PATHS=(
    "${HOME}/Dotfiles"
    "${HOME}/Dotfiles/system_prompts"
    "${HOME}/Dotfiles/system_prompts/global"
    "${HOME}/Dotfiles/logs"
    "${HOME}/Dotfiles/icloud_control"
)

# Validar cada path
for path in "${CRITICAL_PATHS[@]}"; do
    if [ ! -e "${path}" ]; then
        log_warning "Path não existe: ${path}"
        log_info "Criando: ${path}"
        mkdir -p "${path}"
        log_success "Criado: ${path}"
    else
        if [ -d "${path}" ]; then
            if [ -r "${path}" ] && [ -w "${path}" ]; then
                log_success "Path válido: ${path}"
            else
                log_error "Path sem permissões: ${path}"
                exit 1
            fi
        else
            log_warning "Path existe mas não é diretório: ${path}"
        fi
    fi
done

# Validar padrão de HOME
if [[ ! "${HOME}" =~ ^/Users/.*$ ]] && [[ ! "${HOME}" =~ ^/home/.*$ ]]; then
    log_warning "HOME não segue padrão esperado: ${HOME}"
fi

log_success "Todas as validações de paths HOME concluídas!"
