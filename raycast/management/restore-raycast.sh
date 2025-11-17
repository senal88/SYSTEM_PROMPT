#!/usr/bin/env bash
set -euo pipefail

# Script para restaurar backup do Raycast
# Uso: ./restore-raycast.sh [origem] [--force]

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
RAYCAST_BACKUP="${1:-$HOME/Dotfiles/raycast-profile}"
RAYCAST_DEST="$HOME/Library/Application Support/com.raycast.macos"
FORCE_RESTORE="${2:-false}"

echo -e "${BLUE}╔══════════════════════════════════════════════════════════════╗"
echo -e "║                    RESTORE RAYCAST                             ║"
echo -e "╚══════════════════════════════════════════════════════════════╝${NC}"

# 1. Verificar se o backup existe
log "Verificando backup..."
if [[ ! -d "$RAYCAST_BACKUP" ]]; then
    error "Backup não encontrado: $RAYCAST_BACKUP"
    exit 1
fi

# 2. Verificar se há dados no backup
if [[ ! "$(ls -A "$RAYCAST_BACKUP" 2>/dev/null)" ]]; then
    error "Backup vazio: $RAYCAST_BACKUP"
    exit 1
fi

# 3. Fazer backup do estado atual (se existir)
if [[ -d "$RAYCAST_DEST" ]] && [[ "$FORCE_RESTORE" != "--force" ]]; then
    log "Fazendo backup do estado atual..."
    CURRENT_BACKUP="$RAYCAST_BACKUP/current-backup-$(date +%Y%m%d-%H%M%S)"
    mkdir -p "$CURRENT_BACKUP"
    rsync -avh "$RAYCAST_DEST/" "$CURRENT_BACKUP/"
    log "✅ Backup atual salvo em: $CURRENT_BACKUP"
fi

# 4. Parar o Raycast se estiver rodando
log "Parando Raycast..."
pkill -f "Raycast" 2>/dev/null || true
sleep 2

# 5. Criar diretório de destino
log "Criando diretório de destino..."
mkdir -p "$RAYCAST_DEST"

# 6. Restaurar backup
log "Restaurando backup..."
rsync -avh --delete "$RAYCAST_BACKUP/" "$RAYCAST_DEST/"

# 7. Verificar restauração
log "Verificando restauração..."
if [[ -d "$RAYCAST_DEST" ]] && [[ "$(ls -A "$RAYCAST_DEST" 2>/dev/null)" ]]; then
    RESTORE_SIZE=$(du -sh "$RAYCAST_DEST" | cut -f1)
    FILE_COUNT=$(find "$RAYCAST_DEST" -type f | wc -l)
    log "✅ Restauração concluída com sucesso!"
    log "📁 Diretório: $RAYCAST_DEST"
    log "📊 Tamanho: $RESTORE_SIZE"
    log "📄 Arquivos: $FILE_COUNT"
else
    error "❌ Falha na restauração"
    exit 1
fi

# 8. Ajustar permissões
log "Ajustando permissões..."
chmod -R 755 "$RAYCAST_DEST"

# 9. Reiniciar Raycast
log "Reiniciando Raycast..."
open -a "Raycast" 2>/dev/null || true

# 10. Resumo final
echo ""
echo -e "${GREEN}╔══════════════════════════════════════════════════════════════╗"
echo -e "║                    RESTORE CONCLUÍDO!                         ║"
echo -e "╚══════════════════════════════════════════════════════════════╝${NC}"

info "Raycast restaurado de: $RAYCAST_BACKUP"
info "Para fazer novo backup: ./backup-raycast.sh"
info "Para sincronizar: ./sync-raycast.sh $RAYCAST_BACKUP"

echo ""
warn "⚠️  Reinicie o Raycast manualmente se necessário"
warn "⚠️  Verifique as permissões do sistema"

echo ""
log "Restore do Raycast concluído! 🎯"
