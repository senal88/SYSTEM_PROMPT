#!/usr/bin/env bash
set -euo pipefail

################################################################################
# 🔐 VALIDAÇÃO COMPLETA DE SECRETS E VARIÁVEIS - 1PASSWORD
#
# Valida todos os secrets e variáveis necessários em todas as vaults
# Verifica integridade, acesso e completude
#
# Uso: ./validar-secrets-1password_v1.0.0_20251201.sh [--vault VAULT] [--all]
#
# STATUS: ATIVO (2025-12-01)
# VERSÃO: 1.0.0
################################################################################

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
GLOBAL_DIR="$(cd "${SCRIPT_DIR}/.." && pwd)"
TIMESTAMP=$(date +%Y%m%d_%H%M%S)
REPORT_DIR="${GLOBAL_DIR}/logs/validacao-secrets"
REPORT_FILE="${REPORT_DIR}/validacao-${TIMESTAMP}.md"

# Flags
VAULT_SPECIFIC=""
VALIDATE_ALL=false

# Parse arguments
while [[ $# -gt 0 ]]; do
    case $1 in
        --vault)
            VAULT_SPECIFIC="$2"
            shift 2
            ;;
        --all)
            VALIDATE_ALL=true
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

# Mapeamento de secrets necessários por vault
declare -A REQUIRED_SECRETS_1P_VPS=(
    ["yhqdcrihdk5c6sk7x7fwcqazqu"]="Service Account Auth Token: admin-vps conta de servico"
    ["3ztgpgona7iy2htavjmtdccss4"]="GIT_PERSONAL"
    ["6d3sildbgptpqp3lvyjt2gsjhy"]="github.com"
    ["k6x3ye34k6p6rkz7b6e2qhjeci"]="GIT_TOKEN"
)

declare -A REQUIRED_SECRETS_1P_MACOS=(
    ["kvhqgsi3ndrz4n65ptiuryrifa"]="service_1p_macos_dev_localhost"
    ["3xpytbcndxqapydpz27lxoegwm"]="GIT_PAT |Nov-2025"
    ["q36qe2k5ppapzhxdr2q24jtwta"]="SYSTEM_PROMPT | GIT_PERSONAL_KEY"
    ["4ge66znk4qefkypev54t5ivebe"]="id_ed25519_universal"
)

# ============================================================================
# VALIDAR VAULT ESPECÍFICO
# ============================================================================

validar_vault() {
    local vault_name="$1"
    
    log_section "VALIDAÇÃO VAULT: ${vault_name}"
    
    # Obter lista de itens do vault
    log_info "Listando itens do vault ${vault_name}..."
    
    ITEMS=$(op item list --vault "${vault_name}" --format json 2>/dev/null | jq -r '.[].id' || echo "")
    
    if [[ -z "${ITEMS}" ]]; then
        log_error "Nenhum item encontrado no vault ${vault_name}"
        return 1
    fi
    
    ITEM_COUNT=$(echo "${ITEMS}" | wc -l | tr -d ' ')
    log_success "Itens encontrados: ${ITEM_COUNT}"
    
    # Validar cada item
    log_info "Validando acesso aos itens..."
    
    VALID_ITEMS=0
    INVALID_ITEMS=0
    
    while IFS= read -r item_id; do
        if [[ -z "${item_id}" ]]; then
            continue
        fi
        
        if op item get "${item_id}" --vault "${vault_name}" &> /dev/null; then
            VALID_ITEMS=$((VALID_ITEMS + 1))
            log_success "Item válido: ${item_id}"
        else
            INVALID_ITEMS=$((INVALID_ITEMS + 1))
            log_error "Item inválido ou inacessível: ${item_id}"
        fi
    done <<< "${ITEMS}"
    
    log_info "Resumo: ${VALID_ITEMS} válidos, ${INVALID_ITEMS} inválidos"
    
    # Validar secrets necessários específicos
    if [[ "${vault_name}" == "1p_vps" ]]; then
        validar_secrets_necessarios "1p_vps" "REQUIRED_SECRETS_1P_VPS"
    elif [[ "${vault_name}" == "1p_macos" ]]; then
        validar_secrets_necessarios "1p_macos" "REQUIRED_SECRETS_1P_MACOS"
    fi
    
    return 0
}

# ============================================================================
# VALIDAR SECRETS NECESSÁRIOS
# ============================================================================

validar_secrets_necessarios() {
    local vault_name="$1"
    local array_name="$2"
    
    log_info "Validando secrets necessários do vault ${vault_name}..."
    
    # Criar referência ao array associativo
    local -n secrets_array="${array_name}"
    
    MISSING_SECRETS=()
    
    for item_id in "${!secrets_array[@]}"; do
        item_name="${secrets_array[${item_id}]}"
        
        if op item get "${item_id}" --vault "${vault_name}" &> /dev/null; then
            log_success "Secret necessário encontrado: ${item_name} (${item_id})"
        else
            MISSING_SECRETS+=("${item_id}:${item_name}")
            log_error "Secret necessário não encontrado: ${item_name} (${item_id})"
        fi
    done
    
    if [[ ${#MISSING_SECRETS[@]} -gt 0 ]]; then
        log_error "Secrets faltando: ${#MISSING_SECRETS[@]}"
        return 1
    fi
    
    log_success "Todos os secrets necessários estão presentes"
    return 0
}

# ============================================================================
# VALIDAR VARIÁVEIS DE AMBIENTE
# ============================================================================

validar_variaveis_ambiente() {
    log_section "VALIDAÇÃO VARIÁVEIS DE AMBIENTE"
    
    REQUIRED_VARS=(
        "OP_SERVICE_ACCOUNT_TOKEN"
        "OP_ACCOUNT"
    )
    
    OPTIONAL_VARS=(
        "GITHUB_TOKEN"
        "GIT_PAT"
        "OPENAI_API_KEY"
        "ANTHROPIC_API_KEY"
    )
    
    log_info "Validando variáveis obrigatórias..."
    
    MISSING_REQUIRED=()
    
    for var in "${REQUIRED_VARS[@]}"; do
        if [[ -z "${!var:-}" ]]; then
            MISSING_REQUIRED+=("${var}")
            log_error "Variável obrigatória não definida: ${var}"
        else
            log_success "Variável obrigatória definida: ${var}"
        fi
    done
    
    log_info "Validando variáveis opcionais..."
    
    MISSING_OPTIONAL=()
    
    for var in "${OPTIONAL_VARS[@]}"; do
        if [[ -z "${!var:-}" ]]; then
            MISSING_OPTIONAL+=("${var}")
            log_warning "Variável opcional não definida: ${var}")
        else
            log_success "Variável opcional definida: ${var}"
        fi
    done
    
    if [[ ${#MISSING_REQUIRED[@]} -gt 0 ]]; then
        log_error "Variáveis obrigatórias faltando: ${#MISSING_REQUIRED[@]}"
        return 1
    fi
    
    return 0
}

# ============================================================================
# MAIN
# ============================================================================

main() {
    echo ""
    echo -e "${CYAN}╔════════════════════════════════════════════════════════════╗${NC}"
    echo -e "${CYAN}║  VALIDAÇÃO COMPLETA DE SECRETS E VARIÁVEIS              ║${NC}"
    echo -e "${CYAN}╚════════════════════════════════════════════════════════════╝${NC}"
    echo ""
    
    log_info "Iniciando validação..."
    log_info "Relatório será salvo em: ${REPORT_FILE}"
    echo ""
    
    # Cabeçalho do relatório
    {
        echo "# Validação Completa de Secrets e Variáveis"
        echo ""
        echo "**Data:** $(date '+%Y-%m-%d %H:%M:%S')"
        echo "**Versão:** 1.0.0"
        echo ""
        echo "---"
        echo ""
    } > "${REPORT_FILE}"
    
    # Verificar 1Password CLI
    if ! command -v op &> /dev/null; then
        log_error "1Password CLI não encontrado"
        exit 1
    fi
    
    # Verificar autenticação
    if ! op account list &> /dev/null; then
        log_error "1Password não autenticado"
        exit 1
    fi
    
    log_success "1Password autenticado"
    
    # Validar variáveis de ambiente
    validar_variaveis_ambiente
    
    # Validar vaults
    if [[ -n "${VAULT_SPECIFIC}" ]]; then
        validar_vault "${VAULT_SPECIFIC}"
    elif [[ "${VALIDATE_ALL}" == "true" ]]; then
        VAULTS=$(op vault list --format json 2>/dev/null | jq -r '.[].name' || echo "")
        
        while IFS= read -r vault; do
            if [[ -n "${vault}" ]]; then
                validar_vault "${vault}"
            fi
        done <<< "${VAULTS}"
    else
        # Validar vaults principais
        validar_vault "1p_vps"
        validar_vault "1p_macos"
    fi
    
    echo ""
    log_success "╔════════════════════════════════════════════════════════════╗"
    log_success "║  VALIDAÇÃO CONCLUÍDA                                      ║"
    log_success "╚════════════════════════════════════════════════════════════╝"
    echo ""
    
    log_info "Relatório completo: ${REPORT_FILE}"
    echo ""
}

main "$@"

