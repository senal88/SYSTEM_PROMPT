#!/usr/bin/env bash
# update-claude-context.sh
# Atualização automática de contexto para Claude Cloud

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CONTEXT_DIR="$(cd "$SCRIPT_DIR/../.." && pwd)"
DOTFILES_DIR="$(dirname "$CONTEXT_DIR")"
CLAUDE_KNOWLEDGE_DIR="$DOTFILES_DIR/claude-cloud-knowledge"
LOG_FILE="$CONTEXT_DIR/governance/audit/update-$(date +%Y%m%d).log"

log_with_timestamp() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $1" | tee -a "$LOG_FILE"
}

log_with_timestamp "🔄 Iniciando atualização automática de contexto"

# 1. Verificar autenticação
if ! op whoami &>/dev/null; then
    log_with_timestamp "❌ Não autenticado no 1Password"
    exit 1
fi

# 2. Executar script de consolidação
if [ -f "$CONTEXT_DIR/scripts/consolidate-docs-for-claude.sh" ]; then
    log_with_timestamp "📚 Consolidando documentação"
    "$CONTEXT_DIR/scripts/consolidate-docs-for-claude.sh" >> "$LOG_FILE" 2>&1
fi

# 3. Executar script de automação Claude Cloud
if [ -f "$CONTEXT_DIR/scripts/auto-config-claude-cloud.py" ]; then
    log_with_timestamp "🤖 Executando automação Claude Cloud"
    python3 "$CONTEXT_DIR/scripts/auto-config-claude-cloud.py" >> "$LOG_FILE" 2>&1
fi

# 4. Validar arquivos gerados
log_with_timestamp "✅ Atualização concluída"

