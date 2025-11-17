#!/bin/bash
# Script de Setup - macOS Silicon
# Configura ambiente de desenvolvimento completo no macOS

set -euo pipefail

# Cores
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

DOTFILES_DIR="$HOME/Dotfiles"
VSCODE_SNIPPETS_DIR="$HOME/Library/Application Support/Code/User/snippets"
CURSOR_SNIPPETS_DIR="$HOME/Library/Application Support/Cursor/User/snippets"

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

# Verificar se está no macOS
if [[ "$OSTYPE" != "darwin"* ]]; then
    log_error "Este script é apenas para macOS"
    exit 1
fi

log_info "🚀 Configurando ambiente macOS..."

# 1. Criar estrutura de diretórios
log_info "Criando estrutura de diretórios..."
mkdir -p "$VSCODE_SNIPPETS_DIR"
mkdir -p "$CURSOR_SNIPPETS_DIR"
mkdir -p "$HOME/.cursor"
log_success "Estrutura de diretórios criada"

# 2. Copiar snippets VSCode
log_info "Instalando snippets VSCode..."
if [ -d "$DOTFILES_DIR/vscode/snippets" ]; then
    cp -r "$DOTFILES_DIR/vscode/snippets/"* "$VSCODE_SNIPPETS_DIR/"
    log_success "Snippets VSCode instalados"
else
    log_warning "Diretório de snippets VSCode não encontrado"
fi

# 3. Copiar snippets Cursor
log_info "Instalando snippets Cursor..."
if [ -d "$DOTFILES_DIR/vscode/snippets" ]; then
    cp -r "$DOTFILES_DIR/vscode/snippets/"* "$CURSOR_SNIPPETS_DIR/"
    log_success "Snippets Cursor instalados"
else
    log_warning "Diretório de snippets não encontrado"
fi

# 4. Copiar settings VSCode
log_info "Instalando settings VSCode..."
if [ -f "$DOTFILES_DIR/vscode/settings.json" ]; then
    mkdir -p "$HOME/Library/Application Support/Code/User"
    cp "$DOTFILES_DIR/vscode/settings.json" "$HOME/Library/Application Support/Code/User/settings.json"
    log_success "Settings VSCode instalados"
else
    log_warning "Arquivo settings.json não encontrado"
fi

# 5. Copiar settings Cursor
log_info "Instalando settings Cursor..."
if [ -f "$DOTFILES_DIR/vscode/settings.json" ]; then
    mkdir -p "$HOME/Library/Application Support/Cursor/User"
    cp "$DOTFILES_DIR/vscode/settings.json" "$HOME/Library/Application Support/Cursor/User/settings.json"
    log_success "Settings Cursor instalados"
else
    log_warning "Arquivo settings.json não encontrado"
fi

# 6. Copiar .cursorrules
log_info "Instalando .cursorrules..."
if [ -f "$DOTFILES_DIR/context-engineering/.cursorrules" ]; then
    cp "$DOTFILES_DIR/context-engineering/.cursorrules" "$HOME/.cursorrules"
    log_success ".cursorrules instalado"
else
    log_warning "Arquivo .cursorrules não encontrado"
fi

# 7. Configurar Raycast (se instalado)
if command -v raycast &>/dev/null; then
    log_info "Raycast detectado - configurando snippets..."
    # Raycast snippets são gerenciados via UI, apenas avisar
    log_warning "Configure snippets do Raycast manualmente via UI"
    log_info "Arquivos de referência em: $DOTFILES_DIR/raycast/snippets/"
else
    log_warning "Raycast não encontrado - instale para usar snippets"
fi

# 8. Verificar extensões VSCode recomendadas
log_info "Verificando extensões recomendadas..."
if [ -f "$DOTFILES_DIR/vscode/extensions.json" ]; then
    log_info "Extensões recomendadas em: $DOTFILES_DIR/vscode/extensions.json"
    log_info "Instale manualmente ou use: code --install-extension <ext-id>"
fi

log_success "✅ Setup macOS concluído!"
log_info ""
log_info "Próximos passos:"
log_info "1. Recarregue VSCode/Cursor para aplicar configurações"
log_info "2. Instale extensões recomendadas"
log_info "3. Configure Raycast snippets manualmente"
log_info "4. Teste os snippets: digite '1p-get' ou 'sh-template'"

