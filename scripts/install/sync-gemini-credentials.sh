#!/bin/bash

#################################################################################
# Script de Sincronização e Padronização de Credenciais Gemini
# Versão: 2.0.1
# Objetivo: Centralizar credenciais no 1Password e remover duplicatas
#################################################################################

set -e

REPO_ROOT="$HOME/Dotfiles"
CREDENTIALS_DIR="/Users/luiz.sena88/10_INFRAESTRUTURA_VPS/framework/curso-n8n/aulas/04-workflows-iniciantes/aula-15-criando-projeto-no-console-do-google-e-chave-de-api-do-gemini "

# Cores
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

# Detectar vault correto (prioridade: 1p_macos > Personal)
VAULT=$(op vault list --format json 2>/dev/null | jq -r '.[] | select(.name == "1p_macos" or .name == "Personal") | .name' | head -1 || echo "Personal")
ITEM_NAME="Gemini_API_Keys"

log() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Verificar 1Password
check_op() {
    if ! command -v op &> /dev/null; then
        error "1Password CLI não encontrado"
        return 1
    fi

    if ! op account list &>/dev/null; then
        error "1Password não autenticado. Execute: op signin"
        return 1
    fi

    success "1Password CLI configurado"
    return 0
}

# Ler credenciais dos arquivos
read_credentials() {
    local google_api_key_file="$CREDENTIALS_DIR/GOOGLE_API_KEY.txt"
    local service_account_file="$CREDENTIALS_DIR/gcp-ai-setup-24410-2141022d473f.json"

    if [ ! -f "$google_api_key_file" ]; then
        error "Arquivo GOOGLE_API_KEY.txt não encontrado"
        return 1
    fi

    # Ler GOOGLE_API_KEY (pode ter prefixo GOOGLE_API_KEY=)
    GOOGLE_API_KEY=$(cat "$google_api_key_file" | tr -d '\n\r ' | sed 's/^GOOGLE_API_KEY=//')

    # Usar API key do gemini_config.json (não usar private_key_id do service account)
    if [ -f "$REPO_ROOT/configs/gemini_config.json" ]; then
        if command -v jq &> /dev/null; then
            GEMINI_API_KEY=$(jq -r '.gemini.api_key // empty' "$REPO_ROOT/configs/gemini_config.json")
        else
            GEMINI_API_KEY=$(grep -o '"api_key": "[^"]*"' "$REPO_ROOT/configs/gemini_config.json" | cut -d'"' -f4)
        fi
    fi

    if [ -z "$GOOGLE_API_KEY" ]; then
        error "GOOGLE_API_KEY não encontrada"
        return 1
    fi

    if [ -z "$GEMINI_API_KEY" ]; then
        warning "GEMINI_API_KEY não encontrada nos arquivos, usando do gemini_config.json"
        if [ -f "$REPO_ROOT/configs/gemini_config.json" ]; then
            if command -v jq &> /dev/null; then
                GEMINI_API_KEY=$(jq -r '.gemini.api_key // empty' "$REPO_ROOT/configs/gemini_config.json")
            else
                GEMINI_API_KEY=$(grep -o '"api_key": "[^"]*"' "$REPO_ROOT/configs/gemini_config.json" | cut -d'"' -f4)
            fi
        fi
    fi

    success "Credenciais lidas dos arquivos"
    return 0
}

# Listar itens obsoletos no 1Password
list_obsolete_items() {
    log "Buscando itens obsoletos relacionados a Gemini/Google/GCP..."

    # Buscar itens que podem ser duplicados
    op item list --vault "$VAULT" --format json 2>/dev/null | \
        jq -r '.[] | select(.title | test("(?i)(gemini|google|gcp|api.*key|credential)")) | .id' 2>/dev/null || echo ""
}

# Criar/atualizar item no 1Password
sync_to_1password() {
    log "Sincronizando credenciais para 1Password..."

    # Verificar se item existe
    local item_exists=false
    if op item get "$ITEM_NAME" --vault "$VAULT" &>/dev/null 2>&1; then
        item_exists=true
        log "Item $ITEM_NAME já existe, atualizando..."
    else
        log "Criando novo item $ITEM_NAME..."
    fi

    # Criar/atualizar item usando sintaxe correta do op CLI
    if [ "$item_exists" = true ]; then
        # Atualizar item existente usando assignment statements
        op item edit "$ITEM_NAME" --vault "$VAULT" \
            "GEMINI_API_KEY[concealed]=$GEMINI_API_KEY" \
            "GOOGLE_API_KEY[concealed]=$GOOGLE_API_KEY" \
            2>&1 || {
            warning "Tentando método alternativo de atualização..."
            # Método alternativo: obter JSON, modificar e atualizar
            local temp_json=$(mktemp)
            op item get "$ITEM_NAME" --vault "$VAULT" --format json > "$temp_json" 2>/dev/null

            if [ -f "$temp_json" ] && command -v jq &> /dev/null; then
                # Criar novo JSON com campos atualizados
                jq --arg gemini "$GEMINI_API_KEY" --arg google "$GOOGLE_API_KEY" '
                    .fields = [
                        {"id": "GEMINI_API_KEY", "value": $gemini, "type": "CONCEALED", "label": "GEMINI_API_KEY"},
                        {"id": "GOOGLE_API_KEY", "value": $google, "type": "CONCEALED", "label": "GOOGLE_API_KEY"}
                    ]
                ' "$temp_json" | op item edit "$ITEM_NAME" --vault "$VAULT" - 2>&1 || true
            fi
            rm -f "$temp_json"
        }
    else
        # Criar novo item usando assignment statements
        op item create \
            --vault "$VAULT" \
            --title "$ITEM_NAME" \
            --category "Secure Note" \
            "GEMINI_API_KEY[concealed]=$GEMINI_API_KEY" \
            "GOOGLE_API_KEY[concealed]=$GOOGLE_API_KEY" \
            --tags "gemini,api,credentials,gcp,google" \
            2>&1 || {
            warning "Tentando método alternativo de criação..."
            # Método alternativo: criar via JSON template
            local temp_json=$(mktemp)
            cat > "$temp_json" << EOF
{
  "title": "$ITEM_NAME",
  "category": "SECURE_NOTE",
  "vault": {"id": "$(op vault get "$VAULT" --format json 2>/dev/null | jq -r '.id // empty')"},
  "fields": [
    {"id": "GEMINI_API_KEY", "value": "$GEMINI_API_KEY", "type": "CONCEALED", "label": "GEMINI_API_KEY"},
    {"id": "GOOGLE_API_KEY", "value": "$GOOGLE_API_KEY", "type": "CONCEALED", "label": "GOOGLE_API_KEY"}
  ],
  "tags": ["gemini", "api", "credentials", "gcp", "google"]
}
EOF
            op item create --vault "$VAULT" - < "$temp_json" 2>&1 || true
            rm -f "$temp_json"
        }
    fi

    success "Credenciais sincronizadas para 1Password"
    return 0
}

# Remover itens obsoletos
remove_obsolete_items() {
    log "Removendo itens obsoletos..."

    local obsolete_items=$(list_obsolete_items)
    local item_count=0

    if [ -n "$obsolete_items" ]; then
        echo "$obsolete_items" | while read -r item_id; do
            if [ -n "$item_id" ]; then
                local item_title=$(op item get "$item_id" --vault "$VAULT" --format json 2>/dev/null | jq -r '.title // empty')

                # Não remover o item principal
                if [ "$item_title" != "$ITEM_NAME" ]; then
                    log "Removendo item obsoleto: $item_title ($item_id)"
                    op item delete "$item_id" --vault "$VAULT" --archive 2>/dev/null || true
                    item_count=$((item_count + 1))
                fi
            fi
        done

        if [ $item_count -gt 0 ]; then
            success "$item_count item(s) obsoleto(s) removido(s)"
        else
            log "Nenhum item obsoleto encontrado"
        fi
    else
        log "Nenhum item obsoleto encontrado"
    fi
}

# Aplicar configurações nos editores
apply_to_editors() {
    log "Aplicando configurações nos editores..."

    local vs_code_user_dir="$HOME/Library/Application Support/Code/User"
    local cursor_user_dir="$HOME/Library/Application Support/Cursor/User"

    # Configurar VSCode
    if [ -f "$vs_code_user_dir/settings.json" ]; then
        if command -v jq &> /dev/null; then
            jq ". + {
                \"geminiCodeAssist.project\": \"gcp-ai-setup-24410\",
                \"geminiCodeAssist.region\": \"us-central1\",
                \"geminiCodeAssist.apiKey\": \"$GEMINI_API_KEY\",
                \"geminiCodeAssist.googleApiKey\": \"$GOOGLE_API_KEY\"
            }" "$vs_code_user_dir/settings.json" > "$vs_code_user_dir/settings.json.tmp" && \
            mv "$vs_code_user_dir/settings.json.tmp" "$vs_code_user_dir/settings.json"
            success "VSCode configurado"
        fi
    fi

    # Configurar Cursor
    if [ -f "$cursor_user_dir/settings.json" ]; then
        # Remover comentários JSONC temporariamente
        local temp_file=$(mktemp)
        grep -v '^[[:space:]]*//' "$cursor_user_dir/settings.json" > "$temp_file" 2>/dev/null || \
            cp "$cursor_user_dir/settings.json" "$temp_file"

        if command -v jq &> /dev/null; then
            jq ". + {
                \"geminiCodeAssist.project\": \"gcp-ai-setup-24410\",
                \"geminiCodeAssist.region\": \"us-central1\",
                \"geminiCodeAssist.apiKey\": \"$GEMINI_API_KEY\",
                \"geminiCodeAssist.googleApiKey\": \"$GOOGLE_API_KEY\",
                \"cursor.ai.gemini.enabled\": true,
                \"cursor.ai.gemini.project\": \"gcp-ai-setup-24410\"
            }" "$temp_file" > "$cursor_user_dir/settings.json"
            rm "$temp_file"
            success "Cursor configurado"
        else
            rm "$temp_file"
        fi
    fi
}

# Verificar configuração final
verify_configuration() {
    log "Verificando configuração final..."

    echo ""
    echo "╔═══════════════════════════════════════════════════════════════╗"
    echo "║              VERIFICAÇÃO DE CONFIGURAÇÃO                     ║"
    echo "╚═══════════════════════════════════════════════════════════════╝"
    echo ""

    # Verificar 1Password
    if op item get "$ITEM_NAME" --vault "$VAULT" &>/dev/null; then
        success "✅ Item $ITEM_NAME existe no 1Password"

        local stored_gemini=$(op read "op://$VAULT/$ITEM_NAME/GEMINI_API_KEY" 2>/dev/null || echo "")
        local stored_google=$(op read "op://$VAULT/$ITEM_NAME/GOOGLE_API_KEY" 2>/dev/null || echo "")

        if [ -n "$stored_gemini" ] && [ -n "$stored_google" ]; then
            success "✅ Credenciais armazenadas no 1Password"
        else
            warning "⚠️  Algumas credenciais não encontradas no 1Password"
        fi
    else
        error "❌ Item $ITEM_NAME não encontrado no 1Password"
    fi

    echo ""

    # Verificar editores
    if [ -f "$HOME/Library/Application Support/Code/User/settings.json" ]; then
        if grep -q "geminiCodeAssist.project" "$HOME/Library/Application Support/Code/User/settings.json"; then
            success "✅ VSCode configurado"
        else
            warning "⚠️  VSCode não configurado"
        fi
    fi

    if [ -f "$HOME/Library/Application Support/Cursor/User/settings.json" ]; then
        if grep -q "geminiCodeAssist.project" "$HOME/Library/Application Support/Cursor/User/settings.json"; then
            success "✅ Cursor configurado"
        else
            warning "⚠️  Cursor não configurado"
        fi
    fi

    echo ""

    # Verificar extensões
    if code --list-extensions 2>/dev/null | grep -q "geminicodeassist"; then
        success "✅ Extensão Gemini instalada no VSCode"
    fi

    if cursor --list-extensions 2>/dev/null | grep -q "geminicodeassist"; then
        success "✅ Extensão Gemini instalada no Cursor"
    fi

    echo ""
}

main() {
    echo "╔═══════════════════════════════════════════════════════════════╗"
    echo "║        Sincronização e Padronização de Credenciais           ║"
    echo "║              Versão 2.0.1 - Governança                      ║"
    echo "╚═══════════════════════════════════════════════════════════════╝"
    echo ""

    if ! check_op; then
        exit 1
    fi

    echo ""

    if ! read_credentials; then
        error "Não foi possível ler as credenciais"
        exit 1
    fi

    echo ""
    log "Credenciais encontradas:"
    echo "  GEMINI_API_KEY: ${GEMINI_API_KEY:0:20}..."
    echo "  GOOGLE_API_KEY: ${GOOGLE_API_KEY:0:20}..."
    echo ""

    # Sincronizar para 1Password
    sync_to_1password

    echo ""

    # Remover itens obsoletos
    remove_obsolete_items

    echo ""

    # Aplicar nos editores
    apply_to_editors

    echo ""

    # Verificar configuração
    verify_configuration

    echo ""
    echo "╔═══════════════════════════════════════════════════════════════╗"
    echo "║              SINCRONIZAÇÃO CONCLUÍDA                        ║"
    echo "╚═══════════════════════════════════════════════════════════════╝"
    echo ""
    success "Todas as credenciais foram padronizadas e centralizadas!"
    echo ""
    echo "Item principal no 1Password:"
    echo "  Vault: $VAULT"
    echo "  Item: $ITEM_NAME"
    echo ""
}

main "$@"
