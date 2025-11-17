#!/bin/bash

#################################################################################
# Script Universal de Instalação de Extensões
# Versão: 2.0.1
# Objetivo: Instalar extensões em Cursor, VSCode ou qualquer editor compatível
#################################################################################

set -e

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

# Detectar editor
detect_editor() {
    if command -v cursor &> /dev/null; then
        EDITOR_CMD="cursor"
        EDITOR_NAME="Cursor"
        return 0
    elif command -v code &> /dev/null; then
        EDITOR_CMD="code"
        EDITOR_NAME="VSCode"
        return 0
    else
        warning "Nenhum editor compatível encontrado (Cursor ou VSCode)"
        return 1
    fi
}

# Instalar extensões do arquivo JSON
install_from_json() {
    local json_file="$1"
    
    if [ ! -f "$json_file" ]; then
        warning "Arquivo não encontrado: $json_file"
        return 1
    fi
    
    log "Instalando extensões de: $json_file"
    
    # Extrair lista de extensões do JSON
    local extensions=$(cat "$json_file" | grep -o '"[^"]*"' | grep -v "recommendations\|unwantedRecommendations\|extensions" | sed 's/"//g' | grep -v "^$" | head -50)
    
    local count=0
    for ext in $extensions; do
        if [[ "$ext" =~ ^[a-zA-Z0-9][a-zA-Z0-9-]*\.[a-zA-Z0-9][a-zA-Z0-9-]*$ ]]; then
            log "Instalando: $ext"
            $EDITOR_CMD --install-extension "$ext" --force 2>/dev/null || warning "Falha ao instalar: $ext"
            ((count++))
        fi
    done
    
    success "$count extensões processadas"
}

# Instalar extensões individuais
install_extensions() {
    local extensions=("$@")
    
    for ext in "${extensions[@]}"; do
        log "Instalando: $ext"
        $EDITOR_CMD --install-extension "$ext" --force || warning "Falha ao instalar: $ext"
    done
}

# Listar extensões instaladas
list_installed() {
    log "Extensões instaladas em $EDITOR_NAME:"
    $EDITOR_CMD --list-extensions
}

main() {
    clear
    
    echo "╔═══════════════════════════════════════════════════════════════╗"
    echo "║        Instalador Universal de Extensões                    ║"
    echo "║              Versão 2.0.1 - Universal Setup                  ║"
    echo "╚═══════════════════════════════════════════════════════════════╝"
    echo ""
    
    if ! detect_editor; then
        exit 1
    fi
    
    success "Editor detectado: $EDITOR_NAME"
    echo ""
    
    # Verificar se arquivo JSON foi fornecido
    if [ -n "$1" ]; then
        install_from_json "$1"
    else
        # Usar arquivo padrão
        DEFAULT_JSON="$(dirname "$0")/../configs/extensions-universal.json"
        if [ -f "$DEFAULT_JSON" ]; then
            install_from_json "$DEFAULT_JSON"
        else
            warning "Nenhum arquivo de extensões fornecido"
            echo "Uso: $0 [arquivo.json]"
            echo "Ou forneça extensões: $0 ext1 ext2 ext3"
            exit 1
        fi
    fi
    
    echo ""
    list_installed
    echo ""
    success "Instalação concluída!"
}

main "$@"

