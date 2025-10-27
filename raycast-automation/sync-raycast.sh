#!/usr/bin/env bash
set -euo pipefail

# Script para sincronizar Raycast bidirecionalmente
# Uso: ./sync-raycast.sh [direção] [--exclude-sqlite]

# Cores
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

log() { echo -e "${GREEN}[$(date +'%H:%M:%S')]${NC} $1"; }
warn() { echo -e "${YELLOW}[WARNING]${NC} $1"; }
error() { echo -e "${RED}[ERROR]${NC} $1"; }
info() { echo -e "${BLUE}[INFO]${NC} $1"; }

# Configurações
RAYCAST_SRC="$HOME/Library/Application Support/com.raycast.macos"
RAYCAST_BACKUP="$HOME/Dotfiles/raycast-profile"
DIRECTION="${1:-both}"  # both, to-backup, to-raycast
EXCLUDE_SQLITE="${2:-false}"

echo -e "${BLUE}╔══════════════════════════════════════════════════════════════╗"
echo -e "║                    SYNC RAYCAST                                ║"
echo -e "╚══════════════════════════════════════════════════════════════╝${NC}"

# 1. Verificar diretórios
log "Verificando diretórios..."
if [[ ! -d "$RAYCAST_SRC" ]]; then
    error "Diretório do Raycast não encontrado: $RAYCAST_SRC"
    exit 1
fi

if [[ ! -d "$RAYCAST_BACKUP" ]]; then
    log "Criando diretório de backup..."
    mkdir -p "$RAYCAST_BACKUP"
fi

# 2. Preparar opções do rsync
RSYNC_OPTS="-avh --delete"
if [[ "$EXCLUDE_SQLITE" == "true" ]]; then
    RSYNC_OPTS="$RSYNC_OPTS --exclude=*.sqlite*"
    log "Excluindo arquivos SQLite para economizar espaço..."
fi

# 3. Sincronizar baseado na direção
case "$DIRECTION" in
    "to-backup")
        log "Sincronizando Raycast → Backup..."
        rsync $RSYNC_OPTS "$RAYCAST_SRC/" "$RAYCAST_BACKUP/"
        ;;
    "to-raycast")
        log "Sincronizando Backup → Raycast..."
        rsync $RSYNC_OPTS "$RAYCAST_BACKUP/" "$RAYCAST_SRC/"
        ;;
    "both")
        log "Sincronização bidirecional..."
        
        # Primeiro: Raycast → Backup
        log "Raycast → Backup..."
        rsync $RSYNC_OPTS "$RAYCAST_SRC/" "$RAYCAST_BACKUP/"
        
        # Segundo: Backup → Raycast (apenas arquivos mais recentes)
        log "Backup → Raycast (arquivos mais recentes)..."
        rsync -avh --update "$RAYCAST_BACKUP/" "$RAYCAST_SRC/"
        ;;
    *)
        error "Direção inválida: $DIRECTION"
        echo "Uso: $0 [to-backup|to-raycast|both] [--exclude-sqlite]"
        exit 1
        ;;
esac

# 4. Verificar sincronização
log "Verificando sincronização..."
SRC_SIZE=$(du -sh "$RAYCAST_SRC" | cut -f1)
BACKUP_SIZE=$(du -sh "$RAYCAST_BACKUP" | cut -f1)
SRC_FILES=$(find "$RAYCAST_SRC" -type f | wc -l)
BACKUP_FILES=$(find "$RAYCAST_BACKUP" -type f | wc -l)

log "✅ Sincronização concluída!"
log "📁 Raycast: $SRC_SIZE ($SRC_FILES arquivos)"
log "📁 Backup: $BACKUP_SIZE ($BACKUP_FILES arquivos)"

# 5. Criar log de sincronização
log "Criando log de sincronização..."
cat > "$RAYCAST_BACKUP/sync-log.json" << JSON
{
  "timestamp": "$(date -u +%Y-%m-%dT%H:%M:%SZ)",
  "direction": "$DIRECTION",
  "exclude_sqlite": $EXCLUDE_SQLITE,
  "raycast_size": "$SRC_SIZE",
  "backup_size": "$BACKUP_SIZE",
  "raycast_files": $SRC_FILES,
  "backup_files": $BACKUP_FILES
}
JSON

# 6. Resumo final
echo ""
echo -e "${GREEN}╔══════════════════════════════════════════════════════════════╗"
echo -e "║                    SYNC CONCLUÍDO!                             ║"
echo -e "╚══════════════════════════════════════════════════════════════╝${NC}"

info "Sincronização: $DIRECTION"
info "Raycast: $SRC_SIZE ($SRC_FILES arquivos)"
info "Backup: $BACKUP_SIZE ($BACKUP_FILES arquivos)"

echo ""
info "Comandos úteis:"
echo "• Backup completo: ./backup-raycast.sh"
echo "• Restore completo: ./restore-raycast.sh"
echo "• Sync bidirecional: ./sync-raycast.sh both"
echo "• Sync sem SQLite: ./sync-raycast.sh both --exclude-sqlite"

echo ""
log "Sincronização do Raycast concluída! 🎯"
