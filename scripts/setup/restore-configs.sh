#!/bin/bash

#################################################################################
# Script de Restauração de Configurações
# Versão: 2.0.1
# Objetivo: Restaurar backup de configurações
#################################################################################

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"
BACKUP_DIR="$REPO_ROOT/backups"
BACKUP_TIMESTAMP="${1:-latest}"

# Cores
GREEN='\033[0;32m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
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

error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Encontrar backup
find_backup() {
    if [ "$BACKUP_TIMESTAMP" == "latest" ]; then
        BACKUP_NAME=$(ls -t "$BACKUP_DIR" | grep "config-backup-" | head -1)
    else
        BACKUP_NAME="config-backup-$BACKUP_TIMESTAMP"
    fi
    
    if [ ! -d "$BACKUP_DIR/$BACKUP_NAME" ]; then
        error "Backup não encontrado: $BACKUP_DIR/$BACKUP_NAME"
        echo ""
        echo "Backups disponíveis:"
        ls -1 "$BACKUP_DIR" | grep "config-backup-" || echo "Nenhum backup encontrado"
        exit 1
    fi
    
    log "Usando backup: $BACKUP_NAME"
}

# Restaurar Cursor
restore_cursor() {
    log "Restaurando Cursor..."
    
    if [ -d "$BACKUP_DIR/$BACKUP_NAME/cursor-app-support" ]; then
        cp -r "$BACKUP_DIR/$BACKUP_NAME/cursor-app-support/"* "$HOME/Library/Application Support/Cursor/" 2>/dev/null || true
    fi
    
    if [ -d "$BACKUP_DIR/$BACKUP_NAME/cursor-config" ]; then
        cp -r "$BACKUP_DIR/$BACKUP_NAME/cursor-config/"* "$HOME/.config/cursor/" 2>/dev/null || true
    fi
    
    success "Cursor restaurado"
}

# Restaurar VSCode
restore_vscode() {
    log "Restaurando VSCode..."
    
    if [ -d "$BACKUP_DIR/$BACKUP_NAME/vscode-app-support" ]; then
        cp -r "$BACKUP_DIR/$BACKUP_NAME/vscode-app-support/"* "$HOME/Library/Application Support/Code/" 2>/dev/null || true
    fi
    
    if [ -d "$BACKUP_DIR/$BACKUP_NAME/vscode-config" ]; then
        cp -r "$BACKUP_DIR/$BACKUP_NAME/vscode-config/"* "$HOME/.vscode/" 2>/dev/null || true
    fi
    
    success "VSCode restaurado"
}

# Restaurar macOS
restore_macos() {
    if [[ "$OSTYPE" != "darwin"* ]]; then
        return 0
    fi
    
    log "Restaurando configurações do macOS..."
    
    warning "Restauração manual necessária para macOS"
    warning "Use os arquivos .plist em: $BACKUP_DIR/$BACKUP_NAME/"
    
    success "macOS (verificar manualmente)"
}

# Restaurar Git
restore_git() {
    log "Restaurando Git..."
    
    if [ -f "$BACKUP_DIR/$BACKUP_NAME/gitconfig" ]; then
        cp "$BACKUP_DIR/$BACKUP_NAME/gitconfig" "$HOME/.gitconfig"
    fi
    
    if [ -f "$BACKUP_DIR/$BACKUP_NAME/gitignore_global" ]; then
        cp "$BACKUP_DIR/$BACKUP_NAME/gitignore_global" "$HOME/.gitignore_global"
    fi
    
    success "Git restaurado"
}

# Restaurar Shell
restore_shell() {
    log "Restaurando Shell..."
    
    if [ -f "$BACKUP_DIR/$BACKUP_NAME/zshrc" ]; then
        cp "$BACKUP_DIR/$BACKUP_NAME/zshrc" "$HOME/.zshrc"
    fi
    
    if [ -f "$BACKUP_DIR/$BACKUP_NAME/bashrc" ]; then
        cp "$BACKUP_DIR/$BACKUP_NAME/bashrc" "$HOME/.bashrc"
    fi
    
    if [ -f "$BACKUP_DIR/$BACKUP_NAME/bash_profile" ]; then
        cp "$BACKUP_DIR/$BACKUP_NAME/bash_profile" "$HOME/.bash_profile"
    fi
    
    success "Shell restaurado"
}

main() {
    clear
    
    echo "╔═══════════════════════════════════════════════════════════════╗"
    echo "║        Restauração de Configurações                           ║"
    echo "║              Versão 2.0.1 - Universal Setup                 ║"
    echo "╚═══════════════════════════════════════════════════════════════╝"
    echo ""
    
    if [ -z "$1" ]; then
        warning "Uso: $0 [timestamp|latest]"
        echo ""
        echo "Backups disponíveis:"
        ls -1 "$BACKUP_DIR" | grep "config-backup-" || echo "Nenhum backup encontrado"
        exit 1
    fi
    
    find_backup
    
    echo ""
    warning "Esta operação irá sobrescrever configurações existentes!"
    read -p "Continuar? (s/N): " confirm
    
    if [[ ! "$confirm" =~ ^[Ss]$ ]]; then
        log "Operação cancelada"
        exit 0
    fi
    
    echo ""
    
    restore_cursor
    restore_vscode
    restore_macos
    restore_git
    restore_shell
    
    echo ""
    success "Restauração concluída!"
    echo ""
    echo "Reinicie os aplicativos para aplicar as mudanças."
    echo ""
}

main "$@"

