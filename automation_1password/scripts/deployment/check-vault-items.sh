#!/bin/bash
# check-vault-items.sh
# Verifica quais items estão disponíveis no vault antes de injetar
# Last Updated: 2025-11-03
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
VAULT_VPS="1p_vps"

# ============================================================================
# FUNÇÕES
# ============================================================================

list_all_vaults() {
    log_section "📦 Listando Vaults Disponíveis"
    
    if command -v jq &>/dev/null; then
        op vault list --format json 2>/dev/null | jq -r '.[] | "  - \(.name) (ID: \(.id))"' || {
            op vault list 2>&1 | head -20
        }
    else
        op vault list 2>&1 | head -20
    fi
}

check_vault_exists() {
    local vault_name="$1"
    
    log_section "🔍 Verificando Vault: ${vault_name}"
    
    if op vault get "${vault_name}" --format json &>/dev/null 2>&1; then
        local vault_id=$(op vault get "${vault_name}" --format json 2>/dev/null | jq -r '.id' || echo "N/A")
        log_success "Vault ${vault_name} encontrado (ID: ${vault_id})"
        return 0
    else
        log_error "Vault ${vault_name} não encontrado"
        return 1
    fi
}

list_vault_items() {
    local vault_name="$1"
    
    log_section "📋 Items no Vault: ${vault_name}"
    
    if op item list --vault "${vault_name}" --format json &>/dev/null 2>&1; then
        local items=$(op item list --vault "${vault_name}" --format json 2>/dev/null | jq -r '.[].title' | sort)
        local count=$(echo "${items}" | grep -c . || echo "0")
        
        if [ "${count}" -gt 0 ]; then
            log_success "${count} item(s) encontrado(s):"
            echo "${items}" | while read -r item; do
                echo "  - ${item}"
            done
        else
            log_warning "Vault ${vault_name} está vazio"
        fi
    else
        log_error "Não foi possível listar items do vault ${vault_name}"
        return 1
    fi
}

check_required_items() {
    local vault_name="$1"
    
    log_section "✅ Verificando Items Requeridos"
    
    local required=(
        "PostgreSQL"
        "n8n"
    )
    
    local optional=(
        "OpenAI-API"
        "Anthropic-API"
        "HuggingFace-Token"
        "Perplexity-API"
        "Cursor-API"
    )
    
    local missing_required=0
    local missing_optional=0
    
    log_info "Items obrigatórios:"
    for item in "${required[@]}"; do
        if op item get "${item}" --vault "${vault_name}" &>/dev/null 2>&1; then
            log_success "  ✅ ${item}"
        else
            log_error "  ❌ ${item} (faltando)"
            ((missing_required++))
        fi
    done
    
    echo ""
    log_info "Items opcionais:"
    for item in "${optional[@]}"; do
        if op item get "${item}" --vault "${vault_name}" &>/dev/null 2>&1; then
            log_success "  ✅ ${item}"
        else
            log_warning "  ⚠️  ${item} (opcional)"
            ((missing_optional++))
        fi
    done
    
    if [ ${missing_required} -eq 0 ]; then
        log_success "Todos os items obrigatórios presentes!"
        return 0
    else
        log_error "${missing_required} item(s) obrigatório(is) faltando"
        return 1
    fi
}

create_fallback_env() {
    log_section "📝 Criando .env Fallback"
    
    cat > "${REPO_ROOT}/prod/.env.example" << 'EOF'
# .env.example - Variáveis de Ambiente AI Stack
# Copie este arquivo para .env e preencha os valores manualmente
# OU use: op inject -i .env.template -o .env (requer items no 1Password)

# === Project ===
PROJECT_SLUG=platform

# === PostgreSQL ===
POSTGRES_USER=n8n
POSTGRES_PASSWORD=<senha-postgres>
POSTGRES_DB=n8n

# === n8n Security ===
N8N_ENCRYPTION_KEY=<chave-32-caracteres>
N8N_USER_MANAGEMENT_JWT_SECRET=<jwt-secret>
N8N_USER=admin
N8N_PASSWORD=<senha-admin-n8n>

# === API Keys (Opcional) ===
# OPENAI_API_KEY=<opcional>
# ANTHROPIC_API_KEY=<opcional>
# HUGGINGFACE_TOKEN=<opcional>
# PERPLEXITY_API_KEY=<opcional>

EOF
    
    log_success ".env.example criado como fallback"
}

# ============================================================================
# MAIN
# ============================================================================

main() {
    log_section "🔍 Verificação de Vault e Items"
    
    list_all_vaults
    echo ""
    
    # Tentar encontrar vault (pode ter nome diferente)
    local vault_found=false
    
    # Tentar 1p_vps
    if check_vault_exists "${VAULT_VPS}"; then
        vault_found=true
        list_vault_items "${VAULT_VPS}"
        echo ""
        check_required_items "${VAULT_VPS}"
        echo ""
    else
        log_warning "Vault ${VAULT_VPS} não encontrado"
        log_info "Listando items de todos os vaults..."
        
        # Listar todos os vaults e seus items
        for vault in $(op vault list --format json 2>/dev/null | jq -r '.[].name' 2>/dev/null || echo ""); do
            if [ -n "${vault}" ]; then
                log_info "Vault: ${vault}"
                list_vault_items "${vault}" 2>/dev/null || true
                echo ""
            fi
        done
    fi
    
    create_fallback_env
    echo ""
    
    log_section "📊 Resumo"
    
    if [ "${vault_found}" = true ]; then
        log_success "Vault encontrado - pode usar op inject"
        log_info "Próximo passo: op inject -i .env.template -o .env"
    else
        log_warning "Vault padrão não encontrado"
        log_info "Opções:"
        echo "  1. Criar vault ${VAULT_VPS} e sincronizar items"
        echo "  2. Ajustar .env.template para usar vault existente"
        echo "  3. Usar .env.example e preencher manualmente"
    fi
    
    return 0
}

main "$@"

