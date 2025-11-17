#!/bin/bash

#################################################################################
# Script de Sincronização de Configurações
# Versão: 2.0.1
# Objetivo: Sincronizar configurações entre ambientes e projetos
#################################################################################

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"
TARGET_DIR="${1:-$PWD}"

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

# Criar estrutura de diretórios
create_structure() {
    local target="$1"
    
    log "Criando estrutura de diretórios em: $target"
    
    mkdir -p "$target/.vscode"
    mkdir -p "$target/.devcontainer"
    mkdir -p "$target/.cursor"
    mkdir -p "$target/.github/workflows"
    
    success "Estrutura criada"
}

# Copiar configurações do VSCode
sync_vscode_configs() {
    local target="$1"
    
    log "Sincronizando configurações do VSCode..."
    
    if [ -f "$REPO_ROOT/configs/vscode-settings.json" ]; then
        cp "$REPO_ROOT/configs/vscode-settings.json" "$target/.vscode/settings.json"
        success "Settings do VSCode copiados"
    fi
    
    if [ -f "$REPO_ROOT/configs/extensions-universal.json" ]; then
        cp "$REPO_ROOT/configs/extensions-universal.json" "$target/.vscode/extensions.json"
        success "Extensões do VSCode copiadas"
    fi
}

# Copiar configurações do Cursor
sync_cursor_configs() {
    local target="$1"
    
    log "Sincronizando configurações do Cursor..."
    
    if [ -f "$REPO_ROOT/configs/vscode-settings.json" ]; then
        mkdir -p "$target/.cursor"
        cp "$REPO_ROOT/configs/vscode-settings.json" "$target/.cursor/settings.json"
        success "Settings do Cursor copiados"
    fi
}

# Copiar DevContainer
sync_devcontainer() {
    local target="$1"
    
    log "Sincronizando DevContainer..."
    
    if [ -f "$REPO_ROOT/templates/devcontainer/devcontainer.json" ]; then
        cp "$REPO_ROOT/templates/devcontainer/devcontainer.json" "$target/.devcontainer/devcontainer.json"
        success "DevContainer copiado"
    fi
}

# Copiar GitHub Actions
sync_github_actions() {
    local target="$1"
    
    log "Sincronizando GitHub Actions..."
    
    if [ -d "$REPO_ROOT/templates/github/workflows" ]; then
        cp -r "$REPO_ROOT/templates/github/workflows/"* "$target/.github/workflows/" 2>/dev/null || true
        success "GitHub Actions copiados"
    fi
}

# Copiar MCP config
sync_mcp_config() {
    local target="$1"
    
    log "Sincronizando configuração MCP..."
    
    if [ -f "$REPO_ROOT/configs/mcp-servers.json" ]; then
        mkdir -p "$target/.cursor" 2>/dev/null || true
        cp "$REPO_ROOT/configs/mcp-servers.json" "$target/.cursor/mcp-servers.json"
        success "Configuração MCP copiada"
    fi
}

# Criar .gitignore se não existir
create_gitignore() {
    local target="$1"
    
    if [ ! -f "$target/.gitignore" ]; then
        log "Criando .gitignore..."
        cat > "$target/.gitignore" << 'EOF'
# Dependencies
node_modules/
.venv/
__pycache__/
*.pyc
dist/
build/

# IDE
.vscode/
.cursor/
.idea/
*.swp
*.swo
*~

# OS
.DS_Store
Thumbs.db

# Logs
*.log
npm-debug.log*
yarn-debug.log*

# Environment
.env
.env.local
.env.*.local

# Build
.next/
out/
.nuxt/
.cache/
EOF
        success ".gitignore criado"
    fi
}

main() {
    clear
    
    echo "╔═══════════════════════════════════════════════════════════════╗"
    echo "║        Sincronização de Configurações                       ║"
    echo "║              Versão 2.0.1 - Universal Setup                 ║"
    echo "╚═══════════════════════════════════════════════════════════════╝"
    echo ""
    
    if [ ! -d "$TARGET_DIR" ]; then
        warning "Diretório não existe: $TARGET_DIR"
        echo "Criando diretório..."
        mkdir -p "$TARGET_DIR"
    fi
    
    log "Sincronizando para: $TARGET_DIR"
    echo ""
    
    create_structure "$TARGET_DIR"
    sync_vscode_configs "$TARGET_DIR"
    sync_cursor_configs "$TARGET_DIR"
    sync_devcontainer "$TARGET_DIR"
    sync_github_actions "$TARGET_DIR"
    sync_mcp_config "$TARGET_DIR"
    create_gitignore "$TARGET_DIR"
    
    echo ""
    success "Sincronização concluída!"
    echo ""
    echo "Configurações sincronizadas em: $TARGET_DIR"
    echo ""
    echo "Próximas ações:"
    echo "1. Revise as configurações copiadas"
    echo "2. Ajuste conforme necessário"
    echo "3. Commit as mudanças: git add . && git commit -m 'Add universal configs'"
    echo ""
}

main "$@"

