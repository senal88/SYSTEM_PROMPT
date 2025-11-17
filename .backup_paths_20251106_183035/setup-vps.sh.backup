#!/bin/bash
# Script de Setup - VPS Ubuntu
# Configura ambiente de desenvolvimento na VPS Ubuntu

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

# Verificar se está no Linux
if [[ "$OSTYPE" != "linux-gnu"* ]]; then
    log_error "Este script é apenas para Linux"
    exit 1
fi

log_info "🚀 Configurando ambiente VPS Ubuntu..."

# 1. Verificar se dotfiles estão clonados
if [ ! -d "$DOTFILES_DIR" ]; then
    log_warning "Dotfiles não encontrados em $DOTFILES_DIR"
    log_info "Clone os dotfiles primeiro:"
    log_info "git clone <repo> $DOTFILES_DIR"
    exit 1
fi

# 2. Criar estrutura de diretórios
log_info "Criando estrutura de diretórios..."
mkdir -p "$HOME/.config/op"
mkdir -p "$HOME/.cursor"
log_success "Estrutura de diretórios criada"

# 3. Copiar .cursorrules
log_info "Instalando .cursorrules..."
if [ -f "$DOTFILES_DIR/context-engineering/.cursorrules" ]; then
    cp "$DOTFILES_DIR/context-engineering/.cursorrules" "$HOME/.cursorrules"
    cp "$DOTFILES_DIR/context-engineering/cursor-rules/.cursorrules.vps" "$HOME/.cursor/.cursorrules.vps"
    log_success ".cursorrules instalado"
else
    log_warning "Arquivo .cursorrules não encontrado"
fi

# 4. Configurar 1Password
log_info "Configurando 1Password..."
if command -v op &>/dev/null; then
    if [ -f "$DOTFILES_DIR/automation_1password/scripts/op-init.sh" ]; then
        log_info "Executando inicialização do 1Password..."
        bash "$DOTFILES_DIR/automation_1password/scripts/op-init.sh" || log_warning "Erro ao inicializar 1Password"
    fi
else
    log_warning "1Password CLI não encontrado - instale primeiro"
fi

# 5. Configurar VSCode (se instalado via SSH)
log_info "Configurando VSCode Remote..."
if [ -d "$HOME/.vscode-server" ]; then
    mkdir -p "$HOME/.vscode-server/data/User/snippets"
    if [ -d "$DOTFILES_DIR/vscode/snippets" ]; then
        cp -r "$DOTFILES_DIR/vscode/snippets/"* "$HOME/.vscode-server/data/User/snippets/"
        log_success "Snippets VSCode Remote instalados"
    fi
    
    if [ -f "$DOTFILES_DIR/vscode/settings.json" ]; then
        mkdir -p "$HOME/.vscode-server/data/User"
        cp "$DOTFILES_DIR/vscode/settings.json" "$HOME/.vscode-server/data/User/settings.json"
        log_success "Settings VSCode Remote instalados"
    fi
else
    log_warning "VSCode Server não encontrado"
fi

# 6. Configurar bash/zsh
log_info "Configurando shell..."
SHELL_RC="$HOME/.bashrc"
if [ -n "${ZSH_VERSION:-}" ]; then
    SHELL_RC="$HOME/.zshrc"
fi

if [ -f "$DOTFILES_DIR/context-engineering/scripts/shell-config.sh" ]; then
    if ! grep -q "context-engineering" "$SHELL_RC" 2>/dev/null; then
        echo "" >> "$SHELL_RC"
        echo "# Context Engineering Config" >> "$SHELL_RC"
        echo "source $DOTFILES_DIR/context-engineering/scripts/shell-config.sh" >> "$SHELL_RC"
        log_success "Configuração shell adicionada"
    fi
fi

log_success "✅ Setup VPS concluído!"
log_info ""
log_info "Próximos passos:"
log_info "1. Recarregue o shell: source $SHELL_RC"
log_info "2. Configure 1Password: op-init.sh"
log_info "3. Teste os snippets no VSCode Remote"

