#!/bin/bash

#################################################################################
# Script para Sincronizar Hostinger API Key no 1Password
# Versão: 1.0.0
# Objetivo: Criar/atualizar item no 1Password (macOS e VPS)
#################################################################################

set -euo pipefail

# Cores
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
RED='\033[0;31m'
NC='\033[0m'

# Configuração
API_KEY="${HOSTINGER_API_KEY:-jkBoNklZ2vnWHquuZRjbR09CxmqPfXNOqabkEnJvc06e0665}"
ITEM_TITLE="API-VPS-HOSTINGER"

log() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Detectar vault disponível
detect_vault() {
    if op vault list --format json 2>/dev/null | jq -r '.[].name' | grep -q "1p_macos"; then
        echo "1p_macos"
    elif op vault list --format json 2>/dev/null | jq -r '.[].name' | grep -q "Personal"; then
        echo "Personal"
    else
        op vault list --format json 2>/dev/null | jq -r '.[0].name' || echo ""
    fi
}

create_or_update_item() {
    local vault_name="$1"
    local item_title="$2"
    local api_key="$3"

    log "Processando vault: $vault_name"

    # Verificar se item existe
    local item_id=$(op item list --vault "$vault_name" --format json 2>/dev/null | \
        jq -r ".[] | select(.title == \"$item_title\") | .id" | head -1 || echo "")

    if [ -n "$item_id" ]; then
        log "Item existe. Atualizando..."
        # Tentar atualizar usando método simples
        echo "$api_key" | op item edit "$item_id" \
            "credential[concealed]=-" \
            --vault "$vault_name" 2>/dev/null && success "Item atualizado" || {
            log "Método alternativo: usando JSON..."
            # Método alternativo
            local temp_json=$(mktemp)
            op item get "$item_id" --format json > "$temp_json" 2>/dev/null || true
            jq --arg key "$api_key" '.fields[] |= if .id == "credential" then .value = $key else . end' "$temp_json" > "${temp_json}.new"
            op item edit "$item_id" --vault "$vault_name" < "${temp_json}.new" 2>/dev/null && success "Item atualizado" || error "Falha ao atualizar"
            rm -f "$temp_json" "${temp_json}.new"
        }
    else
        log "Criando novo item..."
        # Criar usando template JSON
        local temp_json=$(mktemp)
        local vault_id=$(op vault list --format json | jq -r ".[] | select(.name == \"$vault_name\") | .id")

        cat > "$temp_json" << EOF
{
  "title": "$item_title",
  "category": "API_CREDENTIAL",
  "vault": {
    "id": "$vault_id"
  },
  "fields": [
    {
      "id": "credential",
      "type": "CONCEALED",
      "label": "API Key",
      "value": "$api_key"
    }
  ],
  "notesPlain": "Hostinger API Key para VPS\\n\\nUso: Gerenciamento de VPS via API\\nDocumentação: https://developers.hostinger.com/\\n\\nVariável de ambiente:\\nexport HOSTINGER_API_KEY=\\$(op read \\\"op://$vault_name/$item_title/credential\\\")"
}
EOF
        op item create < "$temp_json" --vault "$vault_name" 2>/dev/null && success "Item criado" || error "Falha ao criar"
        rm -f "$temp_json"
    fi
}

main() {
    echo "╔═══════════════════════════════════════════════════════════════╗"
    echo "║        Sincronizar Hostinger API Key - 1Password            ║"
    echo "╚═══════════════════════════════════════════════════════════════╝"
    echo ""

    # Verificar 1Password CLI
    if ! command -v op &> /dev/null; then
        error "1Password CLI não está instalado"
        exit 1
    fi

    # Verificar autenticação
    if ! op whoami &>/dev/null; then
        error "Não autenticado no 1Password"
        echo ""
        echo "Autentique com: op signin"
        exit 1
    fi
    success "Autenticado no 1Password"

    # Detectar vaults
    VAULT_MACOS=$(detect_vault)

    if [ -n "$VAULT_MACOS" ]; then
        create_or_update_item "$VAULT_MACOS" "$ITEM_TITLE" "$API_KEY"
    else
        error "Nenhum vault encontrado"
        exit 1
    fi

    echo ""
    success "Sincronização concluída!"
    echo ""
    echo "🔑 Ler API Key:"
    echo "   op read \"op://$VAULT_MACOS/$ITEM_TITLE/credential\""
    echo ""
}

main "$@"
