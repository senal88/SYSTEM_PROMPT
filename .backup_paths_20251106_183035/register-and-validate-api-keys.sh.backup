#!/bin/bash
# register-and-validate-api-keys.sh
# Registra e valida API keys no 1Password (1p_macos e 1p_vps)
# Last Updated: 2025-11-01
# Version: 1.0.0

set -euo pipefail

# ============================================================================
# SOURCING LIB
# ============================================================================
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "${SCRIPT_DIR}/../.." && pwd)"
source "${SCRIPT_DIR}/../lib/logging.sh"

# ============================================================================
# CONFIGURAÇÕES
# ============================================================================
VAULT_MACOS="1p_macos"
VAULT_VPS="1p_vps"
SOURCE_FILE="${REPO_ROOT}/add-1password-vps-macos.md"

# ============================================================================
# VERIFICAÇÕES INICIAIS
# ============================================================================

check_prerequisites() {
    log_section "🔍 Verificando Pré-requisitos"
    
    if ! command -v op &> /dev/null; then
        log_error "1Password CLI não está instalado"
        return 1
    fi
    
    # Verificar se está usando Connect ou CLI direto
    if [ -n "${OP_CONNECT_HOST:-}" ] && [ -n "${OP_CONNECT_TOKEN:-}" ]; then
        log_info "Usando 1Password Connect (${OP_CONNECT_HOST})"
        # Testar conectividade do Connect
        if ! curl -s -f -H "Authorization: Bearer ${OP_CONNECT_TOKEN}" \
             "${OP_CONNECT_HOST}/health" &>/dev/null; then
            log_warning "1Password Connect pode não estar acessível, mas continuando..."
            log_info "Verifique se os containers op-connect-api estão rodando"
        fi
    else
        # CLI direto
        if ! op whoami &> /dev/null; then
            log_error "1Password CLI não está autenticado"
            log_info "Execute: op signin"
            return 1
        fi
    fi
    
    log_success "1Password configurado"
    
    # Verificar se arquivo fonte existe
    if [ ! -f "${SOURCE_FILE}" ]; then
        log_error "Arquivo ${SOURCE_FILE} não encontrado"
        return 1
    fi
    
    log_success "Arquivo fonte encontrado"
    
    # Verificar vaults (pode falhar com Connect, mas tentamos)
    local vault_check_failed=0
    
    if op vault get "${VAULT_MACOS}" --format json &>/dev/null 2>&1; then
        log_success "Vault ${VAULT_MACOS} acessível"
    else
        log_warning "Vault ${VAULT_MACOS} não encontrado ou não acessível (será criado se necessário)"
        ((vault_check_failed++))
    fi
    
    if op vault get "${VAULT_VPS}" --format json &>/dev/null 2>&1; then
        log_success "Vault ${VAULT_VPS} acessível"
    else
        log_warning "Vault ${VAULT_VPS} não encontrado ou não acessível (será criado se necessário)"
        ((vault_check_failed++))
    fi
    
    if [ ${vault_check_failed} -eq 2 ]; then
        log_warning "Ambos vaults não acessíveis. Continuando de qualquer forma..."
    fi
    
    return 0
}

# ============================================================================
# EXTRAIR TOKENS DO ARQUIVO
# ============================================================================

extract_tokens() {
    log_section "📄 Extraindo tokens do arquivo"
    
    if [ ! -f "${SOURCE_FILE}" ]; then
        log_error "Arquivo não encontrado"
        return 1
    fi
    
    # Extrair tokens (formato: KEY_NAME=token_value)
    OPENAI_TOKEN=$(grep "^OPENAI_API_KEY=" "${SOURCE_FILE}" | cut -d'=' -f2- | tr -d ' ' || echo "")
    ANTHROPIC_TOKEN=$(grep "^ANTHROPIC_API_KEY=" "${SOURCE_FILE}" | cut -d'=' -f2- | tr -d ' ' || echo "")
    HF_TOKEN=$(grep "^HF_TOKEN=" "${SOURCE_FILE}" | cut -d'=' -f2- | tr -d ' ' || echo "")
    PERPLEXITY_TOKEN=$(grep "^PERPLEXITY_API_KEY=" "${SOURCE_FILE}" | cut -d'=' -f2- | tr -d ' ' || echo "")
    CURSOR_TOKEN=$(grep "^CURSOR_API_KEY=" "${SOURCE_FILE}" | cut -d'=' -f2- | tr -d ' ' || echo "")
    
    local tokens_found=0
    
    [ -n "${OPENAI_TOKEN}" ] && ((tokens_found++))
    [ -n "${ANTHROPIC_TOKEN}" ] && ((tokens_found++))
    [ -n "${HF_TOKEN}" ] && ((tokens_found++))
    [ -n "${PERPLEXITY_TOKEN}" ] && ((tokens_found++))
    [ -n "${CURSOR_TOKEN}" ] && ((tokens_found++))
    
    if [ ${tokens_found} -eq 0 ]; then
        log_error "Nenhum token encontrado no arquivo"
        return 1
    fi
    
    log_success "${tokens_found} token(s) extraído(s)"
    
    return 0
}

# ============================================================================
# REGISTRAR NO 1PASSWORD
# ============================================================================

register_api_key() {
    local item_name="$1"
    local vault="$2"
    local token_value="$3"
    
    if [ -z "${token_value}" ]; then
        log_warning "Token vazio para ${item_name}, pulando..."
        return 0
    fi
    
    # Verificar se item já existe
    if op item get "${item_name}" --vault "${vault}" &>/dev/null 2>&1; then
        log_info "Item ${item_name} já existe em ${vault}, atualizando..."
        
        # Tentar atualizar campo credential
        op item edit "${item_name}" \
            --vault "${vault}" \
            --field "credential=${token_value}" \
            --no-color &>/dev/null 2>&1 && {
                log_success "✅ ${item_name} atualizado em ${vault}"
                return 0
            }
        
        # Se falhou, tentar criar novo item
        log_info "Tentando criar novo item..."
    fi
    
    # Criar novo item
    op item create \
        --vault "${vault}" \
        --category "API Credential" \
        --title "${item_name}" \
        --field "credential=${token_value}" \
        --no-color &>/dev/null 2>&1 && {
        log_success "✅ ${item_name} criado em ${vault}"
        return 0
    }
    
    log_error "Falha ao criar/atualizar ${item_name} em ${vault}"
    return 1
}

register_all_keys() {
    log_section "💾 Registrando API Keys no 1Password"
    
    local failed=0
    
    # Registrar em 1p_macos (ambiente local)
    log_info "Registrando em ${VAULT_MACOS} (macOS)..."
    
    register_api_key "OpenAI-API" "${VAULT_MACOS}" "${OPENAI_TOKEN}" || ((failed++))
    register_api_key "Anthropic-API" "${VAULT_MACOS}" "${ANTHROPIC_TOKEN}" || ((failed++))
    register_api_key "HuggingFace-Token" "${VAULT_MACOS}" "${HF_TOKEN}" || ((failed++))
    register_api_key "Perplexity-API" "${VAULT_MACOS}" "${PERPLEXITY_TOKEN}" || ((failed++))
    register_api_key "Cursor-API" "${VAULT_MACOS}" "${CURSOR_TOKEN}" || ((failed++))
    
    echo ""
    log_info "Registrando em ${VAULT_VPS} (VPS)..."
    
    # Registrar em 1p_vps (ambiente remoto)
    register_api_key "OpenAI-API" "${VAULT_VPS}" "${OPENAI_TOKEN}" || ((failed++))
    register_api_key "Anthropic-API" "${VAULT_VPS}" "${ANTHROPIC_TOKEN}" || ((failed++))
    register_api_key "HuggingFace-Token" "${VAULT_VPS}" "${HF_TOKEN}" || ((failed++))
    register_api_key "Perplexity-API" "${VAULT_VPS}" "${PERPLEXITY_TOKEN}" || ((failed++))
    register_api_key "Cursor-API" "${VAULT_VPS}" "${CURSOR_TOKEN}" || ((failed++))
    
    return ${failed}
}

# ============================================================================
# VALIDAR REGISTRO
# ============================================================================

validate_registration() {
    log_section "✅ Validando Registro"
    
    local items=(
        "OpenAI-API"
        "Anthropic-API"
        "HuggingFace-Token"
        "Perplexity-API"
        "Cursor-API"
    )
    
    local vaults=("${VAULT_MACOS}" "${VAULT_VPS}")
    local validation_failed=0
    
    for vault in "${vaults[@]}"; do
        log_info "Validando vault: ${vault}"
        
        for item in "${items[@]}"; do
            if op item get "${item}" --vault "${vault}" --format json &>/dev/null; then
                # Verificar se tem campo credential
                if op item get "${item}" --vault "${vault}" --fields credential &>/dev/null 2>&1; then
                    log_success "  ✅ ${item}"
                else
                    log_warning "  ⚠️  ${item} (sem campo credential)"
                    ((validation_failed++))
                fi
            else
                log_error "  ❌ ${item} não encontrado"
                ((validation_failed++))
            fi
        done
    done
    
    return ${validation_failed}
}

# ============================================================================
# LIMPEZA
# ============================================================================

cleanup_source_file() {
    log_section "🧹 Limpeza"
    
    if [ -f "${SOURCE_FILE}" ]; then
        log_info "Removendo arquivo fonte após validação..."
        rm -f "${SOURCE_FILE}"
        log_success "✅ Arquivo ${SOURCE_FILE} removido"
    else
        log_info "Arquivo já foi removido anteriormente"
    fi
    
    return 0
}

# ============================================================================
# MAIN
# ============================================================================

main() {
    log_section "🔐 Registro e Validação de API Keys"
    
    check_prerequisites || return 1
    echo ""
    
    extract_tokens || return 1
    echo ""
    
    register_all_keys
    local register_result=$?
    echo ""
    
    if [ ${register_result} -gt 0 ]; then
        log_warning "Alguns registros falharam, mas continuando validação..."
    fi
    
    validate_registration
    local validation_result=$?
    echo ""
    
    if [ ${validation_result} -eq 0 ]; then
        log_success "✅ Todos os itens validados com sucesso!"
        
        cleanup_source_file
        echo ""
        
        log_section "📊 Resumo"
        log_success "✅ API Keys registradas e validadas nos vaults ${VAULT_MACOS} e ${VAULT_VPS}"
        log_success "✅ Arquivo fonte removido"
        echo ""
        echo "Próximos passos:"
        echo "  1. Regenerar .env: cd compose && op inject -i env-ai-stack.template -o .env"
        echo "  2. Validar stack: ./scripts/validation/validate-ai-stack.sh"
        return 0
    else
        log_error "❌ Validação falhou. Verifique os items manualmente."
        log_warning "Arquivo fonte NÃO será removido até validação completa"
        return 1
    fi
}

main "$@"

