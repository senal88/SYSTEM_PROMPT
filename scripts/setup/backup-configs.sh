#!/bin/bash

#################################################################################
# Script de Backup de Configurações
# Versão: 2.0.1
# Objetivo: Criar backup de todas as configurações do sistema
#################################################################################

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"
BACKUP_DIR="$REPO_ROOT/backups"
TIMESTAMP=$(date +%Y%m%d_%H%M%S)
BACKUP_NAME="config-backup-$TIMESTAMP"

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

# Criar diretório de backup
create_backup_dir() {
    mkdir -p "$BACKUP_DIR/$BACKUP_NAME"
    success "Diretório de backup criado: $BACKUP_DIR/$BACKUP_NAME"
}

# Backup configurações do Cursor
backup_cursor() {
    log "Fazendo backup do Cursor..."
    
    local cursor_config="$HOME/Library/Application Support/Cursor"
    local cursor_local="$HOME/.config/cursor"
    
    if [ -d "$cursor_config" ]; then
        cp -r "$cursor_config" "$BACKUP_DIR/$BACKUP_NAME/cursor-app-support" 2>/dev/null || true
    fi
    
    if [ -d "$cursor_local" ]; then
        cp -r "$cursor_local" "$BACKUP_DIR/$BACKUP_NAME/cursor-config" 2>/dev/null || true
    fi
    
    success "Cursor backup concluído"
}

# Backup configurações do VSCode
backup_vscode() {
    log "Fazendo backup do VSCode..."
    
    local vscode_config="$HOME/Library/Application Support/Code"
    local vscode_local="$HOME/.vscode"
    
    if [ -d "$vscode_config" ]; then
        cp -r "$vscode_config" "$BACKUP_DIR/$BACKUP_NAME/vscode-app-support" 2>/dev/null || true
    fi
    
    if [ -d "$vscode_local" ]; then
        cp -r "$vscode_local" "$BACKUP_DIR/$BACKUP_NAME/vscode-config" 2>/dev/null || true
    fi
    
    success "VSCode backup concluído"
}

# Backup configurações do macOS
backup_macos() {
    log "Fazendo backup das configurações do macOS..."
    
    # Dock
    defaults read com.apple.dock > "$BACKUP_DIR/$BACKUP_NAME/macos-dock.plist" 2>/dev/null || true
    
    # Spaces
    defaults read com.apple.spaces > "$BACKUP_DIR/$BACKUP_NAME/macos-spaces.plist" 2>/dev/null || true
    
    # Keyboard
    defaults read -g > "$BACKUP_DIR/$BACKUP_NAME/macos-global.plist" 2>/dev/null || true
    
    success "macOS backup concluído"
}

# Backup configurações do Raycast
backup_raycast() {
    log "Fazendo backup do Raycast..."
    
    local raycast_config="$HOME/Library/Application Support/Raycast"
    
    if [ -d "$raycast_config" ]; then
        cp -r "$raycast_config" "$BACKUP_DIR/$BACKUP_NAME/raycast" 2>/dev/null || true
        success "Raycast backup concluído"
    else
        warning "Raycast não encontrado"
    fi
}

# Backup configurações do Karabiner
backup_karabiner() {
    log "Fazendo backup do Karabiner..."
    
    local karabiner_config="$HOME/.config/karabiner"
    
    if [ -d "$karabiner_config" ]; then
        cp -r "$karabiner_config" "$BACKUP_DIR/$BACKUP_NAME/karabiner" 2>/dev/null || true
        success "Karabiner backup concluído"
    else
        warning "Karabiner não encontrado"
    fi
}

# Backup configurações do Git
backup_git() {
    log "Fazendo backup do Git..."
    
    if [ -f "$HOME/.gitconfig" ]; then
        cp "$HOME/.gitconfig" "$BACKUP_DIR/$BACKUP_NAME/gitconfig"
        success "Git backup concluído"
    fi
    
    if [ -f "$HOME/.gitignore_global" ]; then
        cp "$HOME/.gitignore_global" "$BACKUP_DIR/$BACKUP_NAME/gitignore_global"
    fi
}

# Backup configurações do Shell
backup_shell() {
    log "Fazendo backup do Shell..."
    
    if [ -f "$HOME/.zshrc" ]; then
        cp "$HOME/.zshrc" "$BACKUP_DIR/$BACKUP_NAME/zshrc"
    fi
    
    if [ -f "$HOME/.bashrc" ]; then
        cp "$HOME/.bashrc" "$BACKUP_DIR/$BACKUP_NAME/bashrc"
    fi
    
    if [ -f "$HOME/.bash_profile" ]; then
        cp "$HOME/.bash_profile" "$BACKUP_DIR/$BACKUP_NAME/bash_profile"
    fi
    
    success "Shell backup concluído"
}

# Criar arquivo de informações do backup
create_backup_info() {
    log "Criando arquivo de informações..."
    
    cat > "$BACKUP_DIR/$BACKUP_NAME/BACKUP_INFO.txt" << EOF
Backup criado em: $(date)
Sistema: $(uname -s)
Versão: $(uname -r)
Hostname: $(hostname)
Usuário: $(whoami)

Conteúdo do backup:
- Configurações do Cursor
- Configurações do VSCode
- Configurações do macOS
- Configurações do Raycast
- Configurações do Karabiner
- Configurações do Git
- Configurações do Shell

Para restaurar:
./scripts/restore-configs.sh $TIMESTAMP
EOF
    
    success "Arquivo de informações criado"
}

# Criar arquivo compactado
create_archive() {
    log "Criando arquivo compactado..."
    
    cd "$BACKUP_DIR"
    tar -czf "$BACKUP_NAME.tar.gz" "$BACKUP_NAME" 2>/dev/null || zip -r "$BACKUP_NAME.zip" "$BACKUP_NAME" 2>/dev/null || true
    
    if [ -f "$BACKUP_DIR/$BACKUP_NAME.tar.gz" ] || [ -f "$BACKUP_DIR/$BACKUP_NAME.zip" ]; then
        success "Arquivo compactado criado"
    fi
}

main() {
    clear
    
    echo "╔═══════════════════════════════════════════════════════════════╗"
    echo "║        Backup de Configurações                               ║"
    echo "║              Versão 2.0.1 - Universal Setup                ║"
    echo "╚═══════════════════════════════════════════════════════════════╝"
    echo ""
    
    create_backup_dir
    
    # Detectar sistema operacional
    if [[ "$OSTYPE" == "darwin"* ]]; then
        backup_cursor
        backup_vscode
        backup_macos
        backup_raycast
        backup_karabiner
    else
        backup_vscode
    fi
    
    backup_git
    backup_shell
    create_backup_info
    create_archive
    
    echo ""
    success "Backup concluído!"
    echo ""
    echo "Localização: $BACKUP_DIR/$BACKUP_NAME"
    echo "Timestamp: $TIMESTAMP"
    echo ""
    echo "Para restaurar:"
    echo "./scripts/restore-configs.sh $TIMESTAMP"
    echo ""
}

main "$@"

