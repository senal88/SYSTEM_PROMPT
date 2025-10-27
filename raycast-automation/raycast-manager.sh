#!/usr/bin/env bash
set -euo pipefail

# Raycast Manager - Script principal para gerenciar Raycast
# Uso: ./raycast-manager.sh [comando] [opções]

# Cores
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
NC='\033[0m'

log() { echo -e "${GREEN}[$(date +'%H:%M:%S')]${NC} $1"; }
warn() { echo -e "${YELLOW}[WARNING]${NC} $1"; }
error() { echo -e "${RED}[ERROR]${NC} $1"; }
info() { echo -e "${BLUE}[INFO]${NC} $1"; }
success() { echo -e "${GREEN}[SUCCESS]${NC} $1"; }

# Configurações
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
RAYCAST_SRC="$HOME/Library/Application Support/com.raycast.macos"
RAYCAST_BACKUP="$HOME/Dotfiles/raycast-profile"

show_help() {
    echo -e "${BLUE}╔══════════════════════════════════════════════════════════════╗"
    echo -e "║                    RAYCAST MANAGER                              ║"
    echo -e "║              Gerenciador Completo do Raycast                   ║"
    echo -e "╚══════════════════════════════════════════════════════════════╝${NC}"
    echo ""
    echo -e "${PURPLE}COMANDOS DISPONÍVEIS:${NC}"
    echo ""
    echo -e "${GREEN}  install${NC}           Instalar Raycast + 1Password + Scripts"
    echo -e "${GREEN}  setup-1password${NC}   Configurar 1Password CLI"
    echo -e "${GREEN}  test${NC}              Testar instalação"
    echo ""
    echo -e "${YELLOW}  backup${NC}            Fazer backup do Raycast"
    echo -e "${YELLOW}  restore${NC}           Restaurar backup do Raycast"
    echo -e "${YELLOW}  sync${NC}              Sincronizar Raycast ↔ Backup"
    echo ""
    echo -e "${BLUE}  status${NC}             Mostrar status atual"
    echo -e "${BLUE}  clean${NC}              Limpar arquivos temporários"
    echo -e "${BLUE}  help${NC}               Mostrar esta ajuda"
    echo ""
    echo -e "${PURPLE}EXEMPLOS:${NC}"
    echo "  ./raycast-manager.sh install"
    echo "  ./raycast-manager.sh backup"
    echo "  ./raycast-manager.sh sync both"
    echo "  ./raycast-manager.sh restore --force"
    echo ""
}

show_status() {
    echo -e "${BLUE}╔══════════════════════════════════════════════════════════════╗"
    echo -e "║                    STATUS RAYCAST                              ║"
    echo -e "╚══════════════════════════════════════════════════════════════╝${NC}"
    
    # Raycast
    if ls /Applications/Raycast.app >/dev/null 2>&1; then
        success "✅ Raycast instalado"
    else
        error "❌ Raycast não instalado"
    fi
    
    # 1Password CLI
    if command -v op >/dev/null 2>&1; then
        success "✅ 1Password CLI instalado"
        if op account list >/dev/null 2>&1; then
            success "✅ 1Password CLI autenticado"
        else
            warn "⚠️  1Password CLI não autenticado"
        fi
    else
        error "❌ 1Password CLI não instalado"
    fi
    
    # Diretório do Raycast
    if [[ -d "$RAYCAST_SRC" ]]; then
        RAYCAST_SIZE=$(du -sh "$RAYCAST_SRC" | cut -f1)
        RAYCAST_FILES=$(find "$RAYCAST_SRC" -type f | wc -l)
        success "✅ Diretório Raycast: $RAYCAST_SIZE ($RAYCAST_FILES arquivos)"
    else
        error "❌ Diretório Raycast não encontrado"
    fi
    
    # Backup
    if [[ -d "$RAYCAST_BACKUP" ]]; then
        BACKUP_SIZE=$(du -sh "$RAYCAST_BACKUP" | cut -f1)
        BACKUP_FILES=$(find "$RAYCAST_BACKUP" -type f | wc -l)
        success "✅ Backup: $BACKUP_SIZE ($BACKUP_FILES arquivos)"
    else
        warn "⚠️  Backup não encontrado"
    fi
    
    # Scripts
    if [[ -f "$SCRIPT_DIR/install.sh" ]]; then
        success "✅ Scripts instalados"
    else
        error "❌ Scripts não encontrados"
    fi
}

clean_files() {
    log "Limpando arquivos temporários..."
    
    # Limpar logs antigos
    find "$SCRIPT_DIR" -name "*.log" -mtime +7 -delete 2>/dev/null || true
    
    # Limpar backups antigos
    find "$RAYCAST_BACKUP" -name "current-backup-*" -mtime +30 -exec rm -rf {} \; 2>/dev/null || true
    
    # Limpar arquivos SQLite do backup (opcional)
    if [[ -d "$RAYCAST_BACKUP" ]]; then
        find "$RAYCAST_BACKUP" -name "*.sqlite*" -delete 2>/dev/null || true
        log "Arquivos SQLite removidos do backup"
    fi
    
    success "Limpeza concluída!"
}

# Função principal
main() {
    local command="${1:-help}"
    
    case "$command" in
        "install")
            log "Iniciando instalação completa..."
            "$SCRIPT_DIR/install.sh"
            ;;
        "setup-1password")
            log "Configurando 1Password CLI..."
            "$SCRIPT_DIR/setup-1password.sh"
            ;;
        "test")
            log "Testando instalação..."
            "$SCRIPT_DIR/test-installation.sh"
            ;;
        "backup")
            log "Fazendo backup do Raycast..."
            "$SCRIPT_DIR/backup-raycast.sh" "${@:2}"
            ;;
        "restore")
            log "Restaurando backup do Raycast..."
            "$SCRIPT_DIR/restore-raycast.sh" "${@:2}"
            ;;
        "sync")
            log "Sincronizando Raycast..."
            "$SCRIPT_DIR/sync-raycast.sh" "${@:2}"
            ;;
        "status")
            show_status
            ;;
        "clean")
            clean_files
            ;;
        "help"|"--help"|"-h")
            show_help
            ;;
        *)
            error "Comando inválido: $command"
            echo ""
            show_help
            exit 1
            ;;
    esac
}

# Executar função principal
main "$@"
