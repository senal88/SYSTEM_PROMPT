#!/usr/bin/env bash
# ==============================================================================
# 📋 ORGANIZE & AUDIT SCRIPT - Limpeza e Organização do Projeto
# ==============================================================================
# Arquivo: scripts/maintenance/organize-project.sh
# Propósito: Limpar, auditar e organizar o repositório
# ==============================================================================

set -euo pipefail

# COLORS
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;36m'
NC='\033[0m'

log_header() { echo -e "\n${BLUE}▶ $1${NC}"; }
log_success() { echo -e "${GREEN}✅ $1${NC}"; }
log_warning() { echo -e "${YELLOW}⚠️  $1${NC}"; }

REPO_ROOT="${REPO_ROOT:-$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)}"
TIMESTAMP=$(date +%Y%m%d_%H%M%S)

# ═══════════════════════════════════════════════════════════════
# ETAPA 1: Limpar arquivos temporários
# ═══════════════════════════════════════════════════════════════
log_header "1. Removendo Arquivos Temporários"

TEMP_PATTERNS=(
    "*~"
    "*.tmp"
    "*.bak"
    ".DS_Store"
    "*.swp"
    "._*"
    "Thumbs.db"
)

for pattern in "${TEMP_PATTERNS[@]}"; do
    find "$REPO_ROOT" -name "$pattern" -type f -delete 2>/dev/null || true
    log_success "Removido: $pattern"
done

# ═══════════════════════════════════════════════════════════════
# ETAPA 2: Remover diretórios obsoletos
# ═══════════════════════════════════════════════════════════════
log_header "2. Removendo Diretórios Obsoletos"

OBSOLETE_DIRS=(
    "__pycache__"
    ".pytest_cache"
    ".mypy_cache"
    "node_modules"
    ".egg-info"
)

for dir_pattern in "${OBSOLETE_DIRS[@]}"; do
    find "$REPO_ROOT" -type d -name "$dir_pattern" -exec rm -rf {} + 2>/dev/null || true
    log_success "Removido: $dir_pattern"
done

# ═══════════════════════════════════════════════════════════════
# ETAPA 3: Organizar logs antigos
# ═══════════════════════════════════════════════════════════════
log_header "3. Arquivando Logs Antigos"

if [[ -d "$REPO_ROOT/logs" ]]; then
    # Criar diretório archive se não existir
    mkdir -p "$REPO_ROOT/logs/archive"
    
    # Mover logs antigos (>7 dias)
    find "$REPO_ROOT/logs" -maxdepth 1 -name "*.log" -mtime +7 -exec mv {} "$REPO_ROOT/logs/archive/" \;
    
    LOG_COUNT=$(find "$REPO_ROOT/logs/archive" -type f | wc -l)
    log_success "Arquivados $LOG_COUNT logs antigos"
fi

# ═══════════════════════════════════════════════════════════════
# ETAPA 4: Validar estrutura de diretórios
# ═══════════════════════════════════════════════════════════════
log_header "4. Validando Estrutura de Diretórios"

REQUIRED_DIRS=(
    "scripts/bootstrap"
    "scripts/automation"
    "scripts/maintenance"
    "scripts/secrets"
    "scripts/validation"
    "env"
    "templates/env"
    "configs"
    "connect"
    "docs"
    "logs"
    "backups"
)

for dir in "${REQUIRED_DIRS[@]}"; do
    if [[ ! -d "$REPO_ROOT/$dir" ]]; then
        mkdir -p "$REPO_ROOT/$dir"
        log_warning "Criado: $dir"
    else
        log_success "OK: $dir"
    fi
done

# ═══════════════════════════════════════════════════════════════
# ETAPA 5: Criar .gitkeep em diretórios importantes
# ═══════════════════════════════════════════════════════════════
log_header "5. Criando .gitkeep Files"

for dir in "logs" "configs" "connect/data" "backups" "templates/env"; do
    if [[ ! -f "$REPO_ROOT/$dir/.gitkeep" ]]; then
        touch "$REPO_ROOT/$dir/.gitkeep"
        log_success "Criado: $dir/.gitkeep"
    fi
done

# ═══════════════════════════════════════════════════════════════
# ETAPA 6: Verificar permissões
# ═══════════════════════════════════════════════════════════════
log_header "6. Ajustando Permissões"

# Scripts executáveis
find "$REPO_ROOT/scripts" -name "*.sh" -exec chmod +x {} \; 2>/dev/null || true
log_success "Scripts: +x"

# Diretórios 755
find "$REPO_ROOT" -type d -exec chmod 755 {} \; 2>/dev/null || true
log_success "Diretórios: 755"

# ═══════════════════════════════════════════════════════════════
# ETAPA 7: Relatório de Tamanho
# ═══════════════════════════════════════════════════════════════
log_header "7. Relatório de Espaço"

echo "Tamanho por diretório principal:"
du -sh "$REPO_ROOT"/* | sort -h

# ═══════════════════════════════════════════════════════════════
# CONCLUSÃO
# ═══════════════════════════════════════════════════════════════
log_header "ORGANIZAÇAO CONCLUÍDA!"

echo ""
echo "📊 Estatísticas Finais:"
echo "   Diretórios: $(find "$REPO_ROOT" -type d | wc -l)"
echo "   Arquivos: $(find "$REPO_ROOT" -type f | wc -l)"
echo "   Tamanho: $(du -sh "$REPO_ROOT" | awk '{print $1}')"
echo ""
