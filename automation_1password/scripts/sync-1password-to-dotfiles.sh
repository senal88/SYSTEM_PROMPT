#!/bin/bash

#################################################################################
# Script de Sincronização 1Password -> ~/Dotfiles
# Versão: 2.0.1
# Objetivo: Sincronizar credenciais do 1Password para arquivos locais em ~/Dotfiles
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

# Sincronizar credenciais Gemini
sync_gemini_credentials() {
    log "Sincronizando credenciais Gemini..."
    
    local item_name="Gemini_API_Keys"
    
    if op item get "$item_name" --vault "$VAULT" &>/dev/null; then
        local gemini_key=$(op read "op://$VAULT/$item_name/GEMINI_API_KEY" 2>/dev/null || echo "")
        local google_key=$(op read "op://$VAULT/$item_name/GOOGLE_API_KEY" 2>/dev/null || echo "")
        
        if [ -n "$gemini_key" ] && [ -n "$google_key" ]; then
            mkdir -p "$CREDENTIALS_DIR/api-keys"
            
            # Salvar como arquivos locais (com permissões restritas)
            echo "$gemini_key" > "$CREDENTIALS_DIR/api-keys/GEMINI_API_KEY.local"
            echo "$google_key" > "$CREDENTIALS_DIR/api-keys/GOOGLE_API_KEY.local"
            chmod 600 "$CREDENTIALS_DIR/api-keys/"*.local
            
            success "Credenciais Gemini sincronizadas"
        fi
    fi
}

# Sincronizar service account GCP
sync_gcp_service_account() {
    log "Sincronizando GCP Service Account..."
    
    local item_name="GCP_Service_Account_gcp-ai-setup-24410"
    
    if op item get "$item_name" --vault "$VAULT" &>/dev/null; then
        op document get "$item_name" --vault "$VAULT" > "$CREDENTIALS_DIR/service-accounts/gcp-ai-setup-24410.json" 2>/dev/null || true
        chmod 600 "$CREDENTIALS_DIR/service-accounts/gcp-ai-setup-24410.json" 2>/dev/null || true
        success "Service Account sincronizado"
    fi
}

main() {
    echo "Sincronizando 1Password -> ~/Dotfiles..."
    echo ""
    
    mkdir -p "$CREDENTIALS_DIR"/{api-keys,service-accounts,oauth}
    
    sync_gemini_credentials
    sync_gcp_service_account
    
    echo ""
    success "Sincronização concluída!"
}

main "$@"
