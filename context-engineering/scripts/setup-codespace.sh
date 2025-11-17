#!/bin/bash
# Script de Setup - GitHub Codespaces
# Configura ambiente de desenvolvimento no Codespace

set -euo pipefail

# Cores
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

DOTFILES_DIR="$HOME/Dotfiles"

log_info() {
    echo -e "${BLUE}ℹ${NC} $1"
}

log_success() {
    echo -e "${GREEN}✓${NC} $1"
}

log_error() {
    echo -e "${RED}✗${NC} $1" >&2
}

log_warning() {
    echo -e "${YELLOW}⚠${NC} $1"
}

log_info "🚀 Configurando Codespace..."

# 1. Clonar dotfiles se não existirem
if [ ! -d "$DOTFILES_DIR" ]; then
    log_info "Dotfiles não encontrados - será necessário clonar manualmente"
    log_warning "Configure GITHUB_TOKEN ou clone manualmente"
fi

# 2. Criar estrutura de diretórios
log_info "Criando estrutura de diretórios..."
mkdir -p "$HOME/.config/op"
mkdir -p "$HOME/.cursor"
mkdir -p "$HOME/.vscode-server/data/User/snippets"
log_success "Estrutura de diretórios criada"

# 3. Copiar .cursorrules
log_info "Instalando .cursorrules..."
if [ -f "$DOTFILES_DIR/context-engineering/.cursorrules" ]; then
    cp "$DOTFILES_DIR/context-engineering/.cursorrules" "$HOME/.cursorrules"
    cp "$DOTFILES_DIR/context-engineering/cursor-rules/.cursorrules.codespace" "$HOME/.cursor/.cursorrules.codespace"
    log_success ".cursorrules instalado"
fi

# 4. Configurar VSCode
log_info "Configurando VSCode..."
if [ -d "$DOTFILES_DIR/vscode/snippets" ]; then
    cp -r "$DOTFILES_DIR/vscode/snippets/"* "$HOME/.vscode-server/data/User/snippets/" 2>/dev/null || true
    log_success "Snippets VSCode instalados"
fi

if [ -f "$DOTFILES_DIR/vscode/settings.json" ]; then
    mkdir -p "$HOME/.vscode-server/data/User"
    cp "$DOTFILES_DIR/vscode/settings.json" "$HOME/.vscode-server/data/User/settings.json"
    log_success "Settings VSCode instalados"
fi

# 5. Configurar 1Password (se disponível)
log_info "Configurando 1Password..."
if command -v op &>/dev/null; then
    if [ -f "$DOTFILES_DIR/automation_1password/scripts/op-init.sh" ]; then
        bash "$DOTFILES_DIR/automation_1password/scripts/op-init.sh" || log_warning "Erro ao inicializar 1Password"
    fi
else
    log_warning "1Password CLI não encontrado"
fi

log_success "✅ Setup Codespace concluído!"
log_info ""
log_info "Próximos passos:"
log_info "1. Recarregue VSCode para aplicar configurações"
log_info "2. Instale extensões recomendadas"
log_info "3. Configure 1Password se necessário"

