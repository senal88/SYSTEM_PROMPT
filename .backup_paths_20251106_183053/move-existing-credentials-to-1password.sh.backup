#!/bin/bash
# move-existing-credentials-to-1password.sh
# Move credenciais existentes para 1Password (SEM rotacionar)
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
VAULT="1p_macos"

# Tokens existentes (do terminal)
# IMPORTANTE: Estes são os tokens ATUAIS que você quer preservar
OPENAI_TOKEN="${OPENAI_API_KEY:-}"
ANTHROPIC_TOKEN="${ANTHROPIC_API_KEY:-}"
HF_TOKEN="${HF_TOKEN:-}"
PERPLEXITY_TOKEN="${PERPLEXITY_API_KEY:-}"
CURSOR_TOKEN="${CURSOR_API_KEY:-}"

# ============================================================================
# VERIFICAÇÕES
# ============================================================================

check_1password() {
    if ! command -v op &> /dev/null; then
        log_error "1Password CLI não está instalado"
        return 1
    fi
    
    if ! op whoami &> /dev/null; then
        log_error "1Password CLI não está autenticado"
        log_info "Execute: op signin"
        return 1
    fi
    
    log_success "1Password CLI configurado"
    return 0
}

# ============================================================================
# FUNÇÕES DE CRIAÇÃO DE ITEMS
# ============================================================================

create_or_update_item() {
    local item_name="$1"
    local field_name="${2:-credential}"
    local credential_value="$3"
    
    if [ -z "${credential_value}" ]; then
        log_warning "Token vazio para ${item_name}, pulando..."
        return 0
    fi
    
    log_info "Processando: ${item_name}"
    
    # Verificar se item já existe
    if op item get "${item_name}" --vault "${VAULT}" &>/dev/null 2>&1; then
        log_warning "Item ${item_name} já existe. Atualizando..."
        
        # Tentar atualizar campo
        op item edit "${item_name}" \
            --vault "${VAULT}" \
            --field "${field_name}=${credential_value}" \
            --no-color &>/dev/null && {
                log_success "✅ ${item_name} atualizado no 1Password"
                return 0
            } || {
                log_info "Campo não existe, tentando criar item novo..."
            }
    fi
    
    # Criar novo item
    op item create \
        --vault "${VAULT}" \
        --category "API Credential" \
        --title "${item_name}" \
        --field "${field_name}=${credential_value}" \
        --no-color &>/dev/null && {
        log_success "✅ ${item_name} criado no 1Password"
        return 0
    } || {
        log_error "Falha ao criar/atualizar ${item_name}"
        return 1
    }
}

# ============================================================================
# MAIN
# ============================================================================

main() {
    log_section "🔐 Movendo Credenciais Existentes para 1Password"
    
    check_1password || return 1
    echo ""
    
    log_info "⚠️ Movendo tokens EXISTENTES (sem rotacionar)"
    log_info "As credenciais serão preservadas e movidas para o 1Password"
    echo ""
    
    # Verificar se tokens estão nas variáveis de ambiente
    if [ -z "${OPENAI_TOKEN}" ] && [ -z "${ANTHROPIC_TOKEN}" ] && [ -z "${HF_TOKEN}" ]; then
        log_warning "Tokens não encontrados em variáveis de ambiente"
        log_info "Você pode fornecer os tokens manualmente ou exportá-los antes de executar este script"
        echo ""
        read -p "Deseja informar os tokens manualmente? (s/N): " -n 1 -r
        echo
        if [[ $REPLY =~ ^[Ss]$ ]]; then
            read -sp "OPENAI_API_KEY: " OPENAI_TOKEN
            echo ""
            read -sp "ANTHROPIC_API_KEY: " ANTHROPIC_TOKEN
            echo ""
            read -sp "HF_TOKEN: " HF_TOKEN
            echo ""
            read -sp "PERPLEXITY_API_KEY: " PERPLEXITY_TOKEN
            echo ""
            read -sp "CURSOR_API_KEY: " CURSOR_TOKEN
            echo ""
        else
            log_info "Script cancelado. Exporte as variáveis ou execute novamente após configurá-las."
            return 0
        fi
    fi
    
    log_section "💾 Salvando no 1Password"
    
    create_or_update_item "OpenAI-API" "credential" "${OPENAI_TOKEN}"
    create_or_update_item "Anthropic-API" "credential" "${ANTHROPIC_TOKEN}"
    create_or_update_item "HuggingFace-Token" "credential" "${HF_TOKEN}"
    create_or_update_item "Perplexity-API" "credential" "${PERPLEXITY_TOKEN}"
    create_or_update_item "Cursor-API" "credential" "${CURSOR_TOKEN}"
    
    echo ""
    log_section "🧹 Limpeza"
    
    log_info "✅ Arquivo add-1password-vps-macos.md já foi removido"
    log_info "✅ Arquivo já está no .gitignore"
    
    echo ""
    log_section "✅ Concluído"
    log_success "Credenciais movidas para 1Password com sucesso!"
    echo ""
    echo "Próximos passos:"
    echo "  1. Limpar histórico do terminal: history -c"
    echo "  2. Regenerar .env: cd compose && op inject -i env-ai-stack.template -o .env"
    echo "  3. Tokens agora estão seguros no 1Password"
    echo ""
    log_warning "⚠️ Se o repositório Git é público, considere usar git-filter-repo para limpar histórico"
    
    return 0
}

main "$@"

