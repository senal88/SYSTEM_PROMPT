#!/usr/bin/env bash

################################################################################
# 🍺 CONFIGURAR HOMEBREW - Detectar e configurar Homebrew no PATH
# Verifica instalação e configura PATH se necessário
#
# STATUS: ATIVO (2025-11-28)
# PROPÓSITO: Configurar Homebrew para uso
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
echo "║ 🍺 CONFIGURAR HOMEBREW"
echo "╚════════════════════════════════════════════════════════════════════════════╝"
echo ""

# Verificar se brew está no PATH
if command -v brew >/dev/null 2>&1; then
    BREW_PATH=$(which brew)
    BREW_VERSION=$(brew --version | head -1)
    log_success "Homebrew já está no PATH: ${BREW_PATH}"
    log_info "Versão: ${BREW_VERSION}"
    exit 0
fi

# Verificar instalações possíveis
BREW_PATHS=(
    "/opt/homebrew/bin/brew"
    "/usr/local/bin/brew"
    "$HOME/homebrew/bin/brew"
)

BREW_FOUND=""
BREW_DIR=""

for brew_path in "${BREW_PATHS[@]}"; do
    if [ -f "$brew_path" ]; then
        BREW_FOUND="$brew_path"
        BREW_DIR=$(dirname "$(dirname "$brew_path")")
        log_success "Homebrew encontrado em: ${BREW_DIR}"
        break
    fi
done

if [ -z "$BREW_FOUND" ]; then
    log_error "Homebrew não está instalado"
    echo ""
    log_info "Para instalar Homebrew, execute:"
    echo ""
    echo '  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"'
    echo ""
    log_info "Ou visite: https://brew.sh"
    exit 1
fi

# Verificar arquivo de shell config
SHELL_CONFIG=""
if [ -n "${ZSH_VERSION:-}" ] || [ -f "$HOME/.zshrc" ]; then
    SHELL_CONFIG="$HOME/.zshrc"
elif [ -n "${BASH_VERSION:-}" ] || [ -f "$HOME/.bash_profile" ]; then
    SHELL_CONFIG="$HOME/.bash_profile"
else
    SHELL_CONFIG="$HOME/.zshrc"
fi

log_info "Arquivo de configuração do shell: ${SHELL_CONFIG}"

# Verificar se já está configurado
if grep -q "eval.*homebrew" "$SHELL_CONFIG" 2>/dev/null || grep -q "$BREW_DIR/bin" "$SHELL_CONFIG" 2>/dev/null; then
    log_warning "Homebrew já está configurado em ${SHELL_CONFIG}"
    log_info "Recarregue o shell: source ${SHELL_CONFIG}"
    exit 0
fi

# Adicionar ao shell config
log_info "Adicionando Homebrew ao PATH em ${SHELL_CONFIG}..."

# Detectar arquitetura
if [[ $(uname -m) == "arm64" ]]; then
    # Apple Silicon
    BREW_EVAL="eval \"\$(${BREW_DIR}/bin/brew shellenv)\""
else
    # Intel
    BREW_EVAL="eval \"\$(${BREW_DIR}/bin/brew shellenv)\""
fi

# Adicionar ao arquivo
cat >> "$SHELL_CONFIG" << EOF

# Homebrew
${BREW_EVAL}
EOF

log_success "Homebrew adicionado ao ${SHELL_CONFIG}"
echo ""
log_info "Para aplicar as mudanças, execute:"
echo ""
echo "  source ${SHELL_CONFIG}"
echo ""
log_info "Ou abra um novo terminal"
echo ""

# Tentar carregar no shell atual
eval "$(${BREW_DIR}/bin/brew shellenv)" 2>/dev/null || true

if command -v brew >/dev/null 2>&1; then
    log_success "Homebrew agora está disponível no shell atual"
    BREW_VERSION=$(brew --version | head -1)
    log_info "Versão: ${BREW_VERSION}"
else
    log_warning "Recarregue o shell para usar Homebrew"
fi

echo ""

