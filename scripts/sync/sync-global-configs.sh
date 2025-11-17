#!/bin/bash
#################################################################################
# Script de Sincronização Global de Configurações
# Versão: 1.0.0
# Objetivo: Sincronizar configurações entre macOS e VPS Ubuntu
#################################################################################

set -euo pipefail

# Cores
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
RED='\033[0;31m'
NC='\033[0m'

# Configuração
DOTFILES_DIR="${HOME}/Dotfiles"
VPS_HOST="vps"
VPS_USER="root"
VPS_DOTFILES="/root/Dotfiles"

log() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Sincronizar para VPS
sync_to_vps() {
    log "Sincronizando configurações para VPS..."

    # Verificar conexão SSH
    if ! ssh -o ConnectTimeout=5 "${VPS_HOST}" "echo 'Connected'" &>/dev/null; then
        error "Não foi possível conectar ao VPS"
        exit 1
    fi

    # Criar estrutura no VPS se não existir
    ssh "${VPS_HOST}" "mkdir -p ${VPS_DOTFILES}/{configs/{mcp,shell},scripts/{shell,raycast},docs,credentials/api-keys}"

    # Sincronizar configurações MCP
    log "Sincronizando configurações MCP..."
    scp "${DOTFILES_DIR}/configs/mcp-servers.json" "${VPS_HOST}:${VPS_DOTFILES}/configs/" || true
    scp "${DOTFILES_DIR}/configs/mcp/"*.json "${VPS_HOST}:${VPS_DOTFILES}/configs/mcp/" 2>/dev/null || true

    # Sincronizar scripts de shell
    log "Sincronizando scripts de shell..."
    scp "${DOTFILES_DIR}/scripts/shell/bashrc-ubuntu.sh" "${VPS_HOST}:${VPS_DOTFILES}/scripts/shell/" || true

    # Sincronizar scripts Raycast (apenas estrutura, não executar no VPS)
    log "Sincronizando scripts Raycast..."
    scp "${DOTFILES_DIR}/scripts/raycast/hostinger-api.sh" "${VPS_HOST}:${VPS_DOTFILES}/scripts/raycast/" 2>/dev/null || true

    # Sincronizar documentação
    log "Sincronizando documentação..."
    scp "${DOTFILES_DIR}/docs/HOSTINGER_API_SETUP.md" "${VPS_HOST}:${VPS_DOTFILES}/docs/" 2>/dev/null || true

    # Sincronizar credenciais (apenas estrutura, não conteúdo)
    log "Sincronizando estrutura de credenciais..."
    ssh "${VPS_HOST}" "mkdir -p ${VPS_DOTFILES}/credentials/api-keys && chmod 700 ${VPS_DOTFILES}/credentials"

    # Sincronizar Hostinger API Key (se existir localmente)
    if [ -f "${DOTFILES_DIR}/credentials/api-keys/hostinger-api-key.txt" ]; then
        log "Sincronizando Hostinger API Key..."
        scp "${DOTFILES_DIR}/credentials/api-keys/hostinger-api-key.txt" "${VPS_HOST}:${VPS_DOTFILES}/credentials/api-keys/" || true
        ssh "${VPS_HOST}" "chmod 600 ${VPS_DOTFILES}/credentials/api-keys/hostinger-api-key.txt"
    fi

    success "Configurações sincronizadas para VPS"
}

# Sincronizar do VPS
sync_from_vps() {
    log "Sincronizando configurações do VPS..."

    # Verificar conexão SSH
    if ! ssh -o ConnectTimeout=5 "${VPS_HOST}" "echo 'Connected'" &>/dev/null; then
        error "Não foi possível conectar ao VPS"
        exit 1
    fi

    # Sincronizar configurações MCP
    log "Sincronizando configurações MCP do VPS..."
    scp "${VPS_HOST}:${VPS_DOTFILES}/configs/mcp-servers.json" "${DOTFILES_DIR}/configs/" 2>/dev/null || true

    # Sincronizar scripts de shell
    log "Sincronizando scripts de shell do VPS..."
    scp "${VPS_HOST}:${VPS_DOTFILES}/scripts/shell/bashrc-ubuntu.sh" "${DOTFILES_DIR}/scripts/shell/" 2>/dev/null || true

    success "Configurações sincronizadas do VPS"
}

# Aplicar configurações no VPS
apply_on_vps() {
    log "Aplicando configurações no VPS..."

    ssh "${VPS_HOST}" << 'EOF'
        # Carregar configuração bash
        if [ -f ~/Dotfiles/scripts/shell/bashrc-ubuntu.sh ]; then
            if ! grep -q "source ~/Dotfiles/scripts/shell/bashrc-ubuntu.sh" ~/.bashrc 2>/dev/null; then
                echo "" >> ~/.bashrc
                echo "# Dotfiles Configuration" >> ~/.bashrc
                echo "source ~/Dotfiles/scripts/shell/bashrc-ubuntu.sh" >> ~/.bashrc
            fi
        fi

        # Aplicar para usuário admin também
        if [ -d /home/admin ]; then
            if [ -f ~/Dotfiles/scripts/shell/bashrc-ubuntu.sh ]; then
                if ! grep -q "source ~/Dotfiles/scripts/shell/bashrc-ubuntu.sh" /home/admin/.bashrc 2>/dev/null; then
                    echo "" >> /home/admin/.bashrc
                    echo "# Dotfiles Configuration" >> /home/admin/.bashrc
                    echo "source ~/Dotfiles/scripts/shell/bashrc-ubuntu.sh" >> /home/admin/.bashrc
                fi
            fi
        fi

        echo "✅ Configurações aplicadas no VPS"
EOF

    success "Configurações aplicadas no VPS"
}

# Menu principal
main() {
    local command="${1:-help}"

    case "$command" in
        "vps"|"to-vps")
            sync_to_vps
            apply_on_vps
            ;;
        "from-vps"|"macos")
            sync_from_vps
            ;;
        "apply")
            apply_on_vps
            ;;
        "help"|*)
            echo "╔═══════════════════════════════════════════════════════════════╗"
            echo "║     Sincronização Global de Configurações Dotfiles            ║"
            echo "╚═══════════════════════════════════════════════════════════════╝"
            echo ""
            echo "Uso: $0 [comando]"
            echo ""
            echo "Comandos:"
            echo "  vps, to-vps    - Sincronizar para VPS e aplicar"
            echo "  from-vps       - Sincronizar do VPS para macOS"
            echo "  apply          - Aplicar configurações no VPS"
            echo "  help           - Mostrar esta ajuda"
            echo ""
            ;;
    esac
}

main "$@"
