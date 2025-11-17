#!/bin/bash
# move-credentials-to-1password.sh
# Move credenciais expostas para o 1Password de forma segura
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

create_credential_item() {
    local item_name="$1"
    local field_name="$2"
    local credential_value="$3"
    
    log_info "Criando/atualizando: ${item_name}"
    
    # Verificar se item já existe
    if op item get "${item_name}" --vault "${VAULT}" &>/dev/null; then
        log_warning "Item ${item_name} já existe. Atualizando campo ${field_name}..."
        
        # Atualizar campo existente
        op item edit "${item_name}" \
            --vault "${VAULT}" \
            --field "${field_name}=${credential_value}" \
            --no-color &>/dev/null || {
                log_warning "Falha ao atualizar. Criando novo campo..."
            }
    else
        # Criar novo item
        op item create \
            --vault "${VAULT}" \
            --category "API Credential" \
            --title "${item_name}" \
            --field "${field_name}=${credential_value}" \
            --no-color &>/dev/null || {
                log_error "Falha ao criar item ${item_name}"
                return 1
            }
    fi
    
    log_success "✅ ${item_name} configurado no 1Password"
    return 0
}

# ============================================================================
# MAIN
# ============================================================================

main() {
    log_section "🔐 Movendo Credenciais para 1Password"
    
    check_1password || return 1
    echo ""
    
    log_warning "⚠️ ATENÇÃO: Este script irá criar/atualizar items no 1Password"
    log_warning "Certifique-se de que os tokens foram ROTACIONADOS antes de continuar!"
    echo ""
    
    read -p "Os tokens foram rotacionados? (s/N): " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Ss]$ ]]; then
        log_error "Por favor, rotacione os tokens primeiro!"
        echo ""
        echo "Execute: ./scripts/security/emergency-credential-rotation.sh"
        return 1
    fi
    echo ""
    
    # Solicitar novos tokens (não usar os expostos!)
    log_section "📝 Informe os NOVOS tokens (após rotação)"
    echo ""
    
    read -sp "Novo OPENAI_API_KEY: " OPENAI_TOKEN
    echo ""
    read -sp "Novo ANTHROPIC_API_KEY: " ANTHROPIC_TOKEN
    echo ""
    read -sp "Novo HF_TOKEN (Hugging Face): " HF_TOKEN
    echo ""
    read -sp "Novo PERPLEXITY_API_KEY: " PERPLEXITY_TOKEN
    echo ""
    read -sp "Novo CURSOR_API_KEY: " CURSOR_TOKEN
    echo ""
    
    log_section "💾 Salvando no 1Password"
    
    create_credential_item "OpenAI-API" "credential" "${OPENAI_TOKEN}"
    create_credential_item "Anthropic-API" "credential" "${ANTHROPIC_TOKEN}"
    create_credential_item "HuggingFace-Token" "credential" "${HF_TOKEN}"
    create_credential_item "Perplexity-API" "credential" "${PERPLEXITY_TOKEN}"
    create_credential_item "Cursor-API" "credential" "${CURSOR_TOKEN}"
    
    echo ""
    log_section "🧹 Limpeza"
    
    # Remover arquivo com tokens expostos
    if [ -f "${REPO_ROOT}/add-1password-vps-macos.md" ]; then
        log_info "Removendo arquivo com tokens expostos..."
        rm "${REPO_ROOT}/add-1password-vps-macos.md"
        log_success "Arquivo removido"
    fi
    
    echo ""
    log_section "✅ Concluído"
    log_success "Credenciais movidas para 1Password com sucesso!"
    echo ""
    echo "Próximos passos:"
    echo "  1. Limpar histórico do terminal: history -c && rm ~/.zsh_history"
    echo "  2. Regenerar .env: cd compose && op inject -i env-ai-stack.template -o .env"
    echo "  3. Reiniciar shell para limpar variáveis de ambiente"
    
    return 0
}

main "$@"

