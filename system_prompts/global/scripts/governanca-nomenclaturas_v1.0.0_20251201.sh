#!/usr/bin/env bash
set -euo pipefail

################################################################################
# 📐 GOVERNANÇA DE NOMENCLATURAS
#
# Valida e aplica padrões de nomenclatura em:
# - Arquivos e diretórios
# - Secrets do 1Password
# - Variáveis de ambiente
# - Commits Git
#
# Uso: ./governanca-nomenclaturas_v1.0.0_20251201.sh [--fix] [--validate]
#
# STATUS: ATIVO (2025-12-01)
# VERSÃO: 1.0.0
################################################################################

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
GLOBAL_DIR="$(cd "${SCRIPT_DIR}/.." && pwd)"
DOTFILES_DIR="${DOTFILES_DIR:-${HOME}/Dotfiles}"
TIMESTAMP=$(date +%Y%m%d_%H%M%S)
REPORT_DIR="${GLOBAL_DIR}/logs/governanca"
REPORT_FILE="${REPORT_DIR}/nomenclaturas-${TIMESTAMP}.md"

# Flags
FIX_MODE=false
VALIDATE_ONLY=false

# Parse arguments
while [[ $# -gt 0 ]]; do
    case $1 in
        --fix)
            FIX_MODE=true
            shift
            ;;
        --validate)
            VALIDATE_ONLY=true
            shift
            ;;
        *)
            echo "Opção desconhecida: $1"
            exit 1
            ;;
    esac
done

# Cores
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
MAGENTA='\033[0;35m'
NC='\033[0m'

log_info() {
    echo -e "${BLUE}ℹ️${NC} $@" | tee -a "${REPORT_FILE}"
}

log_success() {
    echo -e "${GREEN}✅${NC} $@" | tee -a "${REPORT_FILE}"
}

log_warning() {
    echo -e "${YELLOW}⚠️${NC} $@" | tee -a "${REPORT_FILE}"
}

log_error() {
    echo -e "${RED}❌${NC} $@" | tee -a "${REPORT_FILE}"
}

log_section() {
    echo "" | tee -a "${REPORT_FILE}"
    echo -e "${MAGENTA}╔════════════════════════════════════════════════════════════╗${NC}" | tee -a "${REPORT_FILE}"
    echo -e "${MAGENTA}║${NC} $@" | tee -a "${REPORT_FILE}"
    echo -e "${MAGENTA}╚════════════════════════════════════════════════════════════╝${NC}" | tee -a "${REPORT_FILE}"
    echo "" | tee -a "${REPORT_FILE}"
}

# Criar diretório de relatórios
mkdir -p "${REPORT_DIR}"

# Padrões de nomenclatura
PATTERN_FILE="${GLOBAL_DIR}/.nomenclaturas"
PATTERN_VERSION="1.0.0"

# ============================================================================
# DEFINIR PADRÕES
# ============================================================================

definir_padroes() {
    cat > "${PATTERN_FILE}" << 'EOF'
# Padrões de Nomenclatura - Versão 1.0.0

## Arquivos e Diretórios
- Apenas minúsculas, números, underscore e hífen
- Deve começar com letra minúscula
- Deve terminar com letra ou número
- Não pode ter espaços
- Não pode ter caracteres especiais exceto _ e -

## Scripts Shell
- Formato: nome-funcao_vVERSÃO_DATA.sh
- Exemplo: automacao-completa-cursor_v1.0.0_20251201.sh

## Documentação Markdown
- Formato: NOME_DOCUMENTACAO_vVERSÃO_DATA.md
- Exemplo: AUTOMACAO_COMPLETA_CURSOR_v1.0.0_20251201.md

## Secrets 1Password
- Formato: op://VAULT/ITEM/FIELD
- Vaults: 1p_vps, 1p_macos (minúsculas)
- Items: PascalCase ou snake_case
- Fields: UPPERCASE ou camelCase

## Variáveis de Ambiente
- UPPERCASE com underscore
- Prefixo quando aplicável (OP_, GIT_, GITHUB_)
- Exemplo: OP_SERVICE_ACCOUNT_TOKEN

## Commits Git
- Formato: tipo: descrição curta
- Tipos: feat, fix, docs, chore, refactor, test
- Exemplo: feat: adicionar sistema de automação
EOF

    log_success "Padrões definidos em: ${PATTERN_FILE}"
}

# ============================================================================
# VALIDAR ARQUIVOS E DIRETÓRIOS
# ============================================================================

validar_arquivos_diretorios() {
    log_section "VALIDAÇÃO ARQUIVOS E DIRETÓRIOS"

    log_info "Validando nomenclaturas de arquivos e diretórios..."

    INVALID_FILES=()
    INVALID_DIRS=()

    # Validar arquivos
    find "${DOTFILES_DIR}" -type f \( -name "*.sh" -o -name "*.md" -o -name "*.yml" -o -name "*.yaml" \) | while read file; do
        filename=$(basename "${file}")
        dirname=$(dirname "${file}")

        # Verificar padrão básico
        if ! [[ "${filename}" =~ ^[a-z0-9_.-]+$ ]]; then
            INVALID_FILES+=("${file}")
            log_warning "Nome inválido: ${file}"

            if [[ "${FIX_MODE}" == "true" ]]; then
                # Sugerir nome corrigido
                NEW_NAME=$(echo "${filename}" | tr '[:upper:]' '[:lower:]' | sed 's/[^a-z0-9_.-]/-/g')
                log_info "Sugestão de correção: ${NEW_NAME}"
            fi
        fi
    done

    # Validar diretórios
    find "${DOTFILES_DIR}" -type d | while read dir; do
        dirname=$(basename "${dir}")

        # Ignorar diretórios especiais
        if [[ "${dirname}" =~ ^\. ]] || [[ "${dirname}" == "node_modules" ]] || [[ "${dirname}" == ".git" ]]; then
            continue
        fi

        if ! [[ "${dirname}" =~ ^[a-z0-9_-]+$ ]]; then
            INVALID_DIRS+=("${dir}")
            log_warning "Diretório com nome inválido: ${dir}"
        fi
    done

    if [[ ${#INVALID_FILES[@]} -eq 0 ]] && [[ ${#INVALID_DIRS[@]} -eq 0 ]]; then
        log_success "Todas as nomenclaturas estão válidas"
    else
        log_warning "Arquivos inválidos: ${#INVALID_FILES[@]}, Diretórios inválidos: ${#INVALID_DIRS[@]}"
    fi

    return 0
}

# ============================================================================
# VALIDAR SECRETS 1PASSWORD
# ============================================================================

validar_secrets_1password() {
    log_section "VALIDAÇÃO SECRETS 1PASSWORD"

    log_info "Validando formato de referências 1Password..."

    if ! command -v op &> /dev/null; then
        log_warning "1Password CLI não encontrado, pulando validação"
        return 0
    fi

    # Buscar referências op:// em arquivos
    INVALID_REFS=()

    grep -r "op://" "${DOTFILES_DIR}" --include="*.sh" --include="*.yml" --include="*.yaml" --include="*.env" 2>/dev/null | while read line; do
        file=$(echo "${line}" | cut -d: -f1)
        ref=$(echo "${line}" | grep -o "op://[^ ]*" || echo "")

        if [[ -n "${ref}" ]]; then
            # Validar formato: op://VAULT/ITEM/FIELD
            if ! [[ "${ref}" =~ ^op://[a-z0-9_]+/[^/]+/.+$ ]]; then
                INVALID_REFS+=("${file}:${ref}")
                log_warning "Referência inválida: ${ref} em ${file}"
            fi
        fi
    done

    if [[ ${#INVALID_REFS[@]} -eq 0 ]]; then
        log_success "Todas as referências 1Password estão válidas"
    else
        log_warning "Referências inválidas: ${#INVALID_REFS[@]}"
    fi

    return 0
}

# ============================================================================
# VALIDAR VARIÁVEIS DE AMBIENTE
# ============================================================================

validar_variaveis_ambiente() {
    log_section "VALIDAÇÃO VARIÁVEIS DE AMBIENTE"

    log_info "Validando nomenclaturas de variáveis de ambiente..."

    INVALID_VARS=()

    # Buscar variáveis em arquivos
    grep -r "export\|ENV\|env" "${DOTFILES_DIR}" --include="*.sh" --include="*.env" --include="*.yml" --include="*.yaml" 2>/dev/null | grep -o "[A-Z_][A-Z0-9_]*" | sort -u | while read var; do
        # Validar formato: UPPERCASE com underscore
        if ! [[ "${var}" =~ ^[A-Z][A-Z0-9_]*$ ]]; then
            INVALID_VARS+=("${var}")
            log_warning "Variável com formato inválido: ${var}")
        fi
    done

    if [[ ${#INVALID_VARS[@]} -eq 0 ]]; then
        log_success "Todas as variáveis de ambiente estão válidas"
    else
        log_warning "Variáveis inválidas: ${#INVALID_VARS[@]}"
    fi

    return 0
}

# ============================================================================
# MAIN
# ============================================================================

main() {
    echo ""
    echo -e "${CYAN}╔════════════════════════════════════════════════════════════╗${NC}"
    echo -e "${CYAN}║  GOVERNANÇA DE NOMENCLATURAS                             ║${NC}"
    echo -e "${CYAN}╚════════════════════════════════════════════════════════════╝${NC}"
    echo ""

    log_info "Iniciando governança de nomenclaturas..."
    log_info "Relatório será salvo em: ${REPORT_FILE}"
    echo ""

    # Cabeçalho do relatório
    {
        echo "# Governança de Nomenclaturas"
        echo ""
        echo "**Data:** $(date '+%Y-%m-%d %H:%M:%S')"
        echo "**Versão:** 1.0.0"
        echo "**Modo:** $([ "${FIX_MODE}" == "true" ] && echo "CORREÇÃO" || echo "VALIDAÇÃO")"
        echo ""
        echo "---"
        echo ""
    } > "${REPORT_FILE}"

    # Definir padrões se não existirem
    if [[ ! -f "${PATTERN_FILE}" ]]; then
        definir_padroes
    fi

    # Executar validações
    validar_arquivos_diretorios
    validar_secrets_1password
    validar_variaveis_ambiente

    echo ""
    log_success "╔════════════════════════════════════════════════════════════╗"
    log_success "║  GOVERNANÇA CONCLUÍDA                                    ║"
    log_success "╚════════════════════════════════════════════════════════════╝"
    echo ""

    log_info "Relatório completo: ${REPORT_FILE}"
    echo ""
}

main "$@"
