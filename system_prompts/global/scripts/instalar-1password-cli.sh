#!/usr/bin/env bash

################################################################################
# 🔐 INSTALAR 1PASSWORD CLI
# Instala 1Password CLI após configurar Homebrew
#
# STATUS: ATIVO (2025-11-28)
# PROPÓSITO: Instalar 1Password CLI para automação
# VERSÃO: 1.0.0
################################################################################

set -euo pipefail

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

echo ""
echo "╔════════════════════════════════════════════════════════════════════════════╗"
echo "║ 🔐 INSTALAR 1PASSWORD CLI"
echo "╚════════════════════════════════════════════════════════════════════════════╝"
echo ""

# Verificar se já está instalado
if command -v op >/dev/null 2>&1; then
    OP_VERSION=$(op --version 2>/dev/null || echo "instalado")
    log_success "1Password CLI já está instalado: $(which op)"
    log_info "Versão: ${OP_VERSION}"
    exit 0
fi

# Verificar Homebrew
if ! command -v brew >/dev/null 2>&1; then
    log_error "Homebrew não está disponível"
    log_info "Execute primeiro: ./scripts/configurar-homebrew.sh"
    exit 1
fi

log_info "Instalando 1Password CLI via Homebrew..."
echo ""

# Instalar 1Password CLI
if brew install --cask 1password-cli; then
    log_success "1Password CLI instalado com sucesso!"
    echo ""

    # Verificar instalação
    if command -v op >/dev/null 2>&1; then
        OP_VERSION=$(op --version 2>/dev/null || echo "instalado")
        log_success "1Password CLI disponível: $(which op)"
        log_info "Versão: ${OP_VERSION}"
        echo ""
        log_info "Próximos passos:"
        echo ""
        echo "  1. Autenticar: op signin"
        echo "  2. Verificar vaults: op vault list"
        echo "  3. Testar acesso: op read op://1p_macos/GitHub/copilot_token"
        echo ""
    else
        log_warning "1Password CLI instalado mas não está no PATH"
        log_info "Recarregue o shell: source ~/.zshrc"
    fi
else
    log_error "Falha ao instalar 1Password CLI"
    echo ""
    log_info "Alternativa: Baixar manualmente de:"
    echo "  https://developer.1password.com/docs/cli/get-started"
    exit 1
fi

echo ""

