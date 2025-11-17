#!/usr/bin/env bash
#
# cleanup-obsolete-files.sh
# Script para backup e remoção automática de arquivos obsoletos
# Mantém governança parametrizada e atualiza documentação
#
# Uso: bash scripts/maintenance/cleanup-obsolete-files.sh
#

set -euo pipefail

# Cores para output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Função de logging
log_info() {
    echo -e "${BLUE}ℹ️  $1${NC}"
}

log_success() {
    echo -e "${GREEN}✅ $1${NC}"
}

log_warning() {
    echo -e "${YELLOW}⚠️  $1${NC}"
}

log_error() {
    echo -e "${RED}❌ $1${NC}"
}

# Variáveis globais
REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
BACKUP_DIR="$REPO_ROOT/.backups/cleanup-$(date +%Y%m%d-%H%M%S)"
TODAY_DATE="2025-10-29"
CLEANUP_LOG="$BACKUP_DIR/cleanup.log"

# Criar diretório de backup
mkdir -p "$BACKUP_DIR"

# Função para registrar operação
log_operation() {
    echo "[$(date +'%Y-%m-%d %H:%M:%S')] $1" | tee -a "$CLEANUP_LOG"
}

echo -e "${BLUE}╔══════════════════════════════════════════════════════════════╗"
echo -e "║          CLEANUP DE ARQUIVOS OBSOLETOS                   ║"
echo -e "╚══════════════════════════════════════════════════════════════╝${NC}"
echo ""

log_info "Repositório: $REPO_ROOT"
log_info "Backup em: $BACKUP_DIR"
log_info "Data: $TODAY_DATE"
echo ""

# ============================================================================
# ARQUIVOS OBSOLETOS IDENTIFICADOS
# ============================================================================

log_info "🔍 Identificando arquivos obsoletos..."

# Array de arquivos obsoletos
declare -a OBSOLETE_FILES=(
    "1password-credentials.json"  # Versão antiga na raiz
    ".tmp_tree.txt"               # Arquivo temporário
    "estrutura_diretorios.txt"    # Backup de estrutura
)

# Contador
BACKED_UP=0
REMOVED=0

# ============================================================================
# BACKUP E REMOÇÃO
# ============================================================================

log_info "📦 Fazendo backup de arquivos obsoletos..."

for file in "${OBSOLETE_FILES[@]}"; do
    FILE_PATH="$REPO_ROOT/$file"
    
    if [[ -f "$FILE_PATH" ]]; then
        log_warning "Processando: $file"
        
        # Fazer backup
        mkdir -p "$(dirname "$BACKUP_DIR/$file")"
        cp -v "$FILE_PATH" "$BACKUP_DIR/$file" >> "$CLEANUP_LOG" 2>&1
        ((BACKED_UP++))
        
        # Remover arquivo original
        rm -f "$FILE_PATH"
        ((REMOVED++))
        
        log_success "Backed up e removido: $file"
    else
        log_info "Não encontrado: $file (já foi removido)"
    fi
done

# ============================================================================
# LIMPEZA DE DIREtóRIOS VAZIOS OBSOLETOS
# ============================================================================

log_info "🧹 Limpando diretórios obsoletos vazios..."

OBSOLETE_DIRS=(
    "connect/macos_connect_server"
)

for dir in "${OBSOLETE_DIRS[@]}"; do
    DIR_PATH="$REPO_ROOT/$dir"
    
    if [[ -d "$DIR_PATH" ]]; then
        if [[ -z "$(ls -A "$DIR_PATH" 2>/dev/null)" ]]; then
            rmdir "$DIR_PATH" 2>/dev/null && log_success "Diretório vazio removido: $dir"
        else
            log_info "Diretório não vazio (mantido): $dir"
        fi
    fi
done

# ============================================================================
# RESUMO
# ============================================================================

echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
log_success "🔧 CLEANUP CONCLUÍDO"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""

log_info "Estatísticas:"
echo "  • Arquivos em backup: $BACKED_UP"
echo "  • Arquivos removidos: $REMOVED"
echo "  • Local do backup: $BACKUP_DIR"
echo ""

if [[ $BACKED_UP -gt 0 ]]; then
    log_success "Backup completo! Arquivos obsoletos preservados."
    log_info "Para restaurar: cp -r $BACKUP_DIR/* $REPO_ROOT/"
else
    log_info "Nenhum arquivo obsoleto encontrado."
fi

echo ""
log_info "📋 Próximos passos:"
echo "  1. Revisar backup em: $BACKUP_DIR"
echo "  2. Validar estrutura: bash scripts/validation/validate_architecture.sh"
echo "  3. Atualizar documentação se necessário"
echo ""

# Criar arquivo de manifesto do backup
cat > "$BACKUP_DIR/MANIFEST.txt" << EOF
Cleanup de Arquivos Obsoletos
Data: $TODAY_DATE
Realizado por: scripts/maintenance/cleanup-obsolete-files.sh

Arquivos em Backup:
$(ls -lh "$BACKUP_DIR" | tail -n +2 | awk '{print $9, "(" $5 ")"}')

Para restaurar:
  cp -r "$BACKUP_DIR"/* "$REPO_ROOT/"

EOF

log_success "Manifesto criado: $BACKUP_DIR/MANIFEST.txt"

exit 0
