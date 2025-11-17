#!/bin/bash

#################################################################################
# Script de Sincronização 1Password -> ~/Dotfiles
# Versão: 2.0.1
# Objetivo: Sincronizar credenciais do 1Password para ~/Dotfiles (governança)
#################################################################################

set -e

DOTFILES_DIR="$HOME/Dotfiles"
CREDENTIALS_DIR="$DOTFILES_DIR/credentials"

# Detectar vault (prioridade: 1p_macos > Personal)
VAULT=$(op vault list --format json 2>/dev/null | jq -r '.[] | select(.name == "1p_macos" or .name == "Personal") | .name' | head -1 || echo "Personal")

log() {
    echo -e "\033[0;34m[INFO]\033[0m $1"
}

success() {
    echo -e "\033[0;32m[SUCCESS]\033[0m $1"
}

warning() {
    echo -e "\033[1;33m[WARNING]\033[0m $1"
}

# Sincronizar credenciais Gemini
sync_gemini_credentials() {
    log "Sincronizando credenciais Gemini..."

    local item_name="Gemini_API_Keys"

    if op item get "$item_name" --vault "$VAULT" &>/dev/null; then
        local gemini_key=$(op read "op://$VAULT/$item_name/GEMINI_API_KEY" 2>/dev/null || echo "")
        local google_key=$(op read "op://$VAULT/$item_name/GOOGLE_API_KEY" 2>/dev/null || echo "")

        if [ -n "$gemini_key" ] && [ -n "$google_key" ]; then
            mkdir -p "$CREDENTIALS_DIR/api-keys"

            echo "$gemini_key" > "$CREDENTIALS_DIR/api-keys/GEMINI_API_KEY.local"
            echo "$google_key" > "$CREDENTIALS_DIR/api-keys/GOOGLE_API_KEY.local"
            chmod 600 "$CREDENTIALS_DIR/api-keys/"*.local

            success "Credenciais Gemini sincronizadas"
            return 0
        fi
    fi

    warning "Item Gemini_API_Keys não encontrado no vault $VAULT"
    return 1
}

# Sincronizar GCP Service Account
sync_gcp_service_account() {
    log "Sincronizando GCP Service Account..."

    mkdir -p "$CREDENTIALS_DIR/service-accounts"

    # Tentar diferentes nomes de itens
    for item_name in "GCP_Service_Account_gcp-ai-setup-24410" "GCP_Service_Account" "gcp-ai-setup-24410"; do
        if op item get "$item_name" --vault "$VAULT" &>/dev/null 2>&1; then
            op document get "$item_name" --vault "$VAULT" > "$CREDENTIALS_DIR/service-accounts/gcp-ai-setup-24410.json" 2>/dev/null && {
                chmod 600 "$CREDENTIALS_DIR/service-accounts/gcp-ai-setup-24410.json"
                success "Service Account sincronizado: $item_name"
                return 0
            }
        fi
    done

    # Tentar do arquivo fonte
    local source_file="/Users/luiz.sena88/10_INFRAESTRUTURA_VPS/framework/curso-n8n/aulas/04-workflows-iniciantes/aula-15-criando-projeto-no-console-do-google-e-chave-de-api-do-gemini /gcp-ai-setup-24410-2141022d473f.json"
    if [ -f "$source_file" ]; then
        cp "$source_file" "$CREDENTIALS_DIR/service-accounts/gcp-ai-setup-24410.json"
        chmod 600 "$CREDENTIALS_DIR/service-accounts/gcp-ai-setup-24410.json"
        success "Service Account copiado de arquivo fonte"
        return 0
    fi

    warning "Service Account não encontrado"
    return 1
}

# Sincronizar OAuth credentials
sync_oauth_credentials() {
    log "Sincronizando OAuth credentials..."

    mkdir -p "$CREDENTIALS_DIR/oauth/google"

    # Tentar diferentes nomes
    for item_name in "Google_OAuth_Credentials" "Google_OAuth" "OAuth_Google"; do
        if op item get "$item_name" --vault "$VAULT" &>/dev/null 2>&1; then
            op document get "$item_name" --vault "$VAULT" > "$CREDENTIALS_DIR/oauth/google/oauth-client-secret.json" 2>/dev/null && {
                chmod 600 "$CREDENTIALS_DIR/oauth/google/oauth-client-secret.json"
                success "OAuth credentials sincronizadas: $item_name"
                return 0
            }
        fi
    done

    warning "OAuth credentials não encontradas"
    return 1
}

# Atualizar arquivo de configuração gemini_config.json
update_gemini_config() {
    log "Atualizando gemini_config.json..."

    local config_file="$DOTFILES_DIR/configs/gemini_config.json"

    if [ ! -f "$config_file" ]; then
        warning "gemini_config.json não encontrado"
        return 1
    fi

    # Ler credenciais locais
    local gemini_key=""
    local google_key=""

    if [ -f "$CREDENTIALS_DIR/api-keys/GEMINI_API_KEY.local" ]; then
        gemini_key=$(cat "$CREDENTIALS_DIR/api-keys/GEMINI_API_KEY.local")
    fi

    if [ -f "$CREDENTIALS_DIR/api-keys/GOOGLE_API_KEY.local" ]; then
        google_key=$(cat "$CREDENTIALS_DIR/api-keys/GOOGLE_API_KEY.local")
    fi

    if [ -n "$gemini_key" ] && [ -n "$google_key" ] && command -v jq &> /dev/null; then
        jq --arg gemini "$gemini_key" --arg google "$google_key" '
            .gemini.api_key = $gemini |
            .gemini.google_api_key = $google |
            .gemini.gcp_project_id = "gcp-ai-setup-24410" |
            .gemini.gcp_region = "us-central1"
        ' "$config_file" > "$config_file.tmp" && mv "$config_file.tmp" "$config_file"
        success "gemini_config.json atualizado"
    fi
}

main() {
    echo "╔═══════════════════════════════════════════════════════════════╗"
    echo "║        Sincronização 1Password -> ~/Dotfiles                ║"
    echo "║              Versão 2.0.1 - Governança                     ║"
    echo "╚═══════════════════════════════════════════════════════════════╝"
    echo ""

    if ! command -v op &> /dev/null; then
        warning "1Password CLI não encontrado"
        exit 1
    fi

    if ! op account list &>/dev/null; then
        warning "1Password não autenticado. Execute: op signin"
        exit 1
    fi

    echo "Vault: $VAULT"
    echo ""

    mkdir -p "$CREDENTIALS_DIR"/{api-keys,service-accounts,oauth/google}

    sync_gemini_credentials
    sync_gcp_service_account
    sync_oauth_credentials
    update_gemini_config

    echo ""
    echo "╔═══════════════════════════════════════════════════════════════╗"
    echo "║              SINCRONIZAÇÃO CONCLUÍDA                        ║"
    echo "╚═══════════════════════════════════════════════════════════════╝"
    echo ""
    success "Credenciais sincronizadas para ~/Dotfiles/credentials"
    echo ""
    echo "Arquivos criados:"
    echo "  - API Keys: $CREDENTIALS_DIR/api-keys/*.local"
    echo "  - Service Account: $CREDENTIALS_DIR/service-accounts/gcp-ai-setup-24410.json"
    echo "  - OAuth: $CREDENTIALS_DIR/oauth/google/oauth-client-secret.json"
    echo ""
}

main "$@"
