#!/usr/bin/env bash
set -euo pipefail

# Raycast Manager - Script principal para gerenciar Raycast (v2 - Consolidado)

# ... (Cores e funções de log) ...

# Configurações
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
MANAGEMENT_DIR="$SCRIPT_DIR/management"
SCRIPTS_DIR="$SCRIPT_DIR/scripts"
RAYCAST_BACKUP="$HOME/Dotfiles/raycast-profile"

show_help() {
    # ... (Help text) ...
    echo "  stirling-convert    Converter arquivo com Stirling-PDF"
    echo "  stirling-control    Controlar o serviço Stirling-PDF"
}

# ... (show_status e clean_files) ...

main() {
    local command="${1:-help}"

    case "$command" in
        "backup")
            log "Fazendo backup do Raycast..."
            "$MANAGEMENT_DIR/backup-raycast.sh" "${@:2}"
            ;;
        "restore")
            log "Restaurando backup do Raycast..."
            "$MANAGEMENT_DIR/restore-raycast.sh" "${@:2}"
            ;;
        "sync")
            log "Sincronizando Raycast..."
            "$MANAGEMENT_DIR/sync-raycast.sh" "${@:2}"
            ;;
        "setup-1password")
            log "Configurando 1Password CLI..."
            "$MANAGEMENT_DIR/setup-1password.sh"
            ;;
        "stirling-convert")
            log "Executando conversão com Stirling-PDF..."
            "$SCRIPTS_DIR/convert.sh" "${@:2}"
            ;;
        "stirling-control")
            log "Controlando serviço Stirling-PDF..."
            "$SCRIPTS_DIR/stirling_control.sh" "${@:2}"
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
            show_help
            exit 1
            ;;
    esac
}

main "$@"
