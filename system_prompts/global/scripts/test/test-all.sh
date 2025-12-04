#!/usr/bin/env bash
################################################################################
# 🧪 SUITE COMPLETA DE TESTES - SISTEMA DE PROMPTS GLOBAL
#
# DESCRIÇÃO:
#   Executa todos os testes do sistema de prompts globais para validar
#   funcionalidade, sincronização e integrações.
#
# VERSÃO: 1.0.0
# DATA: 2025-01-15
# STATUS: ATIVO
################################################################################

set -euo pipefail

# Configuração
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
GLOBAL_DIR="$(cd "${SCRIPT_DIR}/../../.." && pwd)"
DOTFILES_DIR="${DOTFILES_DIR:-${HOME}/Dotfiles}"
VPS_HOST="${VPS_HOST:-admin-vps}"
VPS_USER="${VPS_USER:-admin}"

# Cores
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

# Contadores
TESTS_PASSED=0
TESTS_FAILED=0

log_info() {
    echo -e "${BLUE}[TEST]${NC} $*"
}

log_success() {
    echo -e "${GREEN}[✅ PASS]${NC} $*"
    ((TESTS_PASSED++))
}

log_error() {
    echo -e "${RED}[❌ FAIL]${NC} $*"
    ((TESTS_FAILED++))
}

print_header() {
    echo ""
    echo "╔════════════════════════════════════════════════════════════════════════════╗"
    echo "║ $1"
    echo "╚════════════════════════════════════════════════════════════════════════════╝"
    echo ""
}

# Teste de estrutura de diretórios
test_structure() {
    print_header "📁 TESTE: Estrutura de Diretórios"

    local required_dirs=(
        "${DOTFILES_DIR}/system_prompts/global/prompts"
        "${DOTFILES_DIR}/system_prompts/global/docs"
        "${DOTFILES_DIR}/system_prompts/global/scripts"
        "${DOTFILES_DIR}/system_prompts/global/logs"
    )

    for dir in "${required_dirs[@]}"; do
        if [[ -d "$dir" ]]; then
            log_success "Diretório existe: $(basename ${dir})"
        else
            log_error "Diretório não existe: ${dir}"
        fi
    done
}

# Teste de conectividade SSH
test_ssh() {
    print_header "🌐 TESTE: Conectividade SSH"

    if ssh -o ConnectTimeout=5 -o BatchMode=yes "${VPS_USER}@${VPS_HOST}" "echo 'OK'" >/dev/null 2>&1; then
        log_success "Conexão SSH estabelecida"
    else
        log_error "Falha na conexão SSH"
    fi
}

# Teste de scripts executáveis
test_scripts() {
    print_header "🔧 TESTE: Scripts Executáveis"

    local scripts=(
        "${GLOBAL_DIR}/scripts/sync/sync-system-prompts.sh"
        "${GLOBAL_DIR}/scripts/validate/validate-pre-execution.sh"
        "${GLOBAL_DIR}/scripts/install/setup-system-prompts.sh"
    )

    for script in "${scripts[@]}"; do
        if [[ -f "$script" ]] && [[ -x "$script" ]]; then
            log_success "Script executável: $(basename ${script})"
        else
            log_error "Script não executável ou não existe: ${script}"
        fi
    done
}

# Teste de arquivos principais
test_files() {
    print_header "📄 TESTE: Arquivos Principais"

    local files=(
        "${GLOBAL_DIR}/docs/PLANEJAMENTO_IMPLANTACAO_DEFINITIVA.md"
        "${GLOBAL_DIR}/docs/RESUMO_EXECUTIVO.md"
        "${GLOBAL_DIR}/docs/STATUS_IMPLANTACAO.md"
        "${GLOBAL_DIR}/prompts/system/CURSOR_2.0_SYSTEM_PROMPT_FINAL.md"
    )

    for file in "${files[@]}"; do
        if [[ -f "$file" ]]; then
            local size=$(wc -l < "$file" 2>/dev/null || echo "0")
            log_success "Arquivo existe: $(basename ${file}) (${size} linhas)"
        else
            log_error "Arquivo não existe: ${file}"
        fi
    done
}

# Teste de sincronização (dry-run)
test_sync_dry_run() {
    print_header "🔄 TESTE: Sincronização (Dry-Run)"

    if [[ -f "${GLOBAL_DIR}/scripts/sync/sync-system-prompts.sh" ]]; then
        if "${GLOBAL_DIR}/scripts/sync/sync-system-prompts.sh" dry-run >/dev/null 2>&1; then
            log_success "Sincronização dry-run funcionando"
        else
            log_error "Sincronização dry-run falhou"
        fi
    else
        log_error "Script de sincronização não encontrado"
    fi
}

# Resumo de testes
print_summary() {
    print_header "📊 RESUMO DOS TESTES"

    local total=$((TESTS_PASSED + TESTS_FAILED))
    local pass_rate=0

    if [[ $total -gt 0 ]]; then
        pass_rate=$((TESTS_PASSED * 100 / total))
    fi

    echo "Testes aprovados: ${TESTS_PASSED}"
    echo "Testes falhados: ${TESTS_FAILED}"
    echo "Total de testes: ${total}"
    echo "Taxa de aprovação: ${pass_rate}%"
    echo ""

    if [[ $TESTS_FAILED -eq 0 ]]; then
        log_success "✅ TODOS OS TESTES PASSARAM!"
        return 0
    else
        log_error "❌ ALGUNS TESTES FALHARAM!"
        return 1
    fi
}

# Função principal
main() {
    print_header "🧪 SUITE COMPLETA DE TESTES"

    test_structure
    test_ssh
    test_scripts
    test_files
    test_sync_dry_run

    print_summary
}

main "$@"

