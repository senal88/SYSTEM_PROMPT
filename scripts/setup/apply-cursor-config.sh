#!/bin/bash

#################################################################################
# Script de Aplicação de Configurações do Cursor 2.0
# Versão: 2.0.1
# Objetivo: Aplicar configurações do Cursor 2.0 no macOS
#################################################################################

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"

# Cores
GREEN='\033[0;32m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
YELLOW='\033[1;33m'
NC='\033[0m'

log() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

# Detectar sistema operacional
if [[ "$OSTYPE" != "darwin"* ]]; then
    warning "Este script é específico para macOS"
    exit 1
fi

# Diretórios do Cursor
CURSOR_USER_DIR="$HOME/Library/Application Support/Cursor/User"
CURSOR_CONFIG_DIR="$HOME/.config/cursor"

main() {
    clear
    
    echo "╔═══════════════════════════════════════════════════════════════╗"
    echo "║        Aplicar Configurações Cursor 2.0                    ║"
    echo "║              Versão 2.0.1 - macOS                           ║"
    echo "╚═══════════════════════════════════════════════════════════════╝"
    echo ""
    
    # Criar diretórios se não existirem
    log "Criando diretórios de configuração..."
    mkdir -p "$CURSOR_USER_DIR"
    mkdir -p "$CURSOR_CONFIG_DIR"
    mkdir -p "$CURSOR_CONFIG_DIR/extensions"
    
    # Backup das configurações existentes
    if [ -f "$CURSOR_USER_DIR/settings.json" ]; then
        log "Criando backup das configurações existentes..."
        cp "$CURSOR_USER_DIR/settings.json" "$CURSOR_USER_DIR/settings.json.backup.$(date +%Y%m%d_%H%M%S)"
    fi
    
    if [ -f "$CURSOR_USER_DIR/keybindings.json" ]; then
        cp "$CURSOR_USER_DIR/keybindings.json" "$CURSOR_USER_DIR/keybindings.json.backup.$(date +%Y%m%d_%H%M%S)"
    fi
    
    # Aplicar settings.json
    if [ -f "$REPO_ROOT/configs/cursor-settings.json" ]; then
        log "Aplicando settings.json..."
        cp "$REPO_ROOT/configs/cursor-settings.json" "$CURSOR_USER_DIR/settings.json"
        success "settings.json aplicado"
    else
        warning "Arquivo cursor-settings.json não encontrado"
    fi
    
    # Aplicar keybindings.json
    if [ -f "$REPO_ROOT/configs/cursor-keybindings.json" ]; then
        log "Aplicando keybindings.json..."
        cp "$REPO_ROOT/configs/cursor-keybindings.json" "$CURSOR_USER_DIR/keybindings.json"
        success "keybindings.json aplicado"
    else
        warning "Arquivo cursor-keybindings.json não encontrado"
    fi
    
    # Aplicar perfil de extensões
    if [ -f "$REPO_ROOT/configs/extensions-universal.json" ]; then
        log "Aplicando perfil de extensões..."
        cp "$REPO_ROOT/configs/extensions-universal.json" "$CURSOR_CONFIG_DIR/extensions/recommended.json"
        success "Perfil de extensões aplicado"
    else
        warning "Arquivo extensions-universal.json não encontrado"
    fi
    
    echo ""
    echo "╔═══════════════════════════════════════════════════════════════╗"
    echo "║              CONFIGURAÇÕES APLICADAS COM SUCESSO            ║"
    echo "╚═══════════════════════════════════════════════════════════════╝"
    echo ""
    success "Configurações do Cursor 2.0 aplicadas!"
    echo ""
    echo "Próximas ações:"
    echo "1. Reinicie o Cursor para aplicar as configurações"
    echo "2. Instale as extensões recomendadas via Command Palette"
    echo "3. Configure tokens e secrets conforme necessário"
    echo ""
    echo "Localização dos arquivos:"
    echo "- Settings: $CURSOR_USER_DIR/settings.json"
    echo "- Keybindings: $CURSOR_USER_DIR/keybindings.json"
    echo "- Extensions: $CURSOR_CONFIG_DIR/extensions/recommended.json"
    echo ""
}

main "$@"

