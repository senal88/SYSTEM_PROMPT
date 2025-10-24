#!/bin/bash

################################################################################
# 🔓 inject_secrets_macos.sh
# Script de Injeção Dinâmica de Segredos do 1Password para macOS Silicon
# Propósito: Carregar segredos do 1Password e injetá-los como variáveis de ambiente
# Autor: Manus AI
# Data: 2025-10-22
################################################################################

set -euo pipefail

# ============================================================================
# CONFIGURAÇÃO
# ============================================================================

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
VAULT_NAME="${1:-macos_silicon_workspace}"
ENV_OUTPUT_FILE="${2:-.env}"
TEMP_ENV_FILE="/tmp/.env.temp.$$"

# ============================================================================
# CORES PARA OUTPUT
# ============================================================================

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m'

# ============================================================================
# FUNÇÕES AUXILIARES
# ============================================================================

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

log_section() {
    echo ""
    echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo -e "${CYAN}$1${NC}"
    echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo ""
}

# ============================================================================
# VERIFICAÇÃO DE PRÉ-REQUISITOS
# ============================================================================

check_prerequisites() {
    log_section "Verificando Pré-requisitos"

    # Verificar se op está instalado
    if ! command -v op &> /dev/null; then
        log_error "1Password CLI (op) não está instalado."
        log_info "Instale com: brew install 1password-cli"
        exit 1
    fi

    # Verificar se está autenticado
    if ! op whoami &>/dev/null; then
        log_error "Você não está autenticado no 1Password."
        log_info "Execute: eval \$(op signin)"
        exit 1
    fi

    log_success "1Password CLI está instalado e autenticado."
}

# ============================================================================
# VERIFICAÇÃO DE VAULT
# ============================================================================

check_vault_exists() {
    log_section "Verificando Vault: $VAULT_NAME"

    if op vault get "$VAULT_NAME" &>/dev/null; then
        log_success "Vault '$VAULT_NAME' encontrado."
    else
        log_error "Vault '$VAULT_NAME' não encontrado."
        log_info "Vaults disponíveis:"
        op vault list --format json | jq -r '.[] | "  - \(.name)"'
        exit 1
    fi
}

# ============================================================================
# COLETA DE ITENS DO VAULT
# ============================================================================

collect_items_from_vault() {
    log_section "Coletando Itens do Vault"

    # Obter lista de itens em formato JSON
    ITEMS_JSON=$(op item list --vault "$VAULT_NAME" --format json)

    # Contar itens
    ITEM_COUNT=$(echo "$ITEMS_JSON" | jq 'length')
    log_info "Encontrados $ITEM_COUNT itens no vault."

    # Processar cada item
    echo "$ITEMS_JSON" | jq -r '.[] | "\(.id)|\(.title)"' | while IFS='|' read -r ITEM_ID ITEM_TITLE; do
        log_info "Processando: $ITEM_TITLE"

        # Obter detalhes do item
        ITEM_DETAILS=$(op item get "$ITEM_ID" --vault "$VAULT_NAME" --format json)

        # Extrair campos e criar variáveis de ambiente
        echo "$ITEM_DETAILS" | jq -r '.fields[] | select(.value != null) | "\(.label)=\(.value)"' >> "$TEMP_ENV_FILE"
    done
}

# ============================================================================
# INJEÇÃO VIA ARQUIVO .env.op (MÉTODO ALTERNATIVO)
# ============================================================================

inject_from_template() {
    local TEMPLATE_FILE="$1"

    if [[ ! -f "$TEMPLATE_FILE" ]]; then
        log_error "Arquivo de template não encontrado: $TEMPLATE_FILE"
        return 1
    fi

    log_section "Injetando Segredos a partir de Template"
    log_info "Template: $TEMPLATE_FILE"

    # Usar op inject para substituir referências do 1Password
    op inject -i "$TEMPLATE_FILE" -o "$ENV_OUTPUT_FILE"

    if [[ -f "$ENV_OUTPUT_FILE" ]]; then
        log_success "Arquivo .env gerado: $ENV_OUTPUT_FILE"
        chmod 600 "$ENV_OUTPUT_FILE"
        log_success "Permissões ajustadas (600)."
    else
        log_error "Falha ao gerar arquivo .env."
        return 1
    fi
}

# ============================================================================
# VALIDAÇÃO DE SEGREDOS
# ============================================================================

validate_secrets() {
    log_section "Validando Segredos"

    if [[ ! -f "$ENV_OUTPUT_FILE" ]]; then
        log_error "Arquivo de saída não encontrado: $ENV_OUTPUT_FILE"
        return 1
    fi

    # Contar linhas não vazias e não comentadas
    VALID_LINES=$(grep -v '^#' "$ENV_OUTPUT_FILE" | grep -v '^$' | wc -l)
    log_success "Encontradas $VALID_LINES variáveis de ambiente válidas."

    # Verificar se há variáveis vazias
    EMPTY_VARS=$(grep '=$' "$ENV_OUTPUT_FILE" | wc -l)
    if [[ $EMPTY_VARS -gt 0 ]]; then
        log_warning "Encontradas $EMPTY_VARS variáveis vazias:"
        grep '=$' "$ENV_OUTPUT_FILE" | sed 's/^/  - /'
    fi
}

# ============================================================================
# CARREGAMENTO DE VARIÁVEIS
# ============================================================================

load_environment() {
    log_section "Carregando Variáveis de Ambiente"

    if [[ -f "$ENV_OUTPUT_FILE" ]]; then
        set -a
        source "$ENV_OUTPUT_FILE"
        set +a
        log_success "Variáveis carregadas no ambiente atual."
    else
        log_error "Arquivo .env não encontrado."
        return 1
    fi
}

# ============================================================================
# LIMPEZA DE ARQUIVO TEMPORÁRIO
# ============================================================================

cleanup() {
    if [[ -f "$TEMP_ENV_FILE" ]]; then
        rm -f "$TEMP_ENV_FILE"
    fi
}

# ============================================================================
# EXIBIÇÃO DE RESUMO
# ============================================================================

display_summary() {
    log_section "Resumo da Injeção de Segredos"

    log_info "Vault: $VAULT_NAME"
    log_info "Arquivo de Saída: $ENV_OUTPUT_FILE"
    log_info "Permissões: $(stat -f '%A' "$ENV_OUTPUT_FILE" 2>/dev/null || echo 'N/A')"

    log_info ""
    log_info "Variáveis Carregadas:"
    grep -v '^#' "$ENV_OUTPUT_FILE" | grep -v '^$' | cut -d'=' -f1 | sed 's/^/  - /'
}

# ============================================================================
# FUNÇÃO PRINCIPAL
# ============================================================================

main() {
    echo ""
    echo -e "${BLUE}╔════════════════════════════════════════════════════════════════╗${NC}"
    echo -e "${BLUE}║  🔓 Injeção de Segredos do 1Password para macOS Silicon        ║${NC}"
    echo -e "${BLUE}╚════════════════════════════════════════════════════════════════╝${NC}"
    echo ""

    # Verificar se foi fornecido um arquivo de template
    if [[ $# -gt 2 ]]; then
        TEMPLATE_FILE="$3"
        inject_from_template "$TEMPLATE_FILE"
    else
        check_prerequisites
        check_vault_exists
        collect_items_from_vault
    fi

    validate_secrets
    load_environment
    display_summary

    echo ""
    echo -e "${GREEN}╔════════════════════════════════════════════════════════════════╗${NC}"
    echo -e "${GREEN}║  ✅ Injeção de Segredos Concluída!                             ║${NC}"
    echo -e "${GREEN}╚════════════════════════════════════════════════════════════════╝${NC}"
    echo ""

    log_info "Próximos passos:"
    log_info "1. Verifique o arquivo: cat $ENV_OUTPUT_FILE"
    log_info "2. Use os segredos: source $ENV_OUTPUT_FILE && echo \$VARIAVEL"
    log_info "3. Ou execute com op run: op run --env-file=$ENV_OUTPUT_FILE -- seu_comando"

    cleanup
}

# ============================================================================
# EXECUÇÃO
# ============================================================================

main "$@"

