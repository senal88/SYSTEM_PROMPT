#!/usr/bin/env bash

################################################################################
# 🚀 MASTER - EXECUTAR TODOS OS SCRIPTS
# Executa todos os scripts do sistema em ordem lógica
#
# STATUS: ATIVO (2025-11-28)
# PROPÓSITO: Pipeline completo de atualização e validação
# VERSÃO: 1.0.0
################################################################################

set -euo pipefail

# ============================================================================
# CONFIGURAÇÃO
# ============================================================================

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
DOTFILES_DIR="${DOTFILES_DIR:-${HOME}/Dotfiles}"
GLOBAL_DIR="${DOTFILES_DIR}/system_prompts/global"
TIMESTAMP=$(date +%Y%m%d_%H%M%S)

# Cores
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m'

log_info() {
    echo -e "${BLUE}ℹ️${NC} $@"
}

log_success() {
    echo -e "${GREEN}✅${NC} $@"
}

log_warning() {
    echo -e "${YELLOW}⚠️${NC} $@"
}

log_error() {
    echo -e "${RED}❌${NC} $@"
}

log_step() {
    echo -e "${CYAN}▶${NC} $@"
}

print_header() {
    echo ""
    echo "╔════════════════════════════════════════════════════════════════════════════╗"
    echo "║ $1"
    echo "╚════════════════════════════════════════════════════════════════════════════╝"
    echo ""
}

# ============================================================================
# CARREGAR HOMEBREW
# ============================================================================

load_homebrew() {
    if [ -f "/opt/homebrew/bin/brew" ]; then
        eval "$(/opt/homebrew/bin/brew shellenv)"
    elif [ -f "/usr/local/bin/brew" ]; then
        eval "$(/usr/local/bin/brew shellenv)"
    fi
}

# ============================================================================
# EXECUTAR SCRIPTS EM ORDEM
# ============================================================================

main() {
    print_header "🚀 MASTER - EXECUTAR TODOS OS SCRIPTS"

    log_step "Iniciando pipeline completo..."
    echo ""

    # Carregar Homebrew
    load_homebrew

    cd "${GLOBAL_DIR}"

    # 1. Verificar dependências
    print_header "1️⃣ VERIFICANDO DEPENDÊNCIAS"
    if [ -f "${GLOBAL_DIR}/scripts/verificar-dependencias.sh" ]; then
        "${GLOBAL_DIR}/scripts/verificar-dependencias.sh" || log_warning "Algumas dependências podem estar faltando"
    fi

    # 2. Corrigir dependências se necessário
    print_header "2️⃣ CORRIGINDO DEPENDÊNCIAS"
    if [ -f "${GLOBAL_DIR}/scripts/corrigir-dependencias-completo.sh" ]; then
        "${GLOBAL_DIR}/scripts/corrigir-dependencias-completo.sh" || log_warning "Algumas correções podem ter falhado"
    fi

    # 3. Auditoria completa macOS
    print_header "3️⃣ AUDITORIA COMPLETA macOS"
    if [ -f "${GLOBAL_DIR}/scripts/master-auditoria-completa.sh" ]; then
        "${GLOBAL_DIR}/scripts/master-auditoria-completa.sh" || log_error "Falha na auditoria macOS"
    fi

    # 4. Análise e síntese
    print_header "4️⃣ ANÁLISE E SÍNTESE"
    if [ -f "${GLOBAL_DIR}/scripts/analise-e-sintese.sh" ]; then
        "${GLOBAL_DIR}/scripts/analise-e-sintese.sh" || log_error "Falha na análise e síntese"
    fi

    # 5. Consolidar LLMs
    print_header "5️⃣ CONSOLIDANDO LLMs"
    if [ -f "${GLOBAL_DIR}/scripts/consolidar-llms-full.sh" ]; then
        "${GLOBAL_DIR}/scripts/consolidar-llms-full.sh" || log_error "Falha na consolidação LLMs"
    fi

    # 6. Auditoria 1Password
    print_header "6️⃣ AUDITORIA 1PASSWORD"
    if [ -f "${GLOBAL_DIR}/scripts/auditar-1password-secrets.sh" ]; then
        "${GLOBAL_DIR}/scripts/auditar-1password-secrets.sh" || log_warning "Auditoria 1Password pode ter falhado"
    fi

    # 7. Coletar e adaptar prompts
    print_header "7️⃣ COLETAR E ADAPTAR PROMPTS"
    if [ -f "${GLOBAL_DIR}/scripts/coletar-e-adaptar-prompts.sh" ]; then
        "${GLOBAL_DIR}/scripts/coletar-e-adaptar-prompts.sh" || log_warning "Adaptação de prompts pode ter falhado"
    fi

    # 8. Exportar arquitetura
    print_header "8️⃣ EXPORTAR ARQUITETURA"
    if [ -f "${GLOBAL_DIR}/scripts/exportar-arquitetura.sh" ]; then
        "${GLOBAL_DIR}/scripts/exportar-arquitetura.sh" || log_warning "Exportação de arquitetura pode ter falhado"
    fi

    # Resumo final
    print_header "✅ PIPELINE COMPLETO CONCLUÍDO"

    log_success "Todos os scripts foram executados!"
    echo ""
    log_info "Próximos passos:"
    echo "  1. Revisar relatórios em: ${GLOBAL_DIR}/audit/"
    echo "  2. Verificar llms-full.txt atualizado"
    echo "  3. Revisar prompts adaptados em prompts_temp/"
    echo ""
}

main "$@"

