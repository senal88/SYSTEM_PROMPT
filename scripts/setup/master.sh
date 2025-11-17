#!/bin/bash

#################################################################################
# Script Master de Instalação Universal
# Versão: 2.0.1
# Objetivo: Instalação completa e unificada de todo o stack
#################################################################################

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$HOME/Dotfiles"

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
detect_os() {
    if [[ "$OSTYPE" == "darwin"* ]]; then
        OS="macos"
        success "Sistema detectado: macOS"
    elif [[ "$OSTYPE" == "linux-gnu"* ]]; then
        OS="linux"
        success "Sistema detectado: Linux"
    else
        warning "Sistema operacional não suportado: $OSTYPE"
        exit 1
    fi
}

# Executar setup do macOS
setup_macos() {
    log "Iniciando setup do macOS..."
    
    # Aplicar configurações do Cursor
    if [ -f "$REPO_ROOT/scripts/install/cursor.sh" ]; then
        log "Aplicando configurações do Cursor 2.0..."
        bash "$REPO_ROOT/scripts/install/cursor.sh"
    else
        warning "Script de instalação do Cursor não encontrado"
    fi
}

# Executar setup do Ubuntu/Linux
setup_linux() {
    log "Iniciando setup do Linux..."
    
    if [ -f "$REPO_ROOT/scripts/setup-ubuntu.sh" ]; then
        bash "$REPO_ROOT/scripts/setup-ubuntu.sh"
    else
        warning "Script de setup do Linux não encontrado"
    fi
}

# Instalar extensões
install_extensions() {
    log "Instalando extensões..."
    
    if [ -f "$REPO_ROOT/scripts/install-extensions.sh" ]; then
        bash "$REPO_ROOT/scripts/install-extensions.sh"
    else
        warning "Script de instalação de extensões não encontrado"
    fi
}

# Sincronizar configurações
sync_configs() {
    log "Sincronizando configurações..."
    
    if [ -f "$REPO_ROOT/scripts/sync-configs.sh" ]; then
        bash "$REPO_ROOT/scripts/sync-configs.sh" "$REPO_ROOT"
    else
        warning "Script de sincronização não encontrado"
    fi
}

# Criar backup antes de instalar
create_backup() {
    log "Criando backup antes da instalação..."
    
    if [ -f "$REPO_ROOT/scripts/backup-configs.sh" ]; then
        bash "$REPO_ROOT/scripts/backup-configs.sh"
    else
        warning "Script de backup não encontrado"
    fi
}

main() {
    clear
    
    echo "╔═══════════════════════════════════════════════════════════════╗"
    echo "║        Setup Master Universal - Stack Completo               ║"
    echo "║              Versão 2.0.1 - Universal Setup                  ║"
    echo "╚═══════════════════════════════════════════════════════════════╝"
    echo ""
    
    detect_os
    
    echo ""
    warning "Este script irá instalar e configurar todo o stack de desenvolvimento."
    read -p "Continuar? (s/N): " confirm
    
    if [[ ! "$confirm" =~ ^[Ss]$ ]]; then
        log "Operação cancelada"
        exit 0
    fi
    
    echo ""
    
    # Criar backup primeiro
    create_backup
    
    echo ""
    
    # Executar setup específico do OS
    if [ "$OS" == "macos" ]; then
        setup_macos
    elif [ "$OS" == "linux" ]; then
        setup_linux
    fi
    
    echo ""
    
    # Instalar extensões
    install_extensions
    
    echo ""
    
    # Sincronizar configurações
    sync_configs
    
    echo ""
    
    # Aplicar configurações específicas do editor
    if [ "$OS" == "macos" ]; then
        log "Aplicando configurações específicas do macOS..."
        if [ -f "$REPO_ROOT/scripts/apply-cursor-config.sh" ]; then
            bash "$REPO_ROOT/scripts/apply-cursor-config.sh"
        fi
    fi
    
    echo ""
    echo "╔═══════════════════════════════════════════════════════════════╗"
    echo "║              SETUP COMPLETO E FUNCIONAL                     ║"
    echo "╚═══════════════════════════════════════════════════════════════╝"
    echo ""
    success "Todas as etapas completadas!"
    echo ""
    echo "Próximas ações:"
    echo "1. Revise as configurações aplicadas"
    echo "2. Reinicie os aplicativos (Cursor, VSCode, etc.)"
    echo "3. Configure tokens e secrets conforme necessário"
    echo "4. Teste todas as funcionalidades"
    echo ""
    echo "Documentação completa: $REPO_ROOT/SYSTEM_PROMPT_GLOBAL.md"
    echo ""
}

main "$@"

