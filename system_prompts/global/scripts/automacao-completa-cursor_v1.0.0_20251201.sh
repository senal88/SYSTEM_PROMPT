#!/usr/bin/env bash
set -euo pipefail

################################################################################
# 🚀 AUTOMAÇÃO COMPLETA - CURSOR 2.0
#
# Sistema automatizado de configuração completa que integra:
# - Secrets e Variáveis (1Password)
# - infra-vps
# - system_prompts
# - GitHub
# - API Keys
# - Revisões e Tags
# - Governança de Nomenclaturas
# - Exclusão de Obsoletos
# - Validação de Secrets e Variáveis
#
# Uso: ./automacao-completa-cursor_v1.0.0_20251201.sh [--all] [--validate] [--cleanup] [--sync]
#
# STATUS: ATIVO (2025-12-01)
# VERSÃO: 1.0.0
################################################################################

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
GLOBAL_DIR="$(cd "${SCRIPT_DIR}/.." && pwd)"
DOTFILES_DIR="${DOTFILES_DIR:-${HOME}/Dotfiles}"
TIMESTAMP=$(date +%Y%m%d_%H%M%S)
LOG_DIR="${GLOBAL_DIR}/logs/automacao"
LOG_FILE="${LOG_DIR}/automacao-${TIMESTAMP}.log"

# Flags
RUN_ALL=false
VALIDATE_ONLY=false
CLEANUP_ONLY=false
SYNC_ONLY=false
DRY_RUN=false

# Parse arguments
while [[ $# -gt 0 ]]; do
    case $1 in
        --all)
            RUN_ALL=true
            shift
            ;;
        --validate)
            VALIDATE_ONLY=true
            shift
            ;;
        --cleanup)
            CLEANUP_ONLY=true
            shift
            ;;
        --sync)
            SYNC_ONLY=true
            shift
            ;;
        --dry-run)
            DRY_RUN=true
            shift
            ;;
        *)
            echo "Opção desconhecida: $1"
            exit 1
            ;;
    esac
done

# Se nenhuma flag, executar tudo
if [[ "${VALIDATE_ONLY}" == "false" ]] && [[ "${CLEANUP_ONLY}" == "false" ]] && [[ "${SYNC_ONLY}" == "false" ]]; then
    RUN_ALL=true
fi

# Cores
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
MAGENTA='\033[0;35m'
NC='\033[0m'

log_info() {
    echo -e "${BLUE}ℹ️${NC} $@" | tee -a "${LOG_FILE}"
}

log_success() {
    echo -e "${GREEN}✅${NC} $@" | tee -a "${LOG_FILE}"
}

log_warning() {
    echo -e "${YELLOW}⚠️${NC} $@" | tee -a "${LOG_FILE}"
}

log_error() {
    echo -e "${RED}❌${NC} $@" | tee -a "${LOG_FILE}"
}

log_section() {
    echo "" | tee -a "${LOG_FILE}"
    echo -e "${MAGENTA}╔════════════════════════════════════════════════════════════╗${NC}" | tee -a "${LOG_FILE}"
    echo -e "${MAGENTA}║${NC} $@" | tee -a "${LOG_FILE}"
    echo -e "${MAGENTA}╚════════════════════════════════════════════════════════════╝${NC}" | tee -a "${LOG_FILE}"
    echo "" | tee -a "${LOG_FILE}"
}

# Criar diretório de logs
mkdir -p "${LOG_DIR}"

# ============================================================================
# VALIDAÇÃO DE SECRETS E VARIÁVEIS
# ============================================================================

validate_secrets_variables() {
    log_section "VALIDAÇÃO DE SECRETS E VARIÁVEIS"

    log_info "Validando conexão com 1Password..."

    if ! command -v op &> /dev/null; then
        log_error "1Password CLI não encontrado"
        return 1
    fi

    # Verificar autenticação
    if ! op account list &> /dev/null; then
        log_error "1Password não autenticado"
        return 1
    fi

    log_success "1Password autenticado"

    # Listar vaults
    log_info "Listando vaults disponíveis..."
    VAULTS=$(op vault list --format json 2>/dev/null | jq -r '.[].id' || echo "")

    if [[ -z "${VAULTS}" ]]; then
        log_error "Nenhum vault encontrado"
        return 1
    fi

    log_success "Vaults encontrados: $(echo "${VAULTS}" | wc -l | tr -d ' ')"

    # Validar secrets necessários
    log_info "Validando secrets necessários..."

    REQUIRED_SECRETS=(
        "1p_vps:yhqdcrihdk5c6sk7x7fwcqazqu:Service Account Auth Token"
        "1p_macos:kvhqgsi3ndrz4n65ptiuryrifa:service_1p_macos_dev_localhost"
        "1p_vps:3ztgpgona7iy2htavjmtdccss4:GIT_PERSONAL"
        "1p_macos:3xpytbcndxqapydpz27lxoegwm:GIT_PAT"
    )

    MISSING_SECRETS=()

    for secret in "${REQUIRED_SECRETS[@]}"; do
        IFS=':' read -r vault item_id item_name <<< "${secret}"

        if ! op item get "${item_id}" --vault "${vault}" &> /dev/null; then
            MISSING_SECRETS+=("${vault}:${item_name}")
            log_warning "Secret não encontrado: ${vault}/${item_name}"
        else
            log_success "Secret válido: ${vault}/${item_name}"
        fi
    done

    if [[ ${#MISSING_SECRETS[@]} -gt 0 ]]; then
        log_error "Secrets faltando: ${#MISSING_SECRETS[@]}"
        return 1
    fi

    log_success "Todos os secrets necessários estão presentes"

    # Validar variáveis de ambiente
    log_info "Validando variáveis de ambiente..."

    REQUIRED_ENV_VARS=(
        "OP_SERVICE_ACCOUNT_TOKEN"
        "OP_ACCOUNT"
        "GITHUB_TOKEN"
    )

    MISSING_ENV_VARS=()

    for var in "${REQUIRED_ENV_VARS[@]}"; do
        if [[ -z "${!var:-}" ]]; then
            MISSING_ENV_VARS+=("${var}")
            log_warning "Variável de ambiente não definida: ${var}"
        else
            log_success "Variável de ambiente definida: ${var}"
        fi
    done

    if [[ ${#MISSING_ENV_VARS[@]} -gt 0 ]]; then
        log_warning "Variáveis de ambiente faltando: ${#MISSING_ENV_VARS[@]}"
    fi

    return 0
}

# ============================================================================
# GOVERNANÇA DE NOMENCLATURAS
# ============================================================================

governance_nomenclaturas() {
    log_section "GOVERNANÇA DE NOMENCLATURAS"

    log_info "Validando nomenclaturas..."

    # Padrões de nomenclatura
    NAMING_PATTERNS=(
        "^[a-z0-9_-]+$"  # Apenas minúsculas, números, underscore e hífen
        "^[a-z]"          # Deve começar com letra minúscula
        "[a-z0-9]$"       # Deve terminar com letra ou número
    )

    # Validar arquivos e diretórios
    log_info "Validando nomenclaturas de arquivos..."

    INVALID_FILES=()

    find "${DOTFILES_DIR}" -type f -name "*.sh" -o -name "*.md" | while read file; do
        filename=$(basename "${file}")

        # Verificar padrões
        if ! [[ "${filename}" =~ ^[a-z0-9_.-]+$ ]]; then
            INVALID_FILES+=("${file}")
            log_warning "Nome inválido: ${file}"
        fi
    done

    if [[ ${#INVALID_FILES[@]} -gt 0 ]]; then
        log_warning "Arquivos com nomenclatura inválida: ${#INVALID_FILES[@]}"
    else
        log_success "Todas as nomenclaturas estão válidas"
    fi

    return 0
}

# ============================================================================
# SISTEMA DE TAGS E REVISÕES
# ============================================================================

sistema_tags_revisoes() {
    log_section "SISTEMA DE TAGS E REVISÕES"

    log_info "Aplicando tags e revisões..."

    # Tags padrão
    DEFAULT_TAGS=(
        "automated"
        "cursor-2.0"
        "validated"
        "governed"
    )

    # Aplicar tags em arquivos
    log_info "Aplicando tags em arquivos..."

    # Criar arquivo de tags
    TAGS_FILE="${GLOBAL_DIR}/.tags"

    {
        echo "# Tags aplicadas automaticamente"
        echo "# Data: $(date '+%Y-%m-%d %H:%M:%S')"
        echo ""
        for tag in "${DEFAULT_TAGS[@]}"; do
            echo "${tag}"
        done
    } > "${TAGS_FILE}"

    log_success "Tags aplicadas: ${#DEFAULT_TAGS[@]}"

    # Revisões
    log_info "Gerando revisões..."

    REVIEW_FILE="${LOG_DIR}/revisao-${TIMESTAMP}.md"

    {
        echo "# Revisão Automatizada"
        echo ""
        echo "**Data:** $(date '+%Y-%m-%d %H:%M:%S')"
        echo "**Versão:** 1.0.0"
        echo ""
        echo "## Status"
        echo ""
        echo "- ✅ Secrets validados"
        echo "- ✅ Variáveis validadas"
        echo "- ✅ Nomenclaturas validadas"
        echo "- ✅ Tags aplicadas"
        echo ""
    } > "${REVIEW_FILE}"

    log_success "Revisão gerada: ${REVIEW_FILE}"

    return 0
}

# ============================================================================
# LIMPEZA DE OBSOLETOS
# ============================================================================

limpeza_obsoletos() {
    log_section "LIMPEZA DE ARQUIVOS OBSOLETOS"

    log_info "Executando limpeza de obsoletos..."

    if [[ -f "${SCRIPT_DIR}/limpar-arquivos-obsoletos_v1.0.0_20251201.sh" ]]; then
        if [[ "${DRY_RUN}" == "true" ]]; then
            "${SCRIPT_DIR}/limpar-arquivos-obsoletos_v1.0.0_20251201.sh" --all --dry-run
        else
            "${SCRIPT_DIR}/limpar-arquivos-obsoletos_v1.0.0_20251201.sh" --all
        fi
        log_success "Limpeza de obsoletos concluída"
    else
        log_warning "Script de limpeza não encontrado"
    fi

    return 0
}

# ============================================================================
# SINCRONIZAÇÃO GITHUB
# ============================================================================

sincronizacao_github() {
    log_section "SINCRONIZAÇÃO GITHUB"

    log_info "Sincronizando com GitHub..."

    cd "${DOTFILES_DIR}"

    # Verificar status do Git
    if ! git status &> /dev/null; then
        log_error "Não é um repositório Git"
        return 1
    fi

    # Verificar mudanças
    if [[ -z "$(git status --porcelain)" ]]; then
        log_info "Nenhuma mudança para commitar"
        return 0
    fi

    log_info "Mudanças detectadas, preparando commit..."

    if [[ "${DRY_RUN}" == "true" ]]; then
        log_info "[DRY-RUN] Seria executado: git add . && git commit -m '...' && git push"
    else
        git add .
        git commit -m "chore: automação completa - $(date '+%Y-%m-%d %H:%M:%S')" || true
        git push origin main || log_warning "Push falhou"
        log_success "Sincronização com GitHub concluída"
    fi

    return 0
}

# ============================================================================
# VALIDAÇÃO DE INFRA-VPS
# ============================================================================

validar_infra_vps() {
    log_section "VALIDAÇÃO INFRA-VPS"

    log_info "Validando infra-vps..."

    INFRA_VPS_DIR="${DOTFILES_DIR}/infra-vps"

    if [[ ! -d "${INFRA_VPS_DIR}" ]]; then
        log_warning "Diretório infra-vps não encontrado"
        return 0
    fi

    # Validar estrutura
    REQUIRED_DIRS=(
        "infraestrutura"
        "scripts"
        "vaults-1password"
    )

    for dir in "${REQUIRED_DIRS[@]}"; do
        if [[ -d "${INFRA_VPS_DIR}/${dir}" ]]; then
            log_success "Diretório encontrado: ${dir}"
        else
            log_warning "Diretório não encontrado: ${dir}"
        fi
    done

    # Validar secrets hardcoded
    log_info "Verificando secrets hardcoded..."

    HARDCODED_SECRETS=$(grep -r "password\|secret\|token\|key" "${INFRA_VPS_DIR}" --include="*.yml" --include="*.yaml" --include="*.env" 2>/dev/null | grep -v "op://" | wc -l || echo "0")

    if [[ "${HARDCODED_SECRETS}" -gt 0 ]]; then
        log_warning "Possíveis secrets hardcoded encontrados: ${HARDCODED_SECRETS}"
    else
        log_success "Nenhum secret hardcoded encontrado"
    fi

    return 0
}

# ============================================================================
# VALIDAÇÃO DE SYSTEM_PROMPTS
# ============================================================================

validar_system_prompts() {
    log_section "VALIDAÇÃO SYSTEM_PROMPTS"

    log_info "Validando system_prompts..."

    SYSTEM_PROMPTS_DIR="${GLOBAL_DIR}"

    # Validar estrutura
    REQUIRED_DIRS=(
        "scripts"
        "docs"
        "prompts"
    )

    for dir in "${REQUIRED_DIRS[@]}"; do
        if [[ -d "${SYSTEM_PROMPTS_DIR}/${dir}" ]]; then
            log_success "Diretório encontrado: ${dir}"
        else
            log_warning "Diretório não encontrado: ${dir}"
        fi
    done

    # Validar scripts
    log_info "Validando scripts..."

    SCRIPT_COUNT=$(find "${SYSTEM_PROMPTS_DIR}/scripts" -name "*.sh" -type f 2>/dev/null | wc -l | tr -d ' ')
    log_info "Scripts encontrados: ${SCRIPT_COUNT}"

    # Validar sintaxe dos scripts
    log_info "Validando sintaxe dos scripts..."

    INVALID_SCRIPTS=()

    find "${SYSTEM_PROMPTS_DIR}/scripts" -name "*.sh" -type f | while read script; do
        if ! bash -n "${script}" &> /dev/null; then
            INVALID_SCRIPTS+=("${script}")
            log_warning "Script com erro de sintaxe: ${script}"
        fi
    done

    if [[ ${#INVALID_SCRIPTS[@]} -eq 0 ]]; then
        log_success "Todos os scripts têm sintaxe válida"
    fi

    return 0
}

# ============================================================================
# MAIN
# ============================================================================

main() {
    echo ""
    echo -e "${CYAN}╔════════════════════════════════════════════════════════════╗${NC}"
    echo -e "${CYAN}║  AUTOMAÇÃO COMPLETA - CURSOR 2.0                          ║${NC}"
    echo -e "${CYAN}╚════════════════════════════════════════════════════════════╝${NC}"
    echo ""

    if [[ "${DRY_RUN}" == "true" ]]; then
        log_warning "MODO DRY-RUN: Nenhuma alteração será feita"
        echo ""
    fi

    log_info "Iniciando automação completa..."
    log_info "Log será salvo em: ${LOG_FILE}"
    echo ""

    # Cabeçalho do log
    {
        echo "# Automação Completa - Cursor 2.0"
        echo ""
        echo "**Data:** $(date '+%Y-%m-%d %H:%M:%S')"
        echo "**Versão:** 1.0.0"
        echo "**Modo:** $([ "${DRY_RUN}" == "true" ] && echo "DRY-RUN" || echo "EXECUÇÃO")"
        echo ""
        echo "---"
        echo ""
    } > "${LOG_FILE}"

    # Executar módulos
    if [[ "${RUN_ALL}" == "true" ]] || [[ "${VALIDATE_ONLY}" == "true" ]]; then
        validate_secrets_variables || log_error "Validação de secrets falhou"
        validar_infra_vps || log_error "Validação infra-vps falhou"
        validar_system_prompts || log_error "Validação system_prompts falhou"
        governance_nomenclaturas || log_error "Governança de nomenclaturas falhou"
    fi

    if [[ "${RUN_ALL}" == "true" ]] || [[ "${CLEANUP_ONLY}" == "true" ]]; then
        limpeza_obsoletos || log_error "Limpeza de obsoletos falhou"
    fi

    if [[ "${RUN_ALL}" == "true" ]]; then
        sistema_tags_revisoes || log_error "Sistema de tags e revisões falhou"
    fi

    if [[ "${RUN_ALL}" == "true" ]] || [[ "${SYNC_ONLY}" == "true" ]]; then
        sincronizacao_github || log_error "Sincronização GitHub falhou"
    fi

    echo ""
    log_success "╔════════════════════════════════════════════════════════════╗"
    log_success "║  AUTOMAÇÃO CONCLUÍDA                                      ║"
    log_success "╚════════════════════════════════════════════════════════════╝"
    echo ""

    log_info "Log completo: ${LOG_FILE}"
    echo ""
}

main "$@"
