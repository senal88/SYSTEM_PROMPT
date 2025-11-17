#!/usr/bin/env bash
set -euo pipefail

# Script para fazer backup completo do Raycast
# Uso: ./backup-raycast.sh [destino]

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
RAYCAST_BACKUP="${1:-$DOTFILES_HOME/raycast-profile}"
EXCLUDE_SQLITE="${2:-false}"

echo -e "${BLUE}╔══════════════════════════════════════════════════════════════╗"
echo -e "║                    BACKUP RAYCAST                              ║"
echo -e "╚══════════════════════════════════════════════════════════════╝${NC}"

# 1. Verificar se o diretório fonte existe
log "Verificando diretório fonte..."
if [[ ! -d "$RAYCAST_SRC" ]]; then
    error "Diretório do Raycast não encontrado: $RAYCAST_SRC"
    exit 1
fi

# 2. Criar diretório de destino
log "Criando diretório de destino..."
mkdir -p "$RAYCAST_BACKUP"

# 3. Fazer backup
log "Fazendo backup do Raycast..."
if [[ "$EXCLUDE_SQLITE" == "true" ]]; then
    log "Excluindo arquivos SQLite para economizar espaço..."
    rsync -avh --delete --exclude="*.sqlite*" "$RAYCAST_SRC/" "$RAYCAST_BACKUP/"
else
    rsync -avh --delete "$RAYCAST_SRC/" "$RAYCAST_BACKUP/"
fi

# 4. Verificar backup
log "Verificando backup..."
if [[ -d "$RAYCAST_BACKUP" ]] && [[ "$(ls -A "$RAYCAST_BACKUP" 2>/dev/null)" ]]; then
    BACKUP_SIZE=$(du -sh "$RAYCAST_BACKUP" | cut -f1)
    FILE_COUNT=$(find "$RAYCAST_BACKUP" -type f | wc -l)
    log "✅ Backup concluído com sucesso!"
    log "📁 Diretório: $RAYCAST_BACKUP"
    log "📊 Tamanho: $BACKUP_SIZE"
    log "📄 Arquivos: $FILE_COUNT"
else
    error "❌ Falha no backup"
    exit 1
fi

# 5. Criar arquivo de metadados
log "Criando arquivo de metadados..."
cat > "$RAYCAST_BACKUP/backup-info.json" << JSON
{
  "timestamp": "$(date -u +%Y-%m-%dT%H:%M:%SZ)",
  "source": "$RAYCAST_SRC",
  "destination": "$RAYCAST_BACKUP",
  "exclude_sqlite": $EXCLUDE_SQLITE,
  "size": "$BACKUP_SIZE",
  "file_count": $FILE_COUNT,
  "raycast_version": "$(defaults read com.raycast.macos version 2>/dev/null || echo 'unknown')"
}
JSON

# 6. Resumo final
echo ""
echo -e "${GREEN}╔══════════════════════════════════════════════════════════════╗"
echo -e "║                    BACKUP CONCLUÍDO!                          ║"
echo -e "╚══════════════════════════════════════════════════════════════╝${NC}"

info "Backup salvo em: $RAYCAST_BACKUP"
info "Para restaurar: ./restore-raycast.sh $RAYCAST_BACKUP"
info "Para sincronizar: ./sync-raycast.sh $RAYCAST_BACKUP"

echo ""
log "Backup do Raycast concluído! 🎯"
