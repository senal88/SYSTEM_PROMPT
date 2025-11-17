#!/bin/bash
# prepare-1password-sync.sh
# Prepara sincronização 1Password: 1p_macos → 1p_vps
# Last Updated: 2025-11-02
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
DATA_DIR="${REPO_ROOT}/dados"

# ============================================================================
# FUNÇÕES
# ============================================================================

check_1password_local() {
    log_section "🔐 Verificando 1Password Local (macOS)"
    
    if [ -n "${OP_CONNECT_HOST:-}" ] && [ -n "${OP_CONNECT_TOKEN:-}" ]; then
        log_info "Usando 1Password Connect"
        
        # Listar vaults via Connect
        local vaults=$(curl -s -H "Authorization: Bearer ${OP_CONNECT_TOKEN}" \
            "${OP_CONNECT_HOST}/v1/vaults" 2>/dev/null | jq -r '.[].name' 2>/dev/null || echo "")
        
        if echo "${vaults}" | grep -q "${VAULT_MACOS}"; then
            log_success "Vault ${VAULT_MACOS} acessível via Connect"
            return 0
        else
            log_warning "Vault ${VAULT_MACOS} não encontrado via Connect"
            return 1
        fi
    else
        # CLI direto
        if op item list --vault "${VAULT_MACOS}" --format json &>/dev/null 2>&1; then
            log_success "Vault ${VAULT_MACOS} acessível"
            return 0
        else
            log_warning "Vault ${VAULT_MACOS} não encontrado"
            return 1
        fi
    fi
}

list_essential_secrets() {
    log_section "📋 Listando Secrets Essenciais"
    
    # Items críticos para produção (baseado no inventory)
    local essential_items=(
        "OpenAI-API"
        "Anthropic-API"
        "HuggingFace-Token"
        "Perplexity-API"
        "Cursor-API"
        "PostgreSQL"
        "n8n"
    )
    
    log_info "Items essenciais para sincronizar:"
    for item in "${essential_items[@]}"; do
        echo "  - ${item}"
    done
    
    # Salvar lista
    {
        echo "# Lista de Secrets Essenciais para 1p_vps"
        echo "# Gerado: $(date '+%Y-%m-%d %H:%M:%S')"
        echo ""
        for item in "${essential_items[@]}"; do
            echo "- ${item}"
        done
    } > "${DATA_DIR}/essential_secrets_list.txt"
    
    log_success "Lista salva em: ${DATA_DIR}/essential_secrets_list.txt"
}

create_sync_template() {
    log_section "📝 Criando Template de Sincronização"
    
    cat > "${REPO_ROOT}/prod/1p_sync_template.md" << 'EOF'
# Template: Sincronização 1Password 1p_macos → 1p_vps

## Items para Sincronizar

### API Keys
- [ ] OpenAI-API
- [ ] Anthropic-API
- [ ] HuggingFace-Token
- [ ] Perplexity-API
- [ ] Cursor-API

### Databases
- [ ] PostgreSQL (se necessário)
- [ ] MongoDB (se necessário)
- [ ] Redis (se necessário)

### Application Secrets
- [ ] n8n Encryption Key
- [ ] n8n JWT Secret
- [ ] Traefik Email (se usar SSL)

---

## Método de Sincronização

### Opção 1: Manual (Recomendado para primeira vez)
1. Abrir 1Password app no macOS
2. Copiar items de `1p_macos`
3. Criar items em `1p_vps` manualmente
4. Validar na VPS

### Opção 2: Via CLI (Se tiver acesso aos dois vaults)
```bash
# Exportar item
op item get "Item-Name" --vault 1p_macos --format json > item.json

# Importar em outro vault
op item create --vault 1p_vps < item.json
```

---

## Validação na VPS

Após sincronizar, validar na VPS:
```bash
ssh vps
op vault get 1p_vps
op item list --vault 1p_vps
```

EOF
    
    log_success "Template criado: ${REPO_ROOT}/prod/1p_sync_template.md"
}

# ============================================================================
# MAIN
# ============================================================================

main() {
    log_section "🔄 Preparando Sincronização 1Password"
    
    check_1password_local || {
        log_warning "1Password local não totalmente acessível, mas continuando..."
    }
    echo ""
    
    list_essential_secrets
    echo ""
    
    create_sync_template
    echo ""
    
    log_section "✅ Preparação Completa"
    log_success "Lista de secrets essenciais criada"
    log_success "Template de sincronização criado"
    echo ""
    echo "Próximos passos:"
    echo "  1. Revisar lista: cat ${DATA_DIR}/essential_secrets_list.txt"
    echo "  2. Seguir template: cat ${REPO_ROOT}/prod/1p_sync_template.md"
    echo "  3. Sincronizar items manualmente no 1Password app"
    
    return 0
}

main "$@"

