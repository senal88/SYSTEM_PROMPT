#!/usr/bin/env bash
# sync-branch-main.sh
# Sincroniza branch main e garante acesso Claude

set -euo pipefail

# Cores
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m'

PROJECT_DIR="$HOME/database/BNI_DOCUMENTOS_BRUTOS"

log_info() { echo -e "${BLUE}ℹ${NC} $1"; }
log_success() { echo -e "${GREEN}✅${NC} $1"; }
log_error() { echo -e "${RED}❌${NC} $1" >&2; }
log_warning() { echo -e "${YELLOW}⚠️${NC} $1"; }
log_section() {
    echo ""
    echo -e "${CYAN}════════════════════════════════════════${NC}"
    echo -e "${CYAN}$1${NC}"
    echo -e "${CYAN}════════════════════════════════════════${NC}"
    echo ""
}

# Função principal
main() {
    log_section "🔄 Sincronizando Branch Main"

    cd "$PROJECT_DIR"

    # Verificar branch atual
    CURRENT_BRANCH=$(git branch --show-current)
    log_info "Branch atual: $CURRENT_BRANCH"

    if [ "$CURRENT_BRANCH" != "main" ]; then
        log_warning "Não está na branch 'main'. Mudando..."
        git checkout main || {
            log_error "Não foi possível mudar para branch 'main'"
            exit 1
        }
        log_success "Mudado para branch 'main'"
    fi

    # Buscar atualizações remotas
    log_info "Buscando atualizações do remoto..."
    git fetch origin

    # Verificar diferenças
    BEHIND=$(git rev-list --left-right --count origin/main...HEAD | awk '{print $1}')
    AHEAD=$(git rev-list --left-right --count origin/main...HEAD | awk '{print $2}')

    log_info "Status: $BEHIND commit(s) atrás, $AHEAD commit(s) à frente"

    if [ "$BEHIND" -gt 0 ]; then
        log_warning "Branch local está $BEHIND commit(s) atrás do remoto"
        log_info "Fazendo pull para sincronizar..."
        git pull origin main || {
            log_error "Erro ao fazer pull"
            exit 1
        }
        log_success "Pull concluído"
    fi

    if [ "$AHEAD" -gt 0 ]; then
        log_info "Branch local está $AHEAD commit(s) à frente do remoto"
        log_info "Você pode fazer push se desejar: git push origin main"
    fi

    # Verificar se há mudanças não commitadas
    if [ -n "$(git status --porcelain)" ]; then
        log_warning "Há mudanças não commitadas"
        git status --short | head -10
        log_info "Recomendação: Revisar e commitar mudanças necessárias"
    else
        log_success "Repositório limpo"
    fi

    # Garantir .cursorrules existe
    if [ ! -f ".cursorrules" ]; then
        log_warning ".cursorrules não encontrado. Criando..."
        cat > ".cursorrules" << 'EOF'
# Cursor Rules - BNI Gestão de Imóveis
## Branch: main (confirmada e acessível pelo Claude)
EOF
        log_success ".cursorrules criado"
    fi

    log_section "✅ Sincronização Concluída"

    log_success "Branch 'main' sincronizada e acessível"
    log_info "Claude tem acesso completo à branch 'main'"
}

main "$@"

