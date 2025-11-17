#!/bin/bash

#################################################################################
# Script de Aplicação de Configuração Gemini usando credenciais existentes
# Versão: 2.0.1
# Objetivo: Aplicar configurações usando credenciais do gemini_config.json
#################################################################################

set -e

REPO_ROOT="$HOME/Dotfiles"
GEMINI_CONFIG="$REPO_ROOT/configs/gemini_config.json"

# Cores
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
NC='\033[0m'

log() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

# Ler credenciais do gemini_config.json
get_api_key() {
    if [ -f "$GEMINI_CONFIG" ]; then
        if command -v jq &> /dev/null; then
            jq -r '.gemini.api_key // empty' "$GEMINI_CONFIG" 2>/dev/null
        else
            grep -o '"api_key": "[^"]*"' "$GEMINI_CONFIG" | cut -d'"' -f4
        fi
    fi
}

get_google_api_key() {
    if [ -f "$GEMINI_CONFIG" ]; then
        if command -v jq &> /dev/null; then
            jq -r '.gemini.google_api_key // empty' "$GEMINI_CONFIG" 2>/dev/null
        else
            grep -o '"google_api_key": "[^"]*"' "$GEMINI_CONFIG" | cut -d'"' -f4
        fi
    fi
}

# Configurar VSCode
configure_vscode() {
    log "Configurando VSCode..."

    local api_key=$(get_api_key)
    local google_api_key=$(get_google_api_key)

    if [ -z "$api_key" ] || [ -z "$google_api_key" ]; then
        warning "Credenciais não encontradas em gemini_config.json"
        return 1
    fi

    local vs_code_user_dir="$HOME/Library/Application Support/Code/User"
    local settings_file="$vs_code_user_dir/settings.json"

    mkdir -p "$vs_code_user_dir"

    if command -v jq &> /dev/null && [ -f "$settings_file" ]; then
        jq ". + {
            \"geminiCodeAssist.project\": \"gcp-ai-setup-24410\",
            \"geminiCodeAssist.region\": \"us-central1\",
            \"geminiCodeAssist.apiKey\": \"$api_key\",
            \"geminiCodeAssist.googleApiKey\": \"$google_api_key\"
        }" "$settings_file" > "$settings_file.tmp" && mv "$settings_file.tmp" "$settings_file"
        success "VSCode configurado"
    else
        warning "jq não encontrado ou settings.json não existe. Configure manualmente."
    fi
}

# Configurar Cursor
configure_cursor() {
    log "Configurando Cursor..."

    local api_key=$(get_api_key)
    local google_api_key=$(get_google_api_key)

    if [ -z "$api_key" ] || [ -z "$google_api_key" ]; then
        warning "Credenciais não encontradas em gemini_config.json"
        return 1
    fi

    local cursor_user_dir="$HOME/Library/Application Support/Cursor/User"
    local settings_file="$cursor_user_dir/settings.json"

    mkdir -p "$cursor_user_dir"

    if command -v jq &> /dev/null && [ -f "$settings_file" ]; then
        jq ". + {
            \"geminiCodeAssist.project\": \"gcp-ai-setup-24410\",
            \"geminiCodeAssist.region\": \"us-central1\",
            \"geminiCodeAssist.apiKey\": \"$api_key\",
            \"geminiCodeAssist.googleApiKey\": \"$google_api_key\",
            \"cursor.ai.gemini.enabled\": true,
            \"cursor.ai.gemini.project\": \"gcp-ai-setup-24410\"
        }" "$settings_file" > "$settings_file.tmp" && mv "$settings_file.tmp" "$settings_file"
        success "Cursor configurado"
    else
        warning "jq não encontrado ou settings.json não existe. Configure manualmente."
    fi
}

main() {
    echo "Aplicando configurações Gemini usando credenciais existentes..."
    echo ""

    configure_vscode
    configure_cursor

    echo ""
    success "Configuração aplicada!"
}

main "$@"
